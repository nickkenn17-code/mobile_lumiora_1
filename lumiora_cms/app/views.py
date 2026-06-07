import subprocess
from requests import request
from rest_framework import viewsets, status, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from django.shortcuts import render
from django.contrib.auth.models import User
from django.db import connection
from django.db.models import Sum, Count, Q
from .models import (
    Category, MenuItem, Bundle, Customer, Order, Checkout, AdminUser
)
from .serializers import (
    CategorySerializer, MenuItemSerializer, BundleSerializer,
    CustomerSerializer, OrderSerializer, CheckoutSerializer,
    AdminUserSerializer, UserSerializer
)


class IsAdminOrReadOnly(permissions.BasePermission):
    """Custom permission to only allow admins to edit"""
    def has_permission(self, request, view):
        if request.method in permissions.SAFE_METHODS:
            return True
        return request.user and request.user.is_staff


class CategoryViewSet(viewsets.ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer
    permission_classes = [IsAdminOrReadOnly]


class MenuItemViewSet(viewsets.ModelViewSet):
    queryset = MenuItem.objects.all()
    serializer_class = MenuItemSerializer
    permission_classes = [IsAdminOrReadOnly]
    filterset_fields = ['category', 'is_available']
    search_fields = ['name', 'description']

    @action(detail=False, methods=['get'])
    def available(self, request):
        """Get all available menu items"""
        items = MenuItem.objects.filter(is_available=True)
        serializer = self.get_serializer(items, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=['post'])
    def toggle_availability(self, request, pk=None):
        """Toggle menu item availability"""
        item = self.get_object()
        item.is_available = not item.is_available
        item.save()
        return Response({'is_available': item.is_available})


class BundleViewSet(viewsets.ModelViewSet):
    queryset = Bundle.objects.all()
    serializer_class = BundleSerializer
    permission_classes = [IsAdminOrReadOnly]
    filterset_fields = ['is_active']

    @action(detail=False, methods=['get'])
    def active(self, request):
        """Get all active bundles"""
        bundles = Bundle.objects.filter(is_active=True)
        serializer = self.get_serializer(bundles, many=True)
        return Response(serializer.data)


class CustomerViewSet(viewsets.ModelViewSet):
    queryset = Customer.objects.all()
    serializer_class = CustomerSerializer
    permission_classes = [permissions.IsAuthenticated]
    filterset_fields = ['is_active']
    search_fields = ['email', 'first_name', 'last_name']

    @action(detail=True, methods=['get'])
    def order_history(self, request, pk=None):
        """Get order history for a customer"""
        customer = self.get_object()
        orders = customer.orders.all()
        serializer = OrderSerializer(orders, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def statistics(self, request):
        """Get customer statistics"""
        total_customers = Customer.objects.count()
        active_customers = Customer.objects.filter(is_active=True).count()
        total_spent = Customer.objects.aggregate(Sum('total_spent'))['total_spent__sum'] or 0

        return Response({
            'total_customers': total_customers,
            'active_customers': active_customers,
            'total_revenue': float(total_spent)
        })


class OrderViewSet(viewsets.ModelViewSet):
    queryset = Order.objects.all()
    serializer_class = OrderSerializer
    permission_classes = [permissions.IsAuthenticated]
    filterset_fields = ['status', 'customer']
    ordering_fields = ['created_at', 'total_amount']

    @action(detail=True, methods=['patch'])
    def update_status(self, request, pk=None):
        """Update order status"""
        order = self.get_object()
        new_status = request.data.get('status')
        if new_status and new_status in dict(Order.STATUS_CHOICES):
            order.status = new_status
            order.save()
            return Response(OrderSerializer(order).data)
        return Response(
            {'error': f'Invalid status. Must be one of {list(dict(Order.STATUS_CHOICES).keys())}'},
            status=status.HTTP_400_BAD_REQUEST
        )

    @action(detail=False, methods=['get'])
    def statistics(self, request):
        """Get order statistics"""
        total_orders = Order.objects.count()
        completed_orders = Order.objects.filter(status='completed').count()
        pending_orders = Order.objects.filter(status='pending').count()
        total_revenue = Order.objects.aggregate(Sum('total_amount'))['total_amount__sum'] or 0

        return Response({
            'total_orders': total_orders,
            'completed_orders': completed_orders,
            'pending_orders': pending_orders,
            'total_revenue': float(total_revenue)
        })


class CheckoutViewSet(viewsets.ModelViewSet):
    queryset = Checkout.objects.all()
    serializer_class = CheckoutSerializer
    permission_classes = [permissions.IsAuthenticated]
    filterset_fields = ['payment_status', 'order']

    @action(detail=True, methods=['patch'])
    def update_payment_status(self, request, pk=None):
        """Update payment status"""
        checkout = self.get_object()
        new_status = request.data.get('payment_status')
        if new_status and new_status in dict(Checkout.PAYMENT_STATUS_CHOICES):
            checkout.payment_status = new_status
            checkout.save()
            return Response(CheckoutSerializer(checkout).data)
        return Response(
            {'error': f'Invalid status. Must be one of {list(dict(Checkout.PAYMENT_STATUS_CHOICES).keys())}'},
            status=status.HTTP_400_BAD_REQUEST
        )


class AdminUserViewSet(viewsets.ModelViewSet):
    queryset = AdminUser.objects.all()
    serializer_class = AdminUserSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        """Only superusers can view all admin users"""
        if self.request.user.is_superuser:
            return AdminUser.objects.all()
        return AdminUser.objects.filter(user=self.request.user)

    @action(detail=False, methods=['get'])
    def me(self, request):
        """Get current user's admin profile"""
        try:
            admin_user = request.user.admin_profile
            serializer = self.get_serializer(admin_user)
            return Response(serializer.data)
        except AdminUser.DoesNotExist:
            return Response({'error': 'User is not an admin'}, status=status.HTTP_404_NOT_FOUND)


class DashboardViewSet(viewsets.ViewSet):
    """Dashboard statistics and analytics"""
    permission_classes = [permissions.IsAuthenticated]

    @action(detail=False, methods=['get'])
    def summary(self, request):
        """Get dashboard summary"""
        return Response({
            'total_customers': Customer.objects.count(),
            'total_orders': Order.objects.count(),
            'total_revenue': float(Order.objects.aggregate(Sum('total_amount'))['total_amount__sum'] or 0),
            'menu_items': MenuItem.objects.count(),
            'pending_orders': Order.objects.filter(status='pending').count(),
            'completed_orders': Order.objects.filter(status='completed').count(),
        })

    @action(detail=False, methods=['get'])
    def recent_orders(self, request):
        """Get recent orders"""
        orders = Order.objects.all()[:10]
        serializer = OrderSerializer(orders, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def top_customers(self, request):
        """Get top customers by spending"""
        customers = Customer.objects.order_by('-total_spent')[:5]
        serializer = CustomerSerializer(customers, many=True)
        return Response(serializer.data)
    
    
def kitchen_display(request):
    # Get all active orders (not completed or cancelled)
    active_orders = Order.objects.filter(status__in=['pending', 'confirmed', 'preparing', 'ready']).order_by('created_at')
    
    # We will organize items into these three categories for the template
    coffee_orders = []
    pastry_orders = []
    kitchen_orders = []

    for order in active_orders:
        order_items = order.items.select_related('menu_item', 'menu_item__category').all()
        
        c_items = []
        p_items = []
        k_items = []

        for item in order_items:
            cat_name = item.menu_item.category.name.lower()
            
            # Categorize based on the category name
            # You can adjust these string matches based on your actual database categories
            if 'pastry' in cat_name or 'bread' in cat_name or 'cake' in cat_name:
                p_items.append(item)
            elif 'food' in cat_name or 'kitchen' in cat_name or 'meal' in cat_name:
                k_items.append(item)
            else:
                # Default to coffee/bar for drinks
                c_items.append(item)
                
        # If this order has coffee items, add it to the coffee display
        if c_items:
            coffee_orders.append({'order': order, 'items': c_items})
        # If it has pastry items, add to pastry display
        if p_items:
            pastry_orders.append({'order': order, 'items': p_items})
        # If it has kitchen items, add to kitchen display
        if k_items:
            kitchen_orders.append({'order': order, 'items': k_items})

    context = {
        'coffee_orders': coffee_orders,
        'pastry_orders': pastry_orders,
        'kitchen_orders': kitchen_orders,
    }
    
    return render(request, 'orders.html', context)

def cms_dashboard(request):
    """Renders the custom Lumiora manager dashboard"""
    return render(request, 'cms_home.html')

def pipeline_results(request):
    # This queries the table the pipeline created
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM report_daily_sales ORDER BY order_date DESC")
        columns = [col[0] for col in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
    
    return render(request, 'pipeline_view.html', {'reports': data})

def trigger_pipeline(request):
    # This runs the pipeline script whenever the URL is visited
    subprocess.run(["python", "/app/pipeline.py"])
    return HttpResponse("Pipeline ran successfully!")
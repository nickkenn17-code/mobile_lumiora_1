from rest_framework import serializers
from django.contrib.auth.models import User
from .models import (
    Category, MenuItem, Bundle, Customer, Order, OrderItem, Checkout, AdminUser
)


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'name', 'description', 'created_at', 'updated_at']


class MenuItemSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source='category.name', read_only=True)

    class Meta:
        model = MenuItem
        fields = [
            'id', 'name', 'description', 'category', 'category_name', 
            'price', 'is_available', 'calories', 'created_at', 'updated_at'
        ]


class BundleSerializer(serializers.ModelSerializer):
    items = MenuItemSerializer(many=True, read_only=True)
    item_ids = serializers.PrimaryKeyRelatedField(
        queryset=MenuItem.objects.all(),
        many=True,
        write_only=True,
        source='items'
    )

    class Meta:
        model = Bundle
        fields = [
            'id', 'name', 'description', 'items', 'item_ids',
            'discount_percentage', 'bundle_price', 'is_active',
            'created_at', 'updated_at'
        ]


class CustomerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Customer
        fields = [
            'id', 'email', 'phone', 'first_name', 'last_name', 'address',
            'city', 'postal_code', 'is_active', 'total_orders', 'total_spent',
            'created_at', 'updated_at'
        ]


class OrderItemSerializer(serializers.ModelSerializer):
    menu_item_name = serializers.CharField(source='menu_item.name', read_only=True)

    class Meta:
        model = OrderItem
        fields = ['id', 'menu_item', 'menu_item_name', 'quantity', 'price']


class OrderSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True, read_only=True)
    customer_email = serializers.CharField(source='customer.email', read_only=True)

    class Meta:
        model = Order
        fields = [
            'id', 'customer', 'customer_email', 'status', 'total_amount',
            'notes', 'items', 'created_at', 'updated_at'
        ]


class CheckoutSerializer(serializers.ModelSerializer):
    order_id = serializers.IntegerField(source='order.id', read_only=True)

    class Meta:
        model = Checkout
        fields = [
            'id', 'order', 'order_id', 'amount', 'payment_status',
            'payment_method', 'transaction_id', 'created_at', 'updated_at'
        ]


class AdminUserSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', read_only=True)
    email = serializers.CharField(source='user.email', read_only=True)
    first_name = serializers.CharField(source='user.first_name', read_only=True)
    last_name = serializers.CharField(source='user.last_name', read_only=True)

    class Meta:
        model = AdminUser
        fields = [
            'id', 'user', 'username', 'email', 'first_name', 'last_name',
            'role', 'can_manage_menu', 'can_manage_users', 'can_manage_orders',
            'can_view_analytics', 'is_active'
        ]


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name']

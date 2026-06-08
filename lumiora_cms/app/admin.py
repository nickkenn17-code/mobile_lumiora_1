from django.contrib import admin
from .models import Category, MenuItem, Bundle, Customer, Order, OrderItem, Checkout, AdminUser


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('name',)
    search_fields = ('name', 'description')


@admin.register(MenuItem)
class MenuItemAdmin(admin.ModelAdmin):
    list_display = ('name', 'category', 'price', 'is_available')
    list_filter = ('category', 'is_available')
    search_fields = ('name', 'description')


@admin.register(Bundle)
class BundleAdmin(admin.ModelAdmin):
    list_display = ('name', 'bundle_price', 'discount_percentage')
    search_fields = ('name', 'description')
    filter_horizontal = ('items',)


@admin.register(Customer)
class CustomerAdmin(admin.ModelAdmin):
    list_display = ('email', 'first_name', 'last_name', 'total_orders', 'total_spent', 'is_active')
    list_filter = ('is_active',)
    search_fields = ('email', 'first_name', 'last_name', 'phone')


class OrderItemInline(admin.TabularInline):
    model = OrderItem
    extra = 1


@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ('id', 'customer', 'status', 'total_amount')
    list_filter = ('status',)
    search_fields = ('customer__email', 'id')
    inlines = (OrderItemInline,)


@admin.register(OrderItem)
class OrderItemAdmin(admin.ModelAdmin):
    list_display = ('order', 'menu_item', 'quantity', 'price')
    list_filter = ('order',)
    search_fields = ('order__id', 'menu_item__name')

@admin.register(Checkout)
class CheckoutAdmin(admin.ModelAdmin):
    list_display = ('id', 'order', 'amount', 'payment_status', 'payment_method')
    list_filter = ('payment_status',)
    search_fields = ('transaction_id', 'order__customer__email')


@admin.register(AdminUser)
class AdminUserAdmin(admin.ModelAdmin):
    list_display = ('user', 'role', 'is_active')
    list_filter = ('role', 'is_active')
    search_fields = ('user__username', 'user__email')


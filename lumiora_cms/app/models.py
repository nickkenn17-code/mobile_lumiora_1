# from django.db import models
# from django.contrib.auth.models import User
# from django.core.validators import MinValueValidator

# class Category(models.Model):
#     """Menu item categories"""
#     name = models.CharField(max_length=100, unique=True)
#     description = models.TextField(blank=True, null=True)
#     created_at = models.DateTimeField(auto_now_add=True)
#     updated_at = models.DateTimeField(auto_now=True)

#     class Meta:
#         ordering = ['name']
#         verbose_name_plural = 'Categories'

#     def __str__(self):
#         return self.name


# class MenuItem(models.Model):
#     """Menu items in the cafe"""
#     name = models.CharField(max_length=100)
#     description = models.TextField()
#     category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='items')
#     price = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(0)])
#     is_available = models.BooleanField(default=True)
#     calories = models.IntegerField(blank=True, null=True)
#     created_at = models.DateTimeField(auto_now_add=True)
#     updated_at = models.DateTimeField(auto_now=True)

#     class Meta:
#         ordering = ['category', 'name']

#     def __str__(self):
#         return f"{self.name} (${self.price})"


# class Bundle(models.Model):
#     """Bundle deals combining multiple items"""
#     name = models.CharField(max_length=100)
#     description = models.TextField()
#     items = models.ManyToManyField(MenuItem)
#     discount_percentage = models.FloatField(validators=[MinValueValidator(0)], default=0)
#     bundle_price = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(0)])
#     image = models.ImageField(upload_to='bundles/')
#     created_at = models.DateTimeField(auto_now_add=True)
#     updated_at = models.DateTimeField(auto_now=True)

#     def __str__(self):
#         return self.name


# class Customer(models.Model):
#     """Customer profiles"""
#     email = models.EmailField(unique=True)
#     phone = models.CharField(max_length=20, blank=True)
#     first_name = models.CharField(max_length=50)
#     last_name = models.CharField(max_length=50)
#     address = models.TextField(blank=True)
#     city = models.CharField(max_length=50, blank=True)
#     postal_code = models.CharField(max_length=20, blank=True)
#     is_active = models.BooleanField(default=True)
#     total_orders = models.IntegerField(default=0)
#     total_spent = models.DecimalField(max_digits=10, decimal_places=2, default=0, validators=[MinValueValidator(0)])
#     created_at = models.DateTimeField(auto_now_add=True)
#     updated_at = models.DateTimeField(auto_now=True)

#     class Meta:
#         ordering = ['-created_at']

#     def __str__(self):
#         return f"{self.first_name} {self.last_name} ({self.email})"


# class Order(models.Model):
#     """Customer orders"""
#     STATUS_CHOICES = [
#         ('pending', 'Pending'),
#         ('confirmed', 'Confirmed'),
#         ('preparing', 'Preparing'),
#         ('ready', 'Ready'),
#         ('completed', 'Completed'),
#         ('cancelled', 'Cancelled'),
#     ]
    
#     customer = models.ForeignKey(Customer, on_delete=models.CASCADE, related_name='orders')
#     status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
#     total_amount = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(0)])
#     notes = models.TextField(blank=True)
#     created_at = models.DateTimeField(auto_now_add=True)
#     updated_at = models.DateTimeField(auto_now=True)

#     class Meta:
#         ordering = ['-created_at']

#     def __str__(self):
#         return f"Order #{self.id} - {self.customer.email}"


# class OrderItem(models.Model):
#     """Items in an order"""
#     order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='items')
#     menu_item = models.ForeignKey(MenuItem, on_delete=models.SET_NULL, null=True)
#     quantity = models.PositiveIntegerField(validators=[MinValueValidator(1)])
#     price = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(0)])

#     def __str__(self):
#         return f"{self.quantity}x {self.menu_item.name}"


# class Checkout(models.Model):
#     """Payment checkout information"""
#     PAYMENT_STATUS_CHOICES = [
#         ('pending', 'Pending'),
#         ('completed', 'Completed'),
#         ('failed', 'Failed'),
#         ('refunded', 'Refunded'),
#     ]
    
#     order = models.OneToOneField(Order, on_delete=models.CASCADE, related_name='checkout')
#     amount = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(0)])
#     payment_status = models.CharField(max_length=20, choices=PAYMENT_STATUS_CHOICES, default='pending')
#     payment_method = models.CharField(max_length=50, blank=True)
#     transaction_id = models.CharField(max_length=100, unique=True, blank=True)
#     created_at = models.DateTimeField(auto_now_add=True)
#     updated_at = models.DateTimeField(auto_now=True)

#     class Meta:
#         ordering = ['-created_at']

#     def __str__(self):
#         return f"Checkout for Order #{self.order.id}"


# class AdminUser(models.Model):
#     """Admin user roles and permissions"""
#     ROLE_CHOICES = [
#         ('super_admin', 'Super Admin'),
#         ('admin', 'Admin'),
#         ('manager', 'Manager'),
#         ('staff', 'Staff'),
#     ]
    
#     user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='admin_profile')
#     role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='staff')
#     can_manage_menu = models.BooleanField(default=False)
#     can_manage_users = models.BooleanField(default=False)
#     can_manage_orders = models.BooleanField(default=False)
#     can_view_analytics = models.BooleanField(default=False)
#     is_active = models.BooleanField(default=True)

#     def __str__(self):
#         return f"{self.user.get_full_name()} ({self.role})"

from django.db import models
from django.contrib.auth.models import User
from django.core.validators import MinValueValidator

class Category(models.Model):
    name = models.CharField(max_length=100, unique=True, db_index=True)
    description = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['name']
        verbose_name_plural = 'Categories'

    def __str__(self):
        return self.name

class MenuItem(models.Model):
    name = models.CharField(max_length=100, db_index=True)
    description = models.TextField()
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='items')
    price = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(0)])
    is_available = models.BooleanField(default=True, db_index=True)
    calories = models.IntegerField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['category', 'name']

    def __str__(self):
        return f"{self.name} (${self.price})"

class Bundle(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField()
    items = models.ManyToManyField(MenuItem, related_name='bundles')
    discount_percentage = models.FloatField(validators=[MinValueValidator(0)], default=0)
    bundle_price = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(0)])
    image = models.ImageField(upload_to='bundles/')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name

class Customer(models.Model):
    email = models.EmailField(unique=True, db_index=True)
    phone = models.CharField(max_length=20, blank=True)
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    address = models.TextField(blank=True)
    city = models.CharField(max_length=50, blank=True)
    postal_code = models.CharField(max_length=20, blank=True)
    is_active = models.BooleanField(default=True)
    total_orders = models.IntegerField(default=0)
    total_spent = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.first_name} {self.last_name} ({self.email})"

class Order(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'), ('confirmed', 'Confirmed'),
        ('preparing', 'Preparing'), ('ready', 'Ready'),
        ('completed', 'Completed'), ('cancelled', 'Cancelled'),
    ]
    
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE, related_name='orders')
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending', db_index=True)
    total_amount = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(0)])
    notes = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True, db_index=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"Order #{self.id} - {self.customer.email}"

class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='items')
    menu_item = models.ForeignKey(MenuItem, on_delete=models.SET_NULL, null=True, related_name='order_items')
    quantity = models.PositiveIntegerField(validators=[MinValueValidator(1)])
    price = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(0)])

    def __str__(self):
        return f"{self.quantity}x {self.menu_item.name}"

class Checkout(models.Model):
    PAYMENT_STATUS_CHOICES = [
        ('pending', 'Pending'), ('completed', 'Completed'),
        ('failed', 'Failed'), ('refunded', 'Refunded'),
    ]
    
    order = models.OneToOneField(Order, on_delete=models.CASCADE, related_name='checkout')
    amount = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(0)])
    payment_status = models.CharField(max_length=20, choices=PAYMENT_STATUS_CHOICES, default='pending', db_index=True)
    payment_method = models.CharField(max_length=50, blank=True)
    transaction_id = models.CharField(max_length=100, unique=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"Checkout for Order #{self.order.id}"

class AdminUser(models.Model):
    ROLE_CHOICES = [
        ('super_admin', 'Super Admin'), ('admin', 'Admin'),
        ('manager', 'Manager'), ('staff', 'Staff'),
    ]
    
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='admin_profile')
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='staff')
    can_manage_menu = models.BooleanField(default=False)
    can_manage_users = models.BooleanField(default=False)
    can_manage_orders = models.BooleanField(default=False)
    can_view_analytics = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.get_full_name()} ({self.role})"
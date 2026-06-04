"""
Tests for the Lumiora CMS application
"""
from django.test import TestCase
from django.contrib.auth.models import User
from app.models import Category, MenuItem, Bundle, Customer, Order, OrderItem, Checkout, AdminUser


class CategoryTestCase(TestCase):
    def setUp(self):
        self.category = Category.objects.create(
            name="Coffee",
            description="Coffee beverages"
        )
    
    def test_category_creation(self):
        self.assertEqual(self.category.name, "Coffee")
        self.assertTrue(Category.objects.filter(name="Coffee").exists())


class MenuItemTestCase(TestCase):
    def setUp(self):
        self.category = Category.objects.create(name="Coffee")
        self.item = MenuItem.objects.create(
            name="Espresso",
            description="Strong coffee",
            category=self.category,
            price=3.50,
            is_available=True
        )
    
    def test_menu_item_creation(self):
        self.assertEqual(self.item.name, "Espresso")
        self.assertEqual(self.item.price, 3.50)
        self.assertTrue(self.item.is_available)
    
    def test_menu_item_price_validation(self):
        with self.assertRaises(Exception):
            MenuItem.objects.create(
                name="Invalid",
                description="Test",
                category=self.category,
                price=-5,  # Invalid negative price
                is_available=True
            )


class CustomerTestCase(TestCase):
    def setUp(self):
        self.customer = Customer.objects.create(
            email="customer@example.com",
            first_name="John",
            last_name="Doe",
            phone="1234567890"
        )
    
    def test_customer_creation(self):
        self.assertEqual(self.customer.email, "customer@example.com")
        self.assertEqual(self.customer.first_name, "John")


class OrderTestCase(TestCase):
    def setUp(self):
        self.customer = Customer.objects.create(
            email="customer@example.com",
            first_name="John",
            last_name="Doe"
        )
        self.order = Order.objects.create(
            customer=self.customer,
            status="pending",
            total_amount=25.00
        )
    
    def test_order_creation(self):
        self.assertEqual(self.order.status, "pending")
        self.assertEqual(self.order.total_amount, 25.00)


class AdminUserTestCase(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username="admin",
            email="admin@example.com",
            password="testpass123"
        )
        self.admin_user = AdminUser.objects.create(
            user=self.user,
            role="admin",
            can_manage_menu=True
        )
    
    def test_admin_user_creation(self):
        self.assertEqual(self.admin_user.role, "admin")
        self.assertTrue(self.admin_user.can_manage_menu)

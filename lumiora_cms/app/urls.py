from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views
from .views import (
    CategoryViewSet, MenuItemViewSet, BundleViewSet, CustomerViewSet,
    OrderViewSet, CheckoutViewSet, AdminUserViewSet, DashboardViewSet
)

router = DefaultRouter()
router.register(r'categories', CategoryViewSet, basename='category')
router.register(r'menu-items', MenuItemViewSet, basename='menu-item')
router.register(r'bundles', BundleViewSet, basename='bundle')
router.register(r'customers', CustomerViewSet, basename='customer')
router.register(r'orders', OrderViewSet, basename='order')
router.register(r'checkouts', CheckoutViewSet, basename='checkout')
router.register(r'admin-users', AdminUserViewSet, basename='admin-user')
router.register(r'dashboard', DashboardViewSet, basename='dashboard')

urlpatterns = [
    path('', include(router.urls)),
    # Notice the kitchen route is completely gone from here!
]
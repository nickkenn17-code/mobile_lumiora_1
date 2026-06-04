#!/usr/bin/env python
"""
Setup script for Lumiora CMS
This script handles initial setup and initialization
"""
import os
import sys
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'lumiora_cms.settings')
django.setup()

from django.core.management import execute_from_command_line
from django.contrib.auth.models import User
from app.models import AdminUser


def setup_database():
    """Run database migrations"""
    print("Creating migrations...")
    execute_from_command_line(['manage.py', 'makemigrations'])
    print("Running database migrations...")
    execute_from_command_line(['manage.py', 'migrate'])
    print("✓ Database migrations completed")


def create_superuser():
    """Create a default superuser if none exists"""
    if User.objects.filter(is_superuser=True).exists():
        print("✓ Superuser already exists")
        return
    
    print("\n--- Creating Superuser ---")
    username = input("Enter superuser username (default: admin): ").strip() or "admin"
    email = input("Enter superuser email (default: admin@lumiora.local): ").strip() or "admin@lumiora.local"
    password = input("Enter superuser password: ").strip()
    
    if password:
        user = User.objects.create_superuser(username, email, password)
        AdminUser.objects.create(
            user=user,
            role='super_admin',
            can_manage_menu=True,
            can_manage_users=True,
            can_manage_orders=True,
            can_view_analytics=True
        )
        print(f"✓ Superuser '{username}' created successfully")
    else:
        print("✗ Password required")


def create_sample_data():
    """Create sample data for testing"""
    from app.models import Category, MenuItem
    
    if Category.objects.exists():
        print("✓ Sample data already exists")
        return
    
    print("\n--- Creating Sample Data ---")
    
    # Create categories
    categories = [
        Category.objects.create(name="Coffee", description="Hot and cold coffee beverages"),
        Category.objects.create(name="Tea", description="Various tea options"),
        Category.objects.create(name="Pastries", description="Freshly baked pastries"),
    ]
    
    # Create menu items
    MenuItem.objects.create(
        name="Espresso",
        description="Strong, concentrated coffee",
        category=categories[0],
        price=3.50,
        is_available=True,
        calories=5
    )
    
    MenuItem.objects.create(
        name="Latte",
        description="Espresso with steamed milk",
        category=categories[0],
        price=4.50,
        is_available=True,
        calories=190
    )
    
    MenuItem.objects.create(
        name="Cappuccino",
        description="Espresso with foam and milk",
        category=categories[0],
        price=4.50,
        is_available=True,
        calories=150
    )
    
    print("✓ Sample data created successfully")


def main():
    print("\n" + "="*50)
    print("Lumiora CMS Setup")
    print("="*50 + "\n")
    
    try:
        setup_database()
        create_superuser()
        create_sample_data()
        
        print("\n" + "="*50)
        print("✓ Setup completed successfully!")
        print("="*50)
        print("\nNext steps:")
        print("1. Run: python manage.py runserver")
        print("2. Visit: http://localhost:8000/admin")
        print("3. Login with your superuser credentials")
        print("\n")
        
    except Exception as e:
        print(f"\n✗ Setup failed: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()

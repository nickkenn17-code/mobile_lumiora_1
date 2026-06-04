# Lumiora Admin CMS

A comprehensive Django-based Content Management System for managing the Lumiora Cafe application. This CMS provides a complete admin interface for managing menu items, categories, bundles, customers, orders, and payments.

## Features

✅ **Complete Admin Dashboard**
- User-friendly admin interface built with Django Admin
- RESTful API for programmatic access
- Role-based access control

✅ **Menu Management**
- Create, read, update, delete categories
- Manage menu items with images, prices, and availability
- Bundle deals with discounts

✅ **Customer Management**
- Customer profiles with contact information
- Order history tracking
- Customer spending statistics

✅ **Order Management**
- Create and track customer orders
- Order status workflow (pending, confirmed, preparing, ready, completed, cancelled)
- Order item details with pricing

✅ **Payment & Checkout**
- Track payment status for orders
- Support multiple payment methods
- Transaction ID tracking

✅ **Analytics & Reports**
- Dashboard summary with key metrics
- Customer statistics
- Order statistics
- Revenue tracking

✅ **RESTful API**
- Comprehensive REST API for all resources
- Filtering, searching, and pagination
- Admin-only write operations

## Project Structure

```
lumiora_cms/
├── manage.py                 # Django management script
├── requirements.txt          # Python dependencies
├── .env.example             # Environment variables template
├── lumiora_cms/            # Project configuration
│   ├── __init__.py
│   ├── settings.py         # Django settings
│   ├── urls.py            # URL routing
│   ├── asgi.py            # ASGI config
│   └── wsgi.py            # WSGI config
├── app/                    # Main application
│   ├── migrations/         # Database migrations
│   ├── static/            # Static files (CSS, JS, images)
│   ├── templates/         # HTML templates
│   ├── admin.py           # Django admin customization
│   ├── models.py          # Database models
│   ├── views.py           # API views
│   ├── serializers.py     # DRF serializers
│   ├── urls.py            # API routes
│   ├── forms.py           # Django forms
│   └── tests.py           # Unit tests
└── media/                 # User uploaded files
```

## Installation

### Prerequisites
- Python 3.8+
- PostgreSQL 12+
- pip (Python package manager)

### Setup Steps

1. **Navigate to project directory**
   ```bash
   cd lumiora_cms
   ```

2. **Create a virtual environment**
   ```bash
   # Windows
   python -m venv venv
   venv\Scripts\activate
   
   # macOS/Linux
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your database credentials and settings
   ```

5. **Run database migrations**
   ```bash
   python manage.py migrate
   ```

6. **Create a superuser**
   ```bash
   python manage.py createsuperuser
   ```

7. **Collect static files** (for production)
   ```bash
   python manage.py collectstatic
   ```

8. **Run the development server**
   ```bash
   python manage.py runserver
   ```

   The CMS will be available at: `http://localhost:8000`
   Admin interface: `http://localhost:8000/admin`

## Usage

### Admin Dashboard
Access the Django admin interface at `/admin` with your superuser credentials.

### REST API

The CMS provides a comprehensive REST API. Base URL: `http://localhost:8000/api/`

**Authentication:** Session authentication (login required)

**Available Endpoints:**

#### Categories
- `GET /api/categories/` - List all categories
- `POST /api/categories/` - Create a new category
- `GET /api/categories/{id}/` - Get category details
- `PUT /api/categories/{id}/` - Update a category
- `DELETE /api/categories/{id}/` - Delete a category

#### Menu Items
- `GET /api/menu-items/` - List all menu items
- `POST /api/menu-items/` - Create a new menu item
- `GET /api/menu-items/{id}/` - Get menu item details
- `PUT /api/menu-items/{id}/` - Update a menu item
- `DELETE /api/menu-items/{id}/` - Delete a menu item
- `GET /api/menu-items/available/` - List available items
- `POST /api/menu-items/{id}/toggle_availability/` - Toggle availability

#### Bundles
- `GET /api/bundles/` - List all bundles
- `POST /api/bundles/` - Create a new bundle
- `GET /api/bundles/{id}/` - Get bundle details
- `PUT /api/bundles/{id}/` - Update a bundle
- `DELETE /api/bundles/{id}/` - Delete a bundle
- `GET /api/bundles/active/` - List active bundles

#### Customers
- `GET /api/customers/` - List all customers
- `POST /api/customers/` - Create a new customer
- `GET /api/customers/{id}/` - Get customer details
- `PUT /api/customers/{id}/` - Update a customer
- `DELETE /api/customers/{id}/` - Delete a customer
- `GET /api/customers/{id}/order_history/` - Get customer order history
- `GET /api/customers/statistics/` - Get customer statistics

#### Orders
- `GET /api/orders/` - List all orders
- `POST /api/orders/` - Create a new order
- `GET /api/orders/{id}/` - Get order details
- `PUT /api/orders/{id}/` - Update an order
- `DELETE /api/orders/{id}/` - Delete an order
- `PATCH /api/orders/{id}/update_status/` - Update order status
- `GET /api/orders/statistics/` - Get order statistics

#### Checkouts
- `GET /api/checkouts/` - List all checkouts
- `POST /api/checkouts/` - Create a checkout
- `GET /api/checkouts/{id}/` - Get checkout details
- `PATCH /api/checkouts/{id}/update_payment_status/` - Update payment status

#### Admin Users
- `GET /api/admin-users/` - List admin users (superuser only)
- `GET /api/admin-users/me/` - Get current user's profile

#### Dashboard
- `GET /api/dashboard/summary/` - Get dashboard summary
- `GET /api/dashboard/recent_orders/` - Get recent orders
- `GET /api/dashboard/top_customers/` - Get top customers by spending

## Database Models

### Category
- `name` - Category name
- `description` - Category description
- `image` - Category image

### MenuItem
- `name` - Menu item name
- `description` - Description
- `category` - Foreign key to Category
- `price` - Item price
- `image` - Item image
- `is_available` - Availability status
- `calories` - Calorie information

### Bundle
- `name` - Bundle name
- `description` - Description
- `items` - Many-to-many relation to MenuItems
- `discount_percentage` - Discount percentage
- `bundle_price` - Bundle price
- `image` - Bundle image
- `is_active` - Active status

### Customer
- `email` - Customer email
- `phone` - Phone number
- `first_name` - First name
- `last_name` - Last name
- `address` - Street address
- `city` - City
- `postal_code` - Postal code
- `is_active` - Account status
- `total_orders` - Number of orders
- `total_spent` - Total amount spent

### Order
- `customer` - Foreign key to Customer
- `status` - Order status (pending, confirmed, preparing, ready, completed, cancelled)
- `total_amount` - Order total
- `notes` - Order notes

### OrderItem
- `order` - Foreign key to Order
- `menu_item` - Foreign key to MenuItem
- `quantity` - Item quantity
- `price` - Item price at time of order

### Checkout
- `order` - One-to-one relation to Order
- `amount` - Checkout amount
- `payment_status` - Payment status
- `payment_method` - Payment method used
- `transaction_id` - Transaction identifier

### AdminUser
- `user` - One-to-one relation to Django User
- `role` - Admin role (super_admin, admin, manager, staff)
- `can_manage_menu` - Permission to manage menu
- `can_manage_users` - Permission to manage users
- `can_manage_orders` - Permission to manage orders
- `can_view_analytics` - Permission to view analytics

## Management Commands

```bash
# Create database migrations
python manage.py makemigrations

# Apply migrations
python manage.py migrate

# Create a superuser
python manage.py createsuperuser

# Create a normal user
python manage.py createsuperuser --username admin --email admin@lumiora.local

# Collect static files
python manage.py collectstatic

# Run tests
python manage.py test

# Start development server
python manage.py runserver

# Start on specific port
python manage.py runserver 0.0.0.0:8000

# Shell for interactive testing
python manage.py shell
```

## Configuration

### Environment Variables (.env)

Create a `.env` file based on `.env.example`:

```env
# Django Settings
DEBUG=True
SECRET_KEY=your-very-secret-key-here

# Database
DB_NAME=lumiora_db
DB_USER=postgres
DB_PASSWORD=123
DB_HOST=localhost
DB_PORT=5432

# Allowed Hosts
ALLOWED_HOSTS=localhost,127.0.0.1,43.133.144.212

# External API
EXTERNAL_API_URL=http://localhost:3000

# CORS
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000
```

## Deployment

### Using Gunicorn (Production)

```bash
# Install Gunicorn
pip install gunicorn

# Run with Gunicorn
gunicorn lumiora_cms.wsgi --bind 0.0.0.0:8000 --workers 4
```

### Using Docker

Create a `Dockerfile`:

```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
RUN python manage.py collectstatic --noinput
CMD ["gunicorn", "lumiora_cms.wsgi", "--bind", "0.0.0.0:8000"]
```

Build and run:

```bash
docker build -t lumiora-cms .
docker run -p 8000:8000 lumiora-cms
```

## Troubleshooting

### ModuleNotFoundError: No module named 'django'
```bash
pip install -r requirements.txt
```

### PostgreSQL connection error
- Ensure PostgreSQL is running
- Check database credentials in `.env`
- Verify database exists: `createdb lumiora_db`

### Port already in use
```bash
python manage.py runserver 8001
```

### Static files not loading
```bash
python manage.py collectstatic
```

## API Integration with Mobile App

The mobile app can interact with this CMS API. Example integration points:

```dart
// Fetch menu items
GET /api/menu-items/

// Create an order
POST /api/orders/
{
  "customer": 1,
  "status": "pending",
  "total_amount": 29.99,
  "notes": "No onions"
}

// Track order status
GET /api/orders/{id}/
```

## Security Considerations

- Always use `DEBUG=False` in production
- Use a strong `SECRET_KEY`
- Enable HTTPS for production deployments
- Set `ALLOWED_HOSTS` to your domain(s)
- Use environment variables for sensitive data
- Implement proper authentication and authorization
- Regular security updates for dependencies

## Support and Maintenance

For issues or questions:
1. Check the Django documentation: https://docs.djangoproject.com/
2. Review Django REST Framework docs: https://www.django-rest-framework.org/
3. Check PostgreSQL documentation: https://www.postgresql.org/docs/

## License

This project is part of the Lumiora Mobile Application Performance Optimization assignment.

---

**Last Updated:** June 2026
**Version:** 1.0.0

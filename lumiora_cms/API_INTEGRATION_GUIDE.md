# Lumiora CMS API Integration Guide

## Overview

The Lumiora CMS provides a comprehensive REST API that the mobile application and other clients can interact with. This guide explains how to use the API for common operations.

## Base URL

```
http://localhost:8000/api/
```

or for production:

```
http://your-domain.com/api/
```

## Authentication

The CMS uses Django's session-based authentication. To use the API:

1. **Login via Admin Panel**
   ```
   GET /admin/
   ```
   Log in with your superuser credentials.

2. **Session Authenticated Requests**
   - Your browser session will be authenticated
   - Include credentials when making API calls from scripts

## API Endpoints Reference

### 1. Categories

#### Get all categories
```http
GET /api/categories/
```

**Response:**
```json
[
  {
    "id": 1,
    "name": "Coffee",
    "description": "Hot and cold coffee beverages",
    "image": "/media/categories/coffee.jpg",
    "created_at": "2026-06-04T10:00:00Z",
    "updated_at": "2026-06-04T10:00:00Z"
  }
]
```

#### Create a category (Admin only)
```http
POST /api/categories/
Content-Type: application/json

{
  "name": "Smoothies",
  "description": "Fresh fruit smoothies",
  "image": "/path/to/image.jpg"
}
```

#### Update a category (Admin only)
```http
PUT /api/categories/{id}/
Content-Type: application/json

{
  "name": "Premium Coffee",
  "description": "Updated description"
}
```

#### Delete a category (Admin only)
```http
DELETE /api/categories/{id}/
```

### 2. Menu Items

#### Get all menu items
```http
GET /api/menu-items/
```

**Query Parameters:**
- `category` - Filter by category ID
- `is_available` - Filter by availability (true/false)
- `search` - Search by name or description

**Example:**
```
GET /api/menu-items/?category=1&is_available=true
```

#### Get available menu items
```http
GET /api/menu-items/available/
```

#### Create a menu item (Admin only)
```http
POST /api/menu-items/
Content-Type: application/json

{
  "name": "Cappuccino",
  "description": "Espresso with foam and milk",
  "category": 1,
  "price": "4.50",
  "is_available": true,
  "calories": 150,
  "image": "/path/to/image.jpg"
}
```

#### Update a menu item (Admin only)
```http
PUT /api/menu-items/{id}/
Content-Type: application/json

{
  "price": "5.00",
  "is_available": true
}
```

#### Toggle menu item availability
```http
POST /api/menu-items/{id}/toggle_availability/
```

### 3. Bundles

#### Get all bundles
```http
GET /api/bundles/
```

#### Get active bundles
```http
GET /api/bundles/active/
```

#### Create a bundle (Admin only)
```http
POST /api/bundles/
Content-Type: application/json

{
  "name": "Morning Combo",
  "description": "Coffee and pastry combo",
  "item_ids": [1, 2, 3],
  "discount_percentage": 10,
  "bundle_price": "8.99",
  "is_active": true,
  "image": "/path/to/image.jpg"
}
```

### 4. Customers

#### Get all customers
```http
GET /api/customers/
```

**Query Parameters:**
- `is_active` - Filter by active status
- `search` - Search by email, first name, or last name

#### Create a customer
```http
POST /api/customers/
Content-Type: application/json

{
  "email": "customer@example.com",
  "phone": "1234567890",
  "first_name": "John",
  "last_name": "Doe",
  "address": "123 Main St",
  "city": "New York",
  "postal_code": "10001"
}
```

#### Get customer order history
```http
GET /api/customers/{id}/order_history/
```

#### Get customer statistics
```http
GET /api/customers/statistics/
```

**Response:**
```json
{
  "total_customers": 100,
  "active_customers": 95,
  "total_revenue": 5234.50
}
```

### 5. Orders

#### Get all orders
```http
GET /api/orders/
```

**Query Parameters:**
- `status` - Filter by status (pending, confirmed, preparing, ready, completed, cancelled)
- `customer` - Filter by customer ID
- `ordering` - Sort by field (e.g., `ordering=-created_at`)

#### Create an order
```http
POST /api/orders/
Content-Type: application/json

{
  "customer": 1,
  "status": "pending",
  "total_amount": "29.99",
  "notes": "No onions"
}
```

#### Update order status
```http
PATCH /api/orders/{id}/update_status/
Content-Type: application/json

{
  "status": "confirmed"
}
```

**Valid statuses:**
- `pending` - Order received
- `confirmed` - Order confirmed
- `preparing` - Being prepared
- `ready` - Ready for pickup/delivery
- `completed` - Order completed
- `cancelled` - Order cancelled

#### Get order statistics
```http
GET /api/orders/statistics/
```

**Response:**
```json
{
  "total_orders": 500,
  "completed_orders": 450,
  "pending_orders": 20,
  "total_revenue": 25000.00
}
```

### 6. Checkouts

#### Get all checkouts
```http
GET /api/checkouts/
```

#### Create a checkout
```http
POST /api/checkouts/
Content-Type: application/json

{
  "order": 1,
  "amount": "29.99",
  "payment_status": "pending",
  "payment_method": "credit_card"
}
```

#### Update payment status
```http
PATCH /api/checkouts/{id}/update_payment_status/
Content-Type: application/json

{
  "payment_status": "completed"
}
```

**Valid statuses:**
- `pending` - Payment pending
- `completed` - Payment completed
- `failed` - Payment failed
- `refunded` - Payment refunded

### 7. Dashboard

#### Get dashboard summary
```http
GET /api/dashboard/summary/
```

**Response:**
```json
{
  "total_customers": 100,
  "total_orders": 500,
  "total_revenue": 25000.00,
  "menu_items": 50,
  "pending_orders": 20,
  "completed_orders": 450
}
```

#### Get recent orders
```http
GET /api/dashboard/recent_orders/
```

#### Get top customers
```http
GET /api/dashboard/top_customers/
```

### 8. Admin Users

#### Get current user profile
```http
GET /api/admin-users/me/
```

**Response:**
```json
{
  "id": 1,
  "user": 1,
  "username": "admin",
  "email": "admin@example.com",
  "first_name": "Admin",
  "last_name": "User",
  "role": "super_admin",
  "can_manage_menu": true,
  "can_manage_users": true,
  "can_manage_orders": true,
  "can_view_analytics": true,
  "is_active": true
}
```

## Flutter Mobile App Integration Example

### Example: Fetch Menu Items
```dart
import 'package:http/http.dart' as http;

Future<List<MenuItem>> fetchMenuItems() async {
  final response = await http.get(
    Uri.parse('http://43.133.144.212:8000/api/menu-items/'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((item) => MenuItem.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load menu items');
  }
}
```

### Example: Create an Order
```dart
Future<Order> createOrder(int customerId, List<OrderItem> items, double total) async {
  final response = await http.post(
    Uri.parse('http://43.133.144.212:8000/api/orders/'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'customer': customerId,
      'status': 'pending',
      'total_amount': total,
      'notes': '',
    }),
  );

  if (response.statusCode == 201) {
    return Order.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create order');
  }
}
```

### Example: Update Order Status
```dart
Future<Order> updateOrderStatus(int orderId, String status) async {
  final response = await http.patch(
    Uri.parse('http://43.133.144.212:8000/api/orders/$orderId/update_status/'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'status': status}),
  );

  if (response.statusCode == 200) {
    return Order.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to update order status');
  }
}
```

## Error Handling

### HTTP Status Codes

- `200 OK` - Request successful
- `201 Created` - Resource created successfully
- `204 No Content` - Request successful, no content returned
- `400 Bad Request` - Invalid request parameters
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Permission denied
- `404 Not Found` - Resource not found
- `500 Internal Server Error` - Server error

### Error Response Format

```json
{
  "error": "Invalid status. Must be one of ['pending', 'confirmed', ...]"
}
```

## Rate Limiting

Currently, there is no rate limiting implemented. For production deployments, consider implementing:

1. Django REST Framework throttling
2. API key-based rate limiting
3. IP-based rate limiting

## Pagination

List endpoints support pagination with a default page size of 20 items.

**Query Parameters:**
- `page` - Page number (default: 1)
- `page_size` - Items per page (default: 20)

**Example:**
```
GET /api/menu-items/?page=2&page_size=50
```

**Response:**
```json
{
  "count": 150,
  "next": "http://localhost:8000/api/menu-items/?page=3",
  "previous": "http://localhost:8000/api/menu-items/?page=1",
  "results": [...]
}
```

## Filtering and Search

Most list endpoints support filtering and search:

**Filtering:**
```
GET /api/orders/?status=completed&customer=5
```

**Searching:**
```
GET /api/menu-items/?search=espresso
```

**Ordering:**
```
GET /api/orders/?ordering=-created_at
```

## Common Use Cases

### 1. Display Menu Items in Mobile App
```
GET /api/menu-items/?is_available=true
```

### 2. Get Customer's Order History
```
GET /api/customers/{customer_id}/order_history/
```

### 3. Create New Order from Cart
```
POST /api/orders/
POST /api/checkouts/
```

### 4. Admin Dashboard Overview
```
GET /api/dashboard/summary/
GET /api/dashboard/recent_orders/
GET /api/dashboard/top_customers/
```

### 5. Track Order Status
```
GET /api/orders/{order_id}/
```

### 6. Process Payment
```
PATCH /api/checkouts/{checkout_id}/update_payment_status/
```

## Testing with cURL

### Get menu items
```bash
curl -X GET http://localhost:8000/api/menu-items/
```

### Create an order
```bash
curl -X POST http://localhost:8000/api/orders/ \
  -H "Content-Type: application/json" \
  -d '{"customer": 1, "status": "pending", "total_amount": "29.99"}'
```

### Update order status
```bash
curl -X PATCH http://localhost:8000/api/orders/1/update_status/ \
  -H "Content-Type: application/json" \
  -d '{"status": "completed"}'
```

## Documentation

For more information, visit:
- Django Documentation: https://docs.djangoproject.com/
- Django REST Framework: https://www.django-rest-framework.org/
- API Documentation: http://localhost:8000/api-docs/ (if Swagger is installed)

---

**Last Updated:** June 2026

"""
Helper utilities for the Lumiora CMS
"""
import requests
from django.conf import settings
from django.core.cache import cache
import logging

logger = logging.getLogger(__name__)


class ExternalAPIClient:
    """
    Client for interacting with the external Lumiora API
    """
    
    def __init__(self):
        self.base_url = settings.EXTERNAL_API_URL
    
    def _make_request(self, method, endpoint, data=None):
        """Make HTTP request to external API"""
        try:
            url = f"{self.base_url}{endpoint}"
            if method.upper() == 'GET':
                response = requests.get(url)
            elif method.upper() == 'POST':
                response = requests.post(url, json=data)
            elif method.upper() == 'PUT':
                response = requests.put(url, json=data)
            elif method.upper() == 'DELETE':
                response = requests.delete(url)
            else:
                raise ValueError(f"Unsupported HTTP method: {method}")
            
            response.raise_for_status()
            return response.json() if response.content else None
        
        except requests.exceptions.RequestException as e:
            logger.error(f"External API request failed: {e}")
            return None
    
    def get_menu_items(self):
        """Fetch menu items from external API"""
        return self._make_request('GET', '/api/menu')
    
    def get_orders(self):
        """Fetch orders from external API"""
        return self._make_request('GET', '/api/orders')
    
    def get_customers(self):
        """Fetch customers from external API"""
        return self._make_request('GET', '/api/customers')


def sync_external_data():
    """
    Sync data from external API to CMS
    This can be called periodically via Celery or management command
    """
    client = ExternalAPIClient()
    
    try:
        # Sync menu items
        menu_items = client.get_menu_items()
        if menu_items:
            logger.info(f"Synced {len(menu_items)} menu items")
        
        # Sync orders
        orders = client.get_orders()
        if orders:
            logger.info(f"Synced {len(orders)} orders")
        
        # Sync customers
        customers = client.get_customers()
        if customers:
            logger.info(f"Synced {len(customers)} customers")
        
        return True
    
    except Exception as e:
        logger.error(f"Data sync failed: {e}")
        return False


def cache_key(prefix, *args):
    """Generate a cache key"""
    return f"{prefix}:{'_'.join(map(str, args))}"


def get_cached(prefix, *args, default=None):
    """Get cached value"""
    key = cache_key(prefix, *args)
    return cache.get(key, default)


def set_cached(prefix, value, *args, timeout=3600):
    """Set cached value"""
    key = cache_key(prefix, *args)
    cache.set(key, value, timeout)

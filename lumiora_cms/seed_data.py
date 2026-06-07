import os
import django

# Setup Django environment
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "lumiora_cms.settings")
django.setup()

from app.models import Category, MenuItem

def seed():
    # If categories already exist, we assume data is already seeded
    if Category.objects.exists():
        print("Database already seeded. Skipping.")
        return

    print("Seeding initial menu data into Django...")

    # Create Categories
    cat_latte, _ = Category.objects.get_or_create(
        name='Latte Series', 
        defaults={'description': 'Delicious milk-based espresso drinks'}
    )
    cat_classics, _ = Category.objects.get_or_create(
        name='Classics Coffee', 
        defaults={'description': 'Traditional coffee favorites'}
    )

    # Initial Menu Items with forced integer IDs to match the mobile app
    items = [
        (1, 'Latte', 'Espresso, Steamed milk', 21000, cat_latte),
        (2, 'Aren Latte', 'Espresso, Palm sugar, Steamed milk', 23000, cat_latte),
        (3, 'Spanish Latte', 'Espresso, Condensed milk, Steamed milk', 24000, cat_latte),
        (4, 'Butterscotch Latte', 'Espresso, Butterscotch, Steamed milk', 25000, cat_latte),
        (5, 'Salted Caramel', 'Espresso, Salted Caramel, Steamed milk', 25000, cat_latte),
        (6, 'Pistachio Latte', 'Espresso, Pistachio syrup, Steamed milk', 25000, cat_latte),
        (7, 'Rum Latte', 'Espresso, Rum syrup, Steamed milk', 25000, cat_latte),
        (8, 'Vanilla Latte', 'Espresso, Vanilla syrup, Steamed milk', 25000, cat_latte),
        (9, 'Americano', 'Espresso, Hot water', 18000, cat_classics),
        (10, 'Macchiato', 'Espresso, Foamed milk', 23000, cat_classics),
        (11, 'Cappuccino', 'Espresso, Steamed milk foam', 23000, cat_classics),
        (12, 'Piccolo', 'Espresso, Dash of milk', 23000, cat_classics),
        (13, 'Mochacino', 'Espresso, Chocolate, Steamed milk', 24000, cat_classics),
        (14, 'Espresso', 'Single shot of espresso', 15000, cat_classics),
        (15, 'Split', 'Double shot, split pour', 26000, cat_classics),
        (16, 'Double Shot', 'Two shots of espresso', 18000, cat_classics)
    ]

    for item_id, name, desc, price, cat in items:
        MenuItem.objects.get_or_create(
            id=item_id, 
            defaults={
                'name': name, 
                'description': desc, 
                'price': price, 
                'category': cat, 
                'is_available': True
            }
        )
    print("Seed data successfully injected!")

if __name__ == '__main__':
    seed()

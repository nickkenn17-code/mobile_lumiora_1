CREATE TABLE IF NOT EXISTS menu_items (
    id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    "imagePlaceholder" VARCHAR(255)
);

TRUNCATE TABLE menu_items;

INSERT INTO menu_items (id, name, description, price, category, "imagePlaceholder") VALUES
('m1', 'Latte', 'Espresso, Steamed milk', 21000, 'Latte Series', 'assets/images/placeholder_1.png'),
('m2', 'Aren Latte', 'Espresso, Palm sugar, Steamed milk', 23000, 'Latte Series', 'assets/images/placeholder_1.png'),
('m3', 'Spanish Latte', 'Espresso, Condensed milk, Steamed milk', 24000, 'Latte Series', 'assets/images/placeholder_1.png'),
('m4', 'Butterscotch Latte', 'Espresso, Butterscotch, Steamed milk', 25000, 'Latte Series', 'assets/images/placeholder_1.png'),
('m5', 'Salted Caramel', 'Espresso, Salted Caramel, Steamed milk', 25000, 'Latte Series', 'assets/images/placeholder_1.png'),
('m6', 'Pistachio Latte', 'Espresso, Pistachio syrup, Steamed milk', 25000, 'Latte Series', 'assets/images/placeholder_1.png'),
('m7', 'Rum Latte', 'Espresso, Rum syrup, Steamed milk', 25000, 'Latte Series', 'assets/images/placeholder_1.png'),
('m8', 'Vanilla Latte', 'Espresso, Vanilla syrup, Steamed milk', 25000, 'Latte Series', 'assets/images/placeholder_1.png'),
('m9', 'Americano', 'Espresso, Hot water', 18000, 'Classics Coffee', 'assets/images/placeholder_2.png'),
('m10', 'Macchiato', 'Espresso, Foamed milk', 23000, 'Classics Coffee', 'assets/images/placeholder_2.png'),
('m11', 'Cappuccino', 'Espresso, Steamed milk foam', 23000, 'Classics Coffee', 'assets/images/placeholder_2.png'),
('m12', 'Piccolo', 'Espresso, Dash of milk', 23000, 'Classics Coffee', 'assets/images/placeholder_2.png'),
('m13', 'Mochacino', 'Espresso, Chocolate, Steamed milk', 24000, 'Classics Coffee', 'assets/images/placeholder_2.png'),
('m14', 'Espresso', 'Single shot of espresso', 15000, 'Classics Coffee', 'assets/images/placeholder_2.png'),
('m15', 'Split', 'Double shot, split pour', 26000, 'Classics Coffee', 'assets/images/placeholder_2.png'),
('m16', 'Double Shot', 'Two shots of espresso', 18000, 'Classics Coffee', 'assets/images/placeholder_2.png');


CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL
);

TRUNCATE TABLE users;

-- just dummy data LOL
INSERT INTO users (username, password, phone) VALUES ('user', 'password123', '12345678');
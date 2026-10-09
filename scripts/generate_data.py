"""Generate reproducible synthetic e-commerce data. Standard library only.
Run: python scripts/generate_data.py
"""
from __future__ import annotations

from datetime import date, timedelta
from pathlib import Path
import random
import sqlite3

ROOT = Path(__file__).resolve().parents[1]
DB_PATH = ROOT / "database" / "ecommerce.db"
SCHEMA = (ROOT / "database" / "schema.sql").read_text(encoding="utf-8")
RNG = random.Random(20261009)

CITIES = ["Tehran", "Shiraz", "Isfahan", "Tabriz", "Mashhad", "Karaj", "Yazd", "Rasht", "Ahvaz", "Qom"]
FIRST = ["Arman", "Sara", "Nima", "Ava", "Kian", "Mina", "Parsa", "Darya", "Amir", "Roya", "Pouya", "Neda"]
LAST = ["Ahmadi", "Karimi", "Moradi", "Rahimi", "Rezaei", "Hosseini", "Farhadi", "Ebrahimi", "Jafari", "Kazemi"]
CATEGORIES = ["Electronics", "Clothing", "Home", "Beauty", "Sports", "Books", "Toys", "Grocery", "Office", "Automotive", "Pet", "Outdoors"]
PRODUCT_WORDS = ["Essential", "Classic", "Ultra", "Everyday", "Premium", "Smart", "Compact", "Pro", "Eco", "Comfort", "Plus", "Max", "Fresh", "Studio", "Flex", "Core", "Mini", "Select", "Prime", "Lite"]


def random_date(start: date, end: date) -> str:
    return (start + timedelta(days=RNG.randrange((end - start).days + 1))).isoformat()


def main() -> None:
    if DB_PATH.exists():
        DB_PATH.unlink()
    conn = sqlite3.connect(DB_PATH)
    conn.executescript(SCHEMA)

    conn.executemany(
        "INSERT INTO categories(category_id, category_name) VALUES (?, ?)",
        [(i, name) for i, name in enumerate(CATEGORIES, start=1)],
    )
    customers = [
        (i, f"{RNG.choice(FIRST)} {RNG.choice(LAST)}", RNG.choice(CITIES),
         random_date(date(2024, 1, 1), date(2026, 6, 30)))
        for i in range(1, 1401)
    ]
    conn.executemany("INSERT INTO customers VALUES (?, ?, ?, ?)", customers)

    products = []
    for product_id in range(1, 241):
        category_id = ((product_id - 1) % len(CATEGORIES)) + 1
        product_name = f"{PRODUCT_WORDS[(product_id - 1) // len(CATEGORIES)]} {CATEGORIES[category_id - 1]} Item"
        list_price = round(RNG.uniform(5, 600), 2)
        products.append((product_id, category_id, product_name, list_price))
    conn.executemany("INSERT INTO products VALUES (?, ?, ?, ?)", products)

    # Reserve a few customers and products with no orders/sales for LEFT JOIN exercises.
    active_customers = list(range(1, 1341))
    active_products = list(range(1, 235))
    start, end = date(2025, 1, 1), date(2026, 9, 30)
    orders = []
    items = []
    next_item_id = 1
    for order_id in range(1, 10001):
        customer_id = RNG.choice(active_customers)
        order_date = random_date(start, end)
        status = RNG.choices(["delivered", "shipped", "pending", "canceled"], weights=[82, 8, 6, 4])[0]
        orders.append((order_id, customer_id, order_date, status))
        chosen = RNG.sample(active_products, k=RNG.randint(1, 5))
        for product_id in chosen:
            quantity = RNG.randint(1, 4)
            current_price = products[product_id - 1][3]
            unit_price = round(current_price * RNG.uniform(0.85, 1.05), 2)
            items.append((next_item_id, order_id, product_id, quantity, unit_price))
            next_item_id += 1
    conn.executemany("INSERT INTO orders VALUES (?, ?, ?, ?)", orders)
    conn.executemany("INSERT INTO order_items VALUES (?, ?, ?, ?, ?)", items)
    conn.commit()
    result = conn.execute("PRAGMA foreign_key_check").fetchall()
    if result:
        raise RuntimeError(f"Foreign key errors: {result[:5]}")
    print(f"Generated {DB_PATH.name}: {len(customers)} customers, {len(CATEGORIES)} categories, "
          f"{len(products)} products, {len(orders)} orders, {len(items)} order items. Foreign keys OK.")
    conn.close()


if __name__ == "__main__":
    main()

# Data Dictionary

The dataset is **synthetic**. Currency is USD (fictional prices); dates use ISO `YYYY-MM-DD`.

| Table | Column | Meaning |
| --- | --- | --- |
| `customers` | `customer_id` | Primary key |
| `customers` | `full_name`, `city`, `signup_date` | Customer attributes |
| `categories` | `category_id`, `category_name` | Product categories |
| `products` | `product_id`, `category_id`, `product_name`, `list_price` | Catalog products and current listed price |
| `orders` | `order_id`, `customer_id`, `order_date`, `order_status` | One row per placed order |
| `order_items` | `order_item_id`, `order_id`, `product_id`, `quantity`, `unit_price` | Line items and actual transaction price |

**Revenue rule:** Use `quantity * unit_price` from `order_items`, not `products.list_price`. For completed sales, filter `orders.order_status = 'delivered'`. Order dates are not guaranteed to follow signup dates in this synthetic practice dataset. `unit_price` is per unit, not the line total.

**Join relationships:**

- `customers.customer_id` (1) → (many) `orders.customer_id`
- `orders.order_id` (1) → (many) `order_items.order_id`
- `products.product_id` (1) → (many) `order_items.product_id`
- `categories.category_id` (1) → (many) `products.category_id`

There are deliberately some customers with no orders and some products with no order items, for practicing LEFT JOIN.

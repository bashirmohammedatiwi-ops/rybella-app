# Cosmatic API Documentation

Base URL: `https://your-domain.com/api/v1`

All responses are JSON. Currency is Iraqi Dinar (IQD). Language: Arabic.

---

## Banners

### GET /banners
Returns active banners for home slider.

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "title_ar": "عرض خاص",
      "image": "https://.../storage/banners/1.jpg",
      "link": null
    }
  ]
}
```

---

## Categories

### GET /categories
List root categories (with children).

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name_ar": "مستحضرات العناية بالبشرة",
      "slug": "skincare",
      "image": "...",
      "icon": "skincare",
      "parent_id": null
    }
  ]
}
```

### GET /categories/{slug}
Get single category by slug.

---

## Products

### GET /products
Paginated product list.

**Query params:**
- `category_id` (optional)
- `min_price`, `max_price` (optional)
- `sort`: `newest` | `price_asc` | `price_desc` | `name`
- `per_page` (default 20)

### GET /products/featured
Featured products (no pagination).

### GET /products/best-sellers
Best selling products.

### GET /products/{slug}
Product detail with related products.

**Response (single product):**
```json
{
  "data": {
    "id": 1,
    "name_ar": "...",
    "slug": "...",
    "price": 50000,
    "compare_at_price": 60000,
    "discount_percent": 10,
    "final_price": 45000,
    "image": "https://...",
    "images": ["https://..."],
    "description_ar": "...",
    "sku": "SKU-001",
    "in_stock": true,
    "stock_quantity": 20,
    "category": { "id": 1, "name_ar": "..." }
  },
  "related": [...]
}
```

---

## Orders (Guest)

### POST /orders
Create order (guest checkout). No auth.

**Body:**
```json
{
  "customer_name": "أحمد محمد",
  "customer_phone": "07XXXXXXXX",
  "delivery_address": "العنوان الكامل",
  "city": "بغداد",
  "notes": "ملاحظات اختيارية",
  "coupon_code": "ترحيب10",
  "items": [
    {
      "product_id": 1,
      "product_name_ar": "اسم المنتج",
      "unit_price": 45000,
      "quantity": 2
    }
  ]
}
```

**Response (201):**
```json
{
  "message": "تم إنشاء الطلب بنجاح",
  "data": {
    "id": 1,
    "order_number": "COS-XXXXXXXX",
    "total": 90000,
    "status": "pending"
  }
}
```

### GET /orders/track?phone=07XXXXXXXX
Track orders by customer phone.

### GET /orders/{orderNumber}
Get order details by order number.

---

## Wishlist

Uses `X-Device-ID` header or `device_id` query/body to identify guest.

### GET /wishlist
List wishlist products. Send `X-Device-ID` header.

### POST /wishlist
**Body:** `{ "product_id": 1 }` and `X-Device-ID` header.

### DELETE /wishlist/{productId}
Remove from wishlist. Send `X-Device-ID` header.

---

## Coupons

### POST /coupons/validate
**Body:** `{ "code": "ترحيب10", "subtotal": 100000 }`

**Response (valid):**
```json
{
  "valid": true,
  "message": "تم تطبيق القسيمة",
  "discount": 10000,
  "type": "percent",
  "value": 10
}
```

---

## Order status values (Arabic labels)

- `pending` → قيد الانتظار
- `processing` → قيد المعالجة
- `shipped` → تم الشحن
- `delivered` → تم التسليم
- `cancelled` → ملغي

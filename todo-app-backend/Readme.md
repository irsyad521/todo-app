# Todo API – Secure vs Development Mode

A REST API built with Node.js and MySQL for **secure backend design and API pentesting practice**.

Supports two modes:

* **Production mode** → security enforced, restricted surface
* **Development mode** → debugging features enabled (e.g. Swagger)

---

## Architecture

```
Controller → Service → Repository → Database
```

* **Controller** → HTTP layer
* **Service** → business logic + authorization
* **Repository** → database queries
* **Middleware** → auth, validation, error handling

---

## Features

* JWT Authentication
* Todo CRUD
* RBAC (admin vs user)
* Ownership checks
* Pagination (`page`, `limit`, `meta`)
* Standard API response format
* Strict validation (Joi + sanitization)
* Runtime mode switching
* Swagger (development mode only)

---

## Setup

```
docker compose up --build
```

API:

```
http://localhost:3000/api/v1
```

Health:

```
curl http://localhost:3000/health
```

---

## Swagger

Available only in **development mode**:

```
http://localhost:3000/docs
```

In **production mode**:

```
403 Forbidden
```

---

## Modes

### Production (default)

```
APP_MODE=production docker compose up --build
```

### Development

```
APP_MODE=development docker compose up --build
```

---

## Runtime Mode Switching

Mode can be changed at runtime via internal endpoint:

```
POST /api/v1/system/mode
```

Header:

```
x-admin-token: <ADMIN_TOKEN>
```

Body:

```
{
  "mode": "production" | "development"
}
```

---

## Response Format

Success:

```
{
  "success": true,
  "data": ...
}
```

Pagination:

```
{
  "success": true,
  "data": [...],
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 90,
    "total_pages": 9
  }
}
```

Error:

```
{
  "success": false,
  "message": "...",
  "error_code": "..."
}
```

---

## Default Credentials

| Username | Password |
| -------- | -------- |
| admin    | admin    |
| user     | user     |

---

## Purpose

* Learn secure backend practices
* Understand input validation & RBAC
* Explore attack surface (controlled)
* Practice API testing & pentesting mindset

---

## Disclaimer

For educational purposes only. Do not deploy to production without proper hardening.

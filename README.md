# 🧩 Monokera Service

> Aplicación basada en **microservicios Rails** para la gestión de pedidos y clientes, con comunicación **síncrona (HTTP)** y **asíncrona (RabbitMQ)**.

---

## 📘 Descripción del Proyecto

**Monokera Service** es una aplicación modular construida con **Ruby on Rails (API Mode)**, diseñada para gestionar clientes y pedidos de manera distribuida.  
Su arquitectura desacoplada permite escalar y mantener ambos dominios de forma independiente.

El sistema está compuesto por dos microservicios:

- 🧾 **Order Service:** administra la creación y consulta de pedidos.  
- 👥 **Customer Service:** gestiona la información de los clientes y mantiene actualizado el número de pedidos (`orders_count`).

La comunicación entre servicios combina:
- 🔁 **HTTP (síncrona):** consulta directa entre APIs.
- 📨 **RabbitMQ (asíncrona):** publicación y consumo de eventos entre servicios.

---

## 🏗️ Arquitectura General

### 🔹 Microservicios

#### 🧾 Order Service
- **Framework:** Rails API  
- **Base de datos:** PostgreSQL  
- **Comunicación:**  
  - HTTP con Customer Service (para obtener datos del cliente).  
  - Publica eventos `order.created` en RabbitMQ.  

#### 👥 Customer Service
- **Framework:** Rails API  
- **Base de datos:** PostgreSQL  
- **Comunicación:**  
  - Consume eventos `order.created` desde RabbitMQ.  
  - Actualiza el campo `orders_count` de los clientes.  

---

## 🔄 Flujo de Comunicación

1. El **Order Service** recibe una solicitud para crear un pedido.
2. Antes de crear el pedido, consulta por HTTP al **Customer Service** para obtener la información del cliente.
3. El **Order Service** guarda el pedido en su base de datos y publica un evento `order.created` en **RabbitMQ**.
4. El **Customer Service** escucha este evento desde la cola `customer-service.order-created`.
5. Al recibir el mensaje, incrementa el campo `orders_count` del cliente correspondiente.

---

## ⚙️ Tecnologías Utilizadas

| Componente | Tecnología |
|-------------|-------------|
| Lenguaje | Ruby 3.3.1 |
| Framework | Rails 7.2.2 (modo API) |
| Base de datos | PostgreSQL |
| Mensajería | RabbitMQ |
| Cliente RabbitMQ | Bunny |
| HTTP Client | HTTParty |
| Testing | RSpec, FactoryBot, DatabaseCleaner |
| Contenedores | Docker, Docker Compose |

---

## 🧱 Esquema de Base de Datos

### 👥 Customer Service
| Campo | Tipo |
|--------|------|
| id | integer |
| customer_name | string |
| address | string |
| orders_count | integer |
| created_at | datetime |
| updated_at | datetime |

### 🧾 Order Service
| Campo | Tipo |
|--------|------|
| id | integer |
| customer_id | integer |
| product_name | string |
| quantity | integer |
| price | float |
| status | boolean |
| customer_info | jsonb |
| created_at | datetime |
| updated_at | datetime |

---

## 💬 Mensajería (RabbitMQ)

| Atributo | Valor |
|-----------|--------|
| **Exchange** | `orders` |
| **Tipo** | `topic` |
| **Routing Key** | `order.created` |
| **Queue (Consumer)** | `customer-service.order-created` |

🔹 **Order Service:** publica el evento `order.created`.  
🔹 **Customer Service:** consume el evento y actualiza `orders_count`.

---

## 🧩 Endpoints

### 🧾 Order Service

**Controller:** `OrdersController`

| Método | Endpoint | Descripción |
|---------|-----------|-------------|
| `POST` | `http://localhost:3000/api/v1/orders` | Crea un nuevo pedido (`customer_id`, `product_name`, `quantity`, `price`, `status`). |
| `GET` | `http://localhost:3000/api/v1/orders/:customer_id/client_orders` | Retorna todos los pedidos de un cliente. |

> ⚡ Cada vez que se crea un pedido, se emite un evento `order.created` hacia RabbitMQ.

---

### 👥 Customer Service

**Controller:** `CustomersController`

| Método | Endpoint                                     | Descripción |
|---------|----------------------------------------------|-------------|
| `GET` | `http://localhost:3001/api/v1/customers/:id` | Devuelve información del cliente (`customer_name`, `address`, `orders_count`). |

---

## 📦 Instalación y Configuración

### 1️⃣ Clonar el repositorio

```bash
git clone https://github.com/Davison90/monokera-service.git
cd monokera-service
```

### 2️⃣ Asegurarse de tener Docker instalado

Se requiere **Docker** y **Docker Compose** para orquestar los servicios localmente.

### 3️⃣ Construir e iniciar los contenedores

```bash
docker-compose up --build
```

Esto levantará los siguientes servicios:

```
OrderDB
CustomerDB
RabbitMQ
OrderService
CustomerService
```

---

## 🧪 Ejecución de Tests

### 🧾 Customer Service
```bash
bundle exec rspec
```

### 👥 Order Service
```bash
bundle exec rspec
```

---

## 🧰 Estructura del Proyecto

```plaintext
monokera-service/
├── customer-service/
│   ├── app/
│   ├── config/
│   ├── spec/
│   └── Dockerfile
├── order-service/
│   ├── app/
│   ├── config/
│   ├── spec/
│   └── Dockerfile
├── docker-compose.yml
└── README.md
```

---

## 🌟 Características Principales

✅ Arquitectura basada en microservicios (EDA).  
✅ Comunicación síncrona (HTTP) y asíncrona (RabbitMQ).  
✅ Orquestación con Docker Compose.  
✅ Testing automatizado con RSpec.  
✅ Integración de mensajería con Bunny.  
✅ Configuración simple y reproducible.

---

## 🧭 Diagrama de Arquitectura

> <img alt="Image" width="821" height="511" src="https://private-user-images.githubusercontent.com/26973082/505650522-d5c44993-5039-444d-931a-fe0baa4be2ce.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NjE0MTI5NjcsIm5iZiI6MTc2MTQxMjY2NywicGF0aCI6Ii8yNjk3MzA4Mi81MDU2NTA1MjItZDVjNDQ5OTMtNTAzOS00NDRkLTkzMWEtZmUwYmFhNGJlMmNlLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTEwMjUlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUxMDI1VDE3MTc0N1omWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWI1OGNkNmQwYTU1YWZiZjgzNDJmNjFkZGU3NDdiNzljNGRmYWMyMDliMjQ0YmRkMDg2ZTIwMGI1M2Q1NDk5MDEmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.o_MNKdCr_zE5bpRGgz4tw43ISoPkkFcboP5Zi-jmzlE">

---

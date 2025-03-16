# ✨ Aplicación de Gestión de Pedidos en Flutter

Este proyecto fue desarrollado como parte del **Obligatorio de Flutter 2024** y consiste en una aplicación para la **gestión de pedidos de un restaurante o servicio de comidas**. 

## 📚 Descripción
La aplicación permite gestionar pedidos de clientes, administrar platos disponibles y registrar clientes. Utiliza **Flutter con Dart** y almacenamiento local para persistencia de datos.

## ✨ Características Principales
### 🍲 Gestión de Pedidos
- Listado de pedidos con filtrado por estado (**Pendiente**, **Entregado**, **Cancelado**).
- Búsqueda de pedidos por **cédula** o **nombre del cliente**.
- Creación de pedidos con:
  - **Cliente asociado**.
  - **Selección de platos y cantidades**.
  - **Observaciones opcionales**.
  - **Cálculo automático del importe total**.
  - **Fecha y hora generada automáticamente**.
  - **Estado del pedido**.
  - **Opcional: Marcar como cobrado**.
- Modal emergente al agregar un pedido mostrando el **importe total**.

### 🍽️ Gestión de Platos
- Listado de platos disponibles en el sistema.
- Creación, edición y eliminación de platos.
- Asignación de precios y estados (**Disponible/No disponible**).

### 👤 Gestión de Clientes
- Listado de clientes registrados.
- Alta, modificación y eliminación de clientes.

### 🔧 Tecnologías Utilizadas
- **Flutter** (Framework de UI).
- **Dart** (Lenguaje de programación).
- **SQLite** (Persistencia de datos local con DAOs).
- **Material Design** (Interfaz de usuario).
- **GitHub** (Control de versiones).

## ⚙️ Instalación y Ejecución
1. **Clonar el repositorio:**
   ```sh
   git clone https://github.com/tu_usuario/tu_repositorio.git
   cd tu_repositorio
   ```
2. **Instalar las dependencias:**
   ```sh
   flutter pub get
   ```
3. **Ejecutar la aplicación:**
   ```sh
   flutter run
   ```
---
© 2024 - **Martin Pintos - SOFTteam**

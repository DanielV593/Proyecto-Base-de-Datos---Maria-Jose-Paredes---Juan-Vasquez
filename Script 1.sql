CREATE DATABASE IF NOT EXISTS SistemaCalzado_2026;
USE SistemaCalzado_2026;

-- 1. TABLAS CATÁLOGO 
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150),
    genero_calzado VARCHAR(20) -- Hombre, Mujer, Niños, Unisex
);

CREATE TABLE proveedores (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    ruc_proveedor VARCHAR(15) UNIQUE NOT NULL,
    razon_social VARCHAR(150) NOT NULL,
    pais_origen VARCHAR(50) NOT NULL,
    telefono_contacto VARCHAR(20),
    email VARCHAR(100),
    estado VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    cedula VARCHAR(10) UNIQUE NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    rol_sistema VARCHAR(50) NOT NULL,
    estado VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    tipo_identificacion VARCHAR(20) NOT NULL, -- Cedula, RUC, Pasaporte
    identificacion VARCHAR(15) UNIQUE NOT NULL,
    nombres_completos VARCHAR(150) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion_envio VARCHAR(200),
    ciudad VARCHAR(50),
    tipo_cliente VARCHAR(30) DEFAULT 'Minorista'
);

CREATE TABLE promociones (
    id_promocion INT AUTO_INCREMENT PRIMARY KEY,
    codigo_promo VARCHAR(20) UNIQUE NOT NULL,
    descripcion VARCHAR(150),
    tipo_descuento VARCHAR(20) NOT NULL, -- Porcentaje o Fijo
    valor_descuento DECIMAL(10,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL
);

CREATE TABLE auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tabla VARCHAR(50) NOT NULL,
    accion_realizada VARCHAR(50) NOT NULL,
    usuario_db VARCHAR(100) NOT NULL,
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    detalle_cambios TEXT
);

-- 2. TABLAS TRANSACCIONALES (Con dependencias)
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL, -- Código de barra
    nombre_modelo VARCHAR(150) NOT NULL,
    talla DECIMAL(4,1) NOT NULL, -- Ej: 39.5
    color VARCHAR(30),
    material VARCHAR(50),
    costo_compra DECIMAL(10,2) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 10,
    id_categoria INT NOT NULL,
    id_proveedor INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
);

CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    numero_factura VARCHAR(50) UNIQUE NOT NULL,
    fecha_emision DATETIME DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(10,2) NOT NULL,
    iva DECIMAL(10,2) NOT NULL,
    total_factura DECIMAL(10,2) NOT NULL,
    metodo_pago VARCHAR(50) NOT NULL, -- Efectivo, Tarjeta, Transferencia
    estado_venta VARCHAR(30) DEFAULT 'Completada',
    id_cliente INT NOT NULL,
    id_empleado INT NOT NULL,
    id_promocion INT, -- Puede ser NULL si no hubo descuento
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
    FOREIGN KEY (id_promocion) REFERENCES promociones(id_promocion)
);

CREATE TABLE detalle_venta (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal_linea DECIMAL(10,2) NOT NULL,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

CREATE TABLE devoluciones (
    id_devolucion INT AUTO_INCREMENT PRIMARY KEY,
    fecha_devolucion DATETIME DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(200) NOT NULL,
    cantidad_devuelta INT NOT NULL,
    estado_calzado VARCHAR(50) NOT NULL, -- Nuevo, Defectuoso
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    id_empleado INT NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

CREATE TABLE inventario (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    tipo_movimiento VARCHAR(30) NOT NULL, -- Entrada, Salida, Ajuste
    cantidad INT NOT NULL,
    fecha_movimiento DATETIME DEFAULT CURRENT_TIMESTAMP,
    documento_referencia VARCHAR(100),
    id_producto INT NOT NULL,
    id_empleado INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);
-- Creacion de la Base de datos: 
DROP DATABASE IF EXISTS SistemaCalzado_2026;
CREATE DATABASE SistemaCalzado_2026;
USE SistemaCalzado_2026;

-- Creacion de las Tablas DDL (11 tablas totales)
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150),
    genero_calzado VARCHAR(20)
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
    tipo_identificacion VARCHAR(20) NOT NULL,
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
    tipo_descuento VARCHAR(20) NOT NULL,
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

-- Tablas con dependencias 
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL,
    nombre_modelo VARCHAR(150) NOT NULL,
    talla DECIMAL(4,1) NOT NULL,
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
    metodo_pago VARCHAR(50) NOT NULL,
    estado_venta VARCHAR(30) DEFAULT 'Completada',
    id_cliente INT NOT NULL,
    id_empleado INT NOT NULL,
    id_promocion INT,
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
    estado_calzado VARCHAR(50) NOT NULL,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    id_empleado INT NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

CREATE TABLE inventario (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    tipo_movimiento VARCHAR(30) NOT NULL,
    cantidad INT NOT NULL,
    fecha_movimiento DATETIME DEFAULT CURRENT_TIMESTAMP,
    documento_referencia VARCHAR(100),
    id_producto INT NOT NULL,
    id_empleado INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

USE SistemaCalzado_2026;
-- Insercion de Datos Maestros (Catalogos)
-- Categorías (5)
INSERT INTO categorias (nombre, descripcion, genero_calzado) VALUES 
('Deportivo', 'Calzado para correr', 'Unisex'), ('Casual', 'Uso diario', 'Unisex'), 
('Formal', 'Oficina', 'Hombre'), ('Escolar', 'Colegiales', 'Niños'), ('Plataformas', 'Moda', 'Mujer');

-- Proveedores (12 - Mínimo 10)
INSERT INTO proveedores (ruc_proveedor, razon_social, pais_origen, telefono_contacto, email) VALUES 
('1791234567001', 'Calzado Ecuatoriano S.A.', 'Ecuador', '022345678', 'v@calzadoec.com'),
('0992345678001', 'Importadora Asiática', 'China', '042987654', 'i@asiatica.cn'),
('1893456789001', 'Cuero Andino Ltda.', 'Ecuador', '032112233', 'c@cueroandino.ec'),
('0194567890001', 'Suelas del Sur', 'Ecuador', '072345678', 's@suelas.com'),
('1795678901001', 'Global Shoes', 'Panamá', '022667788', 'i@globalshoes.pa'),
('0996789012001', 'Dist. Guayas', 'Ecuador', '042778899', 'v@distguayas.ec'),
('1797890123001', 'Deportes Cia.', 'Colombia', '022889900', 'd@ymas.co'),
('0198901234001', 'Manu Cuenca', 'Ecuador', '072990011', 'f@mcuenca.ec'),
('1799012345001', 'Zapato Premium', 'Brasil', '022112233', 'p@zapatos.br'),
('0990123456001', 'Industrial Ec', 'Ecuador', '042223344', 'i@calzado.ec'),
('1191122334001', 'Loja Shoes', 'Ecuador', '072111222', 'l@lojashoes.ec'),
('1792233445001', 'Textil Foot', 'Perú', '022334455', 't@textilfoot.pe');

-- Empleados (12 Registros)
INSERT INTO empleados (cedula, nombres, apellidos, cargo, rol_sistema) VALUES 
('1712345678', 'Juan', 'Perez', 'Gerente', 'usuario_admin'), ('1723456789', 'Maria', 'Jose', 'Operaciones', 'usuario_admin'),
('1734567890', 'Carlos', 'Mendoza', 'Vendedor', 'usuario_vendedor'), ('1745678901', 'Ana', 'Torres', 'Cajera', 'usuario_cajero'),
('1756789012', 'Luis', 'Paredes', 'Vendedor', 'usuario_vendedor'), ('1767890123', 'Sofia', 'Rios', 'Auditora', 'usuario_auditor'),
('1778901234', 'Miguel', 'Ortega', 'Gerente', 'usuario_gerente'), ('1789012345', 'Elena', 'Castro', 'Cajera', 'usuario_cajero'),
('1790123456', 'Andres', 'Vega', 'Vendedor', 'usuario_vendedor'), ('1701234567', 'Lucia', 'Gomez', 'Logistica', 'usuario_vendedor'),
('1711223344', 'Pedro', 'Luna', 'Vendedor', 'usuario_vendedor'), ('1722334455', 'Marta', 'Diaz', 'Cajera', 'usuario_cajero');

-- Promociones (12 Registros)
INSERT INTO promociones (codigo_promo, descripcion, tipo_descuento, valor_descuento, fecha_inicio, fecha_fin) VALUES 
('VERANO', 'Verano', 'Porcentaje', 15.00, '2026-06-01', '2026-08-31'), ('MADRES', 'Madres', 'Porcentaje', 20.00, '2026-05-01', '2026-05-15'),
('PADRES', 'Padres', 'Fijo', 5.00, '2026-06-01', '2026-06-20'), ('REGRESO', 'Escolar', 'Porcentaje', 10.00, '2026-08-15', '2026-09-15'),
('BLACKFRI', 'Black Friday', 'Porcentaje', 50.00, '2026-11-20', '2026-11-30'), ('NAVIDAD', 'Navidad', 'Porcentaje', 25.00, '2026-12-01', '2026-12-25'),
('LIQUIDA', 'Liquidacion', 'Fijo', 10.00, '2026-01-01', '2026-01-31'), ('CUMPLE', 'Cumpleaños', 'Fijo', 15.00, '2026-01-01', '2026-12-31'),
('MAYORISTA', 'Por mayor', 'Porcentaje', 12.00, '2026-01-01', '2026-12-31'), ('FLASH', 'Flash', 'Porcentaje', 30.00, '2026-10-10', '2026-10-11'),
('INVIERNO', 'Invierno', 'Porcentaje', 15.00, '2026-01-01', '2026-03-31'), ('PRIMAVERA', 'Primavera', 'Porcentaje', 10.00, '2026-04-01', '2026-05-31');

-- Clientes (32 Registros)
INSERT INTO clientes (tipo_identificacion, identificacion, nombres_completos, telefono, email, direccion_envio, ciudad) VALUES 
('Cedula', '1711111111', 'Cliente Uno', '0991111111', 'c1@mail.com', 'Dir 1', 'Quito'), ('Cedula', '1722222222', 'Cliente Dos', '0992222222', 'c2@mail.com', 'Dir 2', 'Guayaquil'),
('Cedula', '1733333333', 'Cliente Tres', '0993333333', 'c3@mail.com', 'Dir 3', 'Cuenca'), ('Cedula', '1744444444', 'Cliente Cuatro', '0994444444', 'c4@mail.com', 'Dir 4', 'Ambato'),
('Cedula', '1755555555', 'Cliente Cinco', '0995555555', 'c5@mail.com', 'Dir 5', 'Quito'), ('Cedula', '1766666666', 'Cliente Seis', '0996666666', 'c6@mail.com', 'Dir 6', 'Loja'),
('Cedula', '1777777777', 'Cliente Siete', '0997777777', 'c7@mail.com', 'Dir 7', 'Quito'), ('Cedula', '1788888888', 'Cliente Ocho', '0998888888', 'c8@mail.com', 'Dir 8', 'Manta'),
('Cedula', '1799999999', 'Cliente Nueve', '0999999999', 'c9@mail.com', 'Dir 9', 'Ibarra'), ('Cedula', '1700000000', 'Cliente Diez', '0990000000', 'c10@mail.com', 'Dir 10', 'Quito'),
('Cedula', '1710101010', 'Cliente Once', '0991010101', 'c11@mail.com', 'Dir 11', 'Guayaquil'), ('Cedula', '1712121212', 'Cliente Doce', '0991212121', 'c12@mail.com', 'Dir 12', 'Cuenca'),
('Cedula', '1713131313', 'Cliente Trece', '0991313131', 'c13@mail.com', 'Dir 13', 'Ambato'), ('Cedula', '1714141414', 'Cliente Catorce', '0991414141', 'c14@mail.com', 'Dir 14', 'Quito'),
('Cedula', '1715151515', 'Cliente Quince', '0991515151', 'c15@mail.com', 'Dir 15', 'Loja'), ('Cedula', '1716161616', 'Cliente Dieciseis', '0991616161', 'c16@mail.com', 'Dir 16', 'Quito'),
('Cedula', '1717171717', 'Cliente Diecisiete', '0991717171', 'c17@mail.com', 'Dir 17', 'Manta'), ('Cedula', '1718181818', 'Cliente Dieciocho', '0991818181', 'c18@mail.com', 'Dir 18', 'Ibarra'),
('Cedula', '1719191919', 'Cliente Diecinueve', '0991919191', 'c19@mail.com', 'Dir 19', 'Quito'), ('Cedula', '1720202020', 'Cliente Veinte', '0992020202', 'c20@mail.com', 'Dir 20', 'Guayaquil'),
('Cedula', '1721212121', 'Cliente Vintiuno', '0992121212', 'c21@mail.com', 'Dir 21', 'Cuenca'), ('Cedula', '1723232323', 'Cliente Vintidos', '0992323232', 'c22@mail.com', 'Dir 22', 'Ambato'),
('Cedula', '1724242424', 'Cliente Vintitres', '0992424242', 'c23@mail.com', 'Dir 23', 'Quito'), ('Cedula', '1725252525', 'Cliente Vinticuatro', '0992525252', 'c24@mail.com', 'Dir 24', 'Loja'),
('Cedula', '1726262626', 'Cliente Vinticinco', '0992626262', 'c25@mail.com', 'Dir 25', 'Quito'), ('Cedula', '1727272727', 'Cliente Vintiseis', '0992727272', 'c26@mail.com', 'Dir 26', 'Manta'),
('Cedula', '1728282828', 'Cliente Vintisiete', '0992828282', 'c27@mail.com', 'Dir 27', 'Ibarra'), ('Cedula', '1729292929', 'Cliente Vintiocho', '0992929292', 'c28@mail.com', 'Dir 28', 'Quito'),
('Cedula', '1730303030', 'Cliente Vintinueve', '0993030303', 'c29@mail.com', 'Dir 29', 'Guayaquil'), ('Cedula', '1731313131', 'Cliente Treinta', '0993131313', 'c30@mail.com', 'Dir 30', 'Cuenca'),
('Cedula', '1732323232', 'Cliente Treintayuno', '0993232323', 'c31@mail.com', 'Dir 31', 'Ambato'), ('Cedula', '1735353535', 'Cliente Treintaydos', '0993535353', 'c32@mail.com', 'Dir 32', 'Quito');

-- Productos (22 Registros)
INSERT INTO productos (sku, nombre_modelo, talla, color, material, costo_compra, precio_venta, stock_actual, stock_minimo, id_categoria, id_proveedor) VALUES 
('SKU001', 'Runner X', 40.0, 'Rojo', 'Sintetico', 25.00, 50.00, 100, 10, 1, 2), ('SKU002', 'Classic Low', 39.0, 'Blanco', 'Cuero', 30.00, 60.00, 80, 10, 2, 1),
('SKU003', 'Oxford Pro', 42.0, 'Negro', 'Cuero', 40.00, 85.00, 50, 5, 3, 3), ('SKU004', 'Colegial Basic', 35.0, 'Negro', 'Cuero', 15.00, 35.00, 150, 20, 4, 1),
('SKU005', 'Heels Elegance', 37.0, 'Nude', 'Sintetico', 20.00, 45.00, 60, 10, 5, 5), ('SKU006', 'Runner Pro', 41.0, 'Azul', 'Malla', 28.00, 55.00, 90, 10, 1, 2),
('SKU007', 'Sneaker High', 38.0, 'Negro', 'Lona', 18.00, 40.00, 110, 15, 2, 4), ('SKU008', 'Derby Classic', 43.0, 'Cafe', 'Cuero', 42.00, 90.00, 45, 5, 3, 3),
('SKU009', 'Kids Play', 32.0, 'Blanco', 'Sintetico', 12.00, 28.00, 200, 25, 4, 1), ('SKU010', 'Platform Star', 36.0, 'Plata', 'Sintetico', 22.00, 48.00, 70, 10, 5, 5),
('SKU011', 'Trail Max', 44.0, 'Verde', 'Impermeable', 35.00, 75.00, 40, 5, 1, 6), ('SKU012', 'Loafer Comfort', 40.5, 'Marron', 'Gamuza', 32.00, 65.00, 55, 10, 2, 8),
('SKU013', 'Monk Strap', 41.5, 'Negro', 'Cuero', 45.00, 95.00, 30, 5, 3, 3), ('SKU014', 'School Girl', 34.0, 'Azul Marino', 'Cuero', 16.00, 36.00, 130, 20, 4, 1),
('SKU015', 'Wedge Summer', 38.5, 'Beige', 'Yute', 18.00, 42.00, 85, 15, 5, 5), ('SKU016', 'Marathon Lite', 39.5, 'Amarillo', 'Malla', 26.00, 52.00, 105, 15, 1, 2),
('SKU017', 'Slip-On Easy', 42.5, 'Gris', 'Lona', 15.00, 30.00, 140, 20, 2, 4), ('SKU018', 'Chelsea Boot', 40.0, 'Negro', 'Gamuza', 38.00, 80.00, 65, 10, 3, 8),
('SKU019', 'Sport Junior', 30.0, 'Rojo', 'Sintetico', 14.00, 32.00, 180, 25, 4, 1), ('SKU020', 'Stiletto Chic', 35.5, 'Rojo', 'Charol', 25.00, 55.00, 50, 10, 5, 5),
('SKU021', 'Soccer Cleat', 41.0, 'Blanco', 'Sintetico', 30.00, 65.00, 75, 10, 1, 7), ('SKU022', 'Moccasin Relax', 39.0, 'Cafe', 'Cuero', 28.00, 58.00, 80, 10, 2, 8);

-- 2.4 Insercion de Datos Transaccionales (DML)
-- Ventas (52 - Mínimo 50)
-- Generamos facturas variadas.
INSERT INTO ventas (numero_factura, subtotal, iva, total_factura, metodo_pago, id_cliente, id_empleado, id_promocion) VALUES
('FAC-001', 50.00, 7.50, 57.50, 'Efectivo', 1, 3, NULL), ('FAC-002', 60.00, 9.00, 69.00, 'Tarjeta', 2, 4, 1),
('FAC-003', 85.00, 12.75, 97.75, 'Efectivo', 3, 5, NULL), ('FAC-004', 35.00, 5.25, 40.25, 'Transferencia', 4, 3, 2),
('FAC-005', 45.00, 6.75, 51.75, 'Efectivo', 5, 4, NULL), ('FAC-006', 55.00, 8.25, 63.25, 'Tarjeta', 6, 5, NULL),
('FAC-007', 40.00, 6.00, 46.00, 'Efectivo', 7, 3, NULL), ('FAC-008', 90.00, 13.50, 103.50, 'Transferencia', 8, 4, 3),
('FAC-009', 28.00, 4.20, 32.20, 'Efectivo', 9, 5, NULL), ('FAC-010', 48.00, 7.20, 55.20, 'Tarjeta', 10, 3, NULL),
('FAC-011', 75.00, 11.25, 86.25, 'Efectivo', 11, 4, NULL), ('FAC-012', 65.00, 9.75, 74.75, 'Transferencia', 12, 5, 4),
('FAC-013', 95.00, 14.25, 109.25, 'Efectivo', 13, 3, NULL), ('FAC-014', 36.00, 5.40, 41.40, 'Tarjeta', 14, 4, NULL),
('FAC-015', 42.00, 6.30, 48.30, 'Efectivo', 15, 5, NULL), ('FAC-016', 52.00, 7.80, 59.80, 'Transferencia', 16, 3, 5),
('FAC-017', 30.00, 4.50, 34.50, 'Efectivo', 17, 4, NULL), ('FAC-018', 80.00, 12.00, 92.00, 'Tarjeta', 18, 5, NULL),
('FAC-019', 32.00, 4.80, 36.80, 'Efectivo', 19, 3, NULL), ('FAC-020', 55.00, 8.25, 63.25, 'Transferencia', 20, 4, 6),
('FAC-021', 65.00, 9.75, 74.75, 'Efectivo', 21, 5, NULL), ('FAC-022', 58.00, 8.70, 66.70, 'Tarjeta', 22, 3, NULL),
('FAC-023', 50.00, 7.50, 57.50, 'Efectivo', 23, 4, NULL), ('FAC-024', 60.00, 9.00, 69.00, 'Transferencia', 24, 5, 7),
('FAC-025', 85.00, 12.75, 97.75, 'Efectivo', 25, 3, NULL), ('FAC-026', 35.00, 5.25, 40.25, 'Tarjeta', 26, 4, NULL),
('FAC-027', 45.00, 6.75, 51.75, 'Efectivo', 27, 5, NULL), ('FAC-028', 55.00, 8.25, 63.25, 'Transferencia', 28, 3, 8),
('FAC-029', 40.00, 6.00, 46.00, 'Efectivo', 29, 4, NULL), ('FAC-030', 90.00, 13.50, 103.50, 'Tarjeta', 30, 5, NULL),
('FAC-031', 28.00, 4.20, 32.20, 'Efectivo', 31, 3, NULL), ('FAC-032', 48.00, 7.20, 55.20, 'Transferencia', 32, 4, 9),
('FAC-033', 75.00, 11.25, 86.25, 'Efectivo', 1, 5, NULL), ('FAC-034', 65.00, 9.75, 74.75, 'Tarjeta', 2, 3, NULL),
('FAC-035', 95.00, 14.25, 109.25, 'Efectivo', 3, 4, NULL), ('FAC-036', 36.00, 5.40, 41.40, 'Transferencia', 4, 5, 10),
('FAC-037', 42.00, 6.30, 48.30, 'Efectivo', 5, 3, NULL), ('FAC-038', 52.00, 7.80, 59.80, 'Tarjeta', 6, 4, NULL),
('FAC-039', 30.00, 4.50, 34.50, 'Efectivo', 7, 5, NULL), ('FAC-040', 80.00, 12.00, 92.00, 'Transferencia', 8, 3, 11),
('FAC-041', 32.00, 4.80, 36.80, 'Efectivo', 9, 4, NULL), ('FAC-042', 55.00, 8.25, 63.25, 'Tarjeta', 10, 5, NULL),
('FAC-043', 65.00, 9.75, 74.75, 'Efectivo', 11, 3, NULL), ('FAC-044', 58.00, 8.70, 66.70, 'Transferencia', 12, 4, 12),
('FAC-045', 50.00, 7.50, 57.50, 'Efectivo', 13, 5, NULL), ('FAC-046', 60.00, 9.00, 69.00, 'Tarjeta', 14, 3, NULL),
('FAC-047', 85.00, 12.75, 97.75, 'Efectivo', 15, 4, NULL), ('FAC-048', 35.00, 5.25, 40.25, 'Transferencia', 16, 5, 1),
('FAC-049', 45.00, 6.75, 51.75, 'Efectivo', 17, 3, NULL), ('FAC-050', 55.00, 8.25, 63.25, 'Tarjeta', 18, 4, NULL),
('FAC-051', 40.00, 6.00, 46.00, 'Efectivo', 19, 5, NULL), ('FAC-052', 90.00, 13.50, 103.50, 'Transferencia', 20, 3, 2);

-- Detalle_Venta (Asignamos detalles a las 52 ventas)
INSERT INTO detalle_venta (cantidad, precio_unitario, subtotal_linea, id_venta, id_producto) VALUES 
(1, 50.00, 50.00, 1, 1), (1, 60.00, 60.00, 2, 2), (1, 85.00, 85.00, 3, 3), (1, 35.00, 35.00, 4, 4),
(1, 45.00, 45.00, 5, 5), (1, 55.00, 55.00, 6, 6), (1, 40.00, 40.00, 7, 7), (1, 90.00, 90.00, 8, 8),
(1, 28.00, 28.00, 9, 9), (1, 48.00, 48.00, 10, 10), (1, 75.00, 75.00, 11, 11), (1, 65.00, 65.00, 12, 12),
(1, 95.00, 95.00, 13, 13), (1, 36.00, 36.00, 14, 14), (1, 42.00, 42.00, 15, 15), (1, 52.00, 52.00, 16, 16),
(1, 30.00, 30.00, 17, 17), (1, 80.00, 80.00, 18, 18), (1, 32.00, 32.00, 19, 19), (1, 55.00, 55.00, 20, 20),
(1, 65.00, 65.00, 21, 21), (1, 58.00, 58.00, 22, 22), (1, 50.00, 50.00, 23, 1), (1, 60.00, 60.00, 24, 2),
(1, 85.00, 85.00, 25, 3), (1, 35.00, 35.00, 26, 4), (1, 45.00, 45.00, 27, 5), (1, 55.00, 55.00, 28, 6),
(1, 40.00, 40.00, 29, 7), (1, 90.00, 90.00, 30, 8), (1, 28.00, 28.00, 31, 9), (1, 48.00, 48.00, 32, 10),
(1, 75.00, 75.00, 33, 11), (1, 65.00, 65.00, 34, 12), (1, 95.00, 95.00, 35, 13), (1, 36.00, 36.00, 36, 14),
(1, 42.00, 42.00, 37, 15), (1, 52.00, 52.00, 38, 16), (1, 30.00, 30.00, 39, 17), (1, 80.00, 80.00, 40, 18),
(1, 32.00, 32.00, 41, 19), (1, 55.00, 55.00, 42, 20), (1, 65.00, 65.00, 43, 21), (1, 58.00, 58.00, 44, 22),
(1, 50.00, 50.00, 45, 1), (1, 60.00, 60.00, 46, 2), (1, 85.00, 85.00, 47, 3), (1, 35.00, 35.00, 48, 4),
(1, 45.00, 45.00, 49, 5), (1, 55.00, 55.00, 50, 6), (1, 40.00, 40.00, 51, 7), (1, 90.00, 90.00, 52, 8);

-- Devoluciones (22 - Mínimo 20)
INSERT INTO devoluciones (motivo, cantidad_devuelta, estado_calzado, id_venta, id_producto, id_empleado) VALUES 
('Talla incorrecta', 1, 'Nuevo', 1, 1, 3), ('Defecto de fabrica', 1, 'Defectuoso', 2, 2, 4),
('No le gusto', 1, 'Nuevo', 3, 3, 5), ('Talla incorrecta', 1, 'Nuevo', 4, 4, 3),
('Mancha en el cuero', 1, 'Defectuoso', 5, 5, 4), ('Suela despegada', 1, 'Defectuoso', 6, 6, 5),
('Cambio por otro color', 1, 'Nuevo', 7, 7, 3), ('Talla incorrecta', 1, 'Nuevo', 8, 8, 4),
('Defecto costura', 1, 'Defectuoso', 9, 9, 5), ('No le gusto', 1, 'Nuevo', 10, 10, 3),
('Talla incorrecta', 1, 'Nuevo', 11, 11, 4), ('Defecto de fabrica', 1, 'Defectuoso', 12, 12, 5),
('Cambio modelo', 1, 'Nuevo', 13, 13, 3), ('Talla incorrecta', 1, 'Nuevo', 14, 14, 4),
('Mancha', 1, 'Defectuoso', 15, 15, 5), ('No le gusto', 1, 'Nuevo', 16, 16, 3),
('Cambio por talla', 1, 'Nuevo', 17, 17, 4), ('Cordon roto', 1, 'Defectuoso', 18, 18, 5),
('Talla incorrecta', 1, 'Nuevo', 19, 19, 3), ('Defecto de fabrica', 1, 'Defectuoso', 20, 20, 4),
('No le gusto', 1, 'Nuevo', 21, 21, 5), ('Cambio por talla', 1, 'Nuevo', 22, 22, 3);

-- Movimientos de inventario (22 - Mínimo 20)
INSERT INTO inventario (tipo_movimiento, cantidad, documento_referencia, id_producto, id_empleado) VALUES 
('Entrada', 100, 'Factura Proveedor 1', 1, 2), ('Entrada', 80, 'Factura Proveedor 2', 2, 2),
('Entrada', 50, 'Factura Proveedor 3', 3, 2), ('Entrada', 150, 'Factura Proveedor 4', 4, 2),
('Entrada', 60, 'Factura Proveedor 5', 5, 2), ('Entrada', 90, 'Factura Proveedor 6', 6, 2),
('Entrada', 110, 'Factura Proveedor 7', 7, 2), ('Entrada', 45, 'Factura Proveedor 8', 8, 2),
('Entrada', 200, 'Factura Proveedor 9', 9, 2), ('Entrada', 70, 'Factura Proveedor 10', 10, 2),
('Entrada', 40, 'Factura Proveedor 11', 11, 2), ('Entrada', 55, 'Factura Proveedor 12', 12, 2),
('Entrada', 30, 'Factura Proveedor 13', 13, 2), ('Entrada', 130, 'Factura Proveedor 14', 14, 2),
('Entrada', 85, 'Factura Proveedor 15', 15, 2), ('Entrada', 105, 'Factura Proveedor 16', 16, 2),
('Entrada', 140, 'Factura Proveedor 17', 17, 2), ('Entrada', 65, 'Factura Proveedor 18', 18, 2),
('Entrada', 180, 'Factura Proveedor 19', 19, 2), ('Entrada', 50, 'Factura Proveedor 20', 20, 2),
('Entrada', 75, 'Factura Proveedor 21', 21, 2), ('Entrada', 80, 'Factura Proveedor 22', 22, 2);

-- 2.5 Comprobacion de Registros (SELECT)
-- 1. Verificar Catálogos (Tablas maestras)
SELECT * FROM categorias;
SELECT * FROM proveedores;
SELECT * FROM empleados;
SELECT * FROM promociones;

-- 2. Verificar Clientes y Productos
SELECT * FROM clientes;
SELECT * FROM productos;

-- 3. Verificar Tablas Transaccionales
SELECT * FROM ventas;
SELECT * FROM detalle_venta;
SELECT * FROM devoluciones;
SELECT * FROM inventario;

-- Consultas SQL y Subconsultas
-- Consulta 1: Listado de clientes
SELECT 
    id_cliente AS IdCliente, 
    nombres_completos AS Nombres, 
    telefono AS Telefono, 
    email AS Correo, 
    ciudad AS Provincia
FROM clientes;

-- Consulta 2: Productos disponibles
SELECT 
    p.id_producto AS IdProducto, 
    p.nombre_modelo AS NombreProducto, 
    c.nombre AS TipoProducto, 
    p.precio_venta AS Precio, 
    p.stock_actual AS StockActual
FROM productos p
JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE p.stock_actual > 0;

-- Consulta 3: Ventas por fecha
SELECT 
    v.id_venta AS IdVenta, 
    v.fecha_emision AS FechaVenta, 
    c.nombres_completos AS Cliente, 
    v.total_factura AS TotalVenta
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
ORDER BY v.fecha_emision DESC;

-- Consulta 4: Proveedores registrados
SELECT 
    id_proveedor AS IdProveedor, 
    razon_social AS NombreProveedor, 
    pais_origen AS Pais, 
    estado AS TipoProveedor, 
    telefono_contacto AS Telefono
FROM proveedores;

-- Consulta 5: Empleados por rol
SELECT 
    id_empleado AS IdEmpleado, 
    CONCAT(nombres, ' ', apellidos) AS NombreEmpleado, 
    cargo AS Cargo, 
    rol_sistema AS Rol
FROM empleados
ORDER BY rol_sistema;

-- Consulta 6: Clientes con sus compras (JOIN)
SELECT 
    c.nombres_completos AS Cliente, 
    v.fecha_emision AS FechaVenta, 
    v.total_factura AS TotalVenta, 
    v.metodo_pago AS TipoVenta
FROM clientes c
JOIN ventas v ON c.id_cliente = v.id_cliente
ORDER BY v.fecha_emision DESC;

-- Consulta 7: Ventas con vendedor (JOIN)
SELECT 
    v.id_venta AS IdVenta, 
    c.nombres_completos AS Cliente, 
    e.nombres AS Vendedor, 
    v.fecha_emision AS FechaVenta, 
    v.total_factura AS TotalVenta
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN empleados e ON v.id_empleado = e.id_empleado
ORDER BY v.fecha_emision DESC;

-- Consulta 8: Detalle de productos vendidos (JOIN)
SELECT 
    dv.id_venta AS IdVenta, 
    p.nombre_modelo AS Producto, 
    dv.cantidad AS Cantidad, 
    dv.precio_unitario AS PrecioUnitario, 
    dv.subtotal_linea AS Subtotal
FROM detalle_venta dv
JOIN productos p ON dv.id_producto = p.id_producto
ORDER BY dv.id_venta;

-- Consulta 9: Productos con proveedor (JOIN)
SELECT 
    p.nombre_modelo AS Producto, 
    cat.nombre AS TipoProducto, 
    pr.razon_social AS Proveedor, 
    pr.pais_origen AS PaisProveedor
FROM productos p
JOIN categorias cat ON p.id_categoria = cat.id_categoria
JOIN proveedores pr ON p.id_proveedor = pr.id_proveedor;

-- Consulta 10: Devoluciones con cliente y producto (JOIN)
SELECT 
    c.nombres_completos AS Cliente, 
    p.nombre_modelo AS Producto, 
    d.fecha_devolucion AS FechaDevolucion, 
    d.motivo AS Motivo, 
    d.cantidad_devuelta AS Cantidad
FROM devoluciones d
JOIN ventas v ON d.id_venta = v.id_venta
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN productos p ON d.id_producto = p.id_producto
ORDER BY d.fecha_devolucion DESC;
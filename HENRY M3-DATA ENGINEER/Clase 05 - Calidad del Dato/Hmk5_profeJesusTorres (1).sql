-- 2068
-- 1064
SELECT @@global.secure_file_priv;
SHOW VARIABLES LIKE 'secure_file_priv';

SHOW VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile=1;

-- Crear base de datos
DROP DATABASE henry_m3;
CREATE DATABASE henry_m3;

-- Gasto
USE henry_m3;

-- gasto
CREATE TABLE IF NOT EXISTS gasto(
	idGasto INT,
	idSucursal INT,
	idTipoGasto INT,
	fecha DATE,
	monto DECIMAL(10,2)
);

LOAD DATA LOCAL INFILE 'C:/Users/DELLS/Downloads/data/Gasto.csv'
INTO TABLE gasto
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1 LINES
(idGasto, idSucursal, idTipoGasto, fecha, monto);

SELECT * FROM gasto;

-- Compra
CREATE TABLE IF NOT EXISTS compra(
	idCompra INT,
	fecha DATE,
	idProducto INT,
	cantidad INT,
	precio DECIMAL(10,2),
    idProveedor int
);

LOAD DATA LOCAL INFILE 'C:/Users/DELLS/Downloads/data/Compra.csv'
INTO TABLE compra
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1 LINES
(idCompra, fecha, idProducto, cantidad, precio, idproveedor);

SELECT * FROM compra;

-- venta
DROP TABLE IF EXISTS venta;
CREATE TABLE IF NOT EXISTS venta(
	idVenta INT,
    fecha DATE,
    fecha_entrega DATE,
    idCanal INT,
    idCliente INT,
    idSucursal INT,
    idEmpleado INT,
    idProducto INT,
    precio VARCHAR(50), -- VARCHAR?
    cantidad VARCHAR(50) -- VARCHAR?
);

LOAD DATA LOCAL INFILE 'C:/Users/DELLS/Downloads/data/Venta.csv'
INTO TABLE venta
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1 LINES
(idVenta, fecha, fecha_entrega, idCanal, idCliente, idSucursal, idEmpleado, idProducto, precio, cantidad);

-- Que error les da?

SELECT * FROM venta;

-- Sucursales: Ver previamente: que problema puede ocurrir?
DROP TABLE sucursal;
CREATE TABLE IF NOT EXISTS sucursal(
	id INT,
    sucursal VARCHAR(100),
    Domicilio VARCHAR(100),
    localidad VARCHAR(100),
    provincia VARCHAR(100),
    latitud2 VARCHAR(100),
    longitud2 VARCHAR(100)
)   ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

LOAD DATA LOCAL INFILE 'C:/Users/DELLS/Downloads/data/Sucursales.csv'
INTO TABLE sucursal
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' ENCLOSED BY '' ESCAPED BY '' -- ojo con ;
LINES TERMINATED BY '\n' IGNORE 1 LINES
(id, sucursal, Domicilio, localidad, provincia, latitud2, longitud2);

SELECT * FROM sucursal;

-- Cliente
CREATE TABLE IF NOT EXISTS cliente(
	id INT,
    provincia VARCHAR(100),
    nombre_apellido VARCHAR(100),
    domicilio VARCHAR(200),
    telefono VARCHAR(100),
    edad VARCHAR(10),
    localidad VARCHAR(100),
    x VARCHAR(100),
    y VARCHAR(100),
    fecha_alta date,
    usuario_alta varchar(100),
    fecha_ultima_modificacion DATE,
    usuario_ultima_modificacion VARCHAR(100),
    marca_baja TINYINT,
    col10 VARCHAR(5)
);

LOAD DATA LOCAL INFILE 'C:/Users/DELLS/Downloads/data/Clientes.csv'
INTO TABLE cliente
CHARACTER SET latin1
FIELDS TERMINATED BY ';' ENCLOSED BY '' ESCAPED BY '\"' -- ignore \
LINES TERMINATED BY '\n' IGNORE 1 LINES
(id, provincia, nombre_apellido,domicilio,telefono,edad,localidad,x,y,
fecha_alta,usuario_alta,fecha_ultima_modificacion,
usuario_ultima_modificacion,marca_baja,col10);

SELECT * FROM cliente;

--
DROP TABLE IF EXISTS canal_venta;
CREATE TABLE IF NOT EXISTS canal_venta(
	id_canal INT,
    canal VARCHAR(50)
);

LOAD DATA LOCAL INFILE 'C:/Users/DELLS/Downloads/data/CanalDeVenta.csv'
INTO TABLE canal_venta
CHARACTER SET latin1
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' -- ignore \
LINES TERMINATED BY '\n' IGNORE 1 LINES
(id_canal, canal);

SELECT * FROM canal_venta;

--
DROP TABLE IF EXISTS tipo_gasto;
CREATE TABLE IF NOT EXISTS tipo_gasto(
	idTipoGasto INT,
    descripcion VARCHAR(100),
    monto_aproximado INT
);

LOAD DATA LOCAL INFILE 'C:/Users/DELLS/Downloads/data/TiposDeGasto.csv'
INTO TABLE tipo_gasto
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' -- ignore \
LINES TERMINATED BY '\n' IGNORE 1 LINES
(idTipoGasto, descripcion, monto_aproximado);

SELECT * FROM tipo_gasto;

-- producto
DROP TABLE IF EXISTS producto;
CREATE TABLE IF NOT EXISTS producto (
	IDProducto					INTEGER,
	Concepto					VARCHAR(100),
	Tipo						VARCHAR(50),
	Precio2						VARCHAR(30)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

LOAD DATA LOCAL INFILE 'C:/Users/DELLS/Downloads/data/productos.csv' 
INTO TABLE producto 
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES
(IDProducto, Concepto, Tipo, Precio2);

SELECT * FROM producto;

-- empleado
DROP TABLE IF EXISTS empleado;
CREATE TABLE IF NOT EXISTS empleado (
	IDEmpleado					INTEGER,
	Apellido					VARCHAR(100),
	Nombre						VARCHAR(100),
	Sucursal					VARCHAR(50),
	Sector						VARCHAR(50),
	Cargo						VARCHAR(50),
	Salario2					VARCHAR(30)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

LOAD DATA LOCAL INFILE 'C:/Users/DELLS/Downloads/data/Empleados.csv' 
INTO TABLE empleado
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES
(IDEmpleado, Apellido, Nombre, Sucursal, Sector, Cargo, Salario2);

SELECT * FROM empleado;

-- proveedor
DROP TABLE IF EXISTS proveedor;
CREATE TABLE IF NOT EXISTS proveedor (
	IDProveedor		INTEGER,
	Nombre			VARCHAR(80),
	Domicilio		VARCHAR(150),
	Ciudad			VARCHAR(80),
	Provincia		VARCHAR(50),
	Pais			VARCHAR(20),
	Departamento	VARCHAR(80)
);

LOAD DATA LOCAL INFILE 'C:/Users/DELLS/Downloads/data/Proveedores.csv' 
INTO TABLE proveedor
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES
(IDProveedor, Nombre, Domicilio, Ciudad, Provincia, Pais, Departamento);

SELECT * FROM proveedor;

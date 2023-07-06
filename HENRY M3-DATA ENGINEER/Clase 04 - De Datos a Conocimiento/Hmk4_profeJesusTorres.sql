-- 2068
-- 1064
SELECT @@global.secure_file_priv;
SHOW VARIABLES LIKE 'secure_file_priv';

SHOW VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile=1;

-- Crear base de datos
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

LOAD DATA LOCAL INFILE 'C:Gasto.csv'
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
    direccion VARCHAR(100),
    localidad VARCHAR(100),
    provincia VARCHAR(100),
    latitud VARCHAR(100),
    longitud VARCHAR(100)
);

LOAD DATA LOCAL INFILE 'C:/Users/DELLS/Downloads/data/Sucursales.csv'
INTO TABLE sucursal
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' ENCLOSED BY '' ESCAPED BY '' -- ojo con ;
LINES TERMINATED BY '\n' IGNORE 1 LINES
(id, sucursal, direccion, localidad, provincia, latitud, longitud);

SELECT * FROM sucursal;

-- Cliente
CREATE TABLE IF NOT EXISTS clientes(
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
INTO TABLE clientes
CHARACTER SET latin1
FIELDS TERMINATED BY ';' ENCLOSED BY '' ESCAPED BY '\"' -- ignore \
LINES TERMINATED BY '\n' IGNORE 1 LINES
(id, provincia, nombre_apellido,domicilio,telefono,edad,localidad,x,y,
fecha_alta,usuario_alta,fecha_ultima_modificacion,
usuario_ultima_modificacion,marca_baja,col10);

SELECT * FROM clientes;

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
-- empleado
-- proveedor


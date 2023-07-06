-- Editar conexion - Advanced - Others: Añadir la linea: OPT_LOCAL_INFILE=1

SELECT @@global.secure_file_priv;
SHOW VARIABLES LIKE 'secure_file';
SET GLOBAL local_infile=1;

-- Crear base de datos

DROP DATABASE henry_m3;
CREATE DATABASE IF NOT EXISTS henry_m3;
USE henry_m3;

-- gasto
CREATE TABLE IF NOT EXISTS gasto(
	idGasto INT,
	idSucursal INT,
	idTipoGasto INT,
	fecha DATE,
	monto DECIMAL(10,2)
);

LOAD DATA LOCAL INFILE 'C:\\Users\\Ivan Rojas\\Desktop\\Henry Ivan Code\\Modulos-Henry\\M3_DTA_ENGINEER\\Clase_04_De_datos_a_conocimiento\\Datos_Homework\\Gasto.csv'
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

LOAD DATA LOCAL INFILE 'C:\\Users\\Ivan Rojas\\Desktop\\Henry Ivan Code\\Modulos-Henry\\M3_DTA_ENGINEER\\Clase_04_De_datos_a_conocimiento\\Datos_Homework\\Compra.csv'
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

LOAD DATA LOCAL INFILE 'C:\\Users\\Ivan Rojas\\Desktop\\Henry Ivan Code\\Modulos-Henry\\M3_DTA_ENGINEER\\Clase_04_De_datos_a_conocimiento\\Datos_Homework\\Venta.csv'
INTO TABLE venta
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1 LINES
(idVenta, fecha, fecha_entrega, idCanal, idCliente, idSucursal, idEmpleado, idProducto, precio, cantidad);

SELECT * FROM venta;

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

LOAD DATA LOCAL INFILE 'C:\\Users\\Ivan Rojas\\Desktop\\Henry Ivan Code\\Modulos-Henry\\M3_DTA_ENGINEER\\Clase_04_De_datos_a_conocimiento\\Datos_Homework\\Sucursales.csv'
INTO TABLE sucursal
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' ENCLOSED BY '' ESCAPED BY '' -- ojo con ;
LINES TERMINATED BY '\n' IGNORE 1 LINES
(id, sucursal, direccion, localidad, provincia, latitud, longitud);

SELECT * FROM sucursal;

-- Clientes
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

LOAD DATA LOCAL INFILE 'C:\\Users\\Ivan Rojas\\Desktop\\Henry Ivan Code\\Modulos-Henry\\M3_DTA_ENGINEER\\Clase_04_De_datos_a_conocimiento\\Datos_Homework\\Clientes.csv'
INTO TABLE clientes
CHARACTER SET latin1
FIELDS TERMINATED BY ';' ENCLOSED BY '' ESCAPED BY '\"' -- ignore \
LINES TERMINATED BY '\n' IGNORE 1 LINES
(id, provincia, nombre_apellido,domicilio,telefono,edad,localidad,x,y,
fecha_alta,usuario_alta,fecha_ultima_modificacion,
usuario_ultima_modificacion,marca_baja,col10);

SELECT * FROM clientes;

-- canal_venta
DROP TABLE IF EXISTS canal_venta;
CREATE TABLE IF NOT EXISTS canal_venta(
	id_canal INT,
    canal VARCHAR(50)
);

LOAD DATA LOCAL INFILE 'C:\\Users\\Ivan Rojas\\Desktop\\Henry Ivan Code\\Modulos-Henry\\M3_DTA_ENGINEER\\Clase_04_De_datos_a_conocimiento\\Datos_Homework\\CanalDeVenta.csv'
INTO TABLE canal_venta
CHARACTER SET latin1
FIELDS TERMINATED BY ';' ENCLOSED BY '' ESCAPED BY '' -- ignore \
LINES TERMINATED BY '\n' IGNORE 1 LINES
(id_canal, canal);

SELECT * FROM canal_venta;

-- tipo_gasto
DROP TABLE IF EXISTS tipo_gasto;
CREATE TABLE IF NOT EXISTS tipo_gasto(
	idTipoGasto INT,
    descripcion VARCHAR(100),
    monto_aproximado INT
);

LOAD DATA LOCAL INFILE 'C:\\Users\\Ivan Rojas\\Desktop\\Henry Ivan Code\\Modulos-Henry\\M3_DTA_ENGINEER\\Clase_04_De_datos_a_conocimiento\\Datos_Homework\\TiposDeGasto.csv'
INTO TABLE tipo_gasto
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' -- ignore \
LINES TERMINATED BY '\n' IGNORE 1 LINES
(idTipoGasto, descripcion, monto_aproximado);

SELECT * FROM tipo_gasto;

-- productos
DROP TABLE IF EXISTS productos;
CREATE TABLE IF NOT EXISTS productos(
	idProducto INT,
    concepto VARCHAR(100),
    tipo VARCHAR(100),
    precio VARCHAR (50)
);

LOAD DATA LOCAL INFILE 'C:\\Users\\Ivan Rojas\\Desktop\\Henry Ivan Code\\Modulos-Henry\\M3_DTA_ENGINEER\\Clase_04_De_datos_a_conocimiento\\Datos_Homework\\productos.csv'
INTO TABLE productos
CHARACTER SET latin1
FIELDS TERMINATED BY ';' ENCLOSED BY '' ESCAPED BY '' -- ignore \
LINES TERMINATED BY '\n' IGNORE 1 LINES
(idProducto, concepto, tipo, precio);

SELECT * FROM productos;

-- empleados
DROP TABLE IF EXISTS empleados;
CREATE TABLE IF NOT EXISTS empleados(
	idEmpleado INT,
    apellido VARCHAR(100),
    nombre VARCHAR(100),
    sucursal VARCHAR(100),
    sector VARCHAR(100),
    cargo VARCHAR(100),
    salario VARCHAR (50)
);

LOAD DATA LOCAL INFILE 'C:\\Users\\Ivan Rojas\\Desktop\\Henry Ivan Code\\Modulos-Henry\\M3_DTA_ENGINEER\\Clase_04_De_datos_a_conocimiento\\Datos_Homework\\Empleados.csv'
INTO TABLE empleados
CHARACTER SET latin1
FIELDS TERMINATED BY ';' ENCLOSED BY '' ESCAPED BY '' -- ignore \
LINES TERMINATED BY '\n' IGNORE 1 LINES
(idEmpleado, apellido, nombre, sucursal, sector, cargo, salario);

SELECT * FROM empleados;

-- proveedores
DROP TABLE IF EXISTS proveedores;
CREATE TABLE IF NOT EXISTS proveedores(
	idProveedor INT,
    nombre VARCHAR(100),
    address VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    department VARCHAR (100)
);

LOAD DATA LOCAL INFILE 'C:\\Users\\Ivan Rojas\\Desktop\\Henry Ivan Code\\Modulos-Henry\\M3_DTA_ENGINEER\\Clase_04_De_datos_a_conocimiento\\Datos_Homework\\Proveedores.csv'
INTO TABLE proveedores
CHARACTER SET latin1
FIELDS TERMINATED BY ';' ENCLOSED BY '' ESCAPED BY '' -- ignore \
LINES TERMINATED BY '\n' IGNORE 1 LINES
(idProveedor, nombre, address, city, state, country, department);

SELECT * FROM proveedores;

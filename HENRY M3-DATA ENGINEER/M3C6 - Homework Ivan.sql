use henry_m3;

SELECT @@global.secure_file_priv;
SHOW VARIABLES LIKE 'secure_file';
SET GLOBAL local_infile=1;

SET SQL_SAFE_UPDATES = 0;
SELECT @@SQL_SAFE_UPDATES;

/* NORMALIZACION

1. Es necesario contar con una tabla de localidades del país con el fin de evaluar la
apertura de una nueva sucursal y mejorar nuestros datos. A partir de los datos en las tablas
cliente, sucursal y proveedor hay que generar una tabla definitiva de Localidades y Provincias.
Utilizando la nueva tabla de Localidades controlar y corregir (Normalizar) los campos Localidad y
Provincia de las tablas cliente, sucursal y proveedor.

*/



/*Normalización Localidad Provincia*/
DROP TABLE IF EXISTS aux_Localidad;
CREATE TABLE IF NOT EXISTS aux_Localidad (
	Localidad_Original	VARCHAR(80),
	Provincia_Original	VARCHAR(50),
	Localidad_Normalizada	VARCHAR(80),
	Provincia_Normalizada	VARCHAR(50),
	IdLocalidad			INTEGER
)  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

/*Notar la difernecia entre el UNION y el UNION ALL*/

INSERT INTO aux_localidad (Localidad_Original, Provincia_Original, Localidad_Normalizada, Provincia_Normalizada, IdLocalidad)
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM cliente
UNION
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM sucursal
UNION
SELECT DISTINCT Ciudad, Provincia, Ciudad, Provincia, 0 FROM proveedor
ORDER BY 2, 1;

select * from aux_localidad;
SELECT * FROM aux_localidad ORDER BY Provincia_Original;

UPDATE `aux_localidad` SET Provincia_Normalizada = 'Buenos Aires'
WHERE TRIM(Provincia_Original) IN ('B. Aires',
                            'B.Aires',
                            'Bs As',
                            'Bs.As.',
                            'Buenos Aires',
                            'C Debuenos Aires',
                            'Caba',
                            'Ciudad De Buenos Aires',
                            'Pcia Bs As',
                            'Prov De Bs As.',
                            'Provincia De Buenos Aires');
							
UPDATE `aux_localidad` SET Localidad_Normalizada = 'Capital Federal'
WHERE Localidad_Original IN ('Boca De Atencion Monte Castro',
                            'Caba',
                            'Cap.   Federal',
                            'Cap. Fed.',
                            'Capfed',
                            'Capital',
                            'Capital Federal',
                            'Cdad De Buenos Aires',
                            'Ciudad De Buenos Aires')
AND Provincia_Normalizada = 'Buenos Aires';
							
UPDATE `aux_localidad` SET Provincia_Normalizada = 'Córdoba'
WHERE Provincia_Normalizada IN ('Coroba',
                            'Cordoba',
							'Cã³rdoba');
                            
SELECT DISTINCT Provincia_Normalizada FROM aux_localidad;

DROP TABLE IF EXISTS `localidad`;
CREATE TABLE IF NOT EXISTS `localidad` (
  `IdLocalidad` int NOT NULL AUTO_INCREMENT,
  `Localidad` varchar(80) NOT NULL,
  `Provincia` varchar(80) NOT NULL,
  `IdProvincia` int NOT NULL,
  PRIMARY KEY (`IdLocalidad`)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

DROP TABLE IF EXISTS `provincia`;
CREATE TABLE IF NOT EXISTS `provincia` (
  `IdProvincia` int NOT NULL AUTO_INCREMENT,
  `Provincia` varchar(50) NOT NULL,
  PRIMARY KEY (`IdProvincia`)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO Localidad (Localidad, Provincia, IdProvincia)
SELECT DISTINCT Localidad_Normalizada, Provincia_Normalizada, 0
FROM aux_localidad
ORDER BY Provincia_Normalizada, Localidad_Normalizada;

INSERT INTO provincia (Provincia)
SELECT DISTINCT Provincia_Normalizada
FROM aux_localidad
ORDER BY Provincia_Normalizada;

UPDATE localidad l JOIN provincia p
	ON (l.Provincia = p.Provincia)
SET l.IdProvincia = p.IdProvincia;

UPDATE aux_localidad a JOIN localidad l 
			ON (l.Localidad = a.Localidad_Normalizada
                AND a.Provincia_Normalizada = l.Provincia)
SET a.IdLocalidad = l.IdLocalidad;

ALTER TABLE `cliente` ADD `IdLocalidad` INT NOT NULL DEFAULT '0' AFTER `Localidad`;
ALTER TABLE `proveedor` ADD `IdLocalidad` INT NOT NULL DEFAULT '0' AFTER `Departamento`;
ALTER TABLE `sucursal` ADD `IdLocalidad` INT NOT NULL DEFAULT '0' AFTER `Provincia`;

alter table cliente modify column provincia varchar(255) collate utf8mb4_spanish_ci;			-- es encesario cambiar la colacion de las columnas de la tabla cliente para poder comparar con aux_localidad
alter table cliente modify column localidad varchar(255) collate utf8mb4_spanish_ci;			-- es encesario cambiar la colacion de las columnas de la tabla cliente para poder comparar con aux_localidad
-- ALTER TABLE Clientes MODIFY COLUMN Provincia VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
-- ALTER TABLE Clientes MODIFY COLUMN Localidad VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;

UPDATE cliente c JOIN aux_localidad a															-- actualizar la tabla cliente con el idlocalidad de aux_localidad
	ON (c.Provincia = a.Provincia_Original AND c.Localidad = a.Localidad_Original)
SET c.IdLocalidad = a.IdLocalidad;

alter table sucursal modify column provincia varchar(255) collate utf8mb4_spanish_ci;			-- es encesario cambiar la colacion de las columnas de la tabla sucursal para poder comparar con aux_localidad
alter table sucursal modify column localidad varchar(255) collate utf8mb4_spanish_ci;			-- es encesario cambiar la colacion de las columnas de la tabla sucursal para poder comparar con aux_localidad

UPDATE sucursal s JOIN aux_localidad a															-- actualizar la tabla sucursal con el idlocalidad de aux_localidad
	ON (s.Provincia = a.Provincia_Original AND s.Localidad = a.Localidad_Original)
SET s.IdLocalidad = a.IdLocalidad;

alter table proveedor modify column provincia varchar(255) collate utf8mb4_spanish_ci;			-- es encesario cambiar la colacion de las columnas de la tabla proveedor para poder comparar con aux_localidad
alter table proveedor modify column ciudad varchar(255) collate utf8mb4_spanish_ci;				-- es encesario cambiar la colacion de las columnas de la tabla proveedor para poder comparar con aux_localidad

UPDATE proveedor p JOIN aux_localidad a
	ON (p.Provincia = a.Provincia_Original AND p.Ciudad = a.Localidad_Original)					-- actualizar la tabla proveedor con el idlocalidad de aux_localidad
SET p.IdLocalidad = a.IdLocalidad;

ALTER TABLE `cliente`
  DROP `Provincia`,					-- ya no es necesarias esas dos columnas porque se puede obtener la informacion por ilocalidad
  DROP `Localidad`;
  
ALTER TABLE `proveedor`
  DROP `Ciudad`,					-- ya no es necesarias esas dos columnas porque se puede obtener la informacion por ilocalidad
  DROP `Provincia`;
  -- DROP `Pais`,
  -- DROP `Departamento`;
  
ALTER TABLE `sucursal`
  DROP `Localidad`,					-- ya no es necesarias esas dos columnas porque se puede obtener la informacion por ilocalidad
  DROP `Provincia`;

ALTER TABLE `localidad`				-- ya no es necesarias esas dos columnas porque se puede obtener la informacion por ilocalidad
  DROP `Provincia`;

/* 	NORMALIZACIÓN


2. Es necesario discretizar el campo edad en la tabla cliente.
*/

/*Discretización*/
ALTER TABLE `cliente` ADD `Rango_Etario` VARCHAR(20) NOT NULL DEFAULT '-' AFTER `Edad`;

UPDATE cliente SET Rango_Etario = '1_Hasta 30 años' WHERE Edad <= 30;
UPDATE cliente SET Rango_Etario = '2_De 31 a 40 años' WHERE Edad <= 40 AND Rango_Etario = '-';
UPDATE cliente SET Rango_Etario = '3_De 41 a 50 años' WHERE Edad <= 50 AND Rango_Etario = '-';
UPDATE cliente SET Rango_Etario = '4_De 51 a 60 años' WHERE Edad <= 60 AND Rango_Etario = '-';
UPDATE cliente SET Rango_Etario = '5_Desde 60 años' WHERE Edad > 60 AND Rango_Etario = '-';

select Rango_Etario, count(*)
from cliente
group by Rango_Etario
order by rango_etario;


/* OUTLIERS

Aplicar alguna técnica de detección de Outliers en la tabla ventas, sobre los campos Precio
y Cantidad. Realizar diversas consultas para verificar la importancia de haber detectado
Outliers. Por ejemplo ventas por sucursal en un período teniendo en cuenta outliers y descartándolos.
*/

/*Deteccion y corrección de Outliers sobre ventas*/
/*Motivos:		2-Outlier de Cantidad
				3-Outlier de Precio
*/

-- Detección de outliers

SELECT IdProducto, avg(Precio) as promedio, avg(Precio) + (3 * stddev(Precio)) as maximo		-- rango maximo de valores para no ser outlier
from venta
GROUP BY IdProducto;

SELECT IdProducto, avg(Precio) as promedio, avg(Precio) - (3 * stddev(Precio)) as minimo		-- rango minimo de valores para no ser outlier
from venta
GROUP BY IdProducto;

select 3 * stddev(Precio) from venta;
select IdProducto, precio, stddev(precio) over () from venta order by precio desc;


-- Detección de Outliers en la tabla venta para el campo precio
-- SELECT v.*, o.promedio, o.maximo, o.minimo
SELECT v.idproducto, precio, o.promedio, o.maximo, o.minimo
from venta v
JOIN (SELECT 	IdProducto, 											-- subconsulta de rangos para identificar los outliers que se salen de esos rangos
				avg(Precio) as promedio, 
				avg(Precio) + (3 * stddev(Precio)) as maximo,
				avg(Precio) - (3 * stddev(Precio)) as minimo
	from venta
	GROUP BY IdProducto) o
ON (v.IdProducto = o.IdProducto)
WHERE v.Precio > o.maximo OR v.Precio < minimo;

-- Detección de Outliers en la tabla venta para el campo cantidad
SELECT v.*, o.promedio, o.maximo, o.minimo
from venta v
JOIN (SELECT 	IdProducto, 											-- subconsulta de rangos para identificar los outliers que se salen de esos rangos
				avg(Cantidad) as promedio, 								
                avg(Cantidad) + (3 * stddev(Cantidad)) as maximo,
				avg(Cantidad) - (3 * stddev(Cantidad)) as minimo
	from venta
	GROUP BY IdProducto) o
ON (v.IdProducto = o.IdProducto)
WHERE v.Cantidad > o.maximo OR v.Cantidad < o.minimo;


-- Introducimos los outliers de cantidad en la tabla aux_venta
INSERT into aux_venta							-- guardar los outliers en una tabla llamada aux venta
select	v.IdVenta,
		v.Fecha,
		v.Fecha_Entrega,
        v.IdCliente,
        v.IdSucursal,
        v.IdEmpleado,
        v.IdProducto,
        v.Precio,
        v.Cantidad,
        2
from venta v
JOIN (SELECT IdProducto, avg(Cantidad) as promedio, stddev(Cantidad) as Desv
	from venta
	GROUP BY IdProducto) v2
ON (v.IdProducto = v2.IdProducto)
WHERE v.Cantidad > (v2.Promedio + (3*v2.Desv)) OR v.Cantidad < (v2.Promedio - (3*v2.Desv)) 
OR v.Cantidad < 0;


-- Introducimos los outliers de precio en la tabla aux_venta
INSERT into aux_venta
select	v.IdVenta,
		v.Fecha,
        v.Fecha_Entrega,
        v.IdCliente,
        v.IdSucursal,
        v.IdEmpleado,
        v.IdProducto,
        v.Precio,
        v.Cantidad,
        3
from venta v
JOIN (SELECT IdProducto, avg(Precio) as promedio, stddev(Precio) as Desv
	from venta
	GROUP BY IdProducto) v2
ON (v.IdProducto = v2.IdProducto)
WHERE v.Precio > (v2.Promedio + (3*v2.Desv)) OR v.Precio < (v2.Promedio - (3*v2.Desv)) OR v.Precio < 0;

select * from aux_venta where Motivo = 1; -- "Errores"
select * from aux_venta where Motivo = 2; -- outliers de cantidad
select * from aux_venta where Motivo = 3; -- outliers de precio

ALTER TABLE `venta` ADD `Outlier` TINYINT NOT NULL DEFAULT '1' AFTER `Cantidad`;

SET GLOBAL local_infile=1;
SET SQL_SAFE_UPDATES = 0;
SHOW VARIABLES LIKE 'wait_timeout';
SHOW VARIABLES LIKE '%timeout%';
set interactive_timeout = 28000;
set wait_timeout = 28000;

-- cuidado con los timeouts
UPDATE venta v JOIN aux_venta a
	ON (v.IdVenta = a.IdVenta AND a.Motivo IN (2,3))
SET v.Outlier = 0;

-- es necesario ejecutar el codigo por partes ya que el tiempo de espera es muy alto
		UPDATE venta v JOIN aux_venta a
			ON (v.IdVenta = a.IdVenta AND a.Motivo IN (2,3))
		SET v.Outlier = 0
		where v.IdVenta between 1 and 5000;

		UPDATE venta v JOIN aux_venta a
			ON (v.IdVenta = a.IdVenta AND a.Motivo IN (2,3))
		SET v.Outlier = 0
		where v.IdVenta between 5001 and 10000;

		UPDATE venta v JOIN aux_venta a
			ON (v.IdVenta = a.IdVenta AND a.Motivo IN (2,3))
		SET v.Outlier = 0
		where v.IdVenta between 10001 and 15000;

		UPDATE venta v JOIN aux_venta a
			ON (v.IdVenta = a.IdVenta AND a.Motivo IN (2,3))
		SET v.Outlier = 0
		where v.IdVenta between 15001 and 20000;

		UPDATE venta v JOIN aux_venta a
			ON (v.IdVenta = a.IdVenta AND a.Motivo IN (2,3))
		SET v.Outlier = 0
		where v.IdVenta between 20001 and 25000;

		UPDATE venta v JOIN aux_venta a
			ON (v.IdVenta = a.IdVenta AND a.Motivo IN (2,3))
		SET v.Outlier = 0
		where v.IdVenta between 25001 and 30000;

		UPDATE venta v JOIN aux_venta a
			ON (v.IdVenta = a.IdVenta AND a.Motivo IN (2,3))
		SET v.Outlier = 0
		where v.IdVenta between 30001 and 35000;

		UPDATE venta v JOIN aux_venta a
			ON (v.IdVenta = a.IdVenta AND a.Motivo IN (2,3))
		SET v.Outlier = 0
		where v.IdVenta between 35001 and 40000;

		UPDATE venta v JOIN aux_venta a
			ON (v.IdVenta = a.IdVenta AND a.Motivo IN (2,3))
		SET v.Outlier = 0
		where v.IdVenta between 40001 and 45000;

		UPDATE venta v JOIN aux_venta a
			ON (v.IdVenta = a.IdVenta AND a.Motivo IN (2,3))
		SET v.Outlier = 0
		where v.IdVenta > 45000;

-- Ventas con y sin outliers
SELECT 
    co.TipoProducto,
    co.PromedioVentaConOutliers,
    so.PromedioVentaSinOutliers
FROM
    (SELECT 
        tp.TipoProducto,
            AVG(v.Precio * v.Cantidad) AS PromedioVentaConOutliers
    FROM
        venta v
    JOIN producto p ON (v.IdProducto = p.IdProducto)
    JOIN tipo_producto tp ON (p.IdTipoProducto = tp.IdTipoProducto)
    GROUP BY tp.TipoProducto) co
JOIN
    (SELECT 
        tp.TipoProducto,
            AVG(v.Precio * v.Cantidad) AS PromedioVentaSinOutliers
    FROM
        venta v
    JOIN producto p ON (v.IdProducto = p.IdProducto
        AND v.Outlier = 1)
    JOIN tipo_producto tp ON (p.IdTipoProducto = tp.IdTipoProducto)
    GROUP BY tp.TipoProducto) so
ON co.TipoProducto = so.TipoProducto;

/* ETL

Es necesario armar un proceso, mediante el cual podamos integrar todas las fuentes, 
aplicar las transformaciones o reglas de negocio necesarias a los datos y generar el 
modelo final que va a ser consumido desde los reportes. Este proceso debe ser claro 
y autodocumentado. ¿Se puede armar un esquema, donde sea posible detectar con mayor 
facilidad futuros errores en los datos?

R/= es necesario crear un documento de procedimientos
*/

/*
Elaborar 3 KPIs del negocio. Tener en cuenta que deben ser métricas fácilmente graficables,
por lo tanto debemos asegurarnos de contar con los datos adecuados. ¿Necesito tener el claro
las métricas que voy a utilizar? ¿La métrica necesaria debe tener algún filtro en especial?
La Meta que se definió ¿se calcula con la misma métrica?
*/

-- KPI: Margen de Ganancia por producto superior a 20%
SELECT 	venta.Producto, 
		venta.SumaVentas, 
        venta.CantidadVentas, 
        venta.SumaVentasOutliers,
        compra.SumaCompras, 
        compra.CantidadCompras,
        ((venta.SumaVentas / compra.SumaCompras - 1) * 100) as margen
FROM
	(SELECT p.Producto,
			SUM(v.Precio * v.Cantidad * v.Outlier) 	as 	SumaVentas,
			SUM(v.Outlier) 							as	CantidadVentas,
			SUM(v.Precio * v.Cantidad) 				as 	SumaVentasOutliers,
			COUNT(*) 								as	CantidadVentasOutliers
	FROM venta v 
    JOIN producto p
		ON (v.IdProducto = p.IdProducto AND YEAR(v.Fecha) = 2019)
	GROUP BY p.Producto) AS venta
JOIN
	(SELECT 	
		p.Producto,
		SUM(c.Precio * c.Cantidad) 	as SumaCompras,
		COUNT(*)					as CantidadCompras
	FROM compra c 
    JOIN producto p
		ON (c.IdProducto = p.IdProducto AND YEAR(c.Fecha) = 2019)
	GROUP BY p.Producto) as compra
ON (venta.Producto = compra.Producto);
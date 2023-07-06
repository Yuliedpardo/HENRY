-- Solución de Homework.
use henry_m3;
-- 1)
DROP PROCEDURE listaProductos;
DELIMITER $$
CREATE PROCEDURE listaProductos(IN fechaVenta DATE)
BEGIN
	Select distinct tp.TipoProducto, p.Producto
	From fact_venta v join dim_producto p
			On (v.IdProducto = p.IdProducto
				And v.Fecha = fechaVenta)
		join tipo_producto tp
			On (p.idTipoProducto = tp.IdTipoProducto)
	Order by tp.TipoProducto, p.Producto;
END $$
DELIMITER;

CALL listaProductos('2020-01-01');

-- 2)
SET GLOBAL log_bin_trust_function_creators = 1;

DROP FUNCTION margenBruto;

DELIMITER $$
CREATE FUNCTION margenBruto(precio DECIMAL(15,3), margen DECIMAL (9,2)) RETURNS DECIMAL (15,3)
BEGIN
	DECLARE margenBruto DECIMAL (15,3);
    
    SET margenBruto = precio * margen;
    
    RETURN margenBruto;
END$$

DELIMITER ;

Select margenBruto(100.50, 1.2);

Select 	c.Fecha,
		pr.Nombre					as Proveedor,
		p.Producto,
		c.Precio 					as PrecioCompra,
        margenBruto(c.Precio, 1.3)	as PrecioMargen
From 	compra c Join producto p
			On (c.IdProducto = p.IdProducto)
		Join proveedor pr
			On (c.IdProveedor = pr.IdProveedor);

SELECT 	Producto, 
		margenBruto(Precio, 1.30) AS Margen
FROM producto;

-- 3)
SELECT 	p.IdProducto, 
		p.Producto,
        p.Precio,
        margenBruto(Precio, 1.3) AS PrecioMargen
FROM producto p join tipo_producto tp
	On (p.IdTipoProducto = tp.IdTipoProducto
		And TipoProducto = 'Impresión');
     
SELECT 	IdProducto, 
		precio as PrecioVenta, 
        ROUND(precio * ( (100 + 10) /100 ), 2) AS PrecioFinal
FROM compra;

DELIMITER $$
CREATE PROCEDURE MargenbrutoJ(IN porcent int)
BEGIN
    /*SELECT IdProducto, precio as PrecioVenta, ROUND(precio /((100 - porcent)/100),2) AS PrecioFinal
    FROM compra;
    */
    SELECT IdProducto, precio as PrecioVenta, ROUND(precio * ( (100 + porcent) /100 ), 2) AS PrecioFinal
    FROM compra;
END $$
DELIMITER ;

CALL MargenbrutoJ(30);
-- 4)
DROP PROCEDURE listaCategoria;

DELIMITER $$
CREATE PROCEDURE listaCategoria(IN categoria VARCHAR (25))
BEGIN
	SELECT 	v.Fecha,
			v.Fecha_Entrega,
			v.IdCliente,
			v.IdCanal,
			v.IdSucursal,
			tp.TipoProducto,
			p.Producto,
			v.Precio,
			v.Cantidad
	FROM venta v join producto p
			On (v.IdProducto = p.idProducto
				And v.Outlier = 1)
		Join tipo_producto tp
			On (p.IdTipoProducto = tp.IdTipoProducto
				And TipoProducto collate utf8mb4_spanish_ci LIKE Concat('%', categoria, '%'));
                -- And TipoProducto = categoria);
END $$
DELIMITER ;

CALL listaCategoria('i');

-- 5)
DROP PROCEDURE cargarFact_venta;

DELIMITER $$
CREATE PROCEDURE cargarFact_venta()
BEGIN
	TRUNCATE table fact_venta;

    INSERT INTO fact_venta (IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad)
    SELECT	IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad
    FROM 	venta
    WHERE  	Outlier = 1;
END $$
DELIMITER ;

CALL cargarFact_venta();

SHOW TRIGGERS;
-- DROP TRIGGER henry_m3.fact_venta_registros;
-- 6)

SELECT 	c.Rango_Etario, 
		sum(v.Precio*v.Cantidad) 	AS Total_Ventas
FROM fact_venta v
	INNER JOIN dim_cliente c
		ON (v.IdCliente = c.IdCliente
			and c.Rango_Etario collate utf8mb4_spanish_ci = '2_De 31 a 40 años')
GROUP BY c.Rango_Etario;
    
DROP PROCEDURE ventasGrupoEtario; 

DELIMITER $$
CREATE PROCEDURE ventasGrupoEtario(IN grupo VARCHAR(25))
BEGIN
	SELECT 	c.Rango_Etario, 
			sum(v.Precio*v.Cantidad) 	AS Total_Ventas
	FROM fact_venta v
		INNER JOIN dim_cliente c
			ON (v.IdCliente = c.IdCliente
				and c.Rango_Etario collate utf8mb4_spanish_ci like Concat('%', grupo, '%'))
	GROUP BY c.Rango_Etario;
END $$
DELIMITER ;

SELECT DISTINCT Rango_Etario FROM dim_cliente;

CALL ventasGrupoEtario('31%40');

-- 7)

SET @grupo = '2_De 31 a 40 años';

SELECT *
FROM dim_cliente
WHERE Rango_Etario collate utf8mb4_spanish_ci = @grupo
LIMIT 10;

/*Función y Procedimiento provistos*/
SET GLOBAL log_bin_trust_function_creators = 1;
DROP FUNCTION IF EXISTS `UC_Words`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `UC_Words`( str VARCHAR(255) ) RETURNS varchar(255) CHARSET utf8
BEGIN  
  DECLARE c CHAR(1);  
  DECLARE s VARCHAR(255);  
  DECLARE i INT DEFAULT 1;  
  DECLARE bool INT DEFAULT 1;  
  DECLARE punct CHAR(17) DEFAULT ' ()[]{},.-_!@;:?/';  
  SET s = LCASE( str );  
  WHILE i < LENGTH( str ) DO  
     BEGIN  
       SET c = SUBSTRING( s, i, 1 );  
       IF LOCATE( c, punct ) > 0 THEN  
        SET bool = 1;  
      ELSEIF bool=1 THEN  
        BEGIN  
          IF c >= 'a' AND c <= 'z' THEN  
             BEGIN  
               SET s = CONCAT(LEFT(s,i-1),UCASE(c),SUBSTRING(s,i+1));  
               SET bool = 0;  
             END;  
           ELSEIF c >= '0' AND c <= '9' THEN  
            SET bool = 0;  
          END IF;  
        END;  
      END IF;  
      SET i = i+1;  
    END;  
  END WHILE;  
  RETURN s;  
END$$
DELIMITER ;
DROP PROCEDURE IF EXISTS `Llenar_dimension_calendario`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Llenar_dimension_calendario`(IN `startdate` DATE, IN `stopdate` DATE)
BEGIN
    DECLARE currentdate DATE;
    SET currentdate = startdate;
    WHILE currentdate < stopdate DO
        INSERT INTO calendario VALUES (
                        YEAR(currentdate)*10000+MONTH(currentdate)*100 + DAY(currentdate),
                        currentdate,
                        YEAR(currentdate),
                        MONTH(currentdate),
                        DAY(currentdate),
                        QUARTER(currentdate),
                        WEEKOFYEAR(currentdate),
                        DATE_FORMAT(currentdate,'%W'),
                        DATE_FORMAT(currentdate,'%M'));
        SET currentdate = ADDDATE(currentdate,INTERVAL 1 DAY);
    END WHILE;
END$$
DELIMITER ;

/*Se genera la dimension calendario*/
DROP TABLE IF EXISTS `calendario`;
CREATE TABLE calendario (
        id                      INTEGER PRIMARY KEY,  -- year*10000+month*100+day
        fecha                 	DATE NOT NULL,
        anio                    INTEGER NOT NULL,
        mes                   	INTEGER NOT NULL, -- 1 to 12
        dia                     INTEGER NOT NULL, -- 1 to 31
        trimestre               INTEGER NOT NULL, -- 1 to 4
        semana                  INTEGER NOT NULL, -- 1 to 52/53
        dia_nombre              VARCHAR(9) NOT NULL, -- 'Monday', 'Tuesday'...
        mes_nombre              VARCHAR(9) NOT NULL -- 'January', 'February'...
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

ALTER TABLE `calendario` CHANGE `id` `IdFecha` INT(11) NOT NULL;
ALTER TABLE `calendario` ADD UNIQUE(`fecha`);

/*LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Calendario.csv' 
INTO TABLE calendario
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;*/

-- 8)
/*Normalizacion a Letra Capital*/
UPDATE cliente SET  Domicilio = UC_Words(TRIM(Domicilio)),
                    Nombre_y_Apellido = UC_Words(TRIM(Nombre_y_Apellido));
					
UPDATE sucursal SET Domicilio = UC_Words(TRIM(Domicilio)),
                    Sucursal = UC_Words(TRIM(Sucursal));
					
UPDATE proveedor SET Nombre = UC_Words(TRIM(Nombre)),
                    Domicilio = UC_Words(TRIM(Domicilio));

UPDATE producto SET Producto = UC_Words(TRIM(Producto));

UPDATE tipo_producto SET TipoProducto = UC_Words(TRIM(TipoProducto));
					
UPDATE empleado SET Nombre = UC_Words(TRIM(Nombre)),
                    Apellido = UC_Words(TRIM(Apellido));

UPDATE sector SET Sector = UC_Words(TRIM(Sector));

UPDATE cargo SET Cargo = UC_Words(TRIM(Cargo));
                    
UPDATE localidad SET Localidad = UC_Words(TRIM(Localidad));

UPDATE provincia SET Provincia = UC_Words(TRIM(Provincia));

UPDATE dim_cliente SET 	Domicilio = UC_Words(TRIM(Domicilio)),
                    Nombre_y_Apellido = UC_Words(TRIM(Nombre_y_Apellido));

UPDATE dim_producto SET Producto = UC_Words(TRIM(Producto));

-- 9)
/*TRUNCATE TABLE calendario;*/
CALL Llenar_dimension_calendario('2015-01-01','2021-01-01');
SELECT * FROM calendario;

ALTER TABLE venta ADD CONSTRAINT `venta_fk_fecha` FOREIGN KEY (fecha) REFERENCES calendario (fecha) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE compra ADD CONSTRAINT `compra_fk_fecha` FOREIGN KEY (Fecha) REFERENCES calendario (fecha) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE gasto ADD CONSTRAINT `gasto_fk_fecha` FOREIGN KEY (Fecha) REFERENCES calendario (fecha) ON DELETE RESTRICT ON UPDATE RESTRICT;

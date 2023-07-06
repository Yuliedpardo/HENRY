use henry_m3;

/* SOLUCION HOMEWORK 5

1. ¿Qué tan actualizada está la información? ¿La forma en que se actualiza ó mantiene esa información se puede mejorar?

	No esta actualizada la informacion.
	Se ve enconsulta - ventas - fecha_entregas
	La forma de actualización depende del caso de uso que le demos. Si se necesita en tiempo
	real (actualización streaming) o si solo de usa 1 vez al día (actualización batch)

2. ¿Los datos están completos en todas las tablas?

	Los datos no están completos en las tablas. 
	Se ven los campos vacios en proveedores y productos al hacer consulta general.

3. ¿Se conocen las fuentes de los datos?

	En la homework de la calse 4 nos dan una pequeña noción de los origenes de las tablas de excel.

4. Al integrar éstos datos, es prudente que haya una normalización respecto de nombrar las tablas y sus campos.

	Normalización: poder llevar de sistema dimensional a sistema transaccional.
	Normalizar: no ser redundante con la información.
	sistema dimensional: información redundante para facil consulta y analisis
	sistema transaccional: información no redundate (no se repite) para mayor eficiencia en los procesos
	Otra forma de interpretar normalización: estandarizar y limpiar datos.

5. Es importante revisar la consistencia de los datos:

	¿Se pueden relacionar todas las tablas al modelo?
	Con un analisis generar si se puede ver que las tablas se pueden relacionar, solo es cuestión de armar PK y FK

	¿Cuáles son las tablas de hechos y las tablas dimensionales o maestros?
	una tabla de hecho es algo que sucede (una acción)
	las tablas de hecho se pueden evidenciar viendo que tantas refeencias a otras tablas se están haciendo (ID o FK de otras tablas)
	las tablas dimensionales (o tablas de dimensiones) son tablas que necesito para que el fact table se realice
	FACT TABLE: compra, venta, gasto
	DIMENSIONALES: el resto de tablas

	¿Podemos hacer esa separación en los datos que tenemos (tablas de hecho y dimensiones)?
	relacionada con la pregunta anterior
	*/
    
	-- ¿Hay claves duplicadas?
	
    select id, count(*) from clientes group by id having count(*) >1; 						-- no
	select idcompra, count(*) from compra group by idcompra having count(*) >1;				-- no
    select idempleado, count(*) from empleado group by idempleado having count(*) >1;		-- SI HAY
    select idgasto, count(*) from gasto group by idgasto having count(*) >1;				-- no
    select idproducto, count(*) from productos group by idproducto having count(*) >1;		-- no
    select idproveedor, count(*) from proveedores group by idproveedor having count(*) >1;	-- no
    select id, count(*) from sucursal group by id having count(*) >1;						-- no
    select idTipoGasto, count(*) from tipo_gasto group by idTipoGasto having count(*) >1;	-- no
    select idVenta, count(*) from venta group by idVenta having count(*) >1;				-- no		

/*
	¿Cuáles son variables cualitativas y cuáles son cuantitativas?
	variables cualitativas: algo nominal (nombre, fecha) sirven para agrupar variablews numericas
    variable cuantitativa: cuantificar utilizando algunas medidas como mediana, media, desviacion estandar, cuartiles, rango intercuartil

	¿Qué acciones podemos aplicar sobre las mismas?
    cuantitativas: funciones de agragación
    cualitativas: segmentación sobre variables cuantitativas. Tambi´én compararla con si misma.
    
*/

SET SQL_SAFE_UPDATES = 0;				-- para poder modificar las tablas sin hacer referencia a la PK

-- LIMPIEZA, VALORES FALTANTES

-- 6. Normalizar los nombres de los campos y colocar el tipo de dato adecuado para cada uno
-- en cada una de las tablas. Descartar columnas que consideres que no tienen relevancia.

/*nombre de tablas*/
alter table clientes rename	to cliente;
alter table empleados rename to empleado;
alter table productos rename to producto;
alter table proveedores rename to proveedor;

/*nombre de campos*/
alter table canal_venta change id_canal IdCanal int not null;
alter table cliente change id IdCliente int not null;
alter table compra change idCompra IdCompra int not null;
alter table empleado change idEmpleado IdEmpleado int null default null;
alter table gasto change idGasto IdGasto int not null;
alter table producto change idProducto IdProducto int null default null;
alter table producto change concepto Producto varchar(100) character set utf8mb4 collate utf8mb4_spanish_ci null default null;
alter table proveedor change idProveedor IdProveedor int null default null;
alter table proveedor rename column address to domicilio;
alter table proveedor rename column city to ciudad;
alter table proveedor rename column state to provincia;
alter table proveedor rename column country to pais;
alter table proveedor rename column department to departamento;
alter table sucursal change id IdSucursal int null default null;
alter table tipo_gasto change descripcion Tipo_Gasto varchar(100) character set utf8 collate utf8_spanish_ci not null;
alter table venta change idVenta IdVenta int not null;
alter table sucursal rename column direccion to domicilio;

/*tipos de datos*/
alter table  cliente	add Latitud decimal(13,10) not null default '0' after y,
						add Longitud decimal(13,10) not null default '0' after Latitud;


update cliente set y = '0' where y ='';
update cliente set x = '0' where x ='';
update cliente set Latitud = replace(y,',','.');
update cliente set Longitud = replace(x,',','.');
alter table cliente drop x;
alter table cliente drop y;

alter table empleado add Salario2 decimal(10,2) not null default '0' after salario;
update empleado set salario = replace(salario,',','.');
update empleado set Salario2 = '0' where Salario = '';
alter table empleado drop salario;
alter table empleado rename column Salario2 to salario;

alter table producto add precio2 decimal(15,3) not null default '0' after precio;
update producto set precio2 = replace(precio,',','.');
update producto set precio2 = '0' where precio = '';
alter table producto drop precio;
alter table producto rename column precio2 to precio;

alter table  sucursal	add Latitud2 decimal(13,10) not null default '0' after Longitud,
						add Longitud2 decimal(13,10) not null default '0' after Latitud2;
update sucursal set Latitud2 = replace(Latitud,',','.');
update sucursal set Latitud2 = '0' where Latitud ='';
update sucursal set Longitud2 = replace(Longitud,',','.');
update sucursal set Longitud2 = '0' where Longitud ='';
alter table sucursal drop Latitud;
alter table sucursal drop Longitud;
alter table sucursal rename column Latitud2 to Latitud;
alter table sucursal rename column Longitud2 to Longitud;

update venta set precio = 0 where precio = '';
alter table venta modify precio decimal(15,3) not null default '0';

/*columnas sin usar*/
alter table cliente drop col10;


-- 7. Buscar valores faltantes y campos inconsistentes en las tablas sucursal, proveedor, empleado y cliente.
-- De encontrarlos, deberás corregirlos o desestimarlos. Propone y realiza una acción correctiva sobre ese problema.

/*inputar valores faltantes*/
update cliente set domicilio = 'Sin Dato' where trim(domicilio) = '' or isnull(domicilio);
update cliente set localidad = 'Sin Dato' where trim(localidad) = '' or isnull(localidad);
update cliente set nombre_apellido = 'Sin Dato' where trim(nombre_apellido) = '' or isnull(nombre_apellido);
update cliente set provincia = 'Sin Dato' where trim(provincia) = '' or isnull(provincia);

update empleado set apellido = 'Sin Dato' where trim(apellido) = '' or isnull(apellido);
update empleado set nombre = 'Sin Dato' where trim(nombre) = '' or isnull(nombre);
update empleado set sucursal = 'Sin Dato' where trim(sucursal) = '' or isnull(sucursal);
update empleado set sector = 'Sin Dato' where trim(sector) = '' or isnull(sector);
update empleado set cargo = 'Sin Dato' where trim(cargo) = '' or isnull(cargo);

update producto set producto = 'Sin Dato' where trim(producto) = '' or isnull(producto);
update producto set tipo = 'Sin Dato'  where trim(tipo) = '' or isnull(tipo);

update proveedor set nombre = 'Sin Dato'  where trim(nombre) = '' or isnull(nombre);
update proveedor set domicilio = 'Sin Dato'  where trim(domicilio) = '' or isnull(domicilio);
update proveedor set ciudad = 'Sin Dato'  where trim(ciudad) = '' or isnull(ciudad);
update proveedor set provincia = 'Sin Dato'  where trim(provincia) = '' or isnull(provincia);
update proveedor set pais = 'Sin Dato'  where trim(pais) = '' or isnull(pais);
update proveedor set departamento = 'Sin Dato'  where trim(departamento) = '' or isnull(departamento);

update sucursal set domicilio = 'Sin Dato'  where trim(domicilio) = '' or isnull(domicilio);
update sucursal set sucursal = 'Sin Dato'  where trim(sucursal) = '' or isnull(sucursal);
update sucursal set provincia = 'Sin Dato'  where trim(provincia) = '' or isnull(provincia);
update sucursal set localidad = 'Sin Dato'  where trim(localidad) = '' or isnull(localidad);

-- 8. Utilizar la funcion provista 'UC_Words' (Homework_Utiles.sql) para modificar a letra capital
-- los campos que contengan descripciones para todas las tablas.

/*normalización a letra capital*/
use henry_m3;
SET SQL_SAFE_UPDATES = 0;
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

UPDATE cliente SET  Domicilio = UC_Words(TRIM(Domicilio)),
                    Nombre_apellido= UC_Words(TRIM(Nombre_apellido));

UPDATE sucursal SET Domicilio = UC_Words(TRIM(Domicilio)),
                    Sucursal = UC_Words(TRIM(Sucursal));
					
UPDATE proveedor SET Nombre = UC_Words(TRIM(Nombre)),
					 Domicilio = UC_Words(TRIM(Domicilio));

UPDATE producto SET Producto = UC_Words(TRIM(Producto));

-- UPDATE tipo_producto SET TipoProducto = UC_Words(TRIM(TipoProducto));
					
UPDATE empleado SET Nombre = UC_Words(TRIM(Nombre)),
                    Apellido = UC_Words(TRIM(Apellido));


-- 9. Chequear la consistencia de los campos precio y cantidad de la tabla de ventas.

/*
select * from venta where Precio = '' or Cantidad = '';
select count(*) from venta;
*/

select * from producto;
select * from venta where Precio = 0;				-- algunos campos con precio 0 tienen cantidades relacionadas
select * from venta where cantidad = 0;				-- algunos campos con cantidad en 0 tienen precio

UPDATE venta v JOIN producto p ON (v.IdProducto = p.IdProducto) 
SET v.Precio = p.Precio
WHERE v.Precio = 0;

/*Tabla auxiliar donde se guardarán registros con problemas:
1-Cantidad en Cero
*/
DROP TABLE IF EXISTS `aux_venta`;
CREATE TABLE IF NOT EXISTS `aux_venta` (
  `IdVenta`				INTEGER,
  `Fecha` 				DATE NOT NULL,
  `Fecha_Entrega` 		DATE NOT NULL,
  `IdCliente`			INTEGER, 
  `IdSucursal`			INTEGER,
  `IdEmpleado`			INTEGER,
  `IdProducto`			INTEGER,
  `Precio`				FLOAT,
  `Cantidad`			INTEGER,
  `Motivo`				INTEGER
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

UPDATE venta SET Cantidad = REPLACE(Cantidad, '\r', '');

INSERT INTO aux_venta (	IdVenta,
						Fecha,
						Fecha_Entrega,
                        IdCliente, 
                        IdSucursal,
                        IdEmpleado,
                        IdProducto,
                        Precio,
                        Cantidad,
                        Motivo)
SELECT	IdVenta,
		Fecha,
        Fecha_Entrega,
        IdCliente, 
        IdSucursal, 
        IdEmpleado, 
        IdProducto, 
        Precio, 
        0, 
        1
FROM	venta
WHERE 	Cantidad = '' or Cantidad is null;


SELECT * FROM venta WHERE cantidad = '';
UPDATE venta SET Cantidad = '1' WHERE Cantidad = '' or Cantidad is null or Cantidad = ' ';
UPDATE venta SET Cantidad = '1' WHERE TRIM(Cantidad) = '' or Cantidad is null or Cantidad = 0;

select * from venta where cantidad not in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,100,200,300) order by cantidad desc;
UPDATE venta SET Cantidad = '1' WHERE cantidad not in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,100,200,300);

ALTER TABLE `venta` CHANGE `Cantidad` `Cantidad` INTEGER NOT NULL DEFAULT '0';



-- 10. Chequear que no haya claves duplicadas, y de encontrarla en alguna de las tablas, proponer una solución.

-- dado que empleado tiene claves que se repiten se va a utilizar una llave doble incuyendo los ID de los sucursales igualando las dos tablas

SELECT e.*, s.IdSucursal
FROM empleado e JOIN sucursal s
	ON (e.sucursal = s.sucursal);
    
select distinct Sucursal from empleado
where Sucursal NOT IN (select Sucursal from sucursal);

/*Generacion de clave única tabla empleado mediante creacion de clave subrogada*/
UPDATE empleado SET Sucursal = 'Mendoza1' WHERE Sucursal = 'Mendoza 1';
UPDATE empleado SET Sucursal = 'Mendoza2' WHERE Sucursal = 'Mendoza 2';

ALTER TABLE `empleado` ADD `IdSucursal` INT NULL DEFAULT '0' AFTER `Sucursal`;

UPDATE empleado e JOIN sucursal s
	ON (e.Sucursal = s.Sucursal)
SET e.IdSucursal = s.IdSucursal;

ALTER TABLE `empleado` DROP `Sucursal`;

ALTER TABLE `empleado` ADD `CodigoEmpleado` INT NULL DEFAULT '0' AFTER `IdEmpleado`;

UPDATE empleado SET CodigoEmpleado = IdEmpleado;								-- guardan el IdEmpleado a CodigoEmpleado
UPDATE empleado SET IdEmpleado = (IdSucursal * 1000000) + IdEmpleado;			-- Asignan un nuevo IdEmpleado que sale de combinar IdSucursal + codigoempleado 


/*Chequeo de claves duplicadas*/
SELECT * FROM `empleado`;
SELECT IdEmpleado, COUNT(*) FROM empleado GROUP BY IdEmpleado HAVING COUNT(*) > 1;

/*Modificacion de la clave foranea de empleado en venta*/
UPDATE venta SET IdEmpleado = (IdSucursal * 1000000) + IdEmpleado;

/*
Normalización
Generar dos nuevas tablas a partir de la tabla 'empleado' que contengan las entidades Cargo y Sector.
*/
/*Normalizacion tabla empleado*/
DROP TABLE IF EXISTS `cargo`;
CREATE TABLE IF NOT EXISTS `cargo` (
  `IdCargo` integer NOT NULL AUTO_INCREMENT,
  `Cargo` varchar(50) NOT NULL,
  PRIMARY KEY (`IdCargo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO cargo (Cargo) SELECT DISTINCT Cargo FROM empleado ORDER BY 1;

DROP TABLE IF EXISTS `sector`;
CREATE TABLE IF NOT EXISTS `sector` (
  `IdSector` integer NOT NULL AUTO_INCREMENT,
  `Sector` varchar(50) NOT NULL,
  PRIMARY KEY (`IdSector`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO sector (Sector) SELECT DISTINCT Sector FROM empleado ORDER BY 1;

ALTER TABLE `empleado` 	ADD `IdSector` INT NOT NULL DEFAULT '0' AFTER `IdSucursal`, 
						ADD `IdCargo` INT NOT NULL DEFAULT '0' AFTER `IdSector`;



ALTER TABLE empleado MODIFY COLUMN Cargo VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
ALTER TABLE cargo MODIFY COLUMN Cargo VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
UPDATE empleado e JOIN cargo c ON (c.Cargo = e.Cargo) SET e.IdCargo = c.IdCargo;

ALTER TABLE empleado MODIFY COLUMN Sector VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
ALTER TABLE sector MODIFY COLUMN Sector VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
UPDATE empleado e JOIN sector s ON (s.Sector = e.Sector) SET e.IdSector = s.IdSector;

ALTER TABLE `empleado` DROP `Cargo`;
ALTER TABLE `empleado` DROP `Sector`;



/*Normalización tabla producto*/
ALTER TABLE `producto` ADD `IdTipoProducto` INT NOT NULL DEFAULT '0' AFTER `Precio`;

DROP TABLE IF EXISTS `tipo_producto`;
CREATE TABLE IF NOT EXISTS `tipo_producto` (
  `IdTipoProducto` int(11) NOT NULL AUTO_INCREMENT,
  `TipoProducto` varchar(50) NOT NULL,
  PRIMARY KEY (`IdTipoProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO tipo_producto (TipoProducto) SELECT DISTINCT Tipo FROM producto ORDER BY 1;

ALTER TABLE producto MODIFY COLUMN tipo VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
ALTER TABLE tipo_producto MODIFY COLUMN TipoProducto VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
UPDATE producto p JOIN tipo_producto t ON (p.Tipo = t.TipoProducto) SET p.IdTipoProducto = t.IdTipoProducto;

SELECT * FROM `producto`;

ALTER TABLE `producto` DROP `Tipo`;
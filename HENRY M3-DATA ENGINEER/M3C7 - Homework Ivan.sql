/* HOMEWORK

1.
Genere 5 consultas simples con alguna función de agregación y filtrado sobre las tablas.
Anote los resultados del la ficha de estadísticas.
*/

use henry_m3;

-- CONSULTA 1:
SELECT 	p.Provincia,
		l.Localidad,
		c.Rango_Etario,
		SUM(v.Precio * v.Cantidad) AS Venta
FROM venta v 
JOIN cliente c ON (
	v.IdCliente = c.IdCliente)
	AND v.Outlier = 1
	AND YEAR(v.Fecha) = 2020 								-- OP1: filtrado en el JOIN = AND
JOIN localidad l ON (c.IdLocalidad = l.IdLocalidad)
JOIN provincia p ON (l.IdProvincia = p.IdProvincia)
-- WHERE YEAR(v.Fecha) = 2020 AND v.Outlier = 1 			-- OP2: filtrado en  
GROUP BY p.Provincia, l.Localidad, c.Rango_Etario
ORDER BY p.Provincia, l.Localidad, c.Rango_Etario;
-- antes del indice: 1.41+
-- después del indice: 1.41+

-- CONSULTA 2:
SELECT 	pr.Provincia,
		l.Localidad,
        tp.TipoProducto,
		SUM(v.Precio * v.Cantidad) AS Venta
FROM venta v 
JOIN producto p ON (v.IdProducto = p.IdProducto)
JOIN tipo_producto tp ON (tp.IdTipoProducto = p.IdTipoProducto)
JOIN cliente c ON (v.IdCliente = c.IdCliente)
JOIN localidad l ON (c.IdLocalidad = l.IdLocalidad)
JOIN provincia pr ON (l.IdProvincia = pr.IdProvincia)
GROUP BY pr.Provincia, l.Localidad, tp.TipoProducto
ORDER BY pr.Provincia, l.Localidad, tp.TipoProducto;
-- antes del indice: 1.718+
-- después del indice: +

-- CONSULTA 3: 
select * from venta;
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
    JOIN producto p ON 
    (v.IdProducto = p.IdProducto AND YEAR(v.Fecha) = 2019)
	GROUP BY p.Producto) AS venta
JOIN
	(SELECT p.Producto,
			SUM(c.Precio * c.Cantidad) 				as SumaCompras,
			COUNT(*)								as CantidadCompras
	FROM compra c 
    JOIN producto p 
    ON (c.IdProducto = p.IdProducto AND YEAR(c.Fecha) = 2019)
	GROUP BY p.Producto) as compra
ON (venta.Producto = compra.Producto);
-- antes del indice: 1.40+
-- después del indice: +

/*
2.
A partir del conjunto de datos elaborado en clases anteriores, genere las PK de cada una de
las tablas a partir del campo que cumpla con los requisitos correspondientes.
*/

ALTER TABLE `venta` ADD PRIMARY KEY(`IdVenta`);
-- alter table canal_venta rename column IdCanal to id_canal;
ALTER TABLE `canal_venta` ADD PRIMARY KEY(`id_canal`);
ALTER TABLE `producto` ADD PRIMARY KEY(`IdProducto`);
ALTER TABLE `sucursal` ADD PRIMARY KEY(`IdSucursal`);
ALTER TABLE `empleado` ADD PRIMARY KEY(`IdEmpleado`);
ALTER TABLE `proveedor` ADD PRIMARY KEY(`IdProveedor`);
ALTER TABLE `gasto` ADD PRIMARY KEY(`IdGasto`);
ALTER TABLE `cliente` ADD PRIMARY KEY(`IdCliente`);
ALTER TABLE `compra` ADD PRIMARY KEY(`IdCompra`);

/*Creamos las relaciones entre las tablas, y con ellas las restricciones*/
-- Restringir update y delete
ALTER TABLE venta ADD CONSTRAINT `venta_fk_cliente` FOREIGN KEY (IdCliente) REFERENCES cliente (IdCliente) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE venta ADD CONSTRAINT `venta_fk_sucursal` FOREIGN KEY (IdSucursal) REFERENCES sucursal (IdSucursal) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE venta ADD CONSTRAINT `venta_fk_producto` FOREIGN KEY (IdProducto) REFERENCES producto (IdProducto) ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ALTER TABLE venta ADD CONSTRAINT `venta_fk_empleado` FOREIGN KEY (IdEmpleado) REFERENCES empleado (IdEmpleado) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE venta ADD CONSTRAINT `venta_fk_canal` FOREIGN KEY (IdCanal) REFERENCES canal_venta (id_canal) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE producto ADD CONSTRAINT `producto_fk_tipoproducto` FOREIGN KEY (IdTipoProducto) REFERENCES tipo_producto (IdTipoProducto) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE empleado ADD CONSTRAINT `empleado_fk_sector` FOREIGN KEY (IdSector) REFERENCES sector (IdSector) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE empleado ADD CONSTRAINT `empleado_fk_cargo` FOREIGN KEY (IdCargo) REFERENCES cargo (IdCargo) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE empleado ADD CONSTRAINT `empleado_fk_sucursal` FOREIGN KEY (IdSucursal) REFERENCES sucursal (IdSucursal) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE cliente ADD CONSTRAINT `cliente_fk_localidad` FOREIGN KEY (IdLocalidad) REFERENCES localidad (IdLocalidad) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE proveedor ADD CONSTRAINT `proveedor_fk_localidad` FOREIGN KEY (IdLocalidad) REFERENCES localidad (IdLocalidad) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE sucursal ADD CONSTRAINT `sucursal_fk_localidad` FOREIGN KEY (IdLocalidad) REFERENCES localidad (IdLocalidad) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE localidad ADD CONSTRAINT `localidad_fk_provincia` FOREIGN KEY (IdProvincia) REFERENCES provincia (IdProvincia) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE compra ADD CONSTRAINT `compra_fk_producto` FOREIGN KEY (IdProducto) REFERENCES producto (IdProducto) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE compra ADD CONSTRAINT `compra_fk_proveedor` FOREIGN KEY (IdProveedor) REFERENCES proveedor (IdProveedor) ON DELETE RESTRICT ON UPDATE RESTRICT;




----------------------------------------------------------------------------------

-- vamos acá
ALTER TABLE gasto ADD CONSTRAINT `gasto_fk_sucursal` FOREIGN KEY (IdSucursal) REFERENCES sucursal (IdSucursal) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE gasto ADD CONSTRAINT `gasto_fk_tipogasto` FOREIGN KEY (IdTipoGasto) REFERENCES tipo_gasto (IdTipoGasto) ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ALTER TABLE gasto DROP CONSTRAINT `gasto_fk_tipogasto`;

ALTER TABLE venta ADD CONSTRAINT `venta_fk_fecha` FOREIGN KEY (fecha) REFERENCES calendario (fecha) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE compra ADD CONSTRAINT `compra_fk_fecha` FOREIGN KEY (Fecha) REFERENCES calendario (fecha) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE gasto ADD CONSTRAINT `gasto_fk_fecha` FOREIGN KEY (Fecha) REFERENCES calendario (fecha) ON DELETE RESTRICT ON UPDATE RESTRICT;

		select * from venta where IdCliente = 969;
		select * from cliente where IdCliente = 969;
		delete from cliente where IdCliente = 969; -- No me deja porque está creada la restricción

		select * from cliente where IdCliente NOT IN (SELECT IdCliente FROM venta);
		delete from cliente where IdCliente = 22; -- Me deja, está creada la restricción, pero no existe el cliente en ventas


/*Creamos indices de las tablas determinando claves primarias y foraneas*/

ALTER TABLE `venta` ADD INDEX(`IdProducto`);
ALTER TABLE `venta` ADD INDEX(`IdEmpleado`);
ALTER TABLE `venta` ADD INDEX(`Fecha`);
ALTER TABLE `venta` ADD INDEX(`Fecha_Entrega`);
ALTER TABLE `venta` ADD INDEX(`IdCliente`);
ALTER TABLE `venta` ADD INDEX(`IdSucursal`);
ALTER TABLE `venta` ADD INDEX(`IdCanal`);

ALTER TABLE `producto` ADD INDEX(`IdTipoProducto`);

ALTER TABLE `sucursal` ADD INDEX(`IdLocalidad`);


SELECT IdEmpleado, COUNT(*) FROM empleado GROUP BY 1 HAVING COUNT(*) > 1;
DELETE FROM Empleado WHERE IdEmpleado = 26003875;

SELECT CodigoEmpleado, COUNT(*) FROM empleado GROUP BY 1 HAVING COUNT(*) > 1;

-- ALTER TABLE `empleado` ADD PRIMARY KEY(`CodigoEmpleado`); -- Esto da error de clave duplicada

ALTER TABLE `empleado` ADD INDEX(`IdSucursal`);
ALTER TABLE `empleado` ADD INDEX(`IdSector`);
ALTER TABLE `empleado` ADD INDEX(`IdCargo`);
ALTER TABLE `empleado` ADD INDEX(`CodigoEmpleado`); -- Esto da error de clave duplicada

ALTER TABLE `localidad` ADD INDEX(`IdProvincia`);

ALTER TABLE `proveedor` ADD INDEX(`IdLocalidad`);

ALTER TABLE `gasto` ADD INDEX(`IdSucursal`);
ALTER TABLE `gasto` ADD INDEX(`IdTipoGasto`);
ALTER TABLE `gasto` ADD INDEX(`Fecha`);

ALTER TABLE `cliente` ADD INDEX(`IdLocalidad`);

ALTER TABLE `compra` ADD INDEX(`Fecha`);
ALTER TABLE `compra` ADD INDEX(`IdProducto`);
ALTER TABLE `compra` ADD INDEX(`IdProveedor`);

ALTER TABLE `tipo_gasto` ADD INDEX(`idTipoGasto`);
-- Ejemplo
-- DROP INDEX IdCliente ON venta;
-- ALTER TABLE `venta` ADD INDEX(`IdCliente`);

-- Revisar Indexes




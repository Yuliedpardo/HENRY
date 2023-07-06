-- 1. Obtener un listado de cual fue el volumen de ventas (cantidad) por año y método de envío
-- mostrando para cada registro, qué porcentaje representa del total del año. Resolver utilizando
-- Subconsultas y Funciones Ventana, luego comparar la diferencia en la demora de las consultas.

-- (anio, metodo_envio)		--> cantidad_ventas , % del total del anio
	-- (anio, metodo_envio)		--> hay que usar un group by
	-- cantidad_ventas			--> depende de los 2PK (anio, metodo_envio)
	-- % del total del anio 	--> (total_ventas de cada envio de cada año / sum(total_ventas de cada año)
								--  2PK (anio, metodo_envio)				/ 1PK (anio)

-- 1. que necesito mostar?
-- 2. como tengo que mostrarlo? 
-- 3. analisis por columna final: como sacar la columna? de que claves depende para sacarla?

/* SOLUCION 1 : se saca con subconsultas

SELECT
	YEAR(salesorderheader.OrderDate) AS año,
	shipmethod.Name AS metodoEnvio,
	SUM(salesorderdetail.OrderQty) AS cant,
    t.cant_x_año AS totalXaño,
    ROUND(SUM(salesorderdetail.OrderQty) / t.cant_x_año * 100, 2) AS porcentajeDelAño
FROM salesorderheader
JOIN shipmethod
	ON shipmethod.ShipMethodID = salesorderheader.ShipMethodID
JOIN salesorderdetail
	ON salesorderdetail.SalesOrderID = salesorderheader.SalesOrderID
JOIN (	SELECT
			YEAR(salesorderheader.OrderDate) AS anio,
			SUM(salesorderdetail.OrderQty) AS cant_x_año
		FROM salesorderheader AS salesorderheader
		JOIN salesorderdetail AS salesorderdetail
			ON salesorderdetail.SalesOrderID = salesorderheader.SalesOrderID
		GROUP BY anio) AS t
	ON t.anio = YEAR(salesorderheader.OrderDate)
GROUP BY año, metodoEnvio, totalXaño
ORDER BY año, shipmethod.Name;
*/

-- SOLUCION 2
SELECT
	anio,
    metodoEnvio,
    cantidad,
    SUM(cantidad) OVER (PARTITION BY anio) AS cantxAnio,
    ROUND(cantidad / SUM(cantidad) OVER (PARTITION BY anio) *100, 2) AS porcentaAnio
FROM (	SELECT
			YEAR(salesorderheader.OrderDate) AS anio,
			shipmethod.Name AS metodoEnvio,
			SUM(salesorderdetail.OrderQty) AS cantidad
		FROM salesorderheader
		JOIN salesorderdetail
			ON salesorderdetail.SalesOrderID = salesorderheader.SalesOrderID
		JOIN shipmethod
			ON shipmethod.ShipMethodID = salesorderheader.ShipMethodID
		GROUP BY anio, shipmethod.Name
        ORDER BY anio, shipmethod.Name) AS subconsulta
ORDER BY cantxAnio DESC;


-- 2. Obtener un listado por categoría de productos, con el valor total de ventas y productos
-- vendidos, mostrando para ambos, su porcentaje respecto del total.

/*
1. 	CAMPOS A MOSTRAR
	categoria							-->
    TotalVentaXCategoria				-->
    % TotalVentaXCategoria				-->
    TotalVentaProductosXCategoria		-->
    % TotalVentaProductosXCategoria		-->

    
2. 	ANALISIS DE QUE DEBO USAR Y DEPENDENCIAS
	* Categoria												--> pk
    TotalVentaProducto										--> depende de (ValorVentaProducto - pk)
    * TotalVentaXCategoria									--> depende de (TotalVentaProducto) (Producto) (Categoria)
    * % (TotalVentaXCategoria) respecto a TotalVentas		--> depende de (TotalVentaProducto) (TotalVentaCategoria)
    TotalProductosVendidos									--> depende de (CantProdVendidos - pk)
    * TotalVentaProductosXCategoria							--> depende de (TotalProductosVendidos) (Producto) (Categoria)
    * % (TotalVentaProductosXCategoria) respecto a TotalVentaProductos	--> depende de (TotalProductosVendidos) (TotalVentaProductosXCategoria)
*/

SELECT
	Categoria,
    TotalVenta,
    ROUND(TotalVenta / SUM(TotalVenta) OVER () * 100, 2) AS PorcentajeVentas,
	ProdVendidos,
    ROUND(ProdVendidos / SUM(ProdVendidos) OVER () * 100, 2) AS PorcentajeCant
FROM (
	SELECT
		pdc.Name AS Categoria,
		SUM(sod.OrderQty) AS ProdVendidos,
        SUM(sod.LineTotal) AS TotalVenta
	FROM salesorderheader AS soh
	JOIN salesorderdetail AS sod
		ON sod.SalesOrderID = soh.SalesOrderID
	JOIN product AS pd
		ON pd.ProductID = sod.ProductID
	JOIN productsubcategory AS pds
		ON pds.ProductSubcategoryID = pd.ProductSubcategoryID
	JOIN productcategory AS pdc
		ON pdc.ProductCategoryID = pds.ProductCategoryID
	GROUP BY Categoria
	ORDER BY Categoria) AS t
GROUP BY Categoria
ORDER BY PorcentajeVentas DESC;

SELECT * FROM salesorderheader limit 10;
SELECT * FROM salesorderdetail limit 10;
SELECT * FROM product limit 10;
SELECT * FROM productcategory limit 10;
SELECT * FROM productsubcategory limit 10;
		

-- 3. Obtener un listado por país (según la dirección de envío), con el valor total de ventas y productos
-- vendidos, mostrando para ambos, su porcentaje respecto del total.

use adventureworks;

select distinct
	pais,
    sum(cantProductos) over (partition by pais) as cantProdPais,
    sum(totalVentas) over (partition by pais) as totalVentasPais
from (
	select
		cr.Name as pais,
		sod.OrderQty as cantProductos,
		soh.SubTotal as totalVentas
	from
		salesorderheader as soh
		join salesorderdetail as sod
			on sod.SalesOrderID = soh.SalesOrderID
		join address as ad
			on ad.addressID = soh.ShipToAddressID
		join StateProvince as stp
			on stp.StateProvinceID = ad.StateProvinceID
		join countryregion as cr
			on cr.CountryRegionCode = stp.CountryRegionCode) as t;

select
	pais,
    cantProductos,
    round(cantProductos / (sum(cantProductos) over ()) * 100, 2) as percentProd,
    totalVentas,
    round(totalVentas / (sum(totalVentas) over ()) *100, 2) as percentVentas
from (
	select
		cr.Name as pais,
		sum(sod.OrderQty) as cantProductos,
		sum(soh.SubTotal) as totalVentas
	from
		salesorderheader as soh
		join salesorderdetail as sod
			on sod.SalesOrderID = soh.SalesOrderID
		join address as ad
			on ad.addressID = soh.ShipToAddressID
		join StateProvince as stp
			on stp.StateProvinceID = ad.StateProvinceID
		join countryregion as cr
			on cr.CountryRegionCode = stp.CountryRegionCode
	group by pais
    order by pais) as t;

use adventureworks;


-- 4. Obtener por ProductID, los valores correspondientes a la mediana de las ventas (LineTotal),
-- sobre las ordenes realizadas. Investigar las funciones FLOOR() y CEILING().

SELECT
	ProductID,
	AVG(LineTotal) AS Mediana_Producto,
	Cnt
FROM (
	SELECT
		d.ProductID,
		d.LineTotal, 
		COUNT(*) OVER (PARTITION BY d.ProductID) AS Cnt,
		ROW_NUMBER() OVER (PARTITION BY d.ProductID ORDER BY d.LineTotal) AS RowNum
	FROM salesorderheader h
	JOIN salesorderdetail d
		ON (h.SalesOrderID = d.SalesOrderID)) v
WHERE (FLOOR(Cnt/2) = CEILING(Cnt/2) AND (RowNum = FLOOR(Cnt/2) OR RowNum = FLOOR(Cnt/2) + 1))
    OR (FLOOR(Cnt/2) <> CEILING(Cnt/2) AND RowNum = CEILING(Cnt/2))
GROUP BY ProductID;
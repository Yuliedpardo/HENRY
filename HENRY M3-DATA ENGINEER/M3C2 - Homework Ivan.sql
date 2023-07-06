/* Tablas a usar: 
- salesorderheader
- salesorderdetail
- contact
- product
- productsubcategory
- shipmethod
*/

-- 1. Obtener un listado contactos que hayan ordenado productos de la subcategoría "Mountain Bikes",
-- entre los años 2000 y 2003, cuyo método de envío sea "CARGO TRANSPORT 5".

select
	ordenes1.ContactID, concat(contacto.Title, " ", contacto.FirstName, " ",
    contacto.MiddleName, " ", contacto.LastName) as nombre,
    subcategoria.Name as subcategoria,
    year(ordenes1.OrderDate) as anio,
    envio.Name as metodo_envio
from
	salesorderheader ordenes1								-- contiene datos ContactID
join
	salesorderdetail ordenes2								-- contiene los ID de los productos de cada oden: ProductID
on
	(ordenes1.SalesOrderID = ordenes2.SalesOrderID)
join
	product producto										-- contiene ID subcategoria: ProductSubcategoryID
on
	(ordenes2.ProductID = producto.ProductID)
join
	productsubcategory subcategoria							-- contiene descripcion de ID subcategoria: Name
on
	(producto.ProductSubcategoryID = subcategoria.ProductSubcategoryID)
join
	contact contacto										-- contiene los nombres de los contactos: Title, FirstName, MiddleName, LastName
on
	(ordenes1.ContactID = contacto.ContactID)
join
	shipmethod envio										-- contiene los nombres de los metodos de envio = Name
on
	(ordenes1.ShipMethodID = envio.ShipMethodID)
where
	subcategoria.Name = "Mountain Bikes" and
    year(ordenes1.OrderDate) between 2000 and 2003 and
    envio.Name = "CARGO TRANSPORT 5"
group by
	ordenes1.ContactID, nombre, subcategoria, anio, metodo_envio
order by
	ordenes1.ContactID;

    

select * from salesorderheader limit 10;
select * from salesorderdetail limit 10;
select * from product limit 10;
select * from productsubcategory limit 10;
select * from contact limit 10;
select * from shipmethod limit 10;
select * from productsubcategory limit 10;




-- 2. Obtener un listado contactos que hayan ordenado productos de la subcategoría "Mountain Bikes",
-- entre los años 2000 y 2003 con la cantidad de productos adquiridos y ordenado por este valor, de forma descendente.

select
	ordenes1.ContactID,
    concat(contacto.Title, " ", contacto.FirstName, " ", contacto.MiddleName, " ", contacto.LastName) as nombre,
    subcategoria.Name as subcategoria,
    year(ordenes1.OrderDate) as anio,
    sum(ordenes2.OrderQty) as cantidad
from
	salesorderheader ordenes1
join
	salesorderdetail ordenes2								-- contiene los ID de los productos de cada oden: ProductID
on
	(ordenes1.SalesOrderID = ordenes2.SalesOrderID)
join
	product producto										-- contiene ID subcategoria: ProductSubcategoryID
on
	(ordenes2.ProductID = producto.ProductID)
join
	productsubcategory subcategoria							-- contiene descripcion de ID subcategoria: Name
on
	(producto.ProductSubcategoryID = subcategoria.ProductSubcategoryID)
join
	contact contacto										-- contiene los nombres de los contactos: Title, FirstName, MiddleName, LastName
on
	(ordenes1.ContactID = contacto.ContactID)
where
	subcategoria.Name = "Mountain Bikes" and
    year(ordenes1.OrderDate) between 2000 and 2003
group by
	ordenes1.ContactID, nombre, subcategoria, anio
order by
	cantidad desc;


-- 3. Obtener un listado de cual fue el volumen de compra (cantidad) por año y método de envío.
-- volumen = cantidad de articulos

select
	year(ordenes1.OrderDate) as anio,
    envios.Name as metodo_envio,
    sum(ordenes2.OrderQty) as volumen_compra
from
	salesorderheader ordenes1
join
	salesorderdetail ordenes2
on
	(ordenes1.SalesOrderID = ordenes2.SalesOrderID)
join
	shipmethod envios
on
	(ordenes1.ShipMethodID = envios.ShipMethodID)
group by
	anio,
    envios.Name
order by
	anio;
    
select * from salesorderheader limit 10;
select * from salesorderdetail limit 10;
select * from shipmethod limit 10;


-- 4. Obtener un listado por categoría de productos, con el valor total de ventas y productos vendidos.

-- salesorderheader.SubTotal = subtotal de la orden de venta (antes de impuestos y fletes)

select
	categorias.Name as categorias,
    sum(ventas2.OrderQty) as total_unidades,
    sum(ventas1.SubTotal) as valor_total
from
	salesorderheader ventas1
join
	salesorderdetail ventas2
on
	ventas1.SalesOrderID = ventas2.SalesOrderID
join
	product producto
on
	ventas2.ProductID = producto.ProductID
join
	productsubcategory subcategorias
on
	producto.ProductSubcategoryID = subcategorias.ProductSubcategoryID
join
	productcategory categorias
on
	subcategorias.ProductCategoryID = categorias.ProductCategoryID
group by
	categorias;


select * from salesorderheader limit 10;
select * from salesorderdetail limit 10;
select * from productcategory limit 10;
select * from productsubcategory limit 10;
select * from product limit 10;

show columns from productcategory;
show columns from product;


-- 5. Obtener un listado por país (según la dirección de envío), con el valor total de ventas y productos vendidos,
-- sólo para aquellos países donde se enviaron más de 15 mil productos.

select
	countryregion.name as pais,
    sum(salesorderdetail.OrderQty) as total_cant_prods,
    sum(salesorderheader.TotalDue) as total_ventas
from
	salesorderheader
join
	address
on
	salesorderheader.ShipToAddressID = address.AddressID
join
	salesorderdetail
on
	salesorderheader.SalesOrderID = salesorderdetail.SalesOrderID
join
	stateprovince
on
	address.StateProvinceID = stateprovince.StateProvinceID
join
    countryregion
on
	stateprovince.CountryRegionCode = countryregion.CountryRegionCode
group by
	pais
having
	total_cant_prods >= 15000
order by
	total_cant_prods desc;

select * from salesorderheader limit 10;			-- ShipToAddressID, 
select * from address limit 10;						-- StateProvinceID
select * from stateprovince limit 10;				-- CountryRegionCode
select * from countryregion limit 10;				-- Name
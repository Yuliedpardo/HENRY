-- Crear un procedimiento que recibe como parametro una fecha y
-- muestre la cantidad de ordenes ingresadas en esa fecha.

use adventureworks;

SELECT *
FROM salesorderheader;

DELIMITER $$
CREATE PROCEDURE CantidadOrdenes(fecha DATE)
BEGIN
	SELECT count(*)
	FROM salesorderheader
	WHERE DATE(OrderDate) like fecha;
END $$
DELIMITER ;

CALL CantidadOrdenes("2001-07-30");

-- Crear una función que calcule el valor nominal de un margen bruto determinado por el
-- usuario a partir del precio de lista de los productos.

set global log_bin_trust_function_creators = 1;

delimiter $$
create function margenBrutoNominal(precio decimal(15,3), margen decimal(9,2)) returns decimal(15,3)
begin
	declare margenBruto decimal (15,3);
    set margenBruto = precio * margen;
    return margenBruto;
end $$
delimiter ;

Select margenBrutoNominal(100.50, 1.2);

-- Obtener un listado de productos en orden alfabético que muestre cuál debería ser el valor
-- de precio de lista, si se quiere aplicar un margen bruto del 20%, utilizando la función
-- creada en el punto 2, sobre el campo StandardCost. Mostrando tambien el campo ListPrice
-- y la diferencia con el nuevo campo creado.

select 	Name,
		StandardCost,
        margenBrutoNominal(StandardCost, 0.2) as Margen,				# el margen es del 20%
        margenBrutoNominal(StandardCost, 1.2) as Nuevo_Valor,			# es necesario aplicarle el 120% para que le incremente el valor del 20%
        ListPrice,
        ListPrice - margenBrutoNominal(StandardCost, 1.2) as Diferencia
from product
order by Name;

-- Crear un procedimiento que reciba como parámetro una fecha desde y una hasta, y muestre
-- un listado con los Id de los diez Clientes que más costo de transporte tienen entre esas fechas (campo Freight).

drop procedure clientesMasCostosos;

delimiter $$
create procedure clientesMasCostosos(in desde DATE, in hasta DATE)
begin
	select CustomerID, sum(Freight) as Total_Transporte 
    from salesorderheader
    where OrderDate between desde and hasta 
    group by CustomerID
    order by Total_Transporte desc
    limit 10;
end $$
delimiter ;

call clientesMasCostosos('2002-01-01','2002-01-31');
call clientesMasCostosos('2002-01-01','2004-01-31');

-- Crear un procedimiento que permita realizar la inserción de datos en la tabla shipmethod.

describe shipmethod;

delimiter $$
create procedure insertarShipmethod(Nombre varchar(50), Base double, Rate double)
begin
	insert into shipmethod (Name, ShipBase, ShipRate, ModifiedDate)
	values (Nombre, Base, Rate, NOW());
end $$
delimiter ;

CALL insertarShipmethod('Prueba', 1.5, 3.5);

SELECT * FROM shipmethod;







use ejemplom3;

delimiter &&
create procedure VentasDia (in FechaDia date)
begin
select p.Concepto from productos p join venta v 
on p.IdProducto=v.IdProducto
where Fecha=FechaDia;
end&&
delimiter ;

call VentasDia('2018-03-09');

SET GLOBAL log_bin_trust_function_creators = 1;

delimiter &&
create function ValorNominal (precio decimal(15,3), margen decimal(12,2)) returns decimal(15,2)
begin
declare ValorNominal decimal(15,2);
set ValorNominal= precio*margen;
return ValorNominal;
end&&

delimiter ;

select Concepto, ValorNominal(Precio, 0.2) from productos 
where Tipo='impresión';
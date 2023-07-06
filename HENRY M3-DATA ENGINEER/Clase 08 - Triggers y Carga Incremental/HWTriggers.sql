use ejemplom3;

create table neoreg_fact_venta (
Fecha date, 
Fecha_Entrega date,
IdCanal int ,
IdCliente int ,
IdEmpleado int ,
IdProducto int,
usuario varchar(20),
FechaModificacion datetime
); 

create trigger fact_venta_actualizacion after insert on fact_venta
for each row 
insert into neoreg_fact_venta values (new.Fecha, new.Fecha_Entrega, new.IdCanal, new.IdCliente, new.IdEmpleado, new.IdProducto, current_user(), now());

create table total_fventas ( 
Id int auto_increment,
Fecha datetime,
Total_fact_ventas int,
usuario varchar(20),
primary key (Id)
);

create trigger fact_venta_total after insert on fact_venta
for each row 
insert into total_fventas (Fecha, Total_fact_ventas, usuario) values (now(), (select count(*) from fact_venta), current_user());

CREATE TABLE registros_tablas (
Id INT NOT NULL AUTO_INCREMENT,
Tabla VARCHAR(30),
Fecha DATETIME,
CantidadRegistros INT,
PRIMARY KEY (id)
);

insert into registros_tablas(Tabla, Fecha, CantidadRegistros) values ('venta', now(), (select count(*) from venta));

create table actualizacion_fventas(
Fecha date,
IdCliente int,
IdProducto int,
Cantidad int,
Precio float
);

create trigger actualizacion after update on fact_venta
for each row
insert into actualizacion_fventas values (old.Fecha, old.IdCliente, old.IdProducto, old.Cantidad, old.Precio);




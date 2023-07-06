use ejemplom3;

alter table empleados add column IdCargo int;

update empleados p join cargo tp
on (p.Cargo=tp.Cargo)
set p.IdCargo=tp.IdCargo;
alter table empleados
drop Cargo;

alter table cargo convert to character set utf8mb4 collate utf8mb4_spanish_ci;
select * from empleados;

create index localidad on clientes (IdLocalidad);
create index fecha on compras(Fecha);
create index fecha on gastos(Fecha);
create index provincia on localidad(IdProvincia);
create index localidad on proveedores(IdLocalidad);
create index localidad on sucursales(IdLocalidad);
create index fechaventa on venta(Fecha);
create index fechaentrega on venta(Fecha_Entrega);
create index tipop on productos(IdTipo_Producto);
create index sector on empleados(IdSector);
create index cargo on empleados(IdCargo);

alter table venta add foreign key (IdCanal) references canalventa(IdCanal);
alter table venta add foreign key (IdCliente) references clientes(IdCliente);
alter table venta add foreign key (IdSucursal) references sucursales(IdSucursal);
alter table venta add foreign key (IdEmpleado) references empleados(IdEmpleado);
alter table venta add foreign key (IdProducto) references productos(IdProducto);

alter table sucursales add foreign key (IdLocalidad) references localidad(IdLocalidad);

alter table proveedores add foreign key (IdLocalidad) references localidad(IdLocalidad);

alter table productos add foreign key (IdTipo_Producto) references tipo_producto(IdTipo_Producto);

alter table localidad add foreign key (IdProvincia) references provincia(IdProvincia);

alter table gastos add foreign key (IdSucursal) references sucursales(IdSucursal);
alter table gastos add foreign key (IdTipoGasto) references tipo_gastos(IdTipoGasto);

alter table empleados add foreign key (IdSucursal) references sucursales(IdSucursal);
alter table empleados add foreign key (IdSector) references sector(IdSector);
alter table empleados add foreign key (IdCargo) references cargo(IdCargo);

alter table compras add foreign key (IdProducto) references productos(IdProducto);
alter table compras add foreign key (IdProveedor) references proveedores(IdProveedor);

alter table clientes add foreign key (IdLocalidad) references localidad(IdLocalidad);

drop table fact_venta;
create table fact_venta (
IdVenta int auto_increment,
Fecha date,
Fecha_Entrega date,
IdCanal int,
IdCliente int,
IdEmpleado int,
IdProducto int,
Precio float,
Cantidad int,
primary key(IdVenta)
) engine=InnoDB DEFAULT CHARSET= utf8mb4 collate=utf8mb4_spanish_ci;

insert into fact_venta 
select IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad from venta;

select * from fact_venta;

ALTER TABLE `fact_venta` ADD INDEX(`IdProducto`);
ALTER TABLE `fact_venta` ADD INDEX(`IdEmpleado`);
ALTER TABLE `fact_venta` ADD INDEX(`Fecha`);
ALTER TABLE `fact_venta` ADD INDEX(`Fecha_Entrega`);
ALTER TABLE `fact_venta` ADD INDEX(`IdCliente`);
ALTER TABLE `fact_venta` ADD INDEX(`IdCanal`);

CREATE TABLE IF NOT EXISTS dim_cliente (
	IdCliente			INTEGER,
	Nombre_y_Apellido	VARCHAR(80),
	Domicilio			VARCHAR(150),
	Telefono			VARCHAR(30),
	Rango_Etario		VARCHAR(20),
	IdLocalidad			INTEGER,
	Latitud				float,
	Longitud			float,
    primary key (IdCliente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO dim_cliente
SELECT IdCliente, NomApe, Domicilio, Telefono, Rango_Edad, IdLocalidad, Latitud, Longitud
FROM clientes
WHERE IdCliente IN (SELECT distinct IdCliente FROM fact_venta);
drop table dim_producto;
CREATE TABLE IF NOT EXISTS dim_producto (
	IdProducto					INTEGER,
	Producto					VARCHAR(100),
	IdTipoProducto				VARCHAR(50),
    primary key (IdProducto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO dim_producto
SELECT IdProducto, Concepto, IdTipo_Producto
FROM productos
WHERE IdProducto IN (SELECT distinct IdProducto FROM fact_venta);







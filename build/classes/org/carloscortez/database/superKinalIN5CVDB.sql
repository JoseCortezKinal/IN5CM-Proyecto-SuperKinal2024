 drop database if exists superkinalIN5CVDB;

create database if not exists superkinalIN5CVDB;

use superkinalIN5CVDB;

create table Clientes(
	clienteId int not null auto_increment,
    nombre varchar(30) not null,
    apellido varchar(30) not null,
    telefono varchar(15),
    direccion varchar(150) not null,
    nit varchar(15) default 'CF',
    primary key PK_clienteId(clienteId)
);

create table Distribuidores(
    distribuidorId int not null auto_increment,
    nombreDistribuidor varchar(30) not null,
    direccionDistribuidor varchar(200) not null,
    nitDistribuidor varchar(15) not null,
    telefonoDistribuidor varchar(15) not null,
    web varchar(50),
    primary key PK_distribuidorId(distribuidorId)
);

create table CategoriaProductos(
    categoriaProductosId int not null auto_increment,
    nombreCategoria varchar(30) not null,
    descripcionCategoria varchar(100) not null,
    primary key PK_categoriaProductosId(categoriaProductosId)
);

create table Productos(
    productoId int not null auto_increment,
    nombreProducto varchar(50) not null,
    descripcionProducto varchar (100),
    cantidadStock int not null,
    precioUnitario decimal(10,2) not null,
    precioMayor decimal(10,2) not null,
    imagenProducto varchar(50),
    distribuidorId int not null,
    categoriaProductosId int not null,
    primary key PK_productoId(productoId),
    constraint FK_Productos_Distribuidores foreign key Productos(distribuidorId)
        references Distribuidores(DistribuidorId),
	constraint FK_Productos_CategoriaProductos foreign key Productos(categoriaProductosId)
        references CategoriaProductos(categoriaProductosId)
);

create table Cargos(
    cargoId int not null auto_increment,
    nombreCargo varchar(30) not null,
    descripcionCargo varchar(100) not null,
    primary key PK_cargoId(cargoId)
);

create table Empleados(
    empleadoId int not null auto_increment,
    nombreEmpleado varchar(30) not null,
    apellidoEmpleado varchar(30) not null,
    sueldo decimal(10,2) not null,
    horaEntrada time not null,
    horaSalida time not null,
    cargoId int not null,
    encargadoId int,
    primary key PK_empleadoId(empleadoId),
    constraint FK_Empleados_Cargos foreign key Empleados(cargoId)
        references Cargos(cargoId),
    constraint FK_encargadoId foreign key Empleados(encargadoId)
        references Empleados(empleadoId)
);

create table Facturas(
    facturaId int not null auto_increment,
    fecha date not null,
    hora time not null,
    clienteId int not null,
    empleadoId int not null,
    total decimal(10,2),
    primary key PK_facturaId(facturaId),
    constraint FK_Facturas_Clientes foreign key Facturas(clienteId)
        references Clientes(clienteId),
    constraint FK_Facturas_Empleados foreign key Facturas(empleadoId)
        references Empleados(empleadoId)
);

create table DetalleFactura(
    detalleFacturaId int not null auto_increment,
    facturaId int not null,
    productoId int not null,
    primary key PK_detalleFacturaId(detalleFacturaId),
    constraint FK_DetalleFactura_Facturas foreign key DetalleFactura(facturaId)
        references Facturas(facturaId),
    constraint FK_DetalleFactura_Productos foreign key DetalleFactura(productoId)
        references Productos(productoId)
);

create table Compras(
	compraId int not null auto_increment,
    fechaCompra date not null,
    totalCompra decimal (10,2),
    primary key PK_compraId(compraId)
);

create table DetalleCompra(
	detalleCompraId int not null auto_increment,
    cantidadCompra int not null,
    productoId int not null,
    compraId int not null,
    primary key PK_detalleCompraId(detalleCompraId),
    constraint FK_DetalleCompra_Productos foreign key DetalleCompra(productoId)
        references Productos(productoId),
	constraint FK_DetalleCompra_Compras foreign key DetalleCompra(compraId)
		references Compras(compraId)
);
-- CRUD Cliente

select * from Clientes;

insert into Clientes(nombre, apellido, telefono, direccion) values
		('Diego', 'Barrascout', '1231-1321', 'Ciudad');
        
-- Agregar
DELIMITER $$	
create procedure sp_agregarCliente(nom varchar(30), ape varchar(30), tel varchar(15), dir varchar(150), nit varchar(15))
begin
	insert into Clientes(nombre, apellido, telefono, direccion, nit) values
		(nom, ape, tel, dir, nit);
end $$
DELIMITER ;

call sp_agregarCliente('Luis', 'Hernandez', '1313-1313', 'Ciudad', '1525215-6');
-- Listar
DELIMITER $$
create procedure sp_listarclientes()
begin
	select * from clientes;
end $$
DELIMITER ;

-- Eliminar
DELIMITER $$
create procedure sp_eliminarCliente(cliId int)
begin
	delete from Clientes
		where clienteId = cliId;
end $$
DELIMITER ;

-- Buscar
DELIMITER $$
create procedure sp_buscarCliente(cliId int)
begin
	select * from Clientes
		where clienteId = cliId;
end $$
DELIMITER ;

-- Editar
DELIMITER $$
create procedure sp_editarCliente(cliId int, nom varchar(30), ape varchar(30), tel varchar(15), dir varchar(150), nt varchar(15))
begin
	update Clientes set
		nombre = nom,
        apellido = ape,
        telefono = tel,
        direccion = dir,
        nit = nt
			where clienteId = cliId;
end $$
DELIMITER ;
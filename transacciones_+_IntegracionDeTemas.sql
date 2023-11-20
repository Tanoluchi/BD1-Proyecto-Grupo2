/*----------------------------------------
SCRIPT APLICADO A LAS PRUEBAS PRACTICAS SOBRE TRANSACCIONES
BASE DE DATOS 1 - COMISION 3
GRUPO 2
----------------------------------------*/
-- USE base_consorcio;

-- CREACION DE LAS TRANSACCIONES
BEGIN TRY -- INICIAMOS EL BEGIN TRY PARA LUEGO COLOCAR LA LOGICA DENTRO Y ASEGURARNOS DE QUE SI ALGO FALLA IRA POR EL CATCH
	BEGIN TRAN -- COMENZAMOS LA TRANSACCION
	INSERT INTO administrador(apeynom, viveahi, tel, sexo, fechnac) -- UN INSERT A LA TABLA QUE QUEREMOS
	VALUES ('pablito', 'S', '37942222', 'M', '01/01/1996') -- LOS VALORES A INGRESAR A LA TABLA

	INSERT INTO consorcio(idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
	VALUES (999, 1, 1, 'EDIFICIO-111', 'PARAGUAY N 999', 5, 100, 1) -- GENERAMOS UN ERROR INGRESANDO EL ID PROVINCIA 999 QUE NO EXISTE.
	
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',5,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',2,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',3,608.97)

	COMMIT TRAN -- SI TODO FUE EXITOSO FINALIZAMOS LA TRANSACCION
END TRY
BEGIN CATCH -- SI ALGO FALLA VENDRA AQUI
	SELECT ERROR_MESSAGE() -- MOSTRAMOS EL MENSAJE DE ERROR
	ROLLBACK TRAN -- VOLVEMOS HACIA ATRAS PARA MANTENER LA CONSISTENCIA DE LOS DATOS
END CATCH

-----------------------------------------------

--- CASO Transacción Terminada 
-- USE base_consorcio;

-- CREACION DE TRANSACCIONES
BEGIN TRY -- INICIAMOS EL BEGIN TRY PARA LUEGO COLOCAR LA LOGICA DENTRO Y ASEGURARNOS DE QUE SI ALGO FALLA IRA POR EL CATCH
	BEGIN TRAN -- COMENZAMOS LA TRANSACCION
	INSERT INTO administrador(apeynom, viveahi, tel, sexo, fechnac) -- UN INSERT A LA TABLA QUE QUEREMOS
	VALUES ('pablito', 'S', '37942222', 'M', '01/01/1996') -- LOS VALORES A INGRESAR A LA TABLA

	INSERT INTO consorcio(idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
	VALUES (1, 1, 3, 'EDIFICIO-111', 'PARAGUAY N 999', 5, 100, 1) -- AHORA INGRESAMOS EL CONSORCIO SIN INTENCION DE ERROR.
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',5,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',2,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',3,608.97)

	COMMIT TRAN -- SI TODO FUE EXITOSO FINALIZAMOS LA TRANSACCION
END TRY
BEGIN CATCH -- SI ALGO FALLA VENDRA AQUI
	SELECT ERROR_MESSAGE() -- MOSTRAMOS EL MENSAJE DE ERROR
	ROLLBACK TRAN -- VOLVEMOS HACIA ATRAS PARA MANTENER LA CONSISTENCIA DE LOS DATOS
END CATCH

-- LAS SIGUIENTES CONSULTAS VERIFICAN LOS RESULTADOS DE LAS PRUEBAS SOBRE TRANSACCIONES PLANAS 
-----------------------------------------------
 -- NOS MUESTRA CUAL FUE EL ULTIMO REGISTRO DE ADMINISTRADOR CARGADO
SELECT TOP 1 * FROM administrador ORDER BY idadmin DESC; 

 -- MUESTRA LOS DATOS DEL CONSORCIO CON LA DIRECCION EN CUESTION (EXITE O NO)
SELECT * FROM consorcio WHERE direccion = 'PARAGUAY N 999';

-- MUESTRA LOS ULTIMOS 3 REGISTROS DE GASTOS CARGADOS
SELECT TOP 3 * FROM gasto ORDER BY idgasto DESC; 
-----------------------------------------------


-----------------------------------------------
--- CASO Transacción Anidada fallida
-- USE base_consorcio;

-- CREACION DE TRANSACCIONES
BEGIN TRY -- INICIAMOS EL BEGIN TRY PARA LUEGO COLOCAR LA LOGICA DENTRO Y ASEGURARNOS DE QUE SI ALGO FALLA IRA POR EL CATCH
	BEGIN TRAN -- COMENZAMOS LA TRANSACCION
	INSERT INTO administrador(apeynom, viveahi, tel, sexo, fechnac) -- UN INSERT A LA TABLA QUE QUEREMOS
	VALUES ('pablito clavounclavito', 'S', '37942222', 'M', '01/01/1996') -- LOS VALORES A INGRESAR A LA TABLA

	INSERT INTO consorcio(idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
	VALUES (1, 1, 3, 'EDIFICIO-111', 'PARAGUAY N 999', 5, 100, 1) -- GENERAMOS UN ERROR INGRESANDO EL ID PROVINCIA 999 QUE NO EXISTE.

	-------------------------
	BEGIN TRAN -- COMENZAMOS UNA TRANSACCION ANIDADA
		UPDATE consorcio SET nombre = 'EDIFICIO-222'; -- ACTUALIZAMOS EL REGISTRO DE CONSORCIO QUE CARGAMOS ANTES
		INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) 
			VALUES (1,1,1,6,'20130616',20,608.97) -- INSERT A LA TABLA GASTO, DEBE DAR UN ERROR POR TIPO DE GASTO
	COMMIT TRAN -- FINALIZAMOS UNA TRANSACCION ANIDADA
	------------------------

	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',5,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',2,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',3,608.97)

	COMMIT TRAN -- SI TODO FUE EXITOSO FINALIZAMOS LA TRANSACCION
END TRY
BEGIN CATCH -- SI ALGO FALLA VENDRA AQUI
	SELECT ERROR_MESSAGE() -- MOSTRAMOS EL MENSAJE DE ERROR
	ROLLBACK TRAN -- VOLVEMOS HACIA ATRAS PARA MANTENER LA CONSISTENCIA DE LOS DATOS
END CATCH




-----------------------------------------------
--- CASO Transacción Anidada 
-- USE base_consorcio;

-- CREACION DE TRANSACCIONES
BEGIN TRY -- INICIAMOS EL BEGIN TRY PARA LUEGO COLOCAR LA LOGICA DENTRO Y ASEGURARNOS DE QUE SI ALGO FALLA IRA POR EL CATCH
	BEGIN TRAN -- COMENZAMOS LA TRANSACCION
	INSERT INTO administrador(apeynom, viveahi, tel, sexo, fechnac) -- UN INSERT A LA TABLA QUE QUEREMOS
	VALUES ('pablito clavounclavito', 'S', '37942222', 'M', '01/01/1996') -- LOS VALORES A INGRESAR A LA TABLA

	INSERT INTO consorcio(idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
	VALUES (1, 1, 3, 'EDIFICIO-111', 'PARAGUAY N 999', 5, 100, 1) -- GENERAMOS UN ERROR INGRESANDO EL ID PROVINCIA 999 QUE NO EXISTE.

	-------------------------
	BEGIN TRAN -- COMENZAMOS UNA TRANSACCION ANIDADA
		UPDATE consorcio SET nombre = 'EDIFICIO-222'; -- ACTUALIZAMOS EL REGISTRO DE CONSORCIO QUE CARGAMOS ANTES
		INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) 
			VALUES (1,1,1,6,'20130616',5,608.97) -- INSERT A LA TABLA GASTO, DEBE DAR UN ERROR POR TIPO DE GASTO
	COMMIT TRAN -- FINALIZAMOS UNA TRANSACCION ANIDADA
	------------------------

	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',5,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',2,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',3,608.97)

	COMMIT TRAN -- SI TODO FUE EXITOSO FINALIZAMOS LA TRANSACCION
END TRY
BEGIN CATCH -- SI ALGO FALLA VENDRA AQUI
	SELECT ERROR_MESSAGE() -- MOSTRAMOS EL MENSAJE DE ERROR
	ROLLBACK TRAN -- VOLVEMOS HACIA ATRAS PARA MANTENER LA CONSISTENCIA DE LOS DATOS
END CATCH

-----------------------------------------------
-----------------------------------------------
-- LAS SIGUIENTES CONSULTAS VERIFICAN LOS RESULTADOS DE LAS PRUEBAS SOBRE TRANSACCIONES ANIDADAS 
-----------------------------------------------
 -- NOS MUESTAR CUAL FUE EL ULTIMO REGISTRO DE ADMINISTRADOR CARGADO
SELECT TOP 1 * FROM administrador ORDER BY idadmin DESC; 

 -- MUESTRA LOS DATOS DEL CONSORCIO CON LA DIRECCION EN CUESTION (EXITE O NO)
SELECT * FROM consorcio WHERE direccion = 'PARAGUAY N 999';

-- MUESTAR LOS ULTIMOS 3 REGISTROS DE GASTOS CARGADOS
SELECT TOP 4 * FROM gasto ORDER BY idgasto DESC; 
-----------------------------------------------



----------------------------------------------- Implementacion de Backup y restore. Backup en línea. -----------------------------------------------
-- 1 Verificar el modo de recuperacion de la base de datos
use base_consorcio

SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'base_consorcio';


-- 2 cambiamos el modo de recuperacion

USE master; -- Asegúrate de estar en el contexto de la base de datos master
ALTER DATABASE base_consorcio
SET RECOVERY FULL;

-- 3 Realizamos backup de la base de datos

BACKUP DATABASE base_consorcio
TO DISK = 'C:\backup\consorcio_backup.bak'
WITH FORMAT, INIT;

-- Agregamos 10 registros

select * from gasto;

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (1,1,1,5,GETDATE(),5,1200);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (1,2,2,5,GETDATE(),2,1630);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (3,20,2,2,GETDATE(),4,500);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (5,3,1,3,GETDATE(),3,1520);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (5,12,3,4,GETDATE(),5,1120);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (6,45,2,4,GETDATE(),4,2000);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (14,36,2,2,GETDATE(),1,1740);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (18,3,1,2,GETDATE(),2,1520);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (2,48,1,5,GETDATE(),2,1500);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (13,10,2,1,GETDATE(),1,1420);


-- 4 Realizamos backup del log de la base de datos

BACKUP LOG base_consorcio
TO DISK = 'C:\backup\LogBackup.trn'
WITH FORMAT, INIT;


-- Insertamos 10 registros mas

select * from gasto

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (1,1,1,5,GETDATE(),5,1200);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (2,48,1,5,GETDATE(),2,1500);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (3,16,1,2,GETDATE(),4,2300);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (4,21,1,3,GETDATE(),3,1000);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (5,3,1,2,GETDATE(),5,1500);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (6,45,2,4,GETDATE(),4,2000);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (8,17,2,2,GETDATE(),1,1300);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (9,14,1,3,GETDATE(),2,1700);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (12,7,4,2,GETDATE(),3,2100);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (13,10,2,1,GETDATE(),1,1100);


--5 Realizamos backup del log en otra ubicacion

BACKUP LOG base_consorcio
TO DISK = 'C:\backup\logs\LogBackup2.trn'
WITH FORMAT, INIT;

--6 Restauramos el backup de la base de datos

use master

RESTORE DATABASE base_consorcio
FROM DISK = 'C:\backup\consorcio_backup.bak'
WITH REPLACE, NORECOVERY;

RESTORE LOG base_consorcio
FROM DISK = 'C:\backup\LogBackup.trn'
WITH RECOVERY;

-- Segundo log

RESTORE LOG base_consorcio
FROM DISK = 'C:\backup\logs\LogBackup2.trn'
WITH RECOVERY;

select * from gasto





----------------------------------------------- Implementacion de Índices columnares en SQL server -----------------------------------------------
--- Creacion de la tabla.
Create table gastoNew	(
						idgastoNew int identity,
						idprovincia int,
                         idlocalidad int,
                         idconsorcio int, 
					     periodo int,
					     fechapago datetime,					     
						 idtipogasto int,
						 importe decimal (8,2),	
					     Constraint PK_gastoNew PRIMARY KEY (idgastoNew),
						 Constraint FK_gastoNew_consorcio FOREIGN KEY (idprovincia,idlocalidad,idconsorcio)  REFERENCES consorcio(idprovincia,idlocalidad,idconsorcio),
						 Constraint FK_gastoNew_tipo FOREIGN KEY (idtipogasto)  REFERENCES tipogasto(idtipogasto)					     					     						 					     					     
							)
go


--select * from gasto;


--CARGA DE UN MILLON DE REGISTROS
--INSERCION POR LOTES

-- select * from gastoNew;

declare @tamanioLote int = 1000; -- Tamaño del lote
declare @cont int = 1;     -- Contador de lotes

-- Inicia un bucle para la inserción por lotes
while @cont <= 1000000 -- Cambia 1000 por el número de lotes necesarios para un millón de registros
begin
    insert into gastoNew (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
    select top (@tamanioLote) idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe
    from gasto
    where idgasto not in (select idgastoNew from gastoNew); -- Evita duplicados

    set @cont = @cont + 1;
end;



-- Declarar el tamaño del lote y el contador
DECLARE @BatchSize INT = 1000; -- Tamaño del lote
DECLARE @Counter INT = 1;     -- Contador de lotes

-- Iniciar un bucle para la inserción por lotes
WHILE @Counter <= 1000000 -- Cambia 1000 al número de lotes necesarios para un millón de registros
BEGIN
    -- Insertar registros desde gasto a gastoNew en lotes
    INSERT INTO gastoNew (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
    SELECT TOP (@BatchSize) idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe
    FROM gasto
    WHERE idgasto NOT IN (SELECT idgasto FROM gastoNew); -- Evitar duplicados

    SET @Counter = @Counter + 1;
END;

insert into gastoNew (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
select idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe
from gasto
order by idgasto
offset 0 rows
fetch next 1000000 rows only; -- Ajusta el tamaño del lote según tus necesidades




INSERT INTO gastoNew (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
SELECT idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe
FROM (
    SELECT idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe,
           ROW_NUMBER() OVER (ORDER BY idgasto) AS RowNumber
    FROM gasto
) AS Subquery
WHERE RowNumber BETWEEN 1 AND 1000000;






----------------------------------------------- Implementacion de Índices Optimización de consultas a través de índices. -----------------------------------------------


--PRIMER EJECUCION DE CONSULTA -----------------------------------------------------------------
--Permite ver detalle de los tiempos de ejecucionde la consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go;
--Consulta: Gastos del periodo 8 

SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8 ;
go;


--SEGUNDA EJECUCION DE CONSULTA ----------------------------------------------------------------------------

--SqlServer toma la PK de gasto como indice CLUSTERED, asique para crear el solicitado en periodo debemos primero eliminar el actual
ALTER TABLE gasto
DROP CONSTRAINT PK_gasto;
go;

--Transformamos la PK en un indice NONCLUSTERED
ALTER TABLE gasto
ADD CONSTRAINT PK_gasto PRIMARY KEY NONCLUSTERED (idGasto);
go;

--Creamos un nuevo indice CLUSTERED en periodo
CREATE CLUSTERED INDEX IX_gasto_periodo
ON gasto (periodo);
go;
--Permite ver detalle de los tiempos de ejecucionde la consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go;
--Consulta: Gastos del periodo 8 

SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8 ;
go;


--TERCER EJECUCION DE CONSULTA------------------------------------------------------------------
-- Elimina el índice agrupado anterior
DROP INDEX IX_gasto_periodo ON gasto;
go;

-- Crea un nuevo índice agrupado en periodo, fechapago e idtipogasto
CREATE CLUSTERED INDEX IX_Gasto_Periodo_FechaPago_idTipoGasto
ON gasto (periodo, fechapago, idtipogasto);
go;

--Permite ver detalle de los tiempos de ejecucionde la consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go;
--Consulta: Gastos del periodo 8 

SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8 ;
go;



----------------------------------------------- Implementacion de Vistas y vistas indexadas -----------------------------------------------









----------------------------------------------- Implementacion de Triggers de auditoría -----------------------------------------------

--PRIMER EJECUCION DE CONSULTA -----------------------------------------------------------------
--Permite ver detalle de los tiempos de ejecucionde la consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go;
--Consulta: Gastos del periodo 8 

SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8 ;
go;


--SEGUNDA EJECUCION DE CONSULTA ----------------------------------------------------------------------------

--SqlServer toma la PK de gasto como indice CLUSTERED, asique para crear el solicitado en periodo debemos primero eliminar el actual
ALTER TABLE gasto
DROP CONSTRAINT PK_gasto;
go;

--Transformamos la PK en un indice NONCLUSTERED
ALTER TABLE gasto
ADD CONSTRAINT PK_gasto PRIMARY KEY NONCLUSTERED (idGasto);
go;

--Creamos un nuevo indice CLUSTERED en periodo
CREATE CLUSTERED INDEX IX_gasto_periodo
ON gasto (periodo);
go;
--Permite ver detalle de los tiempos de ejecucionde la consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go;
--Consulta: Gastos del periodo 8 

SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8 ;
go;


--TERCER EJECUCION DE CONSULTA------------------------------------------------------------------
-- Elimina el índice agrupado anterior
DROP INDEX IX_gasto_periodo ON gasto;
go;

-- Crea un nuevo índice agrupado en periodo, fechapago e idtipogasto
CREATE CLUSTERED INDEX IX_Gasto_Periodo_FechaPago_idTipoGasto
ON gasto (periodo, fechapago, idtipogasto);
go;

--Permite ver detalle de los tiempos de ejecucionde la consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go;
--Consulta: Gastos del periodo 8 

SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8 ;
go;



----------------------------------------------- Implementacion de Manejo de permisos a nivel de usuarios de base de datos -----------------------------------------------

USE base_consorcio;

/*
Creamos usuarios de prubea
*/

CREATE LOGIN UsuarioAnalista WITH PASSWORD = 'ContrasenaAnalista';
CREATE LOGIN UsuarioDisenador WITH PASSWORD = 'ContrasenaDisenador';


CREATE USER UsuarioAnalista FOR LOGIN UsuarioAnalista;
CREATE USER UsuarioDisenador FOR LOGIN UsuarioDisenador;


/*

Creamos dos roles
*/

CREATE ROLE Analistas;
CREATE ROLE Disenadores;


/*
Le damos permisos  a los roles
*/

GRANT SELECT TO Analistas;


GRANT CREATE TABLE TO Disenadores;
GRANT ALTER ON SCHEMA::dbo TO Disenadores;

/*
Le asignamos a cada role los usuarios
*/

ALTER ROLE Analistas ADD MEMBER UsuarioAnalista;
ALTER ROLE Disenadores ADD MEMBER UsuarioDisenador;

/*
Crear usuario solo vista
*/
CREATE SCHEMA ViewSchema AUTHORIZATION dbo;
GO
-- Crear una nueva vista en este esquema
-- Crear vistas para cada tabla
CREATE VIEW ViewSchema.ProvinciaView AS SELECT * FROM provincia;
GO
CREATE VIEW ViewSchema.LocalidadView AS SELECT * FROM localidad;
GO
CREATE VIEW ViewSchema.ZonaView AS SELECT * FROM zona;
GO
CREATE VIEW ViewSchema.ConsorcioView AS SELECT * FROM consorcio;
GO
CREATE VIEW ViewSchema.GastoView AS SELECT * FROM gasto;
GO
CREATE VIEW ViewSchema.ConserjeView AS SELECT * FROM conserje;
GO
CREATE VIEW ViewSchema.AdministradorView AS SELECT * FROM administrador;
GO
CREATE VIEW ViewSchema.TipoGastoView AS SELECT * FROM tipogasto;
GO
-- Crear un nuevo rol de base de datos
CREATE ROLE db_viewreader;

-- Otorgar permisos SELECT a todos los objetos en el esquema ViewSchema al nuevo rol de base de datos
GRANT SELECT ON SCHEMA::ViewSchema TO db_viewreader;


-- Crear un nuevo usuario
CREATE USER usuarioVista WITHOUT LOGIN;

-- Agregar el nuevo usuario al rol de base de datos
ALTER ROLE db_viewreader ADD MEMBER usuarioVista;

--------------------------------
use base_consorcio;

--NOTA: Es mejor probar en querys diferentes para evitar algun problema
/*

Testeo el funciomiento del role de analista
*/

EXECUTE AS USER = 'UsuarioAnalista';
SELECT * FROM conserje;

/*
Ejemplo de lo que no puede hacer
CREATE TABLE tablaEjemplo1 (ID INT, Nombre VARCHAR(50));
*/

REVERT;



/*
Testeo el funcionamiento del role de diseñador
*/
EXECUTE AS USER = 'UsuarioDisenador';
CREATE TABLE tablaEjemplo (ID INT, Nombre VARCHAR(50));
ALTER TABLE tablaEjemplo ADD Descripcion VARCHAR(100);
/*
Ejemplo de lo que no puede hacer
SELECT * FROM conserje;
*/


REVERT;


/*
Testeo el funcionamiento de usuario solo vista
*/
EXECUTE AS USER = 'usuarioVista';
-- Consultar la vista individual
SELECT * FROM ViewSchema.GastoView;
REVERT;





--------------------------
go
create login benn with password='Password123';
create login artur with password='Password123';

--creamos usuarios con los long in anteriores
create user benn for login benn
create user artur for login artur
--asignamos roles a los usuarios
alter role db_datareader add member benn
alter role db_ddladmin add artur

go
-- creamos el procedimiento insertarAdministrador
create procedure insertarAdministrador
@apeynom varchar(50),
@viveahi varchar(1),
@tel varchar(20),
@s varchar(1),
@nacimiento datetime
as
begin
	insert into administrador(apeynom,viveahi,tel,sexo,fechnac)
	values (@apeynom,@viveahi,@tel,@s,@nacimiento);
end

--probar con benn antes del permiso 
--insert into administrador(apeynom,viveahi,tel,sexo,fechnac) values ('Lezana mauricio','S','3912819222','M','2003-05-26')
--exec  insertarAdministrador 'Lezana mauricio','S','3912819222','M','2003-05-26'
grant execute on insertarAdministrador to benn 
--probar despues de el permiso 
--exec  insertarAdministrador 'Lezana mauricio','S','3912819222','M','2003-05-26'
select * from administrador



----------------------------------------------- Implementacion de Procedimientos y funciones almacenadas -----------------------------------------------

CREATE PROCEDURE InsertarAdministrador
(
    @apeynom varchar(50),
    @viveahi varchar(1),
    @tel varchar(20),
    @sexo varchar(1),
    @fechnac datetime
)
AS
BEGIN
    INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac)
    VALUES (@apeynom, @viveahi, @tel, @sexo, @fechnac);
END

CREATE PROCEDURE ModificarAdministrador
(
    @idadmin int,
    @apeynom varchar(50),
    @viveahi varchar(1),
    @tel varchar(20),
    @sexo varchar(1),
    @fechnac datetime
)
AS
BEGIN
    UPDATE administrador
    SET apeynom = @apeynom,
        viveahi = @viveahi,
        tel = @tel,
        sexo = @sexo,
        fechnac = @fechnac
    WHERE idadmin = @idadmin;
END

CREATE PROCEDURE BorrarAdministrador
(
    @idadmin int
)
AS
BEGIN
    DELETE FROM administrador
    WHERE idadmin = @idadmin;
END

-- Lote de Pruebas --

-- Vaciar la tabla Administrador:
DELETE FROM administrador;

-- Insertar datos utilizando el procedimiento almacenado correspondiente:
EXEC InsertarAdministrador 'Julian Cruz', 'S', '3795024422', 'M', '17-02-1997';

-- Modificar datos de un administrador utilizando el procedimiento almacenado correspondiente:
EXEC ModificarAdministrador 1, 'Julian Luis Cruz', 'N', '112443434', 'M', '17-02-1997';

-- Eliminacion de datos de un administrador utilizando el procedimiento almacenado correspondiente:
EXEC BorrarAdministrador 1;


USE base_consorcio
GO

CREATE PROCEDURE agregarConsorcio
@Provincia INT,
@Localidad INT,
@Consorcio INT, 
@Nombre VARCHAR(50),
@Direccion VARCHAR(255),
@Zona INT,
@Conserje INT,
@Admin INT

      AS
BEGIN
		INSERT INTO consorcio(idprovincia,idlocalidad,idconsorcio,nombre,direccion, idzona,idconserje,idadmin) 
			VALUES (@Provincia,@Localidad,@Consorcio,@Nombre,@Direccion, @Zona, @Conserje, @Admin)
					
END  

CREATE PROCEDURE modificarConsorcio
@Provincia INT,
@Localidad INT,
@Consorcio INT, 
@Nombre VARCHAR(50),
@Direccion VARCHAR(255),
@Zona INT,
@Conserje INT,
@Admin INT

      AS
BEGIN

	IF @Consorcio IS NOT NULL
		UPDATE consorcio SET idprovincia= @Provincia, idlocalidad= @Localidad,nombre= @Nombre,direccion= @Direccion,idzona= @Zona, 
		idconserje= @Conserje,idadmin= @Admin
		WHERE idconsorcio= @Consorcio
END

CREATE PROCEDURE eliminarConsorcio
@Consorcio INT

AS
BEGIN

	DELETE FROM consorcio WHERE idconsorcio=@Consorcio
END

/*EXECUTE agregarConsorcio @Provincia=5, @Localidad=6, @Consorcio= 50, @Nombre='Nicolás', @Direccion='General Viamonte 1658', @Zona=3,@Conserje='2',@Admin=1
SELECT * FROM consorcio WHERE idConsorcio=50 */
/*EXECUTE modificarConsorcio @Provincia=6, @Localidad=5, @Consorcio= 50, @Nombre='Anibal', @Direccion='Juan Jose Castelli 1217', @Zona=4, @Conserje='1', @Admin=2
SELECT * FROM consorcio WHERE idConsorcio=50 
DELETE FROM consorcio WHERE idconsorcio=50*/
/*EXECUTE eliminarConsorcio @Consorcio=50
SELECT * FROM consorcio WHERE idconsorcio=50 */

----Procedimiento insertar registro de la tabla gastos
CREATE PROCEDURE InsertarGasto(
    @idprovincia INT,
    @idlocalidad INT,
    @idconsorcio INT,
    @periodo INT,
    @fechapago DATETIME,
    @idtipogasto INT,
    @importe DECIMAL(8, 2)
)
AS
BEGIN
    INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
    VALUES (@idprovincia, @idlocalidad, @idconsorcio, @periodo, @fechapago, @idtipogasto, @importe);
END;
----FIN INSERTARGASTOS

----Procedimiento modificar registro de la tabla gastos
CREATE PROCEDURE ModificarGasto
(
    @idgasto INT,
    @idprovincia INT,
    @idlocalidad INT,
    @idconsorcio INT,
    @periodo INT,
    @fechapago DATETIME,
    @idtipogasto INT,
    @importe DECIMAL(8, 2)
)
AS
BEGIN
    UPDATE gasto
    SET
        idprovincia = @idprovincia,
        idlocalidad = @idlocalidad,
        idconsorcio = @idconsorcio,
        periodo = @periodo,
        fechapago = @fechapago,
        idtipogasto = @idtipogasto,
        importe = @importe
    WHERE idgasto = @idgasto;
END;

----FIN MODIFICARGASTOS


----Procedimiento borrar registro de la tabla gastos
CREATE PROCEDURE BorrarGasto
(
    @idgasto INT
)
AS
BEGIN
    DELETE FROM gasto
    WHERE idgasto = @idgasto;
END;

----FIN BORRARGASTOS


-- Inserción de datos en la tabla gasto utilizando sentencias INSERT
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
VALUES
    (24, 17, 6, 8, convert(datetime,'20231029'), 4, 100.50),
    (24, 17, 6, 3, convert(datetime,'20231030'), 4, 150.75),
    (24, 17, 6, 4, convert(datetime,'20231101'), 5, 75.25);
---FIN de la insercion de datos utilizando sentencias INSERT	


-- Invocación de procedimientos almacenados para insertar datos
EXEC InsertarGasto 24, 17, 6, 8, '20231102', 4, 80.00;
EXEC InsertarGasto 24, 17, 6, 3, '20231103', 5, 60.25;

---FIN de la invocación de procedimientos almacenados para insertar datos

---Actualización de un registro utilizando el procedimiento almacenado
EXEC ModificarGasto @idgasto = 1, @idprovincia = 24, @idlocalidad = 17, @idconsorcio = 6, @periodo = 8, @fechapago = '20240115', @idtipogasto = 4, @importe = 120.00;

---FIN de la invocación de procedimientos almacenados para actualización de un registro

---Eliminación de un registro utilizando el procedimiento almacenado
EXEC BorrarGasto @idgasto = 2;

---FIN de la invocación de procedimientos almacenados para la eliminación de un registro













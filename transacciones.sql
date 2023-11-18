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


----- Implementacion de Backup y restore. Backup en línea.






----- Implementacion de Índices columnares en SQL server







----- Implementacion de Índices Optimización de consultas a través de índices.






---Implementacion de Vistas y vistas indexadas







---Implementacion de Triggers de auditoría

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



---Implementacion de Manejo de permisos a nivel de usuarios de base de datos

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



---Implementacion de Procedimientos y funciones almacenadas






---Implementacion de Réplicas de base de datos














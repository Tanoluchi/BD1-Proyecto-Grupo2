-- USE base_consorcio;

-- CREACION DE TRANSACCIONES
BEGIN TRY -- INICIAMOS EL BEGIN TRY PARA LUEGO COLOCAR LA LOGICA DENTRO Y ASEGURARNOS DE QUE SI ALGO FALLA IRA POR EL CATCH
	BEGIN TRAN -- COMENZAMOS LA TRANSACCION
	INSERT INTO administrador(apeynom, viveahi, tel, sexo, fechnac) -- UN INSERT A LA TABLA QUE QUEREMOS
	VALUES ('pablito clavounclavito', 'S', '37942222', 'M', '01/01/1996') -- LOS VALORES A INGRESAR A LA TABLA

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

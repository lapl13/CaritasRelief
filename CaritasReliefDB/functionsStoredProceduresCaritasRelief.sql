-----------------------------------------
-- -- -- -- --  FUNCIONES  -- -- -- -- --
-----------------------------------------

CREATE OR ALTER FUNCTION fnLoginRecolector (@USER varchar(50), @CLAVE varchar(50))
RETURNS int
AS
BEGIN
    DECLARE @respuestaIdRecolector int;
    SELECT @respuestaIdRecolector = Recolectores.idRecolector FROM Recolectores
    INNER JOIN Logins ON Recolectores.idLogin = Logins.idLogin
    WHERE (usuario = @USER AND contrasena = @CLAVE);
    RETURN @respuestaIdRecolector;
END;
--SELECT dbo.fnLoginRecolector('JMartinez100','**Jomar100**');



CREATE OR ALTER FUNCTION fnTotalEstadosCobrado(@DIA date)
RETURNS TABLE
AS
RETURN
    SELECT
        (SELECT COUNT(*) FROM Recibos WHERE cobrado = 1 AND @DIA = fecha) AS cobrados,
        (SELECT COUNT(*) FROM Recibos WHERE cobrado = 2 AND @DIA = fecha) AS pendientes,
        (SELECT COUNT(*) FROM Recibos WHERE cobrado = 0 AND @DIA = fecha) AS cobradosFallidos;
--SELECT * FROM dbo.fnTotalEstadosCobrado('2023-12-01');



CREATE OR ALTER FUNCTION fnEstadosCobradoRecolector(@DIA date, @IDRECOLECTOR int)
RETURNS TABLE
AS
RETURN
    SELECT
        (SELECT COUNT(*) FROM Recibos WHERE cobrado = 1 AND @DIA = fecha AND @IDRECOLECTOR = idRecolector) AS cobrados,
        (SELECT COUNT(*) FROM Recibos WHERE cobrado = 2 AND @DIA = fecha AND @IDRECOLECTOR = idRecolector) AS pendientes,
        (SELECT COUNT(*) FROM Recibos WHERE cobrado = 0 AND @DIA = fecha AND @IDRECOLECTOR = idRecolector) AS cobradosFallidos;
--SELECT * FROM dbo.fnEstadosCobradoRecolector('2023-12-01', 1);



CREATE OR ALTER FUNCTION fnDineroTotalCobrado(@DIA date)
RETURNS money
AS
BEGIN
    DECLARE @total money;
    SELECT @total = SUM(cantidad)
    FROM Recibos
    WHERE cobrado = 1 AND @DIA = fecha
    RETURN @total;
END;
--SELECT dbo.fnDineroTotalCobrado('2023-12-01');



CREATE OR ALTER FUNCTION fnDineroTotalRecolector(@DIA date, @IDRECOLECTOR int)
RETURNS money
AS
BEGIN
    DECLARE @total money;
    SELECT @total = SUM(cantidad)
    FROM Recibos
    WHERE cobrado = 1 AND @DIA = fecha AND @IDRECOLECTOR = idRecolector
    RETURN @total;
END;
--SELECT dbo.fnDineroTotalRecolector('2023-12-01', 1);


------------------------------------------
-- -- -- -- STORED PROECEDURES -- -- -- --
------------------------------------------

CREATE PROCEDURE spUpdateReciboNuevoRecolector @idRecibo int, @idRecolectorNuevo int
    AS  
        UPDATE recibos
        SET idRecolector = @idRecolectorNuevo
        WHERE idRecibo = @idRecibo;
--EXECUTE spUpdateReciboRecolector 2, 2;


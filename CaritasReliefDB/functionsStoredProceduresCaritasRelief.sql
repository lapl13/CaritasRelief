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



------------------------------------------
-- -- -- -- STORED PROECEDURES -- -- -- --
------------------------------------------

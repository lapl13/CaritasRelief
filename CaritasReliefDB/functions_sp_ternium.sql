--FUNCIONES Y STORED PROCEDURES
--*SE DEBEN DE CORRER POR SEPARADO CADA OBJETO PARA CREAR CADA UNO

-------------------------------------------------------------
------------------------- FUNCIONES -------------------------
-------------------------------------------------------------

--fetchUserCourseInfo
--SELECT * FROM fn_fetchUserCourseInfo(3)
CREATE OR ALTER FUNCTION fn_fetchUserCourseInfo (@LOGID int)
RETURNS TABLE
AS
RETURN
    SELECT encuadres.nombre AS encuadre, FORMAT(users.fecha_ingreso_programa_jp, 'yyyy-MM-dd', 'en-US') AS fecha_ingreso_programa_jp, FORMAT(users.generacion_graduacion, 'yyyy-MM-dd', 'en-US') AS fecha_graduacion FROM users
    INNER JOIN encuadres ON users.id_encuadre_actual = encuadres.id_encuadre
    WHERE users.id_login = @LOGID;
--SELECT * FROM fn_fetchCourseList(3)
CREATE OR ALTER FUNCTION fn_fetchCourseList (@LOGID int)
RETURNS TABLE
AS
RETURN (
    SELECT cursos.nombre, dbo.fn_checkUsersCursos(cursos.id_curso, (SELECT id_user FROM users WHERE id_login = @LOGID)) AS BitColumns
    FROM cursos
    INNER JOIN users ON cursos.id_encuadre = users.id_encuadre_actual
    WHERE users.id_login = @LOGID
);

CREATE OR ALTER FUNCTION fn_checkUsersCursos(@CURSOID int, @USERID int)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT;
    SELECT @result = completado
    FROM users_cursos WHERE (id_user = @USERID AND id_curso = @CURSOID);
    return @result;
END;



--compensationCard
--SELECT * FROM fn_compensationCardNoticias(1)
CREATE or ALTER FUNCTION fn_compensationCardNoticias(@id_login int)
RETURNS TABLE
AS
RETURN
    SELECT noticias.titulo, noticias.autor, FORMAT(noticias.fecha, 'yyyy-MM-dd', 'en-US') AS fecha_noticia, noticias.cuerpo FROM noticias
    INNER JOIN noticias_encuadres ON noticias.id_noticia = noticias_encuadres.id_noticia
    INNER JOIN users ON noticias_encuadres.id_encuadre = users.id_encuadre_actual
    WHERE users.id_login = @id_login;

--SELECT * FROM fn_compensationCardUserL(1)
CREATE or ALTER FUNCTION fn_compensationCardUserL(@id_login int)
RETURNS TABLE
AS
RETURN
    SELECT encuadres.nombre AS encuadre_actual, encuadres.remuneracion, FORMAT(encuadres.fecha_adelanto, 'yyyy-MM-dd', 'en-US') AS fecha_de_adelanto FROM encuadres
    INNER JOIN users ON encuadres.id_encuadre = users.id_encuadre_actual
    WHERE users.id_login = @id_login;

--userHistory
--SELECT * FROM fn_userHistoryL(1)
CREATE or ALTER FUNCTION fn_userHistoryL(@id_login int)
RETURNS TABLE
AS
RETURN
    SELECT bitacora_rotaciones.fecha_timestamp AS fecha_cierre_rotacion, supervisores.nombres AS tutor, jefes.nombre_completo AS jefe, bitacora_rotaciones.estructura3, bitacora_rotaciones.estructura4, bitacora_rotaciones.estructura5, bitacora_rotaciones.performance, bitacora_rotaciones.potencial, bitacora_rotaciones.feedback FROM bitacora_rotaciones
    INNER JOIN supervisores ON bitacora_rotaciones.id_supervisor = supervisores.id_supervisor
    INNER JOIN jefes ON bitacora_rotaciones.id_jefe = jefes.id_jefe
    INNER JOIN users ON users.id_user = bitacora_rotaciones.id_user
    WHERE users.id_login = @id_login;


CREATE   FUNCTION [dbo].[fn_userHistory](@id_user int)
RETURNS TABLE
AS
RETURN
    SELECT bitacora_rotaciones.fecha_timestamp AS fecha_cierre_rotacion, supervisores.nombres AS tutor, jefes.nombre_completo AS jefe, bitacora_rotaciones.estructura3, bitacora_rotaciones.estructura4, bitacora_rotaciones.estructura5, bitacora_rotaciones.performance, bitacora_rotaciones.potencial, bitacora_rotaciones.feedback FROM bitacora_rotaciones
    INNER JOIN supervisores ON bitacora_rotaciones.id_supervisor = supervisores.id_supervisor
    INNER JOIN jefes ON bitacora_rotaciones.id_jefe = jefes.id_jefe
    INNER JOIN users ON users.id_user = bitacora_rotaciones.id_user
    WHERE users.id_user = @id_user;


--SELECT * FROM fn_compensationCardUser(1)
CREATE or ALTER FUNCTION fn_compensationCardUser(@id_user int)
RETURNS TABLE
AS
RETURN
    SELECT encuadres.nombre AS encuadre_actual, encuadres.remuneracion, FORMAT(encuadres.fecha_adelanto, 'yyyy-MM-dd', 'en-US') AS fecha_de_adelanto FROM encuadres
    INNER JOIN users ON encuadres.id_encuadre = users.id_encuadre_actual
    WHERE users.id_user = @id_user;



--userCard/get
--SELECT * FROM fn_userCardGet(3)
CREATE or ALTER FUNCTION fn_userCardGet(@id_login int)
RETURNS TABLE
AS
RETURN
    SELECT users.foto_perfil, users.nombres, users.apellidos, logins.email, logins.usuario, users.id_cet, logins.contrasena, users.intereses, users.fecha_ingreso_programa_jp, users.generacion_graduacion, jefes.nombre_completo AS jefe, encuadres.nombre AS encuadre
    FROM users
    INNER JOIN logins ON users.id_login = logins.id_login
    INNER JOIN rotaciones_actuales ON users.id_user = rotaciones_actuales.id_user
    INNER JOIN jefes ON rotaciones_actuales.id_jefe = jefes.id_jefe
    INNER JOIN encuadres ON users.id_encuadre_actual = encuadres.id_encuadre
    WHERE users.id_login = @id_login;




--fetchInventory

--SELECT * FROM fn_fetchInventory(3)
CREATE or ALTER FUNCTION fn_fetchInventory(@id_login int)
RETURNS TABLE
AS
RETURN
    SELECT users_items.clave, users_items.equipado FROM users_items
    INNER JOIN users ON users_items.id_user = users.id_user
    WHERE users.id_login = @id_login;



--funcion de ayuda para obtener numero total de cursos en el encuadre donde se encuentra el usuario
CREATE or ALTER FUNCTION fn_totalCursosEncuadre(@id_login int)
RETURNS INT
    AS
    BEGIN
        DECLARE @total int = 0;
        SELECT @total = COUNT(cursos.tokens) FROM cursos
        INNER JOIN encuadres ON cursos.id_encuadre = encuadres.id_encuadre
        INNER JOIN users ON encuadres.id_encuadre = users.id_encuadre_actual
        WHERE users.id_login = @id_login
        RETURN @total
    END

--SELECT dbo.fn_totalCursosEncuadre(3);



--fetchProgress
--SELECT * FROM fn_fetchProgress(3);
CREATE or ALTER FUNCTION fn_fetchProgress(@id_login int)
RETURNS TABLE
AS
RETURN
    SELECT (SELECT dbo.fn_totalCursosEncuadre(@id_login)) AS total_cursos, juegos_ganados, juegos_pendientes, tokens FROM users
    WHERE id_login = @id_login;




-- GET GT INFO
CREATE OR ALTER FUNCTION fn_getGT(@USERID INT)
RETURNS TABLE
AS
RETURN
    SELECT nombres, apellidos, logins.usuario, logins.email, '' AS password, id_cet, id_encuadre_actual, 
    FORMAT(fecha_ingreso_programa_jp, 'yyyy-MM-dd', 'en-US') AS fecha_ingreso_programa_jp, FORMAT(generacion_graduacion, 'yyyy-MM-dd', 'en-US') AS generacion_graduacion, 
    foto_perfil, idm4, genero, FORMAT(fecha_nacimiento, 'yyyy-MM-dd', 'en-US') AS fecha_nacimiento, pais, 
    perfil, universidad, descripcion_titulo, tipo_posicion_actual, rango_graduacion
    FROM users
    INNER JOIN logins ON users.id_login = logins.id_login
    WHERE id_user = @USERID;



-- GET INFO ROTACION
CREATE OR ALTER FUNCTION fn_getRotacion(@USERID INT)
RETURNS TABLE
AS
RETURN
    SELECT id_jefe, id_supervisor, estructura3, estructura4, estructura5
    FROM rotaciones_actuales
    WHERE id_user = @USERID;




-- Get Preguntas/Respuestas Foro
CREATE OR ALTER FUNCTION fn_getForo()
RETURNS TABLE
AS
RETURN
    SELECT id_foro, pregunta, COALESCE(respuesta, '') AS respuesta FROM foro;



-- GET TABLA PARA TOMAR LISTA
CREATE OR ALTER FUNCTION fn_tablaAsistencia(@ENCUADRE INT)
RETURNS TABLE
AS
RETURN
    SELECT id_user, nombres, apellidos, id_cet FROM users
    WHERE id_encuadre_actual = @ENCUADRE;


---- Fetch Dashboard -----
CREATE OR ALTER FUNCTION fn_dashboardFetch(@LOGINID INT)
RETURNS TABLE
AS
RETURN
    SELECT nombres, 'user' AS DashboardType, encuadres.nombre AS encuadre,
        (SELECT COUNT(id_curso) / (SELECT dbo.fn_totalCursosEncuadre(@LOGINID))
         FROM users_cursos
         INNER JOIN users ON users_cursos.id_user = users.id_user
         INNER JOIN logins ON users.id_login = @LOGINID) AS avance
    FROM users
    INNER JOIN encuadres ON users.id_encuadre_actual = encuadres.id_encuadre
    WHERE id_login = @LOGINID

    UNION ALL

    SELECT nombres, 'admin' AS DashboardType, NULL AS encuadre, NULL AS avance
    FROM admins
    WHERE id_login = @LOGINID
    AND EXISTS (
        SELECT 1
        FROM [dbo].[tipos]
        INNER JOIN logins ON tipos.id_tipo = logins.id_tipo
        WHERE logins.id_login = @LOGINID
    );



--------login--------

CREATE or ALTER FUNCTION fn_login(@USEREMAIL varchar(50), @CONTRASENA varchar(128))  
RETURNS int
    AS
    BEGIN
        DECLARE @loginid int = 0;
        SELECT @loginid = id_login FROM [dbo].[logins]
        WHERE (usuario = @USEREMAIL OR email = @USEREMAIL) AND contrasena = @CONTRASENA AND estado = 1
        RETURN @loginid;
    END

--SELECT dbo.fn_login('admin_prueba', '74CB9CF858439097CB8A2EA840C6C3991F1218B2B807DB955DC0DBF119561CE488D33077DAE7E25BB2E6CB4F5650D3071A1E5E0E33E8F170BA49E3D02BDD6FED');


-- TABLA GLOBAL TRAINEER
CREATE OR ALTER FUNCTION fn_tablaGT(@BUSQUEDA VARCHAR(100), @ENCUADRE INT)
RETURNS TABLE
AS
RETURN
    SELECT id_user, idm4, nombres, apellidos, logins.email, encuadres.nombre FROM users 
    INNER JOIN logins ON users.id_login = logins.id_login
    INNER JOIN encuadres ON users.id_encuadre_actual = encuadres.id_encuadre
    WHERE nombres LIKE @BUSQUEDA + '%' AND logins.estado = 1
    AND (users.id_encuadre_actual = @ENCUADRE OR
        CASE
            WHEN @ENCUADRE = -1 THEN 'True'
            ELSE 'False'
        END = 'True');


-- TABLA ADMINS
CREATE OR ALTER FUNCTION fn_tablaAdmins(@BUSQUEDA VARCHAR(100))
RETURNS TABLE
AS
RETURN
    SELECT * FROM view_admins WHERE nombres LIKE @BUSQUEDA + '%';


-- TABLA TUTORES
CREATE OR ALTER FUNCTION fn_tablaTutores(@BUSQUEDA VARCHAR(100))
RETURNS TABLE
AS
RETURN
    SELECT * FROM view_tutores WHERE nombres LIKE @BUSQUEDA + '%';


-- TABLA CURSOS
CREATE OR ALTER FUNCTION fn_tablaCursos(@BUSQUEDA VARCHAR(100), @ENCUADRE INT)
RETURNS TABLE
AS
RETURN
    SELECT * FROM view_cursos 
    WHERE nombre LIKE @BUSQUEDA + '%'
    AND (ENCNOM = (SELECT nombre from encuadres WHERE id_encuadre = @ENCUADRE) OR
        CASE
            WHEN @ENCUADRE = -1 THEN 'True'
            ELSE 'False'
        END = 'True');


-- TABLA GT BAJAS
CREATE OR ALTER FUNCTION fn_tablaGTBajas(@BUSQUEDA VARCHAR(100))
RETURNS TABLE
AS
RETURN
    SELECT * FROM view_GTBajas WHERE nombres LIKE @BUSQUEDA + '%';


-- TABLA ADMINS BAJAS
CREATE OR ALTER FUNCTION fn_tablaAdminsBajas(@BUSQUEDA VARCHAR(100))
RETURNS TABLE
AS
RETURN
    SELECT * FROM view_AdminBajas WHERE nombres LIKE @BUSQUEDA + '%';



--jefes
CREATE or ALTER FUNCTION [dbo].[fn_jefes]()
RETURNS TABLE
	AS
		RETURN (SELECT * FROM jefes);


--cursos
CREATE OR ALTER FUNCTION [dbo].[fn_cursos](@encuadre int)
RETURNS TABLE 
	AS RETURN 
	(SELECT id_curso, nombre 
	FROM [dbo].[cursos]
	WHERE id_encuadre = @encuadre);


--encuadres
CREATE OR ALTER FUNCTION [dbo].[fn_encuadres]()
RETURNS TABLE
	AS RETURN
	(SELECT id_encuadre, nombre FROM [dbo].[encuadres]);



--tutores
CREATE OR ALTER FUNCTION [dbo].[fn_tutores]()
RETURNS TABLE
	AS RETURN
	(SELECT * FROM [dbo].[supervisores]);








---------------------------------------------------------------------
------------------------- STORED PROCEDURES -------------------------
---------------------------------------------------------------------

--




-----Cerrar Rotacion----

CREATE PROCEDURE sp_cerrarRotacion (@id_login int, @id_user int, @performance smallint, @potencial smallint, @feedback text)
AS
BEGIN
    INSERT INTO bitacora_rotaciones
    (
        fecha_timestamp,
        id_encuadre,
        id_admin,
        id_user,
        id_supervisor,
        id_jefe,
        estructura3,
        estructura4,
        estructura5,
        performance,
        potencial,
        feedback
    )
    VALUES
    (
        GETDATE(),
        (SELECT id_encuadre_actual FROM users WHERE id_user = @id_user),
        (SELECT id_admin FROM admins WHERE id_login = @id_login),
        @id_user,
        (SELECT id_supervisor FROM rotaciones_actuales WHERE id_user = @id_user),
        (SELECT id_jefe FROM rotaciones_actuales WHERE id_user = @id_user),
        (SELECT estructura3 FROM rotaciones_actuales WHERE id_user = @id_user),
        (SELECT estructura4 FROM rotaciones_actuales WHERE id_user = @id_user),
        (SELECT estructura5 FROM rotaciones_actuales WHERE id_user = @id_user),
        @performance,
        @potencial,
        @feedback
    )
END

-- EXECUTE sp_cerrarRotacion 1, 1, 1, 1, "feed prueba";




--equipItem

--EXECUTE sp_equipItem 3, 'H_Hair1Black', 'cabello'
CREATE PROCEDURE sp_equipItem(@id_login int, @clave varchar(50), @categoria varchar(50))
AS
BEGIN
    DECLARE @id_user int = 0;
    SELECT @id_user = id_user FROM users WHERE id_login = @id_login;

    UPDATE users_items
    SET equipado = 0 WHERE id_user = @id_user AND categoria = @categoria;

    UPDATE users_items
    SET equipado = 1 WHERE id_user = @id_user AND clave = @clave;
END



--buyItem

--EXECUTE sp_buyItem 3, 'H_Hair1Black', 'cabello', 0
CREATE PROCEDURE sp_buyItem(@id_login int, @clave varchar(50), @categoria varchar(50), @tokens int)
AS
BEGIN
    DECLARE @id_user int = 0;
    SELECT @id_user = id_user FROM users WHERE id_login = @id_login;

    INSERT INTO dbo.users_items (id_user, clave, categoria, equipado)
    VALUES (@id_user, @clave, @categoria, 0);

    UPDATE users SET tokens = @tokens WHERE id_login = @id_login;
END



--gameOver

--EXECUTE sp_gameOver 3, 0, 0, 0;
CREATE PROCEDURE sp_gameOver(@id_login int, @new_tokens int, @new_juegos_ganados int, @new_juegos_pendientes int)
AS
BEGIN
    UPDATE users
    SET
        tokens = @new_tokens,
        juegos_ganados = @new_juegos_ganados,
        juegos_pendientes = @new_juegos_pendientes
    WHERE
        id_login = @id_login
END




--------admin--------

CREATE PROCEDURE sp_insert_newAdmin
(
    @nombres varchar(50),
    @apellidos varchar(50),
    @usuario varchar(50),
    @correo varchar(50),
    @password varchar(128)
)
AS
BEGIN
    INSERT INTO dbo.logins
    (
        email,
        usuario,
        contrasena,
        estado,
        id_tipo
    )
    VALUES
    (
        @correo,
        @usuario,
        @password,
        1,
        2
    )

    DECLARE @idlogin int;

    SELECT @idlogin = id_login FROM logins WHERE usuario = @usuario

    INSERT INTO dbo.admins
    (
        nombres,
        apellidos,
        id_login
    )
    VALUES
    (
        @nombres,
        @apellidos,
        @idlogin
    )
END

-- EXECUTE sp_insert_newAdmin
--     @nombres = 'admin',
--     @apellidos = 'prueba2',
--     @usuario = 'admin_prueba2',
--     @correo = 'admin_prueba2@ternium.com.mx',
--     @password = '74CB9CF858439097CB8A2EA840C6C3991F1218B2B807DB955DC0DBF119561CE488D33077DAE7E25BB2E6CB4F5650D3071A1E5E0E33E8F170BA49E3D02BDD6FED';




--------tutor--------
--(supervisor)

CREATE PROCEDURE sp_insert_newTutor
(
    @nombres varchar(50),
    @apellidos varchar(50)
)
AS
BEGIN
    INSERT INTO dbo.supervisores
    (
        nombres,
        apellidos
    )
    VALUES
    (
        @nombres,
        @apellidos
    )
END

-- EXECUTE sp_insert_newTutor
--     @nombres = 'tutor',
--     @apellidos = 'prueba';




--------jefe--------

CREATE PROCEDURE sp_insert_newJefe
(
    @nombre varchar(50)
)
AS
BEGIN
    INSERT INTO dbo.jefes
    (
        nombre_completo
    )
    VALUES
    (
        @nombre
    )
END

-- EXECUTE sp_insert_newJefe
--     @nombre = 'jefe prueba';



--------curso--------

CREATE PROCEDURE sp_insert_newCurso
(
    @encuadre int,
    @nombre varchar(50),
    @fecha date,
    @tokens int,
    @modalidad varchar(50)
)
AS
BEGIN
    INSERT INTO dbo.cursos
    (
        id_encuadre,
        nombre,
        fecha,
        tokens,
        curso_final,
        modalidad
    )
    VALUES
    (
        @encuadre,
        @nombre,
        @fecha,
        @tokens,
        0,
        @modalidad
    )
END

-- EXECUTE sp_insert_newCurso
--     @encuadre = 1,
--     @nombre = 'pruebaCurso 11 GT1',
--     @fecha = '2023-06-30',
--     @tokens = 20,
--     @modalidad = 'pruebaWebinar';




--------noticia--------

CREATE PROCEDURE sp_insert_newNoticia
(
    @encuadre int,
    @titulo varchar(50),
    @noticia text,
    @logID int
)
AS
BEGIN
    DECLARE @date_now date = CAST(GETDATE() AS DATE);
    DECLARE @autor_nom varchar(50);
    DECLARE @autor_ap varchar(50);

    SELECT @autor_nom = nombres, @autor_ap = apellidos FROM admins WHERE id_login = @logID

    INSERT INTO dbo.noticias
    (
        autor,
        titulo,
        cuerpo,
        fecha
    )
    VALUES
    (
        CONCAT(@autor_nom, ' ', @autor_ap),
        @titulo,
        @noticia,
        @date_now
    )

    DECLARE @idnoticia int;

    SELECT @idnoticia = id_noticia FROM noticias WHERE fecha = @date_now

    INSERT INTO dbo.noticias_encuadres
    (
        id_noticia,
        id_encuadre
    )
    VALUES
    (
        @idnoticia,
        @encuadre
    )
END

-- EXECUTE sp_insert_newNoticia
--     @encuadre = 1,
--     @titulo = 'pruebaNoticia',
--     @noticia = 'Lorem Ipsium...',
--     @logID = 1;



--------remuneracion--------

CREATE PROCEDURE sp_update_EncuadreNewRemuneracion
(
    @encuadre int,
    @fechaAdelanto date,
    @remuneracion money
)
AS
BEGIN
    UPDATE encuadres
    SET
        remuneracion = @remuneracion,
        fecha_adelanto = @fechaAdelanto
    WHERE
        id_encuadre = @encuadre
END

-- EXECUTE sp_update_EncuadreNewRemuneracion
--     @encuadre = 1,
--     @fechaAdelanto = '2023-06-30',
--     @remuneracion = 1000;



--------users--------

CREATE PROCEDURE sp_insert_newGT
(
    @nombres varchar(50),
    @apellidos varchar(50),
    @usuario varchar(50),
    @correo varchar(50),
    @password varchar(128),
    @codigoEmpleado int,
    @idm4 varchar(50),
    @encuadreActual int,
    @fechaInicio date,
    @fechaGraduacion date,
    @jefeActual int,
    @imagenDePerfil varchar(max),
    @genero character,
    @fechaNacimiento date,
    @pais varchar(50),
    @perfil varchar(50),
    @universidad varchar(50),
    @titulo varchar(50),
    @posicionActual varchar(50),
    @rangoGraduacion smallint,
    @tutor int,
    @estructura3 varchar(50),
    @estructura4 varchar(50),
    @estructura5 varchar(50)
)
AS
BEGIN
    INSERT INTO dbo.logins
    (
        email,
        usuario,
        contrasena,
        estado,
        id_tipo
    )
    VALUES
    (
        @correo,
        @usuario,
        @password,
        1,
        1
    )

    DECLARE @idlogin int;

    SELECT @idlogin = id_login FROM logins WHERE usuario = @usuario

    INSERT INTO dbo.users
    (
        id_cet,
        idm4,
        nombres,
        apellidos,
        genero,
        fecha_nacimiento,
        pais,
        perfil,
        universidad,
        descripcion_titulo,
        tipo_posicion_actual,
        cantidad_rotaciones_realizadas,
        id_encuadre_alta,
        fecha_ingreso_programa_jp,
        id_encuadre_actual,
        generacion_graduacion,
        juegos_pendientes,
        juegos_ganados,
        tokens,
        intereses,
        foto_perfil,
        rango_graduacion,
        id_login
    )
    VALUES
    (
        @codigoEmpleado,
        @idm4,
        @nombres,
        @apellidos,
        @genero,
        @fechaNacimiento,
        @pais,
        @perfil,
        @universidad,
        @titulo,
        @posicionActual,
        0,
        @encuadreActual,
        @fechaInicio,
        @encuadreActual,
        @fechaGraduacion,
        0,
        0,
        0,
        '',
        @imagenDePerfil,
        @rangoGraduacion,
        @idlogin
    )

    DECLARE @iduser int;

    SELECT @iduser = id_user FROM users WHERE id_cet = @codigoEmpleado

    INSERT INTO dbo.rotaciones_actuales
    (
        id_user,
        id_supervisor,
        id_jefe,
        estructura3,
        estructura4,
        estructura5
    )
    VALUES
    (
        @iduser,
        @tutor,
        @jefeActual,
        @estructura3,
        @estructura4,
        @estructura5
    )
END

-- EXECUTE sp_insert_newGT
--     @nombres = 'Daniela',
--     @apellidos = 'Pascual Quiroga',
--     @usuario = 'usuario_prueba',
--     @correo = 'usuario_prueba@ternium.com.mx',
--     @password = '74CB9CF858439097CB8A2EA840C6C3991F1218B2B807DB955DC0DBF119561CE488D33077DAE7E25BB2E6CB4F5650D3071A1E5E0E33E8F170BA49E3D02BDD6FED',
--     @codigoEmpleado = '30008661',
--     @idm4 = 'DU38617967',
--     @encuadreActual = 6,
--     @fechaInicio = '2020-01-06',
--     @fechaGraduacion = '2021-02-01',
--     @jefeActual = 1,
--     @imagenDePerfil = '',
--     @genero = 'F',
--     @fechaNacimiento = '1994-11-05',
--     @pais = 'Mexico',
--     @perfil = 'DINE',
--     @universidad = 'ITESM',
--     @titulo = 'Ing. Industrial',
--     @posicionActual = 'Pool',
--     @rangoGraduacion = 1,
--     @tutor = 1,
--     @estructura3 = 'Ternium - México',
--     @estructura4 = 'Commercial - México',
--     @estructura5 = 'Commercial Coordination - México';




-----postPregunta----

CREATE PROCEDURE sp_postPregunta @LOGID int, @PREGUNTA text
    AS 
        INSERT INTO foro (id_user, id_admin, pregunta, respuesta) VALUES ((SELECT id_user FROM users WHERE id_login = @LOGID), NULL, @PREGUNTA, NULL)

-- EXECUTE sp_postPregunta 3, '¿Como le hago par a usar el foro?'


-----postRespuesta----
CREATE PROCEDURE sp_postRespuesta @IDPREGUNTA int, @LOGID int, @RESPUESTA text 
    AS  
        UPDATE foro SET id_admin = (SELECT id_admin FROM admins WHERE id_login = @LOGID), respuesta = @RESPUESTA WHERE id_foro = @IDPREGUNTA

-- EXECUTE sp_postRespuesta 1, 1 'Asi se hace la pregunta'


-----bajaGT----

CREATE PROCEDURE sp_bajaGT @USERID int
    AS
        UPDATE logins
        SET estado = 0
        FROM logins
        INNER JOIN users ON logins.id_login = users.id_login
        WHERE users.id_user = @USERID;
---


-----altaGT----

CREATE PROCEDURE sp_altaGT @USERID int
    AS
        UPDATE logins
        SET estado = 1
        FROM logins
        INNER JOIN users ON logins.id_login = users.id_login
        WHERE users.id_user = @USERID;
---



-----tomarLista-----

CREATE PROCEDURE sp_tomarLista @USERID int, @CURSOID int, @ASISTENCIA bit
    AS
        INSERT INTO users_cursos(id_user, id_curso, completado, fecha_completado) VALUES (@USERID, @CURSOID, @ASISTENCIA, CAST(GETDATE() AS DATE))

-- EXECUTE sp_tomarLista 1, 2, 0;



-----updateIntereses-----

--EXECUTE sp_updateIntereses 3, 'nuevos intereses'
CREATE PROCEDURE sp_updateIntereses @LOGID int, @INTERESES text
    AS
        UPDATE users SET intereses = @INTERESES WHERE id_login = @LOGID




------Update GT------

CREATE PROCEDURE sp_editarGT @USERID int, @nombres varchar(50), @apellidos varchar(50), @usuario varchar(50), @correo varchar(50), @password varchar(128),
@codigoEmpleado int, @encuadreActual int, @fechaInicio date, @fechaGraduacion date, @imagenDePerfil varchar(max), @idm4 varchar(50),
@genero char(1), @fechaNacimiento date, @pais varchar(50), @perfil varchar(50), @universidad varchar(50), @titulo varchar(50), @posicionActual varchar(50),
@rangoGraduacion int
    AS
        UPDATE users 
        SET nombres = @nombres, apellidos = @apellidos, id_cet = @codigoEmpleado, id_encuadre_actual = @encuadreActual, 
        fecha_ingreso_programa_jp = @fechaInicio, generacion_graduacion = @fechaGraduacion, foto_perfil = @imagenDePerfil, 
        idm4 = @idm4, genero = @genero, fecha_nacimiento = @fechaNacimiento, pais = @pais, perfil = @perfil, universidad = @universidad, 
        descripcion_titulo = @titulo, tipo_posicion_actual = @posicionActual, rango_graduacion = @rangoGraduacion
        WHERE id_user = @USERID;

        UPDATE logins
        SET usuario = @usuario, email = @correo, 
        contrasena = 
        (CASE 
            WHEN @password != '' THEN @password
            ELSE (SELECT contrasena FROM logins INNER JOIN users ON logins.id_login = users.id_login WHERE id_user = @USERID)
            END)
        FROM logins
        INNER JOIN users ON logins.id_login = users.id_login
        WHERE users.id_user = @USERID;



------Update Rotacion------

CREATE PROCEDURE sp_editarRotacion @USERID int, @jefe int, @tutor int, @estructura3 varchar(50), 
@estructura4 varchar(50), @estructura5 varchar(50)
    AS
        UPDATE rotaciones_actuales
        SET id_jefe = @jefe, id_supervisor = @tutor, estructura3 = @estructura3, estructura4 = @estructura4, estructura5 = @estructura5
        WHERE id_user = @USERID;



------BAJA ADMINS------

CREATE PROCEDURE sp_bajaAdmin @ADMINID int
    AS
        UPDATE logins
        SET estado = 0
        FROM logins
        INNER JOIN admins ON logins.id_login = admins.id_login
        WHERE admins.id_admin = @ADMINID;



------ALTA ADMINS------

CREATE PROCEDURE sp_altaAdmin @ADMINID int
    AS
        UPDATE logins
        SET estado = 1
        FROM logins
        INNER JOIN admins ON logins.id_login = admins.id_login
        WHERE admins.id_admin = @ADMINID;

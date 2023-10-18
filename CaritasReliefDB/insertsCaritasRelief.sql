--INSERTS INICIALES

BEGIN;

--Donantes
INSERT INTO Donantes (nombres, apellidos, direccion, referenciaDomicilio, telCasa, telCelular, activo) VALUES ('Doña Pelos', 'Perez', 'Av Garza Sada 2501, Tecnológico, 64849 Monterrey', 'Cerca del HEB', '8113589595', '8123456789', 1);

--Logins
INSERT INTO Logins (usuario, contrasena, tipo, activo) VALUES ('JMartinez100', '**Jomar100**', 1, 1);
INSERT INTO Logins (usuario, contrasena, tipo, activo) VALUES ('MGarcia100', '**Magar100**', 2, 1);

--Recolectores
INSERT INTO Recolectores (idLogin, nombres, apellidos, activo) VALUES (1, 'José', 'Martínez', 1);

--Recibos
INSERT INTO Recibos (idRecolector, idDonante, cantidad, cobrado, comentarios, fecha, comentarioHorario, activo) VALUES (1, 1, 200, 0, '', '2023-10-18', 'Antes de la 1 pm', 1);

--Admins
INSERT INTO Admins (idLogin, nombres, apellidos, activo) VALUES (2, 'María', 'García', 1);

--Acciones
INSERT INTO Acciones (tipo, descripcion, activo) VALUES ('Login', 'El usuario ingresó a su cuenta', 1);
INSERT INTO Acciones (tipo, descripcion, activo) VALUES ('Login', 'El usuario salió de su cuenta', 1);
INSERT INTO Acciones (tipo, descripcion, activo) VALUES ('Recolección', 'El usuario cobró un recibo', 1);
INSERT INTO Acciones (tipo, descripcion, activo) VALUES ('Recolección', 'El usuario agregó un comentario a un recibo', 1);

--BitacoraActividadUsuarios


END;
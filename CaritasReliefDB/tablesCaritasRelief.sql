-- TABLAS

BEGIN;


CREATE TABLE Recibos
(
    idRecibo int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idRecolector int NOT NULL,
    idDonante int NOT NULL,
    cantidad money,
    cobrado bit,
    comentarios varchar(100),
    fecha date,
    comentarioHorario varchar(150),
    activo bit NOT NULL
);

CREATE TABLE Donantes
(
    idDonante int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    nombres varchar(50),
    apellidos varchar(50),
    direccion varchar(150),
    referenciaDomicilio varchar(150),
    telCasa varchar(20),
    telCelular varchar(20),
    activo bit NOT NULL
);

CREATE TABLE Recolectores
(
    idRecolector int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idLogin int NOT NULL,
    nombres varchar(50),
    apellidos varchar(50),
    activo bit NOT NULL
);

CREATE TABLE Logins
(
    idLogin int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    usuario varchar(50) NOT NULL,
    contrasena varchar(64) NOT NULL,
    tipo int NOT NULL,
    activo bit NOT NULL
);

CREATE TABLE Admins
(
    idAdmin int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idLogin int NOT NULL,
    nombres varchar(50),
    apellidos varchar(50),
    activo bit NOT NULL
);

CREATE TABLE BitacoraActividadUsuarios
(
    idBitacoraRecolector int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idLogin int NOT NULL,
    fecha date,
    idAccion int NOT NULL,
    activo bit NOT NULL
);

CREATE TABLE Acciones
(
    idAccion int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    tipo varchar(50) NOT NULL,
    descripcion varchar(100) NOT NULL,
    activo bit NOT NULL
);

ALTER TABLE Recibos
    ADD FOREIGN KEY (idDonante)
    REFERENCES Donantes (idDonante);


ALTER TABLE Recibos
    ADD FOREIGN KEY (idRecolector)
    REFERENCES Recolectores (idRecolector);


ALTER TABLE Recolectores
    ADD FOREIGN KEY (idLogin)
    REFERENCES Logins (idLogin);


ALTER TABLE Admins
    ADD FOREIGN KEY (idLogin)
    REFERENCES Logins (idLogin);


ALTER TABLE BitacoraActividadUsuarios
    ADD FOREIGN KEY (idAccion)
    REFERENCES Acciones (idAccion);


ALTER TABLE BitacoraActividadUsuarios
    ADD FOREIGN KEY (idLogin)
    REFERENCES Logins (idLogin);

END;
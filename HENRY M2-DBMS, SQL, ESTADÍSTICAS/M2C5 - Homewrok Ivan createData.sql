/* """
Comentario
MULTILINEA
IF EXISTS
""" */

DROP DATABASE IF EXISTS henry;
CREATE DATABASE henry;

USE henry; -- Utilizar BD
DROP TABLE IF EXISTS carrera;
CREATE TABLE carrera (
	carreraID INT NOT NULL AUTO_INCREMENT, -- Entero no nulo que se va a incrementar solo
    nombre VARCHAR(20) NOT NULL,
    PRIMARY KEY(carreraID)
);

-- SELECT * FROM carrera; SELECCIONA TODOS LOS DATOS DE carrera

CREATE TABLE instructor (
	instructorID INT NOT NULL AUTO_INCREMENT , 
    cedulaIdentidad VARCHAR(25) NOT NULL,
    nombre VARCHAR(45) NOT NULL,
    apellido VARCHAR(45) NOT NULL,
    fechaNacimiento DATE NOT NULL,
    fechaIncorporacion DATE NOT NULL,
    PRIMARY KEY(instructorID)
);
-- SELECT * FROM instructor;

CREATE TABLE cohorte (
	cohorteID INT NOT NULL AUTO_INCREMENT,
    codigo VARCHAR(45) NOT NULL,
    carreraID INT NOT NULL,
    instructorID INT NOT NULL,
    fechaInicio DATE,
    fechaFinalizacion DATE,
    PRIMARY KEY (cohorteID),
    FOREIGN KEY(carreraID) REFERENCES carrera(carreraID),
    FOREIGN KEY(instructorID) REFERENCES instructor(instructorID)
);
-- SELECT * FROM cohorte;


CREATE TABLE alumno (
	alumnoID INT NOT NULL AUTO_INCREMENT,
    cedulaIdentidad VARCHAR(25) NOT NULL,
    nombre VARCHAR(45) NOT NULL,
    apellido VARCHAR(45) NOT NULL,
    fechaNacimiento DATE NOT NULL,
	fechaIngreso DATE,
    cohorteID INT,
    PRIMARY KEY(alumnoID),
    FOREIGN KEY(cohorteID) REFERENCES cohorte(cohorteID)
);
-- SELECT * FROM alumno;

SHOW TABLES;
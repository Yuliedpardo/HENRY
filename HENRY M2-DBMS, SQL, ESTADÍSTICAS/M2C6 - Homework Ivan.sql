USE HENRY;

-- #2 Inserte los siguientes registros dentro de la base de datos creada en la clase anterior,
-- corregir los errores que impidan la instrucción.

INSERT INTO alumno (idAlumno,cedulaIdentidad,nombre,apellido,fechaNacimiento,fechaIngreso,idCohorte)
VALUES (161,'41944781','Stephanie','Hurst','1986-11-23','2022-02-14',1243),
  (162,'31806976','Nathaniel','Duran','2005-12-02','2022-01-03',1243),
  (163,'9364994K','Shelley','Yang','1984-01-14','2022-01-18',1243),
  (164,'263549317','Donovan','Snow','2008-07-23','2022-02-09',1243),
  (165,'377028562','Regina','Joyce','2002-07-05','2022-02-08',1243),
  (166,'7332238','Hedley','Cameron','2002-06-05','2022-01-12',1243),
  (167,'448157210','Kiayada','Oneil','2009-03-26','2022-02-25',1243),
  (168,'123492919','Aristotle','Adams','2000-09-29','2022-01-18',1243),
  (169,'182865443','Harlan','Barnett','1997-10-19','2022-02-09',1243),
  (170,'389678961','Maya','Dotson','2003-11-28','2022-01-14',1243),
  (171,'152989121','Sean','Hancock','1997-09-21','2022-02-22',1243),
  (172,'507078060','Arthur','Leon','2006-12-01','2022-02-15',1243),
  (173,'72477197','Hakeem','Williams','1988-03-13','2022-01-21',1243),
  (174,'41643293','Nigel','Vincent','2001-10-06','2022-01-31',1243),
  (175,'454734130','Adele','Alston','2005-10-05','2022-01-16',1243),
  (176,'335187784','Mara','Rodgers','2004-03-29','2022-02-13',1243),
  (177,'122874648','Galvin','Jones','2005-11-08','2022-01-06',1243),
  (178,'386395705','Tashya','Clarke','1992-07-02','2022-01-31',1243),
  (179,'402918667','Imani','Mack','2000-07-28','2022-01-29',1243),
  (180,'277347865','William','Long','2009-12-06','2022-02-09',1243);
  
-- #2 No se sabe con certeza el lanzamiento de las cohortes N° 1245 y N° 1246, se solicita que las elimine de la tabla.

DELETE FROM cohorte
WHERE cohorteID IN (1245, 1246);

-- #3 Se ha decidido retrasar el comienzo de la cohorte N°1243, por lo que la nueva fecha de inicio será el 16/05.
-- Se le solicita modificar la fecha de inicio de esos alumnos.

SELECT *
FROM cohorte
WHERE cohorteID = 1243;

UPDATE cohorte
SET fechaInicio = '2022-05-16'
WHERE cohorteID = 1243;

-- 4. El alumno N° 165 solicito el cambio de su Apellido por “Ramirez”.

SELECT *
FROM alumno
WHERE alumnoID = 165;

UPDATE alumno
SET apellido = "Ramirez"
WHERE alumnoID = 165;

-- 5. El área de Learning le solicita un listado de alumnos de la Cohorte N°1243 que incluya la fecha de ingreso.

SELECT *
FROM alumno;

SELECT *
FROM alumno
WHERE cohorteID = 1243;

-- 6. Como parte de un programa de actualización, el área de People le solicita un listado
-- de los instructores que dictan la carrera de Full Stack Developer.

SHOW TABLES;

SELECT *
FROM carrera;

SELECT *
FROM cohorte;

SELECT DISTINCT instructorID			-- muestra valores no duplicados
FROM cohorte
WHERE carreraID = 1;

SELECT *
FROM instructor
WHERE instructorID <= 5;

SELECT DISTINCT instructor.instructorID, instructor.nombre, instructor.apellido
FROM instructor
JOIN cohorte ON (cohorte.instructorID = instructor.instructorID)
JOIN carrera ON (carrera.carreraID = carrera.carreraID)
WHERE carrera.nombre = 'Full Stack Developer';

-- 7. Se desea saber que alumnos formaron parte de la cohorte N° 1235. Elabore un listado.

SELECT *
FROM alumno
WHERE cohorteID = 1235;

-- 8. Del listado anterior se desea saber quienes ingresaron en el año 2019.

SELECT *
FROM alumno
WHERE cohorteID = 1235 AND YEAR(fechaIngreso) = 2019;

-- 9.

SELECT alumno.nombre, alumno.apellido, alumno.fechaNacimiento, carrera.nombre AS nombre_carrera
FROM alumno
JOIN cohorte ON (cohorte.cohorteID = alumno.cohorteID)
JOIN carrera ON (carrera.carreraID = carrera.carreraID)
-- WHERE carrera.nombre = 'Full Stack Developer'; -- OK
-- WHERE carrera.nombre LIKE ('%full stack%'); -- OK
-- WHERE carrera.nombre NOT LIKE ('%Data%');
-- WHERE carrera.nombre != 'Data Science';
WHERE carrera.carreraID = 1;
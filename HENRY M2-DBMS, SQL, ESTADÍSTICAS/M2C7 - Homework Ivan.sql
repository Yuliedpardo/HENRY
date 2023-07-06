-- 1. ¿Cuantas carreas tiene Henry?

USE henry;

SELECT DISTINCT COUNT(*) AS cantCarreras
FROM carrera;

SELECT COUNT(carreraID) AS cantCarreras
FROM carrera;

-- 2. ¿Cuantos alumnos hay en total?

SELECT DISTINCT COUNT(*) AS cantAlumnos
FROM alumno;

SELECT COUNT(alumnoID) AS cantAlumnos
FROM alumno;

-- 3. ¿Cuantos alumnos tiene cada cohorte?

SELECT cohorteID, COUNT(alumnoID) AS cantAlumnos
FROM alumno
GROUP BY cohorteID;

-- 4. Confecciona un listado de los alumnos ordenado por los últimos alumnos que ingresaron, con nombre y apellido en un solo campo.

select concat(nombre," ", apellido) AS nombreAlumno, fechaIngreso
from alumno
order by fechaIngreso;

-- 5. ¿Cual es el nombre del primer alumno que ingreso a Henry?

select *
from alumno
order by fechaIngreso
limit 5;

select concat(nombre," ", apellido) AS nombreCompleto, fechaIngreso
from alumno
where fechaIngreso = (
	select min(fechaIngreso)
    from alumno);

-- 6. ¿En que fecha ingreso?

select fechaIngreso
from alumno
where fechaIngreso = (
	select min(fechaIngreso)
    from alumno);

-- 7. ¿Cual es el nombre del ultimo alumno que ingreso a Henry?

select concat(nombre," ", apellido) AS nombreCompleto, fechaIngreso
from alumno
where fechaIngreso = (
	select max(fechaIngreso)
    from alumno);

-- 8. La función YEAR le permite extraer el año de un campo date, utilice esta función
-- y especifique cuantos alumnos ingresarona a Henry por año.

select year(fechaIngreso) AS anioIngreso, count(fechaIngreso) AS cantAlumnos
from alumno
group by year(fechaIngreso);

-- 9. ¿Cuantos alumnos ingresaron por semana a henry?, indique también el año. WEEKOFYEAR()

select year(fechaIngreso) AS anio, weekofyear(fechaIngreso) AS semana, count(fechaIngreso) AS cantAlumnos
from alumno
group by anio, semana
order by anio, semana;

-- 10. ¿En que años ingresaron más de 20 alumnos?

select year(fechaIngreso) AS anio, count(*) AS cantAlumnos
from alumno
group by anio
having count(fechaIngreso) > 20
order by anio;

-- 11. Investigue las funciones TIMESTAMPDIFF() y CURDATE().
-- ¿Podría utilizarlas para saber cual es la edad de los instructores?.
-- ¿Como podrías verificar si la función cálcula años completos?
-- Utiliza DATE_ADD().

select
	concat(nombre, ' ', apellido) AS nombreCompleto,
    fechaNacimiento,
	timestampdiff(YEAR, fechaNacimiento, curdate()) AS edad,
	date_add(fechaNacimiento,interval timestampdiff(Year,fechaNacimiento, curdate()) year) as verificacion
FROM instructor
ORDER BY fechaNacimiento;


-- 12. Cálcula:
-- - La edad de cada alumno.

SELECT
	concat(nombre, ' ', apellido) AS nombreCompleto,
    timestampdiff(YEAR, fechaNacimiento, curdate()) AS años,
    date_add(fechaNacimiento,interval timestampdiff(Year,fechaNacimiento, curdate()) year) as verificacion
FROM alumno
ORDER BY años;

-- - La edad promedio de los alumnos de henry.

SELECT avg(timestampdiff(YEAR, fechaNacimiento, curdate())) as edad_promedio
FROM alumno;

-- - La edad promedio de los alumnos de cada cohorte.

SELECT idCohorte, avg(timestampdiff(YEAR, fechaNacimiento, curdate())) as edad_promedio
FROM alumno
GROUP BY idCohorte;

-- 13. Elabora un listado de los alumnos que superan la edad promedio de Henry.

SELECT concat(nombre, ' ', apellido) AS nombreCompleto,
		timestampdiff(YEAR, fechaNacimiento, curdate()) AS anios
FROM alumno
WHERE
	timestampdiff(YEAR, fechaNacimiento, curdate()) > (
		SELECT avg(timestampdiff(YEAR, fechaNacimiento, curdate())) AS edad_promedio
		FROM alumno)
ORDER BY anios;
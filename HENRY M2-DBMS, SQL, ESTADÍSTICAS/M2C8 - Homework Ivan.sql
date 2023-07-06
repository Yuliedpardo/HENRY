CREATE DATABASE test;

USE test;

DROP TABLE persona;

CREATE TABLE IF NOT EXISTS persona(
	IdPersona INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(45),
    Edad INT
);

SELECT * FROM persona;

CREATE TABLE IF NOT EXISTS oferta_gastronomica(
	id_local INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    categoria VARCHAR(20),
    direccion VARCHAR(100),
    barrio VARCHAR(50),
    comuna VARCHAR(50)
);

SELECT * FROM oferta_gastronomica;
SELECT count(*) FROM oferta_gastronomica;

#Barrio con más pubs
SELECT categoria, barrio, count(*) as cantidad
FROM oferta_gastronomica
GROUP BY categoria, barrio
HAVING categoria = 'PUB'
ORDER BY cantidad desc;

#Locales por rubro
SELECT categoria, count(*) as cantidad
FROM oferta_gastronomica
GROUP BY categoria
ORDER BY cantidad desc;

#Resto por comuna
SELECT comuna, count(*) as cantidad
from oferta_gastronomica
GROUP BY categoria, comuna
HAVING categoria = 'RESTAURANTE'
ORDER BY cantidad desc;



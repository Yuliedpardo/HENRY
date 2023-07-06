# Ejercicio adicional de volumenes

- Objetivo: 
1) Crear un contenedor (a) de mongodb que use un volumen
2) Eliminar el contenedor
3) Crear otro contenedor (b) que use la informacion persistente del contenedor (a)
4) Verificar que la data es persistente

- Referencia: Pueden tomar como referencia el video del dataft11, M4, clase 2, Code review, 1hr 24min en adelante
- Esto es una variante de la guia que se ofrece en Rise de Docker :)

# Pasos
1. Crear una carpeta para usarla de conexion entre Docker y la maquina anfitrion
	mkdir dockerdata
2. Entrar a la carpeta creada
	cd dockerdata
3. Levantar un contenedor que genere un volumen, este volumen vincula la carpeta "dockerdata" que acabamos de crear con la carpeta "/data/db" en el contenedor
	docker run -d --name mongodb -v "$(pwd)":/data/db mongo:4.0.4
4. Verificar que el contenedor esta prendido
	docker ps
- Se usa la version de mongo 4.0.4 para que el contenedor quede prendido, si no llegasea funcionar se puede intentar con:
	docker run -d --name mongodb -v "$(pwd)":/data/db mongo
	docker run -d --name mongodb -v "$(pwd)":/data/db mongo:4.4
5. Entrar en el contenedor:
	docker exec -it mongodb bash
6. Dentro del contenedor conectarse a la base de datos
	mongo
7. Usar la base de datos prueba, insertar un color y verificar que este insertado
	show dbs (listo las bases de datos)
	use prueba (creo la base “prueba”)
	db.prueba.insert({‘color’: ’azul’}) (inserto un nuevo dato)
	db.prueba.find() (veo el dato que cargué)
8. Salir de mongo y luego del contenedor
	exit
	exit
9. Eliminar el contenedor
	docker rm mongodb
10. Levantar otro contenedor, con el nombre db, que se vincule con la carpeta que anteriormente se levanto
	docker run -d --name db --mount type=bind,source='/home/ubuntu/dockerdata',target='/data/db' mongo:4.0.4
- Usar la misma version que funciono en el paso (4)
11. Entrar en el contenedor que acabamos de levantar
	docker exec -it db bash
12. Entrar a mongo y verificar que tenemos la data que insertamos en el primer contenedor
	mongo
	use prueba
	db.prueba.find()


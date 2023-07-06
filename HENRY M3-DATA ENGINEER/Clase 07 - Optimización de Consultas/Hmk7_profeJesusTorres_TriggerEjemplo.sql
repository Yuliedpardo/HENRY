
DROP TRIGGER audit_alumno;
CREATE TRIGGER Audit_alumno AFTER UPDATE ON alumno -- BEFORE
FOR EACH ROW -- Para cada fila que se inserta en alumno
INSERT INTO auditoria_alumno (descripcion, fecha_y_hora, usuario)
VALUES 
	(concat('Nueva insercion: ', NEW.idAlumno, NEW.nombre,NOW()), 
	-- old o new: update o insert
	NOW(),
	current_user());

-- INSERT INTO nombre_tabla ...
-- INSERT INTO nombre_tabla ...
-- INSERT INTO nombre_tabla ...
-- INSERT INTO nombre_tabla ...
-- INSERT INTO nombre_tabla ...

-- INSERT INTO nombre_tabla 
-- () () () ();

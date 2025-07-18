CREATE TABLE sakilacampus.pais (
    id_pais SMALLINT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(50),
    ultima_actualizacion TIMESTAMP
);

CREATE TABLE sakilacampus.ciudad (
    id_ciudad SMALLINT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(50),
    id_pais SMALLINT UNSIGNED,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_pais) REFERENCES sakilacampus.pais(id_pais)
);

CREATE TABLE sakilacampus.direccion (
    id_direccion SMALLINT UNSIGNED PRIMARY KEY,
    direccion VARCHAR(50),
    direccion2 VARCHAR(50),
    distrito VARCHAR(20),
    id_ciudad SMALLINT UNSIGNED,
    codigo_postal VARCHAR(10),
    telefono VARCHAR(20),
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_ciudad) REFERENCES sakilacampus.ciudad(id_ciudad)
);

CREATE TABLE sakilacampus.idioma (
    id_idioma TINYINT UNSIGNED PRIMARY KEY,
    nombre CHAR(20),
    ultima_actualizacion TIMESTAMP
);

CREATE TABLE sakilacampus.empleado (
    id_empleado TINYINT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    id_direccion SMALLINT UNSIGNED,
    email VARCHAR(50),
    id_almacen TINYINT UNSIGNED,
    activo TINYINT(1),
    username VARCHAR(16),
    password VARCHAR(40),
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_direccion) REFERENCES sakilacampus.direccion(id_direccion)
);

CREATE TABLE sakilacampus.almacen (
    id_almacen TINYINT UNSIGNED PRIMARY KEY,
    id_empleado_jefe TINYINT UNSIGNED,
    id_direccion SMALLINT UNSIGNED,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_empleado_jefe) REFERENCES sakilacampus.empleado(id_empleado),
    FOREIGN KEY (id_direccion) REFERENCES sakilacampus.direccion(id_direccion)
);

CREATE TABLE sakilacampus.cliente (
    id_cliente SMALLINT UNSIGNED PRIMARY KEY,
    id_almacen TINYINT UNSIGNED,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    email VARCHAR(50),
    id_direccion SMALLINT UNSIGNED,
    activo TINYINT(1),
    fecha_creacion DATETIME,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_almacen) REFERENCES sakilacampus.almacen(id_almacen),
    FOREIGN KEY (id_direccion) REFERENCES sakilacampus.direccion(id_direccion)
);

CREATE TABLE sakilacampus.actor (
    id_actor SMALLINT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    ultima_actualizacion TIMESTAMP
);

CREATE TABLE sakilacampus.categoria (
    id_categoria TINYINT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(25),
    ultima_actualizacion TIMESTAMP
);

CREATE TABLE sakilacampus.pelicula (
    id_pelicula SMALLINT UNSIGNED PRIMARY KEY,
    titulo VARCHAR(255),
    descripcion TEXT,
    anio_lanzamiento YEAR,
    id_idioma TINYINT UNSIGNED,
    id_idioma_original TINYINT UNSIGNED,
    duracion_alquiler TINYINT UNSIGNED,
    rental_rate DECIMAL(4,2),
    duracion SMALLINT UNSIGNED,
    replacement_cost DECIMAL(5,2),
    clasificacion ENUM('G','PG','PG-13','R','NC-17'),
    caracteristicas_especiales SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes'),
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_idioma) REFERENCES sakilacampus.idioma(id_idioma),
    FOREIGN KEY (id_idioma_original) REFERENCES sakilacampus.idioma(id_idioma)
);

CREATE TABLE sakilacampus.inventario (
    id_inventario MEDIUMINT UNSIGNED PRIMARY KEY,
    id_pelicula SMALLINT UNSIGNED,
    id_almacen TINYINT UNSIGNED,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_pelicula) REFERENCES sakilacampus.pelicula(id_pelicula),
    FOREIGN KEY (id_almacen) REFERENCES sakilacampus.almacen(id_almacen)
);

CREATE TABLE sakilacampus.pelicula_actor (
    id_pelicula SMALLINT UNSIGNED,
    id_actor SMALLINT UNSIGNED,
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY (id_pelicula, id_actor),
    FOREIGN KEY (id_pelicula) REFERENCES sakilacampus.pelicula(id_pelicula),
    FOREIGN KEY (id_actor) REFERENCES sakilacampus.actor(id_actor)
);

CREATE TABLE sakilacampus.pelicula_categoria (
    id_pelicula SMALLINT UNSIGNED,
    id_categoria TINYINT UNSIGNED,
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY (id_pelicula, id_categoria),
    FOREIGN KEY (id_pelicula) REFERENCES sakilacampus.pelicula(id_pelicula),
    FOREIGN KEY (id_categoria) REFERENCES sakilacampus.categoria(id_categoria)
);

CREATE TABLE sakilacampus.alquiler (
    id_alquiler INT PRIMARY KEY,
    fecha_alquiler DATETIME,
    id_inventario MEDIUMINT UNSIGNED,
    id_cliente SMALLINT UNSIGNED,
    fecha_devolucion DATETIME,
    id_empleado TINYINT UNSIGNED,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_inventario) REFERENCES sakilacampus.inventario(id_inventario),
    FOREIGN KEY (id_cliente) REFERENCES sakilacampus.cliente(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES sakilacampus.empleado(id_empleado)
);

CREATE TABLE sakilacampus.pago (
    id_pago SMALLINT UNSIGNED PRIMARY KEY,
    id_cliente SMALLINT UNSIGNED,
    id_empleado TINYINT UNSIGNED,
    id_alquiler INT,
    total DECIMAL(5,2),
    fecha_pago DATETIME,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES sakilacampus.cliente(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES sakilacampus.empleado(id_empleado),
    FOREIGN KEY (id_alquiler) REFERENCES sakilacampus.alquiler(id_alquiler)
);

CREATE TABLE sakilacampus.film_text (
    film_id SMALLINT PRIMARY KEY,
    title VARCHAR(255),
    description TEXT
);

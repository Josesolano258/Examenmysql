--Funciones SQL:

--Desarrolla las siguientes funciones:


-- 1.TotalIngresosCliente(ClienteID, Año): Calcula los ingresos generados por un cliente en un año específico.

DELIMITER $$

CREATE FUNCTION TotalIngresosCliente(cliente_id INT, anio INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10,2);

  SELECT SUM(p.total) INTO total
  FROM pago p
  WHERE p.id_cliente = cliente_id
    AND YEAR(p.fecha_pago) = anio;

  RETURN IFNULL(total, 0);
END$$

DELIMITER ;


-- 2.PromedioDuracionAlquiler(PeliculaID): Retorna la duración promedio de alquiler de una película específica.

DELIMITER $$

CREATE FUNCTION PromedioDuracionAlquiler(pelicula_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE promedio DECIMAL(10,2);

  SELECT AVG(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) INTO promedio
  FROM alquiler a
  JOIN inventario i ON a.id_inventario = i.id_inventario
  WHERE i.id_pelicula = pelicula_id
    AND a.fecha_devolucion IS NOT NULL;

  RETURN IFNULL(promedio, 0);
END$$

DELIMITER ;


-- 3.IngresosPorCategoria(CategoriaID): Calcula los ingresos totales generados por una categoría específica de películas.

DELIMITER $$

CREATE FUNCTION IngresosPorCategoria(categoria_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10,2);

  SELECT SUM(p.total) INTO total
  FROM pago p
  JOIN alquiler a ON p.id_alquiler = a.id_alquiler
  JOIN inventario i ON a.id_inventario = i.id_inventario
  JOIN pelicula_categoria pc ON i.id_pelicula = pc.id_pelicula
  WHERE pc.id_categoria = categoria_id;

  RETURN IFNULL(total, 0);
END$$

DELIMITER ;


-- 4.DescuentoFrecuenciaCliente(ClienteID): Calcula un descuento basado en la frecuencia de alquiler del cliente.

DELIMITER $$

CREATE FUNCTION DescuentoFrecuenciaCliente(cliente_id INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
  DECLARE cantidad INT;
  DECLARE descuento DECIMAL(5,2);

  SELECT COUNT(*) INTO cantidad
  FROM alquiler
  WHERE id_cliente = cliente_id;

  SET descuento = 
    CASE
      WHEN cantidad > 100 THEN 0.15
      WHEN cantidad > 50 THEN 0.10
      WHEN cantidad > 20 THEN 0.05
      ELSE 0.00
    END;

  RETURN descuento;
END$$

DELIMITER ;


-- 5.EsClienteVIP(ClienteID): Verifica si un cliente es "VIP" basándose en la cantidad de alquileres realizados y los ingresos generados.

DELIMITER $$

CREATE FUNCTION EsClienteVIP(cliente_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  DECLARE cantidad INT;
  DECLARE ingresos DECIMAL(10,2);

  SELECT COUNT(*) INTO cantidad
  FROM alquiler
  WHERE id_cliente = cliente_id;

  SELECT SUM(total) INTO ingresos
  FROM pago
  WHERE id_cliente = cliente_id;

  RETURN (cantidad > 100 AND IFNULL(ingresos, 0) > 500);
END$$

DELIMITER ;


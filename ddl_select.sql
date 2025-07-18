--Consultas SQL:

--Realiza las siguientes consultas en SQL relacionadas con el sistema de alquiler de películas:

-- 1. Cliente con más alquileres en los últimos 6 meses
-- Sirve para ver quién ha estado más activo recientemente.
SELECT 
    c.id_cliente,
    c.nombre,
    c.apellidos,
    COUNT(a.id_alquiler) AS cantidad_alquileres
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
WHERE a.fecha_alquiler >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
GROUP BY c.id_cliente
ORDER BY cantidad_alquileres DESC
LIMIT 1;

-- 2. Top 5 películas más alquiladas en el último año
-- Me ayuda a saber cuáles pelis son las más populares.
SELECT 
    p.titulo,
    COUNT(a.id_alquiler) AS veces_alquilada
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
WHERE a.fecha_alquiler >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
GROUP BY p.id_pelicula
ORDER BY veces_alquilada DESC
LIMIT 5;

-- 3. Ingresos y cantidad de alquileres por categoría
-- Para ver qué categorías están dejando más plata y movimiento.
SELECT 
    cat.nombre AS categoria,
    COUNT(alq.id_alquiler) AS total_alquileres,
    SUM(pago.total) AS ingresos_totales
FROM categoria cat
JOIN pelicula_categoria pc ON cat.id_categoria = pc.id_categoria
JOIN pelicula p ON pc.id_pelicula = p.id_pelicula
JOIN inventario i ON p.id_pelicula = i.id_pelicula
JOIN alquiler alq ON i.id_inventario = alq.id_inventario
JOIN pago ON alq.id_alquiler = pago.id_alquiler
GROUP BY cat.id_categoria, cat.nombre
ORDER BY ingresos_totales DESC;

-- 4. Clientes por idioma en un mes específico
-- Cuántos clientes alquilaron pelis por idioma en junio de 2025.
SELECT 
    i.nombre AS idioma,
    COUNT(DISTINCT a.id_cliente) AS total_clientes
FROM alquiler a
JOIN inventario inv ON a.id_inventario = inv.id_inventario
JOIN pelicula p ON inv.id_pelicula = p.id_pelicula
JOIN idioma i ON p.id_idioma = i.id_idioma
WHERE MONTH(a.fecha_alquiler) = 6
  AND YEAR(a.fecha_alquiler) = 2025
GROUP BY i.id_idioma, i.nombre
ORDER BY total_clientes DESC;

-- 5. Clientes que alquilaron todas las pelis de una categoría
-- Muy útil para detectar fans leales de una categoría específica.
SELECT 
    c.id_cliente,
    c.nombre,
    c.apellidos,
    cat.nombre AS categoria
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
JOIN pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
GROUP BY c.id_cliente, cat.id_categoria
HAVING COUNT(DISTINCT p.id_pelicula) = (
    SELECT COUNT(*) 
    FROM pelicula_categoria 
    WHERE id_categoria = cat.id_categoria
)
ORDER BY categoria, c.apellidos, c.nombre;

-- 6. Ciudades con más clientes activos en los últimos 3 meses
-- Para saber dónde está la mayor cantidad de movimiento reciente.
SELECT 
    ciu.nombre AS ciudad,
    COUNT(DISTINCT c.id_cliente) AS clientes_activos
FROM cliente c
JOIN direccion d ON c.id_direccion = d.id_direccion
JOIN ciudad ciu ON d.id_ciudad = ciu.id_ciudad
JOIN alquiler a ON c.id_cliente = a.id_cliente
WHERE a.fecha_alquiler >= DATE_SUB(NOW(), INTERVAL 3 MONTH)
  AND c.activo = 1
GROUP BY ciu.id_ciudad
ORDER BY clientes_activos DESC
LIMIT 3;

-- 7. Categorías con menos alquileres en el último año
-- Ideal para detectar categorías poco rentables o poco vistas.
SELECT 
    cat.nombre AS categoria,
    COUNT(alq.id_alquiler) AS total_alquileres
FROM categoria cat
JOIN pelicula_categoria pc ON cat.id_categoria = pc.id_categoria
JOIN pelicula p ON pc.id_pelicula = p.id_pelicula
JOIN inventario i ON p.id_pelicula = i.id_pelicula
JOIN alquiler alq ON i.id_inventario = alq.id_inventario
WHERE alq.fecha_alquiler >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
GROUP BY cat.id_categoria, cat.nombre
ORDER BY total_alquileres ASC
LIMIT 5;

-- 8. Promedio de días que tarda un cliente en devolver una película
-- Útil para medir responsabilidad o eficiencia de retorno.
SELECT 
    c.id_cliente,
    c.nombre,
    c.apellidos,
    ROUND(AVG(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)), 2) AS promedio_dias_retorno
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
WHERE a.fecha_devolucion IS NOT NULL
GROUP BY c.id_cliente, c.nombre, c.apellidos
ORDER BY promedio_dias_retorno DESC;

-- 9. Empleados con más alquileres en la categoría 'Acción'
-- Esto me deja ver quiénes promueven más esta categoría.
SELECT 
    e.id_empleado,
    e.nombre,
    e.apellidos,
    COUNT(alq.id_alquiler) AS total_alquileres
FROM alquiler alq
JOIN inventario i ON alq.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
JOIN pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
JOIN categoria c ON pc.id_categoria = c.id_categoria
JOIN empleado e ON alq.id_empleado = e.id_empleado
WHERE c.nombre = 'Acción'
GROUP BY e.id_empleado, e.nombre, e.apellidos
ORDER BY total_alquileres DESC
LIMIT 5;

-- 10. Informe de clientes más frecuentes en alquileres
-- Un ranking de los que más alquilan.
SELECT 
    c.id_cliente,
    c.nombre,
    c.apellidos,
    COUNT(a.id_alquiler) AS total_alquileres
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
GROUP BY c.id_cliente, c.nombre, c.apellidos
ORDER BY total_alquileres DESC;



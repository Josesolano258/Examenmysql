-- 1.Encuentra el cliente que ha realizado la mayor cantidad de alquileres en los últimos 6 meses.

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

-- 2.Lista las cinco películas más alquiladas durante el último año.

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


-- 3.Obtén el total de ingresos y la cantidad de alquileres realizados por cada categoría de película.

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

-- 4.Calcula el número total de clientes que han realizado alquileres por cada idioma disponible en un mes específico.

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


-- 5.Encuentra a los clientes que han alquilado todas las películas de una misma categoría.

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


-- 6.Lista las tres ciudades con más clientes activos en el último trimestre.

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


-- 7.Muestra las cinco categorías con menos alquileres registrados en el último año.

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


-- 8.Calcula el promedio de días que un cliente tarda en devolver las películas alquiladas.

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


-- 9.Encuentra los cinco empleados que gestionaron más alquileres en la categoría de Acción.

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


-- 10.Genera un informe de los clientes con alquileres más recurrentes.

SELECT 
    c.id_cliente,
    c.nombre,
    c.apellidos,
    COUNT(a.id_alquiler) AS total_alquileres
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
GROUP BY c.id_cliente, c.nombre, c.apellidos
ORDER BY total_alquileres DESC;


-- 11.Calcula el costo promedio de alquiler por idioma de las películas.

SELECT 
    i.nombre AS idioma,
    ROUND(AVG(p.rental_rate), 2) AS costo_promedio
FROM pelicula p
JOIN idioma i ON p.id_idioma = i.id_idioma
GROUP BY i.nombre
ORDER BY costo_promedio DESC;


-- 12.Lista las cinco películas con mayor duración alquiladas en el último año.

SELECT 
    p.titulo,
    p.duracion AS duracion_minutos,
    MAX(a.fecha_alquiler) AS ultima_vez_alquilada
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY p.id_pelicula
ORDER BY p.duracion DESC
LIMIT 5;


-- 13.Muestra los clientes que más alquilaron películas de Comedia.

SELECT 
    c.id_cliente,
    CONCAT(c.nombre, ' ', c.apellidos) AS cliente,
    COUNT(*) AS total_alquileres_comedia
FROM alquiler a
JOIN cliente c ON a.id_cliente = c.id_cliente
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
JOIN pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
WHERE cat.nombre = 'Comedia'
GROUP BY c.id_cliente
ORDER BY total_alquileres_comedia DESC
LIMIT 10;


-- 14.Encuentra la cantidad total de días alquilados por cada cliente en el último mes.

SELECT 
    c.id_cliente,
    CONCAT(c.nombre, ' ', c.apellidos) AS cliente,
    SUM(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) AS total_dias_alquilados
FROM alquiler a
JOIN cliente c ON a.id_cliente = c.id_cliente
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
  AND a.fecha_devolucion IS NOT NULL
GROUP BY c.id_cliente
ORDER BY total_dias_alquilados DESC;


-- 15.Muestra el número de alquileres diarios en cada almacén durante el último trimestre.

SELECT 
    a.id_almacen,
    DATE(alq.fecha_alquiler) AS fecha,
    COUNT(*) AS total_alquileres
FROM alquiler alq
JOIN inventario inv ON alq.id_inventario = inv.id_inventario
JOIN almacen a ON inv.id_almacen = a.id_almacen
WHERE alq.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY a.id_almacen, fecha
ORDER BY fecha, a.id_almacen;


-- 16.Calcula los ingresos totales generados por cada almacén en el último semestre.

SELECT a.id_almacen,
       SUM(p.total) AS ingresos_totales
FROM pago p
JOIN alquiler alq ON p.id_alquiler = alq.id_alquiler
JOIN inventario i ON alq.id_inventario = i.id_inventario
JOIN almacen a ON i.id_almacen = a.id_almacen
WHERE p.fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY a.id_almacen
ORDER BY ingresos_totales DESC;


-- 17.Encuentra el cliente que ha realizado el alquiler más caro en el último año.

SELECT c.id_cliente,
       c.nombre,
       c.apellidos,
       p.total AS monto_maximo,
       p.fecha_pago
FROM pago p
JOIN cliente c ON p.id_cliente = c.id_cliente
WHERE p.fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY p.total DESC
LIMIT 1;


-- 18.Lista las cinco categorías con más ingresos generados durante los últimos tres meses.


SELECT cat.nombre AS categoria,
       SUM(p.total) AS ingresos_totales
FROM pago p
JOIN alquiler a ON p.id_alquiler = a.id_alquiler
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula_categoria pc ON i.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
WHERE p.fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY cat.id_categoria
ORDER BY ingresos_totales DESC
LIMIT 5;

-- 19.Obtén la cantidad de películas alquiladas por cada idioma en el último mes.

SELECT i.nombre AS idioma,
       COUNT(*) AS total_alquileres
FROM alquiler a
JOIN inventario inv ON a.id_inventario = inv.id_inventario
JOIN pelicula p ON inv.id_pelicula = p.id_pelicula
JOIN idioma i ON p.id_idioma = i.id_idioma
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY i.id_idioma
ORDER BY total_alquileres DESC;


-- 20.Lista los clientes que no han realizado ningún alquiler en el último año.

SELECT c.id_cliente, c.nombre, c.apellidos, c.email
FROM cliente c
LEFT JOIN alquiler a ON c.id_cliente = a.id_cliente 
                      AND a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
WHERE a.id_alquiler IS NULL;

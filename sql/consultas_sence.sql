


-- Requerimiento 1: Inversión efectiva en capacitaciones aprobadas
SELECT 
    e.nombre,
    d.nombre_departamento,
    c.nombre_curso,
    ca.costo_total
FROM fact_capacitaciones ca 
JOIN dim_empleados e ON ca.id_empleado = e.id_empleado
JOIN dim_departamentos d ON e.id_departamento = d.id_departamento 
JOIN dim_cursos c ON ca.id_curso = c.id_curso
WHERE ca.estado_curso = 'Aprobado';

-- Requerimiento 2: Resumen de gasto y empleados únicos por departamento
SELECT 
    d.nombre_departamento AS departamento,
    COUNT(DISTINCT e.id_empleado) AS cantidad_empleados,
    SUM(ca.costo_total) AS total
FROM dim_empleados e
JOIN dim_departamentos d ON d.id_departamento = e.id_departamento
JOIN fact_capacitaciones ca ON ca.id_empleado = e.id_empleado
WHERE ca.estado_curso = 'Aprobado'
GROUP BY d.id_departamento
ORDER BY total DESC;

-- Requerimiento 3: Cobertura SENCE y Costo Neto Empresa por Departamento
SELECT 
    d.nombre_departamento,
    SUM(ca.costo_total) AS total_costo,
    SUM(ca.cobertura_sence) AS total_sence,
    SUM(ca.costo_total - ca.cobertura_sence) AS `Costo Neto pagado por la Empresa`
FROM fact_capacitaciones ca
JOIN dim_empleados e ON e.id_empleado = ca.id_empleado
JOIN dim_departamentos d ON d.id_departamento = e.id_departamento
GROUP BY d.nombre_departamento
ORDER BY SUM(ca.costo_total - ca.cobertura_sence) DESC;

-- Requerimiento 4: Eficiencia y Tasa de Aprobación por Curso
SELECT 
    c.nombre_curso,
    COUNT(ca.id_registro) AS `total de postulaciones`,
    SUM(CASE WHEN ca.estado_curso = 'Aprobado' THEN 1 ELSE 0 END) AS `total de aprobados`,
    SUM(ca.costo_total) AS `costo total`
FROM dim_cursos c
JOIN fact_capacitaciones ca ON c.id_curso = ca.id_curso
GROUP BY c.id_curso
ORDER BY COUNT(ca.id_registro) DESC;

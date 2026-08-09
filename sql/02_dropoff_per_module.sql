-- Tujuan: Menghitung drop-off rate per urutan modul (module_order)
-- Business Question #8

WITH module_reach AS (
    SELECT
        m.module_order,
        p.enrollment_id,
        p.status
    FROM fact_progress p
    JOIN dim_modules m ON p.module_id = m.module_id
)
SELECT
    module_order,
    COUNT(DISTINCT enrollment_id) AS reached,
    COUNT(DISTINCT CASE WHEN status = 'completed' THEN enrollment_id END) AS completed,
    ROUND(
        100.0 * (COUNT(DISTINCT enrollment_id) - COUNT(DISTINCT CASE WHEN status = 'completed' THEN enrollment_id END))
        / COUNT(DISTINCT enrollment_id), 1
    ) AS dropoff_rate_pct
FROM module_reach
GROUP BY module_order
ORDER BY module_order;

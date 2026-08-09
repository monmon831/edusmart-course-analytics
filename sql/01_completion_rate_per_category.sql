-- Tujuan: Menghitung completion rate per kategori kursus
-- Business Question #7

WITH enrollment_completion AS (
    SELECT
        e.enrollment_id,
        e.course_id,
        c.category,
        COUNT(DISTINCT CASE WHEN p.status = 'completed' THEN p.module_id END) AS completed_modules,
        c.total_modules
    FROM fact_enrollments e
    JOIN dim_courses c ON e.course_id = c.course_id
    LEFT JOIN fact_progress p ON e.enrollment_id = p.enrollment_id
    GROUP BY e.enrollment_id, e.course_id, c.category, c.total_modules
)
SELECT
    category,
    COUNT(*) AS total_enrollment,
    SUM(CASE WHEN completed_modules >= total_modules THEN 1 ELSE 0 END) AS total_completed,
    ROUND(100.0 * SUM(CASE WHEN completed_modules >= total_modules THEN 1 ELSE 0 END) / COUNT(*), 1) AS completion_rate_pct
FROM enrollment_completion
GROUP BY category
ORDER BY completion_rate_pct ASC;

-- Tujuan: Identifikasi kursus dengan enrollment tinggi tapi completion rate rendah
-- Business Question #16 & #19

WITH course_stats AS (
    SELECT
        c.course_id,
        c.course_name,
        c.category,
        COUNT(DISTINCT e.enrollment_id) AS total_enrollment,
        COUNT(DISTINCT CASE
            WHEN sub.completed_modules >= c.total_modules THEN e.enrollment_id
        END) AS total_completed
    FROM dim_courses c
    JOIN fact_enrollments e ON c.course_id = e.course_id
    LEFT JOIN (
        SELECT enrollment_id, COUNT(DISTINCT module_id) AS completed_modules
        FROM fact_progress
        WHERE status = 'completed'
        GROUP BY enrollment_id
    ) sub ON e.enrollment_id = sub.enrollment_id
    GROUP BY c.course_id, c.course_name, c.category, c.total_modules
)
SELECT
    course_id,
    course_name,
    category,
    total_enrollment,
    total_completed,
    ROUND(100.0 * total_completed / total_enrollment, 1) AS completion_rate_pct
FROM course_stats
WHERE total_enrollment >= (SELECT AVG(total_enrollment) FROM course_stats)  -- hanya kursus dengan demand di atas rata-rata
ORDER BY completion_rate_pct ASC
LIMIT 10;

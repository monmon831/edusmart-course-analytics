-- Tujuan: Menghitung korelasi antara rating instruktur dan completion rate kursus mereka
-- Business Question #11

WITH enrollment_completion AS (
    SELECT
        e.enrollment_id,
        c.instructor_id,
        COUNT(DISTINCT CASE WHEN p.status = 'completed' THEN p.module_id END) AS completed_modules,
        c.total_modules
    FROM fact_enrollments e
    JOIN dim_courses c ON e.course_id = c.course_id
    LEFT JOIN fact_progress p ON e.enrollment_id = p.enrollment_id
    GROUP BY e.enrollment_id, c.instructor_id, c.total_modules
),
instructor_stats AS (
    SELECT
        ec.instructor_id,
        COUNT(*) AS total_enrollment,
        ROUND(100.0 * SUM(CASE WHEN ec.completed_modules >= ec.total_modules THEN 1 ELSE 0 END) / COUNT(*), 1) AS completion_rate_pct,
        (SELECT ROUND(AVG(r.rating), 2)
         FROM fact_reviews r
         JOIN fact_enrollments e2 ON r.enrollment_id = e2.enrollment_id
         JOIN dim_courses c2 ON e2.course_id = c2.course_id
         WHERE c2.instructor_id = ec.instructor_id) AS avg_rating,
        (SELECT COUNT(*)
         FROM fact_reviews r
         JOIN fact_enrollments e2 ON r.enrollment_id = e2.enrollment_id
         JOIN dim_courses c2 ON e2.course_id = c2.course_id
         WHERE c2.instructor_id = ec.instructor_id) AS total_review
    FROM enrollment_completion ec
    GROUP BY ec.instructor_id
)
SELECT
    instructor_id,
    total_enrollment,
    completion_rate_pct,
    avg_rating,
    total_review
FROM instructor_stats
WHERE total_enrollment >= 10
  AND total_review >= 5
ORDER BY completion_rate_pct ASC;

-- Query di atas menghasilkan data mentah (avg_rating vs completion_rate_pct) per instruktur.
-- Koefisien korelasi Pearson dihitung dari hasil query ini:

WITH enrollment_completion AS (
    SELECT
        e.enrollment_id,
        c.instructor_id,
        COUNT(DISTINCT CASE WHEN p.status = 'completed' THEN p.module_id END) AS completed_modules,
        c.total_modules
    FROM fact_enrollments e
    JOIN dim_courses c ON e.course_id = c.course_id
    LEFT JOIN fact_progress p ON e.enrollment_id = p.enrollment_id
    GROUP BY e.enrollment_id, c.instructor_id, c.total_modules
),
instructor_stats AS (
    SELECT
        ec.instructor_id,
        COUNT(*) AS total_enrollment,
        100.0 * SUM(CASE WHEN ec.completed_modules >= ec.total_modules THEN 1 ELSE 0 END) / COUNT(*) AS completion_rate_pct,
        (SELECT AVG(r.rating)
         FROM fact_reviews r
         JOIN fact_enrollments e2 ON r.enrollment_id = e2.enrollment_id
         JOIN dim_courses c2 ON e2.course_id = c2.course_id
         WHERE c2.instructor_id = ec.instructor_id) AS avg_rating,
        (SELECT COUNT(*)
         FROM fact_reviews r
         JOIN fact_enrollments e2 ON r.enrollment_id = e2.enrollment_id
         JOIN dim_courses c2 ON e2.course_id = c2.course_id
         WHERE c2.instructor_id = ec.instructor_id) AS total_review
    FROM enrollment_completion ec
    GROUP BY ec.instructor_id
),
filtered AS (
    SELECT avg_rating, completion_rate_pct
    FROM instructor_stats
    WHERE total_enrollment >= 10 AND total_review >= 5
)
SELECT
    (COUNT(*) * SUM(avg_rating * completion_rate_pct) - SUM(avg_rating) * SUM(completion_rate_pct)) /
    (SQRT(COUNT(*) * SUM(avg_rating * avg_rating) - SUM(avg_rating) * SUM(avg_rating)) *
     SQRT(COUNT(*) * SUM(completion_rate_pct * completion_rate_pct) - SUM(completion_rate_pct) * SUM(completion_rate_pct)))
    AS korelasi_pearson,
    COUNT(*) AS jumlah_instruktur
FROM filtered;

-- Hasil: korelasi_pearson = -0.008 (praktis nol), n = 60 instruktur.
-- Divalidasi silang dengan Python (scipy.stats.pearsonr) di notebooks/04_correlation_analysis.ipynb,
-- hasil identik dengan tambahan p-value = 0.9518 (tidak signifikan secara statistik).
-- Kesimpulan: tidak ada korelasi antara rating instruktur dan completion rate kursus mereka.

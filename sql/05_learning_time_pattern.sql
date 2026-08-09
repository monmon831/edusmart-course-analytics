-- Tujuan: Mengidentifikasi jam dan hari dengan aktivitas belajar tertinggi
-- Business Question #12

SELECT
    DAYNAME(access_timestamp) AS day_name,
    DAYOFWEEK(access_timestamp) AS day_order,
    HOUR(access_timestamp) AS hour_of_day,
    COUNT(*) AS total_access
FROM fact_progress
WHERE access_timestamp IS NOT NULL
GROUP BY DAYNAME(access_timestamp), DAYOFWEEK(access_timestamp), HOUR(access_timestamp)
ORDER BY day_order, hour_of_day;

-- Ringkasan: 15 kombinasi jam-hari dengan aktivitas tertinggi
SELECT
    DAYNAME(access_timestamp) AS day_name,
    HOUR(access_timestamp) AS hour_of_day,
    COUNT(*) AS total_access
FROM fact_progress
WHERE access_timestamp IS NOT NULL
GROUP BY DAYNAME(access_timestamp), HOUR(access_timestamp)
ORDER BY total_access DESC
LIMIT 15;

-- Catatan: 688 baris dengan access_timestamp NULL dikecualikan (di-flag
-- has_access_time=False pada proses cleaning, tidak punya info jam akses yang valid).
--
-- Hasil: pola konsisten dan jelas --
-- Hari kerja (Senin-Jumat): puncak akses di 19.00-22.00 (700+ akses/jam)
-- dan jam istirahat siang 12.00-13.00 (320-400 akses/jam).
-- Akhir pekan (Sabtu-Minggu): lebih merata di 09.00-16.00 (400-500 akses/jam).
-- Dini hari (00.00-05.00): aktivitas sangat rendah di semua hari.
-- Rekomendasi: kirim notifikasi/reminder di jam 19.00-22.00 pada hari kerja;
-- untuk akhir pekan, jendela lebih fleksibel (09.00-16.00).

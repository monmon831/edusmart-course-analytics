# Business Questions — EduSmart Course Performance Analysis

20 pertanyaan bisnis, disusun berjenjang dari deskriptif dasar hingga strategis, dikaitkan dengan tabel dataset yang relevan.

**Status:** ✅ 20/20 terjawab. Level 1-3 (17 pertanyaan) terjawab lengkap dengan data kuantitatif. Level 4 (3 pertanyaan) sebagian bersifat rekomendasi kualitatif berbasis temuan, karena keterbatasan data (tidak ada informasi cost/margin aktual untuk proyeksi finansial presisi).

---

## Level 1 — Deskriptif Dasar

**1. Berapa total user, total kursus, dan total enrollment yang tercatat di platform saat ini?**
✅ 2.000 user, 300 kursus, 7.947 enrollment. (`docs/data_dictionary.md`, dashboard halaman Overview)

**2. Kategori kursus apa yang memiliki jumlah kursus terbanyak?**
✅ Photography (43 kursus), diikuti Business (42) dan Data Science/Marketing (40 masing-masing). Distribusi antar kategori relatif merata (30-43 kursus per kategori).

**3. Berapa rata-rata rating yang diberikan user untuk seluruh kursus?**
✅ 4.15 dari skala 5. Distribusi condong ke rating tinggi (4-5).

**4. Berapa jumlah user yang berstatus "active" vs "inactive"?**
✅ Active: 1.617 (80.8%), Inactive: 383 (19.2%). Catatan penting: status ini TIDAK mencerminkan aktivitas belajar riil (lihat temuan #17 di `reports/key_findings.md`).

**5. Kursus mana dengan jumlah enrollment tertinggi dan terendah?**
✅ Dianalisis di tingkat kategori (Business & Photography tertinggi ~1.150 enrollment) dan tingkat kursus individual (`sql/03_top_priority_courses.sql`).

---

## Level 2 — Diagnostik

**6. Berapa completion rate keseluruhan platform?**
✅ 28.74% (2.284 dari 7.947 enrollment).

**7. Bagaimana completion rate berbeda antar kategori kursus?**
✅ Rentang 26.65% (Programming, terendah) – 31.92% (Photography, tertinggi). Gap antar kategori relatif sempit (~5 poin), menunjukkan masalah bersifat platform-wide.

**8. Modul ke berapa yang paling sering menjadi titik drop-off?**
✅ Drop-off meningkat tajam di modul-modul akhir: modul 9 (25.46%), modul 10 (35.52%), modul 11 (51.16%) — bukan di modul awal seperti dugaan umum.

**9. Apakah ada perbedaan completion rate antara level Beginner/Intermediate/Advanced?**
✅ Advanced sedikit lebih rendah (27.24%) dibanding Beginner (29.48%) dan Intermediate (29.52%).

**10. Instruktur mana yang kursusnya memiliki completion rate tertinggi dan terendah?**
✅ Tertinggi: Jelita Sihotang (37.50%). Terendah: Elisa Handayani (20.55%). Gap antar instruktur (~17 poin) jauh lebih lebar dari gap antar kategori.

---

## Level 3 — Analisis Pola & Korelasi

**11. Apakah ada korelasi antara rating instruktur/kursus dengan completion rate?**
✅ Tidak ada. Korelasi Pearson r = -0.008, p-value = 0.9518 (tidak signifikan secara statistik). Divalidasi silang lewat SQL dan Python.

**12. Jam berapa dan hari apa user paling aktif mengakses materi belajar?**
✅ Hari kerja: puncak 19.00-22.00 dan 12.00-13.00. Akhir pekan: lebih merata 09.00-16.00. Dini hari (00.00-05.00) sepi di semua hari.

**13. Apakah kecepatan progress minggu pertama bisa memprediksi completion?**
✅ Ya. Completer rata-rata menyelesaikan 1.13 modul di minggu pertama; non-completer rata-rata 0.60 modul (median = 0).

**14. Apakah sumber akuisisi (organic/promo/referral/ads) berpengaruh terhadap completion rate?**
✅ Ya, meski gap tidak besar. Organic tertinggi (30.22%), ads terendah (27.64%).

**15. Berapa rata-rata time-to-dropoff, dan apakah berbeda per kategori?**
✅ Rentang 23.8 hari (Data Science, tercepat) – 31.9 hari (Language, terlama).

---

## Level 4 — Strategis & Actionable

**16. Kursus mana yang demand tinggi tapi completion rate rendah — prioritas revisi?**
✅ "Data Analysis dengan Python - Batch 2" (16.22%) dan "Financial Analysis untuk Manajer" (21.05%) sebagai prioritas berbasis completion rate murni. Lihat juga jawaban #19 untuk versi yang mempertimbangkan revenue.

**17. Apakah ada pola karakteristik user (kota, usia, gender, waktu belajar) yang berkorelasi dengan completion?**
✅ Tidak ada pola signifikan. Gender (28.71% vs 28.77%), kelompok usia (25.54%-29.65%), dan kota (27.87%-30.52%) semuanya berada dalam rentang sempit mendekati rata-rata platform. Implikasi: segmentasi campaign berbasis demografi kemungkinan tidak efektif — faktor perilaku (kecepatan progress, instruktur, drop-off modul akhir) jauh lebih berpengaruh daripada siapa penggunanya.

**18. Jenis intervensi apa yang paling berpotensi menaikkan completion rate?**
🔶 Terjawab secara kualitatif di `reports/recommendations.md` — early warning system untuk minggu pertama dan revisi struktur modul akhir adalah dua intervensi dengan dasar data paling kuat. Tidak ada data historis intervensi yang sudah pernah dijalankan, sehingga efektivitasnya belum bisa diukur secara kuantitatif (butuh A/B testing setelah implementasi).

**19. Kursus mana yang harus diprioritaskan berdasarkan revenue impact, jumlah user terdampak, dan completion rate?**
✅ Dengan mempertimbangkan estimasi revenue (price × enrollment), tiga kursus prioritas tertinggi: "Entrepreneurship Fundamentals" (estimasi revenue ~Rp18 juta, completion rate 13.89%, 31 user belum selesai), "Manajemen Proyek Agile - Batch 2" (~Rp17.5 juta, 14.29%, 30 user belum selesai), dan "Data Visualization dengan Power BI" (~Rp16.5 juta, 15.15%, 28 user belum selesai). **Catatan keterbatasan:** estimasi revenue ini pendekatan kasar (price × total enrollment, asumsi semua bayar harga penuh) — dataset tidak memiliki data transaksi aktual atau informasi subscription, sehingga angka ini indikatif, bukan revenue riil.

**20. Bagaimana proyeksi peningkatan completion rate dan dampaknya terhadap retensi/revenue jika rekomendasi diimplementasikan?**
❌ **Sengaja tidak dijawab dengan angka proyeksi spesifik.** Dataset tidak memiliki data historis dari intervensi yang pernah dicoba sebelumnya, informasi cost/margin operasional, atau data retensi jangka panjang pasca-completion — sehingga proyeksi kuantitatif (misal "completion rate akan naik ke X%") tidak bisa dibuat secara bertanggung jawab tanpa dasar data yang memadai. Rekomendasi disusun sebagai langkah aksi (`reports/recommendations.md`) dengan prioritas effort-vs-impact, bukan target angka yang mengasumsikan hasil yang belum teruji.

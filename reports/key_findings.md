# Key Findings — EduSmart Course Performance Analysis

Ringkasan temuan utama dari analisis data cleaning, EDA, SQL analysis, feature engineering, dan uji korelasi statistik terhadap dataset EduSmart (7.947 enrollment, 300 kursus, 60 instruktur, periode Agustus 2023 – Juli 2026).

---

## A. Gambaran Umum Platform

**1. Completion rate keseluruhan platform: 28.74%**
Dari 7.947 enrollment, hanya 2.284 (28.74%) yang menyelesaikan seluruh modul kursus. Angka ini konsisten baik untuk enrollment lama maupun baru (completion rate enrollment yang sudah berjalan ≥3 bulan: 27.87%) — artinya rendahnya completion rate bukan sekadar efek "belum sempat selesai", melainkan pola struktural yang konsisten.

**2. Pertumbuhan enrollment eksponensial**
Enrollment tumbuh dari 2/bulan (Agustus 2023) menjadi 991/bulan (Juli 2026) — hampir 500x lipat, dengan akselerasi tajam sejak awal 2026. Sekitar 25% dari seluruh enrollment terjadi hanya dalam 2 bulan terakhir periode data.

**3. Ghost user: 14.8% dari total enrollment**
1.175 enrollment (14.8%) tidak pernah memiliki satu pun aktivitas belajar (0 baris di fact_progress) — mendaftar tapi tidak pernah memulai.

**4. Segmentasi learner profile**
- Mid-dropper (mulai serius, berhenti di tengah): 29.7% — kelompok terbesar
- Completer: 28.7%
- Early-dropper (berhenti ≤25% modul): 22.9%
- Ghost user: 14.8%
- Slow learner/near-complete (76-99% modul): 3.9%

---

## B. Completion Rate per Segmen

**5. Variasi completion rate antar kategori kursus relatif sempit**
Rentang 26.65% (Programming, terendah) – 31.92% (Photography, tertinggi), selisih hanya ~5 poin. Menunjukkan masalah completion rate rendah bersifat **platform-wide**, bukan spesifik ke kategori tertentu.

**6. Completion rate per level kursus**
Advanced course sedikit lebih rendah (27.24%) dibanding Beginner (29.48%) dan Intermediate (29.52%) — pola wajar secara pedagogis, gap tidak ekstrem.

**7. Variasi completion rate antar instruktur SANGAT LEBAR**
Rentang 20.55% (Elisa Handayani) – 37.50% (Jelita Sihotang), selisih ~17 poin — jauh lebih lebar dari gap antar kategori. **Variasi completion rate lebih dipengaruhi oleh instruktur individual dibanding kategori kursus.**

**8. Completion rate per sumber akuisisi (enrollment_source)**
Organic tertinggi (30.22%), ads terendah (27.64%). User yang datang secara organik cenderung lebih berkomitmen menyelesaikan kursus dibanding yang datang lewat iklan berbayar.

---

## C. Drop-off Analysis

**9. Drop-off meningkat tajam di modul-modul akhir kursus**
Menggunakan window function (LEAD) untuk mengukur user yang benar-benar tidak melanjutkan ke modul berikutnya:
- Modul 1-3: drop-off rendah (7-9%)
- Modul 9: 25.46%
- Modul 10: 35.52%
- Modul 11: 51.16%

Ini pola paling kritis dalam keseluruhan analisis — user yang sudah menempuh sebagian besar kursus justru paling berisiko berhenti sebelum benar-benar selesai, mengindikasikan kelelahan konten di bagian akhir, bukan kurangnya minat awal.

**10. Kecepatan progress minggu pertama adalah sinyal prediktif kuat**
User yang akhirnya menyelesaikan kursus rata-rata menuntaskan 1.13 modul di 7 hari pertama sejak enrollment; user yang tidak menyelesaikan rata-rata hanya 0.60 modul (median = 0, artinya lebih dari separuh non-completer tidak menyelesaikan modul apapun di minggu pertama).

---

## D. Kursus & Prioritas Revisi

**11. Kursus populer dengan completion rate terendah**
- "Data Analysis dengan Python - Batch 2" (37 enrollment): 16.22%
- "Financial Analysis untuk Manajer" (38 enrollment): 21.05%

**12. Kursus dengan completion rate tinggi sebagai benchmark**
"Editing Foto dengan Lightroom - Batch 5": 52.27% completion rate — jauh di atas rata-rata platform, berpotensi jadi rujukan pola sukses untuk direplikasi.

**13. Pola berulang pada kursus multi-batch**
Dua versi "Digital Marketing Fundamentals" (course_id berbeda, nama sama) sama-sama menunjukkan completion rate rendah (24.32% dan 27.03%) — mengindikasikan masalah di struktur konten dasar, bukan spesifik ke satu batch.

---

## E. Rating vs Completion Rate

**14. Tidak ada korelasi antara rating dan completion rate**
Koefisien korelasi Pearson: **r = -0.008** (praktis nol), p-value = 0.9518 (jauh di atas ambang signifikansi 0.05). Divalidasi silang lewat 2 metode independen (SQL dan Python/scipy) dengan hasil identik. **Rating instruktur/kursus tidak bisa dipakai sebagai proxy atau prediktor completion rate.**

**15. Rating rata-rata seluruh kategori sangat merata dan tinggi**
Rentang 4.06 – 4.21 dari skala 5, jauh lebih sempit dibanding variasi completion rate — memperkuat bahwa rating mengukur aspek berbeda (kepuasan sesaat) dari completion rate (komitmen jangka panjang).

---

## F. Pola Perilaku User

**16. Pola waktu belajar sangat jelas dan konsisten**
- Hari kerja: puncak tajam di 19.00-22.00 (700+ akses/jam) dan jam istirahat siang 12.00-13.00 (320-400 akses/jam)
- Akhir pekan: lebih merata di 09.00-16.00 (400-500 akses/jam)
- Dini hari (00.00-05.00): aktivitas sangat rendah di semua hari

**17. account_status TIDAK mencerminkan aktivitas belajar riil**
Rata-rata jumlah progress user berstatus "inactive" (17.9) hampir identik dengan user "active" (18.1). 99.5% user berstatus inactive tetap memiliki histori progress substansial — field ini kemungkinan mencatat status akun/langganan, bukan keterlibatan belajar.

**18. Segmen "serial dropper"**
Ditemukan user yang enroll banyak kursus (8-11 kursus) namun completion rate sangat rendah (0-20%) — pola perilaku eksploratif yang berbeda karakter dari drop-off biasa di satu kursus.

**19. Time-to-dropoff bervariasi per kategori**
Data Science tercepat drop-off (rata-rata 23.8 hari sejak enrollment), Language paling lama bertahan (31.9 hari) — berguna untuk menentukan waktu ideal pengiriman reminder per kategori.

---

## G. Karakteristik User & Prioritas Revenue

**20. Tidak ada pola demografis yang berkorelasi dengan completion rate**
Completion rate berdasarkan gender (Female 28.77% vs Male 28.71%), kelompok usia (rentang 25.54%-29.65%), dan kota (rentang 27.87%-30.52%) semuanya berada dalam rentang sempit mendekati rata-rata platform. Tidak ada kelompok demografis yang menonjol signifikan — mengindikasikan completion rate lebih dipengaruhi oleh faktor perilaku (kecepatan progress, instruktur, struktur modul) dibanding karakteristik siapa penggunanya.

**21. Kursus prioritas revisi berdasarkan estimasi revenue**
Mempertimbangkan price × enrollment sebagai estimasi revenue, tiga kursus dengan kombinasi revenue tinggi namun completion rate sangat rendah: "Entrepreneurship Fundamentals" (~Rp18 juta, completion rate 13.89%, 31 dari 36 user belum selesai), "Manajemen Proyek Agile - Batch 2" (~Rp17.5 juta, 14.29%), dan "Data Visualization dengan Power BI" (~Rp16.5 juta, 15.15%). *Catatan: estimasi revenue ini indikatif (asumsi semua enrollment membayar harga penuh), bukan angka transaksi aktual.*

---

## H. Kualitas Data

**22. Anomali data yang teridentifikasi dan ditangani**
Sepanjang proses cleaning ditemukan dan didokumentasikan: 210 baris enrollment dengan anomali tanggal (enrollment sebelum registrasi/publish, 71% terkonsentrasi pada 1 course_id yang diduga hasil republish batch), 6 baris retake sah (bukan duplikat error), 359 nilai time_spent negatif, dan 347 outlier ekstrem yang di-cap menggunakan rasio terhadap durasi modul (bukan threshold absolut IQR yang terbukti terlalu sensitif). Seluruh data dibersihkan dengan pendekatan flag-dan-catat, bukan hapus sembarangan — detail lengkap di data_cleaning_log.txt.

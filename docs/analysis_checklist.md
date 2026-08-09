# CHECKLIST ANALISIS — Project EduSmart

Checklist ini disusun spesifik berdasarkan struktur dataset EduSmart (7 tabel) yang sudah dibuat, sehingga setiap poin bisa langsung dieksekusi tanpa perlu menebak-nebak kolom mana yang dimaksud.

---

## ✅ A. DATA CLEANING (Umum)

- [ ] Cek jumlah baris & kolom tiap tabel setelah import — cocokkan dengan Data Dictionary
- [ ] Cek tipe data tiap kolom (tanggal terbaca sebagai date/datetime, bukan string; angka terbaca sebagai numeric)
- [ ] Cek konsistensi penamaan kategori (`category` di `dim_courses`, `status` di `fact_progress`, dll) — pastikan tidak ada variasi penulisan (misal "Programming" vs "programming ")
- [ ] Validasi seluruh relasi PK–FK bisa di-JOIN tanpa baris "orphan" (FK yang tidak ditemukan pasangannya di tabel induk)
- [ ] Cek rentang tanggal logis: `enrollment_date` >= `registration_date` (user) dan >= `publish_date` (kursus)
- [ ] Cek `completion_date`/`completion_timestamp` tidak lebih awal dari `access_date`/`access_timestamp`
- [ ] Simpan versi data mentah terpisah sebelum mulai proses cleaning (jangan overwrite)
- [ ] Dokumentasikan setiap perubahan: kolom apa, jumlah baris terdampak, alasan keputusan

---

## ✅ B. MISSING VALUE

- [ ] `dim_users.email` — identifikasi baris kosong, putuskan: biarkan (flag "no email") atau exclude dari analisis yang butuh email
- [ ] `dim_modules.duration_minutes` — cek baris kosong, putuskan strategi imputasi (median durasi per kategori kursus, atau biarkan null dan exclude dari perhitungan rata-rata durasi)
- [ ] `fact_progress.access_date` & `access_timestamp` — cek baris kosong, tentukan apakah tetap dihitung sebagai "modul diakses" (pakai completion_date sebagai proxy) atau di-exclude dari analisis pola waktu belajar
- [ ] `fact_progress.completion_date` & `completion_timestamp` — pastikan null hanya muncul saat `status != 'completed'` (validasi konsistensi, bukan cleaning kolom itu sendiri)
- [ ] `fact_reviews.rating` — cek apakah ada baris kosong/null yang perlu di-exclude dari perhitungan rata-rata rating
- [ ] Hitung dan laporkan **persentase missing value per kolom** sebelum memutuskan strategi (drop vs imputasi vs flag)
- [ ] Cek apakah missing value terjadi acak atau berpola (misal: missing `access_timestamp` lebih banyak di kategori kursus tertentu — bisa jadi insight tersendiri, bukan sekadar noise)

---

## ✅ C. DUPLICATE

- [ ] `fact_enrollments` — cek duplikasi kombinasi `user_id` + `course_id` (re-enrollment); putuskan apakah dihitung sebagai 1 percobaan belajar atau tetap dipisah
- [ ] `dim_users` — cek duplikasi berdasarkan `email` (kemungkinan 1 user daftar dua akun)
- [ ] `fact_reviews` — cek apakah ada 1 `enrollment_id` dengan lebih dari 1 review (harusnya maksimal 1 review per enrollment)
- [ ] `fact_progress` — cek duplikasi kombinasi `enrollment_id` + `module_id` (harusnya 1 baris per modul per enrollment)
- [ ] Cek duplikasi exact-row (seluruh kolom identik) di semua tabel sebagai pengecekan dasar
- [ ] Dokumentasikan jumlah duplikasi ditemukan dan keputusan penanganannya (drop semua kecuali satu, gabungkan, atau biarkan dengan catatan)

---

## ✅ D. OUTLIER

- [ ] `fact_progress.time_spent_minutes` — identifikasi nilai negatif (data error, perlu dikoreksi/dibuang)
- [ ] `fact_progress.time_spent_minutes` — identifikasi outlier ekstrem tinggi (misal >3x atau >5x durasi modul asli) menggunakan IQR atau persentil (>P99)
- [ ] Bandingkan `time_spent_minutes` terhadap `duration_minutes` modul aslinya — buat rasio (actual/expected) untuk mendeteksi anomali lebih akurat daripada threshold absolut
- [ ] `dim_users.birth_date` — cek usia hasil turunan (dari birth_date) tidak masuk akal (misal usia <10 tahun atau >100 tahun)
- [ ] `fact_enrollments` — cek `enrollment_date` yang jatuh sebelum `dim_courses.publish_date` (secara logika tidak mungkin, indikasi data error)
- [ ] Cek kursus dengan `price` di luar rentang wajar (misal 0 untuk kursus premium yang seharusnya berbayar) — validasi ke tim konten jika perlu
- [ ] Putuskan strategi tiap outlier: cap (winsorize), exclude dari analisis tertentu, atau biarkan dengan catatan jika secara bisnis valid (misal user yang benar-benar belajar sangat lama karena review ulang materi)

---

## ✅ E. EXPLORATORY DATA ANALYSIS (EDA)

- [ ] Distribusi jumlah kursus per kategori dan per level (Beginner/Intermediate/Advanced)
- [ ] Distribusi jumlah enrollment per kategori kursus
- [ ] Tren jumlah enrollment per bulan/kuartal (apakah growing, stagnan, atau menurun)
- [ ] Distribusi `enrollment_source` (organic/promo/referral/ads) dan proporsinya
- [ ] Completion rate keseluruhan platform (baseline angka)
- [ ] Completion rate per kategori kursus (bar chart, urutkan dari terendah)
- [ ] Completion rate per level kursus (Beginner vs Intermediate vs Advanced)
- [ ] Distribusi rating kursus (histogram 1–5) dan rata-rata rating per kategori
- [ ] Distribusi demografis user: gender, kota, kelompok usia
- [ ] Distribusi `time_spent_minutes` (boxplot) untuk melihat sebaran & confirm hasil outlier handling
- [ ] Proporsi status `account_status` (active vs inactive) dan hubungannya dengan aktivitas belajar riil
- [ ] Jumlah user per "learner profile" implisit — bandingkan user yang punya banyak progress vs yang minim aktivitas

---

## ✅ F. SQL ANALYSIS

- [ ] Query: completion rate per kategori kursus (JOIN `fact_enrollments`, `dim_courses`, agregasi status completed)
- [ ] Query: drop-off rate per `module_order` — di modul urutan ke berapa user paling banyak berhenti (JOIN `fact_progress`, `dim_modules`)
- [ ] Query: completion rate per instruktur (JOIN `dim_instructors`, `dim_courses`, `fact_enrollments`)
- [ ] Query: rata-rata rating per instruktur vs completion rate kursusnya (untuk uji korelasi di tahap berikutnya)
- [ ] Query: time-to-dropoff rata-rata (selisih hari `enrollment_date` ke `access_timestamp` terakhir) per kategori kursus
- [ ] Query: distribusi jumlah akses (`access_timestamp`) per jam dan per hari (untuk heatmap pola waktu belajar)
- [ ] Query: completion rate berdasarkan `enrollment_source` (organic/promo/referral/ads)
- [ ] Query: top 10 kursus dengan enrollment tertinggi tapi completion rate terendah (kandidat revisi prioritas)
- [ ] Query: user yang enroll banyak kursus tapi jarang menyelesaikan (identifikasi pola "serial dropper")
- [ ] Window function: urutan modul yang diakses per enrollment untuk menentukan titik berhenti terakhir secara presisi
- [ ] Simpan seluruh query dalam file `.sql` dengan komentar penjelasan tujuan tiap query

---

## ✅ G. DASHBOARD (Power BI)

- [ ] Rancang struktur halaman: Overview, Course Performance, Drop-off Analysis, Learning Pattern, Instructor Performance
- [ ] Import dataset bersih ke Power BI dan bangun relasi sesuai ERD (star schema)
- [ ] KPI Card halaman Overview: total enrollment, completion rate keseluruhan, rata-rata rating, total user aktif
- [ ] Visual: bar chart completion rate per kategori kursus
- [ ] Visual: bar/funnel chart drop-off rate per modul (per kursus terpilih)
- [ ] Visual: heatmap jam × hari untuk pola waktu belajar aktif
- [ ] Visual: scatter plot rating instruktur vs completion rate kursus
- [ ] Visual: tabel/matrix top kursus prioritas revisi (enrollment tinggi, completion rendah)
- [ ] Tambahkan slicer/filter: kategori, level kursus, rentang tanggal enrollment, instruktur
- [ ] Uji interaktivitas dashboard (drill-down, filter cross-highlight antar visual)
- [ ] Review keterbacaan dashboard dari sudut pandang user non-teknis (warna, label, tooltip jelas)

---

## ✅ H. BUSINESS INSIGHT

- [ ] Rangkum 3–5 temuan utama dari EDA + SQL Analysis (bukan sekadar angka, tapi "apa artinya")
- [ ] Identifikasi kategori/kursus dengan completion rate rendah namun demand tinggi — prioritas revisi konten
- [ ] Identifikasi modul-modul dengan drop-off tertinggi lintas kursus — cari pola kesamaan (posisi di tengah kursus, topik sulit, durasi terlalu panjang, dll)
- [ ] Simpulkan apakah rating instruktur benar-benar berkorelasi dengan completion rate, atau ada faktor lain yang lebih dominan
- [ ] Simpulkan pola waktu belajar optimal user — rekomendasikan jadwal notifikasi/reminder yang sesuai
- [ ] Identifikasi karakteristik user yang cenderung menyelesaikan kursus (dari kategori, sumber akuisisi, atau kecepatan progress awal)
- [ ] Susun rekomendasi konkret per temuan (bukan hanya observasi) — misal: "modul X perlu dipecah jadi 2 bagian karena durasi terlalu panjang dan drop-off tinggi di titik ini"
- [ ] Prioritaskan rekomendasi berdasarkan effort vs impact (mana yang quick win, mana yang perlu revisi besar)
- [ ] Validasi insight dengan angka pendukung yang bisa dicek ulang (tidak ada klaim tanpa data di baliknya)
- [ ] Susun ringkasan insight dalam bahasa non-teknis untuk laporan final ke manajemen

---

*Gunakan checklist ini sebagai working document — centang tiap poin seiring progres, dan tambahkan catatan temuan di sampingnya jika perlu sebagai bahan mentah laporan final.*

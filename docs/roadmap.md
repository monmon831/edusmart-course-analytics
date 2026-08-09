# PROJECT ROADMAP
## EduSmart — Course Performance & Completion Rate Analysis

Roadmap ini menguraikan alur kerja end-to-end proyek, dari data mentah sampai laporan rekomendasi final untuk manajemen EduSmart. Setiap tahap dilengkapi tujuan, aktivitas detail, output, tools, dan estimasi waktu — mengacu pada dataset dan Business Questions yang sudah disusun sebelumnya.

---

## Ringkasan Alur (High-Level Flow)

```
1. Import Data → 2. Data Cleaning → 3. EDA → 4. SQL Analysis
        → 5. Feature Engineering → 6. Dashboard
        → 7. Business Insight → 8. Final Report
```

Total estimasi: **± 3 minggu (15–19 hari kerja)**, sesuai timeline di Project Brief.

---

## TAHAP 1 — Import Data
**Tujuan:** Memastikan seluruh sumber data masuk ke environment kerja dengan struktur dan relasi yang benar.

**Aktivitas:**
- Import 7 file CSV (`dim_users`, `dim_instructors`, `dim_courses`, `dim_modules`, `fact_enrollments`, `fact_progress`, `fact_reviews`) ke database (SQLite/PostgreSQL/MySQL) dan/atau ke Python (Pandas DataFrame).
- Cek jumlah baris tiap tabel sesuai ekspektasi (tidak ada baris hilang saat import).
- Cek tipe data awal tiap kolom (apakah tanggal terbaca sebagai string atau datetime, angka terbaca sebagai numeric, dll).
- Verifikasi relasi PK-FK antar tabel bisa di-JOIN tanpa error (uji coba JOIN sederhana).
- Buat backup/salinan data mentah (raw) terpisah dari data yang akan diproses — jangan overwrite data asli.

**Output:** Data mentah tersimpan rapi di database/environment kerja, siap diproses.
**Tools:** SQL (CREATE TABLE + import), Python (`pd.read_csv`), Excel (cek cepat).
**Estimasi:** 1 hari.

---

## TAHAP 2 — Data Cleaning
**Tujuan:** Menghasilkan dataset bersih dan konsisten agar analisis berikutnya valid dan tidak bias.

**Aktivitas:**
- **Handling missing values:** email kosong di `dim_users`, `access_timestamp`/`access_date` kosong di `fact_progress`, `duration_minutes` kosong di `dim_modules` — tentukan strategi (drop, imputasi, atau flag sebagai kategori "unknown").
- **Handling outlier/anomali:** `time_spent_minutes` bernilai negatif atau ekstrem tinggi di `fact_progress` — investigasi, lalu cap/exclude sesuai threshold yang masuk akal (misal >99th percentile).
- **Handling duplikasi:** cek dan tangani duplikasi enrollment (user_id + course_id sama).
- **Konsistensi status vs data lain:** cek user dengan `account_status = inactive` tapi masih punya baris di `fact_progress` — putuskan apakah ini valid (histori lama) atau perlu di-flag.
- **Standarisasi format:** samakan format tanggal, kapitalisasi teks (nama kota, kategori), dan tipe data numerik.
- **Dokumentasikan setiap keputusan cleaning** (apa yang diubah, kenapa, berapa baris terdampak) — penting untuk transparansi ke klien.

**Output:** Dataset bersih (`*_clean`) + Data Cleaning Report (ringkasan isu & tindakan yang diambil).
**Tools:** Python (Pandas) — utama; SQL untuk validasi query; Excel untuk spot-check manual.
**Estimasi:** 3–4 hari.

---

## TAHAP 3 — Exploratory Data Analysis (EDA)
**Tujuan:** Memahami karakteristik data secara menyeluruh dan menjawab Business Questions Level 1–2 (deskriptif & diagnostik).

**Aktivitas:**
- Distribusi enrollment per kategori, level kursus, dan sumber akuisisi.
- Completion rate keseluruhan dan per kategori kursus (jawab BQ #6, #7, #9).
- Distribusi rating kursus & instruktur (jawab BQ #3, #10).
- Profil user aktif vs inactive, sebaran demografi (kota, gender, usia).
- Visualisasi awal: bar chart, histogram, boxplot untuk `time_spent_minutes`, line chart tren enrollment per bulan.
- Identifikasi pola menarik/anomali yang perlu didalami lebih lanjut di tahap SQL Analysis atau Feature Engineering.

**Output:** EDA Report (visualisasi + insight awal), daftar hipotesis untuk didalami lebih lanjut.
**Tools:** Python (Pandas, Matplotlib/Seaborn), Excel (pivot table untuk cross-check cepat).
**Estimasi:** 2–3 hari.

---

## TAHAP 4 — SQL Analysis
**Tujuan:** Menjawab pertanyaan bisnis yang butuh query relasional kompleks — khususnya pola drop-off per modul dan analisis multi-tabel.

**Aktivitas:**
- Query drop-off rate per modul per kursus (JOIN `fact_progress`, `dim_modules`, `fact_enrollments`) — jawab BQ #8.
- Query completion rate per instruktur (JOIN `dim_instructors`, `dim_courses`, `fact_enrollments`) — jawab BQ #10.
- Query time-to-dropoff rata-rata per kategori kursus — jawab BQ #15.
- Query korelasi sederhana antara `enrollment_source` dan completion rate — jawab BQ #14.
- Window function untuk menghitung urutan modul yang diakses user dan mendeteksi titik berhenti terakhir.
- Susun seluruh query dalam file `.sql` terdokumentasi (setiap query diberi komentar tujuan & cara baca hasil).

**Output:** SQL Query Documentation siap pakai ulang oleh tim internal.
**Tools:** SQL (PostgreSQL/MySQL/SQLite).
**Estimasi:** 2 hari.

---

## TAHAP 5 — Feature Engineering *(jika diperlukan)*
**Tujuan:** Membuat variabel turunan yang memperkuat analisis korelasi dan pola perilaku user (Business Questions Level 3).

**Aktivitas:**
- Buat kolom **completion_flag** per enrollment (1 = selesai, 0 = tidak) sebagai target variable.
- Buat **progress_speed_week1** — jumlah modul diselesaikan dalam 7 hari pertama sejak enrollment (untuk uji BQ #13: apakah kecepatan awal memprediksi completion).
- Buat **days_to_dropoff** — selisih hari dari enrollment_date ke access_timestamp terakhir tercatat.
- Buat **access_hour** dan **access_dayname** dari `access_timestamp` (untuk analisis pola waktu belajar, BQ #12).
- Buat **engagement_score** sederhana — kombinasi frekuensi akses + rata-rata time_spent per user.
- Gabungkan rating instruktur (rata-rata) sebagai atribut di level kursus, untuk uji korelasi rating vs completion rate (BQ #11).
- Validasi setiap fitur baru dengan sample check manual sebelum dipakai ke analisis korelasi/dashboard.

**Output:** Dataset analitik (`analytical_dataset`) siap pakai untuk analisis statistik & dashboard.
**Tools:** Python (Pandas, NumPy), sedikit statistik dasar (`scipy.stats` untuk uji korelasi).
**Estimasi:** 1–2 hari. *(Tahap ini bisa disingkat/dilewati sebagian jika insight dari EDA + SQL sudah cukup menjawab kebutuhan klien.)*

---

## TAHAP 6 — Dashboard
**Tujuan:** Menyediakan alat monitoring performa kursus yang bisa dipakai tim EduSmart secara mandiri dan berkelanjutan.

**Aktivitas:**
- Rancang struktur dashboard: halaman **Overview** (KPI utama), **Course Performance** (completion rate per kategori/kursus), **Drop-off Analysis** (per modul), **Learning Pattern** (heatmap jam × hari), **Instructor Performance** (rating vs completion).
- Import dataset bersih & analitik ke Power BI, bangun relasi sesuai ERD (star schema).
- Buat visual utama: KPI card (completion rate, total enrollment, avg rating), bar chart drop-off per modul, heatmap jam/hari aktif, scatter plot rating vs completion rate.
- Tambahkan filter interaktif (slicer): kategori, level, rentang tanggal, instruktur.
- Uji dashboard dari sisi user non-teknis — pastikan mudah dibaca dan tidak butuh penjelasan panjang.

**Output:** Dashboard Power BI (.pbix) interaktif, siap dipakai tim internal.
**Tools:** Power BI.
**Estimasi:** 3–4 hari.

---

## TAHAP 7 — Business Insight
**Tujuan:** Menerjemahkan seluruh temuan teknis menjadi insight yang actionable, menjawab Business Questions Level 3–4 (strategis).

**Aktivitas:**
- Rangkum temuan kunci: kategori/kursus dengan completion rate terendah tapi demand tinggi (BQ #16), pola user yang berhasil menyelesaikan kursus (BQ #17), modul dengan drop-off tertinggi dan kemungkinan penyebabnya (BQ #18).
- Susun prioritas revisi kursus berdasarkan kombinasi jumlah user terdampak, revenue, dan completion rate (BQ #19).
- Rumuskan rekomendasi konkret: redesign modul tertentu, strategi notifikasi berbasis jam aktif, program coaching untuk instruktur dengan completion rate rendah, dsb.
- Diskusikan/validasi insight awal dengan klien (checkpoint) sebelum masuk ke laporan final — beri ruang untuk feedback.

**Output:** Daftar insight & rekomendasi terstruktur (draft), siap dirangkum ke laporan final.
**Tools:** Python/SQL (validasi angka pendukung insight), dokumen catatan (Notion/Word/Slide draft).
**Estimasi:** 1–2 hari.

---

## TAHAP 8 — Final Report
**Tujuan:** Menyampaikan hasil kerja secara profesional dan siap dipresentasikan ke manajemen EduSmart.

**Aktivitas:**
- Susun laporan rekomendasi kurikulum (ringkas, non-teknis, fokus pada actionable insight — bukan detail teknis analisis).
- Sertakan ringkasan metodologi singkat (data yang dipakai, pendekatan analisis) agar laporan kredibel tanpa membebani pembaca non-teknis.
- Lampirkan/tautkan Dashboard Power BI sebagai alat monitoring berkelanjutan.
- Siapkan slide presentasi ringkas (opsional tapi direkomendasikan) untuk sesi presentasi ke stakeholder.
- Review akhir: pastikan semua deliverable dari Project Brief (Data Cleaning Report, EDA Report, SQL Documentation, Dashboard, Laporan Rekomendasi) lengkap dan konsisten satu sama lain.
- Serahkan seluruh file kepada klien beserta panduan singkat cara menggunakan dashboard.

**Output:** Laporan Rekomendasi Kurikulum (PDF/Slide) + Dashboard final + seluruh dokumentasi pendukung.
**Tools:** Word/PowerPoint (laporan & slide), Power BI (dashboard final).
**Estimasi:** 2 hari.

---

## Ringkasan Timeline

| Tahap | Durasi | Kumulatif |
|---|---|---|
| 1. Import Data | 1 hari | Hari 1 |
| 2. Data Cleaning | 3–4 hari | Hari 2–5 |
| 3. EDA | 2–3 hari | Hari 6–8 |
| 4. SQL Analysis | 2 hari | Hari 9–10 |
| 5. Feature Engineering | 1–2 hari | Hari 11–12 |
| 6. Dashboard | 3–4 hari | Hari 13–16 |
| 7. Business Insight | 1–2 hari | Hari 17–18 |
| 8. Final Report | 2 hari | Hari 19–20 |

**Total: ± 19–20 hari kerja (sekitar 3 minggu)**, selaras dengan timeline di Project Brief. Tahap 3–4 dan 6–7 bisa sedikit overlap dalam praktiknya (misal mulai bangun kerangka dashboard sambil menyelesaikan SQL Analysis) untuk mempercepat pengerjaan bila diperlukan.

---

## Checkpoint dengan Klien (disarankan)

| Checkpoint | Setelah Tahap | Tujuan |
|---|---|---|
| Checkpoint 1 | Data Cleaning selesai | Konfirmasi klien setuju dengan keputusan cleaning (terutama data yang di-drop/diimputasi) |
| Checkpoint 2 | EDA + SQL Analysis selesai | Validasi awal apakah arah temuan sesuai ekspektasi klien sebelum lanjut ke dashboard |
| Checkpoint 3 | Dashboard draft selesai | Kumpulkan feedback layout/visual sebelum finalisasi |
| Checkpoint 4 | Sebelum Final Report dikirim | Presentasi insight utama, pastikan rekomendasi relevan dengan kebutuhan manajemen |

Checkpoint rutin ini penting agar tidak ada kejutan di akhir proyek dan klien merasa terlibat sepanjang proses — sesuai ekspektasi yang tertulis di Project Brief (poin komunikasi progres berkala).

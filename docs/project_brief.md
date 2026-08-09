# PROJECT BRIEF
## Data Analyst Freelance — Course Performance & Completion Rate Analysis

**Klien:** EduSmart
**Jenis Proyek:** Data Analysis (Freelance — Upwork)
**Kategori:** EdTech / Online Learning Platform

---

## 1. Profil Perusahaan

**Nama Perusahaan:** EduSmart
**Industri:** Educational Technology (EdTech)
**Model Bisnis:** Platform kursus online (subscription & pay-per-course) yang menyediakan ratusan kursus dari berbagai kategori — teknologi, bisnis, desain, bahasa, dan pengembangan diri.
**Skala:** Platform menengah dengan ribuan user terdaftar dan ratusan kursus aktif dari puluhan instruktur.
**Tim Internal:** Product Manager, Content/Curriculum Team, Marketing Team — belum memiliki Data Analyst tetap, sehingga proyek ini dikerjakan secara freelance.

---

## 2. Latar Belakang Bisnis

EduSmart sudah berjalan selama beberapa tahun dan berhasil mengumpulkan banyak data enrollment, progress belajar, serta rating dari user. Namun, data ini belum dimanfaatkan secara maksimal untuk pengambilan keputusan. Tim manajemen mulai khawatir karena banyak user yang mendaftar kursus tapi tidak menyelesaikannya, sementara biaya produksi konten dan akuisisi user terus meningkat.

Manajemen ingin mulai berbasis data (data-driven) dalam menentukan kursus mana yang perlu direvisi, instruktur mana yang perlu didukung lebih lanjut, dan strategi apa yang bisa meningkatkan keterlibatan (engagement) user agar completion rate naik.

---

## 3. Permasalahan yang Sedang Dihadapi

1. **Completion rate rendah** di sebagian besar kursus — belum diketahui secara pasti kategori atau modul mana yang menjadi penyebab utama drop-off.
2. **Data belum terstruktur rapi** — data progress belajar memiliki banyak inkonsistensi (misalnya user tercatat "aktif" tapi tidak ada aktivitas selama berbulan-bulan, atau data modul selesai yang tidak sinkron dengan waktu akses).
3. **Belum ada visibilitas terhadap pola belajar user** — tim tidak tahu jam/hari mana user paling aktif belajar, sehingga strategi notifikasi dan campaign belum optimal.
4. **Belum jelas hubungan antara kualitas instruktur (rating) dan hasil belajar user** (completion rate), sehingga sulit menentukan prioritas coaching untuk instruktur.
5. **Tidak ada dashboard monitoring** — setiap kali butuh insight, tim harus meminta laporan manual, yang memakan waktu dan tidak real-time.

---

## 4. Tujuan Bisnis

- Meningkatkan **completion rate** kursus secara keseluruhan.
- Mengidentifikasi kursus dan modul yang **perlu direvisi** berdasarkan data, bukan asumsi.
- Memahami **pola perilaku user** yang berhasil menyelesaikan kursus, agar bisa direplikasi ke user lain.
- Membangun **dashboard monitoring** yang bisa dipakai tim secara mandiri (self-service analytics).
- Menyusun **rekomendasi strategi konten & engagement** yang actionable untuk tim kurikulum dan marketing.

---

## 5. Pertanyaan Bisnis yang Harus Dijawab Data Analyst

1. Berapa completion rate per kategori kursus, dan kategori mana yang paling rendah/tinggi?
2. Di modul mana user paling banyak berhenti (drop-off) dalam sebuah kursus?
3. Apakah ada hubungan antara rating instruktur dan completion rate kursus mereka?
4. Kapan (jam & hari) user paling aktif mengakses materi belajar?
5. Apakah ada pola tertentu (misalnya kecepatan progress di minggu pertama) yang membedakan user yang menyelesaikan kursus vs yang tidak?
6. Kategori kursus mana yang paling diminati (jumlah enrollment tertinggi) tapi completion rate-nya rendah — ini jadi prioritas revisi?
7. Apa rekomendasi konkret untuk memperbaiki struktur modul dan meningkatkan engagement user?

---

## 6. KPI yang Ingin Dipantau

| KPI | Deskripsi |
|---|---|
| **Completion Rate** | % user yang menyelesaikan kursus dari total yang mendaftar (keseluruhan & per kategori) |
| **Drop-off Rate per Modul** | % user yang berhenti di modul tertentu sebelum lanjut ke modul berikutnya |
| **Average Rating per Instruktur/Kursus** | Rata-rata rating dan korelasinya dengan completion rate |
| **Enrollment Volume** | Jumlah pendaftaran per kategori/kursus per periode |
| **Active Learning Hours** | Jam & hari dengan aktivitas belajar tertinggi |
| **Time to Drop-off** | Rata-rata waktu (hari) sejak enrollment hingga user berhenti aktif |
| **User Retention/Engagement Score** | Frekuensi akses user selama masa kursus berlangsung |

---

## 7. Deliverables yang Diminta Klien

1. **Data Cleaning Report** — ringkasan proses pembersihan data (progress tidak konsisten, user inactive, duplikasi, dsb).
2. **EDA Report** — analisis completion rate per kategori kursus lengkap dengan visualisasi.
3. **SQL Query Documentation** — kumpulan query untuk analisis pola drop-off per modul (siap dipakai ulang oleh tim internal).
4. **Analisis Korelasi** — laporan hubungan rating instruktur terhadap completion rate (termasuk visualisasi & interpretasi statistik).
5. **Dashboard Interaktif (Power BI)** — dashboard monitoring performa kursus yang bisa difilter per kategori/kursus/periode.
6. **Analisis Pola Waktu Belajar** — heatmap/visualisasi jam & hari user paling aktif.
7. **Laporan Rekomendasi** — dokumen ringkas berisi rekomendasi perbaikan konten kursus & strategi engagement, ditujukan untuk tim kurikulum dan manajemen (non-teknis, mudah dipahami).

**Format akhir:** File Power BI (.pbix), notebook/script Python (untuk reproducibility), file SQL query (.sql), dan laporan ringkasan (PDF/Slide).

---

## 8. Timeline Proyek

| Tahap | Aktivitas | Estimasi Waktu |
|---|---|---|
| 1 | Data cleaning & validasi | 3–4 hari |
| 2 | EDA completion rate per kategori | 2–3 hari |
| 3 | SQL analysis pola drop-off per modul | 2 hari |
| 4 | Analisis korelasi rating vs completion rate | 2 hari |
| 5 | Analisis pola waktu belajar optimal | 1–2 hari |
| 6 | Pembuatan dashboard Power BI | 3–4 hari |
| 7 | Penyusunan laporan rekomendasi & presentasi akhir | 2 hari |
| **Total** | | **± 3 minggu (15–19 hari kerja)** |

*Catatan: Timeline bisa disesuaikan berdasarkan kompleksitas data aktual dan ketersediaan freelancer.*

---

## 9. Tools yang Diperbolehkan

- **Excel** — untuk eksplorasi awal dan validasi data cepat
- **SQL** — untuk query data enrollment, progress, dan analisis drop-off
- **Python** (Pandas, Matplotlib/Seaborn, atau library statistik lain) — untuk data cleaning, EDA, dan analisis korelasi
- **Power BI** — untuk dashboard akhir yang akan digunakan tim internal secara berkelanjutan

*Klien terbuka terhadap tools tambahan selama hasil akhir tetap kompatibel dengan Power BI dan mudah dipahami tim non-teknis.*

---

## 10. Ekspektasi Hasil dari Klien

- Insight yang diberikan **actionable**, bukan sekadar angka — setiap temuan disertai rekomendasi konkret.
- Dashboard harus **mudah digunakan tim internal** tanpa perlu keahlian teknis (self-service, filter interaktif, visual yang jelas).
- Laporan rekomendasi ditulis dengan bahasa yang **dapat dipahami stakeholder non-teknis** (Product Manager, Curriculum Team).
- Semua proses analisis **terdokumentasi dengan baik** (query SQL, script Python) agar bisa direplikasi/diperbarui oleh tim internal di masa depan.
- Komunikasi progres dilakukan secara berkala (mis. update mingguan) agar klien bisa memberi feedback di tengah proses, bukan hanya di akhir.
- Deliverable akhir siap dipresentasikan ke jajaran manajemen EduSmart.

---

*Project Brief ini disusun sebagai acuan kerja sama antara EduSmart (Klien) dan Data Analyst (Freelancer) untuk proyek analisis performa kursus dan rekomendasi kurikulum.*

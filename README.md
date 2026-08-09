# 📊 EduSmart — Course Performance & Completion Rate Analysis

Analisis data end-to-end untuk mengidentifikasi penyebab rendahnya completion rate di platform kursus online EduSmart, lengkap dengan dashboard monitoring dan rekomendasi kurikulum berbasis data.

**Role:** Data Analyst (Freelance)
**Tools:** SQL · Python (Pandas, Matplotlib/Seaborn, SciPy) · Power BI · Excel

---

## 📌 Project Overview

EduSmart adalah platform kursus online dengan ratusan kursus aktif dan ribuan user terdaftar, namun belum memanfaatkan data enrollment, progress belajar, dan rating secara maksimal untuk pengambilan keputusan. Proyek ini disimulasikan sebagai engagement freelance di mana saya berperan sebagai Data Analyst yang diminta menganalisis data platform dari awal (data cleaning) hingga menghasilkan dashboard monitoring dan laporan rekomendasi kurikulum untuk manajemen.

Proyek ini mencakup seluruh siklus kerja seorang Data Analyst: pemahaman kebutuhan bisnis, data cleaning, EDA, SQL analysis, feature engineering, pembuatan dashboard sesuai spesifikasi teknis, hingga penyusunan insight dan rekomendasi strategis.

---

## ❓ Business Problem

Manajemen EduSmart menghadapi beberapa masalah utama:

- **Completion rate rendah** di sebagian besar kursus, tanpa kejelasan penyebab utamanya.
- **Data belum terstruktur rapi** — inkonsistensi pada data progress belajar dan status user.
- **Tidak ada visibilitas** terhadap pola belajar user yang berhasil menyelesaikan kursus.
- **Belum jelas** hubungan antara kualitas instruktur (rating) dan hasil belajar user.
- **Tidak ada dashboard monitoring** — setiap insight harus diminta secara manual.

📄 Detail lengkap: [`docs/project_brief.md`](docs/project_brief.md) · [`docs/business_questions.md`](docs/business_questions.md)

---

## 🗂️ Dataset

Dataset terdiri dari **7 tabel relasional** (star schema) — 4 tabel dimensi & 3 tabel fakta, total ±52.000 baris, dengan data "messiness" realistis (missing values, outlier, duplikasi) untuk mensimulasikan kondisi data dunia nyata.

| Tabel | Baris | Deskripsi |
|---|---|---|
| `dim_users` | 2.000 | Profil pelajar |
| `dim_instructors` | 60 | Profil instruktur |
| `dim_courses` | 300 | Master kursus |
| `dim_modules` | ±2.467 | Modul per kursus |
| `fact_enrollments` | ±7.947 | Data pendaftaran kursus |
| `fact_progress` | ±35.526 | Progres belajar per modul (termasuk timestamp akses) |
| `fact_reviews` | ±3.623 | Rating & ulasan kursus |

📄 Data dictionary lengkap (kolom, tipe data, PK/FK, ERD): [`docs/data_dictionary.md`](docs/data_dictionary.md)

---

## 🛠️ Tools

| Tool | Kegunaan |
|---|---|
| **Excel** | Eksplorasi awal & validasi data cepat |
| **SQL** | Query completion rate, drop-off analysis, prioritas kursus, korelasi rating, pola waktu |
| **Python** (Pandas, Matplotlib, Seaborn, SciPy) | Data cleaning, EDA, feature engineering, uji korelasi |
| **Power BI** | Dashboard monitoring interaktif, dibangun mengikuti spesifikasi teknis terperinci |

---

## 🔄 Workflow

```
1. Import Data → 2. Data Cleaning → 3. EDA → 4. SQL Analysis
     → 5. Feature Engineering → 6. Dashboard
     → 7. Business Insight → 8. Final Report
```

| Tahap | Aktivitas Utama | Output |
|---|---|---|
| Import Data | Load 7 tabel CSV, validasi relasi PK-FK | Raw dataset siap diproses |
| Data Cleaning | Handling missing value, duplikasi, outlier | Dataset bersih + cleaning report |
| EDA | Distribusi, tren, completion rate per segmen | Visualisasi awal + hipotesis |
| SQL Analysis | Query drop-off per modul, completion per kategori/instruktur, korelasi rating, pola waktu belajar | 5 file SQL documentation (`sql/`) |
| Feature Engineering | progress_speed_week1 (kecepatan progress minggu pertama) | Analytical dataset |
| Dashboard | Bangun dashboard 5 halaman di Power BI sesuai `docs/dashboard_specification.md` | `dashboard/EduSmart_Dashboard.pbix` |
| Business Insight | Terjemahkan temuan jadi insight actionable | `reports/key_findings.md` |
| Final Report | Rangkum rekomendasi untuk manajemen | `reports/recommendations.md` |

📄 Roadmap detail per tahap: [`docs/roadmap.md`](docs/roadmap.md) · Checklist analisis: [`docs/analysis_checklist.md`](docs/analysis_checklist.md)

---

## 📈 Dashboard

Dashboard Power BI interaktif dengan **5 halaman**, dibangun mengikuti spesifikasi teknis di [`docs/dashboard_specification.md`](docs/dashboard_specification.md): **Overview**, **Course Performance**, **Drop-off Analysis**, **Learning Pattern**, dan **Instructor Performance**.

**Fitur utama:**
- **6 KPI Cards** di halaman Overview: Total Enrollment, Completion Rate, Total Active Users, Average Course Rating, Total Courses Published, Average Time to Drop-off
- **Conditional formatting warna** pada Completion Rate (merah <40%, kuning 40-69%, hijau ≥70%) — menegaskan urgensi masalah secara visual
- Tren enrollment per bulan (pertumbuhan platform dari waktu ke waktu)
- Completion rate per kategori & level kursus (level dalam bentuk **stacked bar** completed vs belum completed)
- Tabel **Top 10** kursus prioritas revisi (enrollment tinggi, completion rate rendah)
- **Drop-off funnel per modul dengan slicer kursus spesifik** — dapat difilter ke 1 kursus tertentu karena tiap kursus punya jumlah modul berbeda
- Heatmap jam × hari untuk pola waktu belajar aktif
- Scatter plot rating instruktur vs completion rate + tabel ranking instruktur
- Distribusi rating kursus (1-5)
- Slicer interaktif tersinkron di semua halaman: kategori kursus, level kursus (button/tile)
- Filter tersembunyi (page-level, berlaku di semua halaman): bahasa kursus
- Tombol **Reset Filter** di setiap halaman

```
![Uploading EduSmart_Dashboard_page-0001.jpg…]()
![Uploading EduSmart_Dashboard_page-0002.jpg…]()
![Uploading EduSmart_Dashboard_page-0003.jpg…]()
![Uploading EduSmart_Dashboard_page-0004.jpg…]()
![Uploading EduSmart_Dashboard_page-0005.jpg…]()
```

---

## 🔑 Key Findings

Beberapa temuan utama dari analisis (22 insight lengkap di [`reports/key_findings.md`](reports/key_findings.md)):

- **Completion rate keseluruhan platform hanya 28,74%**, dengan 14,8% enrollment tergolong "ghost enrollment" (mendaftar tapi tidak pernah mengakses modul apapun).
- **Drop-off terbesar justru terjadi di modul-modul akhir kursus**, bukan di awal — drop-off rate melonjak dari 25,46% di modul 9, menjadi 35,52% di modul 10, dan 51,16% di modul 11.
- **Tidak ada korelasi antara rating instruktur dan completion rate** (r = -0,008, p = 0,95 — divalidasi silang lewat SQL dan Python).
- **Aktivitas 7 hari pertama sangat prediktif**: user yang akhirnya menyelesaikan kursus rata-rata menuntaskan 1,13 modul di minggu pertama, dibanding hanya 0,60 modul untuk yang akhirnya tidak menyelesaikan.
- **Variasi completion rate antar instruktur individual** (20,55%–37,50%) jauh lebih lebar dibanding antar kategori kursus (26,65%–31,92%).
- Jam belajar puncak: **19.00–22.00 di hari kerja**, dengan pola berbeda di akhir pekan (lebih merata siang-sore 09.00–16.00).
- Ditemukan **2 kursus prioritas** dengan enrollment cukup tinggi (35–38) namun completion rate sangat rendah (16,22% dan 21,05%); dengan mempertimbangkan estimasi revenue, 3 kursus tambahan (harga premium Rp499rb) juga masuk prioritas karena completion rate hanya 13,89%–15,15%.
- **Tidak ditemukan pola demografis** (gender, usia, kota) yang berkorelasi dengan completion rate.

---

## 💡 Business Recommendations

Rekomendasi utama (detail lengkap di [`reports/recommendations.md`](reports/recommendations.md)):

1. **Bangun early-warning system** — kirim reminder otomatis untuk user yang belum menyelesaikan modul apapun dalam 3-5 hari sejak enrollment.
2. **Revisi struktur modul-modul akhir kursus** (terutama 3 modul terakhir pada kursus dengan ≥10 modul).
3. **Jalankan program coaching instruktur berbasis data completion rate**, bukan berdasarkan rating — kedua metrik ini tidak berkorelasi.
4. **Jadwalkan notifikasi/reminder di jam 19.00–22.00 pada hari kerja**, dan lebih awal (09.00–10.00) untuk kampanye akhir pekan.
5. **Prioritaskan audit pada kursus dengan completion rate terendah** dan revenue tinggi (lihat dashboard halaman Course Performance untuk daftar lengkap), pelajari pola sukses dari kursus benchmark completion rate tertinggi.
6. **Pisahkan KPI evaluasi instruktur** — rating dan completion rate perlu dipantau dan dievaluasi secara terpisah.

---

## 📁 Folder Structure

```
edusmart-course-analytics/
├── README.md                          # Dokumen ini
├── requirements.txt                   # Dependencies Python
├── .gitignore
│
├── data/
│   ├── raw/                           # Dataset mentah (7 tabel CSV)
│   │   ├── dim_users.csv
│   │   ├── dim_instructors.csv
│   │   ├── dim_courses.csv
│   │   ├── dim_modules.csv
│   │   ├── fact_enrollments.csv
│   │   ├── fact_progress.csv
│   │   └── fact_reviews.csv
│   └── processed/                     # Dataset hasil cleaning & feature engineering
│       ├── *_cleaned.csv              # 7 tabel hasil data cleaning
│       └── enrollment_analytical.csv  # Dataset hasil feature engineering
│
├── docs/
│   ├── project_brief.md               # Latar belakang, tujuan, deliverables proyek
│   ├── data_dictionary.md             # Skema tabel, PK/FK, ERD
│   ├── business_questions.md          # 20 pertanyaan bisnis & status jawaban
│   ├── roadmap.md                     # Alur kerja 8 tahap
│   ├── analysis_checklist.md          # Checklist cleaning, EDA, SQL, dashboard
│   └── dashboard_specification.md     # Spesifikasi teknis dashboard (KPI, grafik, filter, warna, layout, UX)
│
├── sql/
│   ├── 01_completion_rate_per_category.sql
│   ├── 02_dropoff_per_module.sql
│   ├── 03_top_priority_courses.sql
│   ├── 04_rating_correlation.sql
│   └── 05_learning_time_pattern.sql
│
├── notebooks/
│   ├── 01_data_cleaning.ipynb
│   ├── 02_eda.ipynb
│   ├── 03_feature_engineering.ipynb
│   └── 04_correlation_analysis.ipynb
│
├── dashboard/
│   ├── EduSmart_Dashboard.pbix
│   └── screenshots/
│
└── reports/
    ├── key_findings.md                # 22 insight bisnis
    └── recommendations.md             # Rekomendasi strategis untuk manajemen
```

---

## 📬 Contact

Proyek ini dibuat sebagai portofolio Data Analyst — mensimulasikan proyek freelance nyata dari awal (project brief & dashboard specification) hingga akhir (dashboard interaktif & laporan rekomendasi).

*Feedback dan diskusi terbuka lewat [alishamonifa3@gmail.com].*

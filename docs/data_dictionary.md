# DATA DICTIONARY — Dataset Dummy EduSmart

Dataset ini terdiri dari **7 tabel relasional** (4 tabel dimensi + 3 tabel fakta) yang disimpan sebagai file CSV, siap dipakai untuk SQL (import ke database), Python (Pandas), maupun Power BI (relational model / star schema).

File tersedia:
`dim_users.csv`, `dim_courses.csv`, `dim_instructors.csv`, `dim_modules.csv`, `fact_enrollments.csv`, `fact_progress.csv`, `fact_reviews.csv`

---

## 1. dim_users — 2.000 baris
Data profil user/pelajar.

| Kolom | Tipe Data | Deskripsi |
|---|---|---|
| **user_id** (PK) | INT | ID unik user |
| full_name | VARCHAR | Nama lengkap user |
| email | VARCHAR | Email user (±1% missing — untuk latihan data cleaning) |
| gender | VARCHAR | Male / Female |
| birth_date | DATE | Tanggal lahir |
| city | VARCHAR | Kota domisili user |
| registration_date | DATE | Tanggal user mendaftar di platform |
| account_status | VARCHAR | active / inactive |

---

## 2. dim_instructors — 60 baris
Data instruktur/pengajar kursus.

| Kolom | Tipe Data | Deskripsi |
|---|---|---|
| **instructor_id** (PK) | INT | ID unik instruktur |
| instructor_name | VARCHAR | Nama instruktur |
| expertise_area | VARCHAR | Bidang keahlian (Programming, Data Science, dll) |
| email | VARCHAR | Email instruktur |
| joined_date | DATE | Tanggal bergabung sebagai instruktur |
| years_experience | INT | Lama pengalaman mengajar (tahun) |

---

## 3. dim_courses — 300 baris
Data master kursus.

| Kolom | Tipe Data | Deskripsi |
|---|---|---|
| **course_id** (PK) | INT | ID unik kursus |
| course_name | VARCHAR | Nama kursus |
| category | VARCHAR | Kategori kursus (8 kategori) |
| **instructor_id** (FK → dim_instructors) | INT | Instruktur pengampu kursus |
| level | VARCHAR | Beginner / Intermediate / Advanced |
| price | INT | Harga kursus (Rupiah, 0 = gratis) |
| total_modules | INT | Jumlah total modul dalam kursus |
| publish_date | DATE | Tanggal kursus dipublikasikan |
| language | VARCHAR | Bahasa pengantar kursus |

---

## 4. dim_modules — ±2.467 baris
Data modul/materi dalam setiap kursus (rata-rata 4–12 modul per kursus).

| Kolom | Tipe Data | Deskripsi |
|---|---|---|
| **module_id** (PK) | INT | ID unik modul |
| **course_id** (FK → dim_courses) | INT | Kursus induk dari modul ini |
| module_order | INT | Urutan modul dalam kursus (1, 2, 3, ...) |
| module_title | VARCHAR | Judul modul |
| duration_minutes | INT | Estimasi durasi modul dalam menit (±2% missing) |

---

## 5. fact_enrollments — ±7.947 baris
Data pendaftaran user ke kursus (transaksi utama).

| Kolom | Tipe Data | Deskripsi |
|---|---|---|
| **enrollment_id** (PK) | INT | ID unik pendaftaran |
| **user_id** (FK → dim_users) | INT | User yang mendaftar |
| **course_id** (FK → dim_courses) | INT | Kursus yang didaftar |
| enrollment_date | DATE | Tanggal pendaftaran |
| enrollment_source | VARCHAR | Sumber akuisisi: organic / promo / referral / ads |

*Catatan: terdapat sejumlah kecil duplikasi user_id + course_id (± 3 baris) untuk mensimulasikan kasus re-enrollment/retake — bagian dari latihan data cleaning.*

---

## 6. fact_progress — ±35.526 baris
Data progres belajar user per modul — tabel paling granular, dasar analisis drop-off, completion rate, dan pola waktu belajar.

| Kolom | Tipe Data | Deskripsi |
|---|---|---|
| **progress_id** (PK) | INT | ID unik record progres |
| **enrollment_id** (FK → fact_enrollments) | INT | Pendaftaran terkait |
| **module_id** (FK → dim_modules) | INT | Modul yang diakses |
| access_date | DATE | Tanggal modul diakses (±2% missing/null) |
| access_timestamp | DATETIME | Tanggal + jam modul diakses (dipakai untuk analisis jam/hari belajar paling aktif; ±2% missing, selaras dengan access_date) |
| status | VARCHAR | not_started / in_progress / completed |
| time_spent_minutes | INT | Waktu yang dihabiskan di modul (mengandung nilai negatif & outlier ekstrem secara sengaja untuk latihan cleaning) |
| completion_date | DATE | Tanggal modul diselesaikan (null jika belum selesai) |
| completion_timestamp | DATETIME | Tanggal + jam modul diselesaikan (= access_timestamp + time_spent_minutes; null jika belum selesai) |

**Pola jam/hari belajar yang disisipkan dalam `access_timestamp`:**
- **Jam sibuk (weekday):** 19.00–22.00 (malam hari) dan 12.00–13.00 (jam istirahat siang) — bobot akses jauh lebih tinggi dibanding jam lain.
- **Weekend (Sabtu–Minggu):** distribusi lebih merata sepanjang siang–sore (09.00–16.00) dengan tambahan puncak malam (20.00–21.00).
- **Dini hari (00.00–05.00):** aktivitas sangat rendah di semua hari.

Pola ini sengaja dibuat agar analisis "jam/hari belajar paling aktif" (poin 6 di Project Brief) menghasilkan insight yang jelas dan bisa divisualisasikan sebagai heatmap jam × hari di Power BI atau Python.

*Catatan penting: tabel ini didesain dengan 5 pola "learner profile" (completer, early_dropper, mid_dropper, slow_learner, ghost_user) sehingga pola drop-off per modul terlihat realistis dan bisa dianalisis. User dengan profil "ghost_user" (enrolled tapi tidak pernah mengakses modul) sengaja tidak punya baris di tabel ini — inilah salah satu bentuk data inconsistency yang perlu diidentifikasi.*

---

## 7. fact_reviews — ±3.623 baris
Data rating & ulasan kursus dari user (opsional — tidak semua enrollment memberi review).

| Kolom | Tipe Data | Deskripsi |
|---|---|---|
| **review_id** (PK) | INT | ID unik review |
| **enrollment_id** (FK → fact_enrollments) | INT | Pendaftaran yang memberi review |
| rating | INT | Skor 1–5 |
| review_text | VARCHAR | Isi ulasan |
| review_date | DATE | Tanggal review diberikan |

---

## Entity Relationship Diagram (ERD) — Skema Konseptual

```
dim_instructors (1) ────────< (N) dim_courses (1) ────────< (N) dim_modules
                                       │                              │
                                       │ (1)                          │ (1)
                                       │                              │
                                       ∨ (N)                          ∨ (N)
dim_users (1) ────────< (N) fact_enrollments ────────< (N) fact_progress
                                       │ (1)
                                       │
                                       ∨ (N)
                                fact_reviews
```

### Penjelasan Hubungan Antar Tabel

| Relasi | Tipe | Penjelasan |
|---|---|---|
| dim_instructors → dim_courses | 1-ke-N | 1 instruktur bisa mengampu banyak kursus |
| dim_courses → dim_modules | 1-ke-N | 1 kursus terdiri dari banyak modul |
| dim_users → fact_enrollments | 1-ke-N | 1 user bisa mendaftar banyak kursus |
| dim_courses → fact_enrollments | 1-ke-N | 1 kursus bisa didaftar banyak user |
| fact_enrollments → fact_progress | 1-ke-N | 1 pendaftaran memiliki banyak baris progres (1 per modul yang diakses) |
| dim_modules → fact_progress | 1-ke-N | 1 modul diakses oleh banyak enrollment berbeda |
| fact_enrollments → fact_reviews | 1-ke-1 (opsional) | 1 pendaftaran maksimal memberi 1 review |

**Struktur ini adalah star schema sederhana**: `fact_enrollments` dan `fact_progress` sebagai tabel fakta utama, dikelilingi oleh tabel dimensi (`dim_users`, `dim_courses`, `dim_instructors`, `dim_modules`) — cocok langsung dipakai sebagai data model di Power BI.

---

## Karakteristik "Messiness" yang Sengaja Disisipkan (untuk latihan data cleaning)

| Isu | Lokasi | Jumlah (approx.) |
|---|---|---|
| Email kosong | dim_users | ~16 baris |
| access_date kosong | fact_progress | ~709 baris |
| time_spent_minutes negatif | fact_progress | ~356 baris |
| time_spent_minutes outlier ekstrem | fact_progress | ~255 baris |
| duration_minutes modul kosong | dim_modules | ~51 baris |
| Duplikasi enrollment (user+course sama) | fact_enrollments | ~3 baris |
| User "ghost" (enroll tapi 0 progres) | fact_enrollments vs fact_progress | ~15% dari total enrollment |
| User berstatus "inactive" tapi punya histori progres | dim_users vs fact_progress | Bisa ditemukan lewat JOIN |

Karakteristik ini sengaja dirancang agar proyek benar-benar membutuhkan tahap **data cleaning** (Tugas #1 di Project Brief) sebelum masuk ke EDA dan analisis lanjutan.

---

## Contoh Penggunaan

- **SQL**: import ke SQLite/PostgreSQL/MySQL untuk query drop-off per modul (`fact_progress` JOIN `dim_modules` JOIN `fact_enrollments`).
- **Python**: gunakan Pandas untuk data cleaning (handle missing values, outlier, duplikasi) dan analisis korelasi rating vs completion rate.
- **Power BI**: import ketujuh CSV, buat relasi sesuai ERD di atas, bangun dashboard completion rate per kategori, drop-off per modul, dan heatmap jam/hari belajar aktif (ekstrak jam dari kolom `access_timestamp`, gabungkan dengan nama hari dari `access_date`).

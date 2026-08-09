# DASHBOARD SPECIFICATION — Project EduSmart
## Disusun oleh Project Manager untuk Tim Data Analyst

Dokumen ini menerjemahkan kebutuhan klien (EduSmart) di Project Brief menjadi spesifikasi teknis dashboard yang siap dieksekusi. Tujuannya: dashboard bisa dipakai mandiri oleh tim non-teknis (Product Manager, Curriculum Team) untuk memonitor performa kursus tanpa perlu meminta laporan manual setiap saat.

**Status implementasi:** ✅ Seluruh item wajib telah diimplementasikan di `dashboard/EduSmart_Dashboard.pbix`. Slicer Instruktur dan Enrollment Source (button slicer) belum ditambahkan pada versi ini — dapat dikembangkan lebih lanjut mengikuti pola slicer Kategori/Level yang sudah ada. Mobile layout (item opsional) belum dibuat pada versi ini.

---

## 1. KPI Cards

KPI Card ditempatkan di bagian atas halaman **Overview**, harus terlihat dalam 3 detik pertama tanpa perlu scroll.

| KPI Card | Sumber Data | Catatan |
|---|---|---|
| **Total Enrollment** | `fact_enrollments` | Angka kumulatif + badge perbandingan vs periode sebelumnya (▲/▼ %) |
| **Overall Completion Rate** | `fact_enrollments` + `fact_progress` | Metrik paling penting — tampilkan besar, warnai merah/kuning/hijau sesuai threshold |
| **Total Active Users** | `dim_users` (account_status = active) | Untuk melihat basis user yang masih engaged |
| **Average Course Rating** | `fact_reviews` | Skala 1–5, tampilkan dalam bentuk bintang + angka |
| **Total Courses Published** | `dim_courses` | Konteks skala platform |
| **Average Time to Drop-off (hari)** | `fact_progress` + `fact_enrollments` | KPI pendukung untuk urgensi masalah |

**Ketentuan KPI Card:**
- Maksimal 6 card per baris agar tidak sesak.
- Setiap card punya perbandingan terhadap periode sebelumnya (MoM atau QoQ) — bukan angka statis, supaya klien langsung tahu tren naik/turun.
- Completion Rate diberi **conditional formatting warna** (lihat bagian Warna) karena ini KPI paling kritikal di seluruh proyek.

---

## 2. Grafik yang Diperlukan

| Grafik | Jenis | Halaman | Tujuan |
|---|---|---|---|
| Completion Rate per Kategori Kursus | Bar chart horizontal, diurutkan | Course Performance | Identifikasi kategori bermasalah dalam sekali lihat |
| Enrollment Trend per Bulan | Line chart | Overview | Melihat momentum pertumbuhan/penurunan platform |
| Drop-off Funnel per Modul | Funnel chart / bar chart menurun | Drop-off Analysis | Titik persis di mana user paling banyak berhenti |
| Heatmap Jam × Hari Aktif Belajar | Heatmap matrix | Learning Pattern | Menentukan waktu optimal untuk notifikasi/reminder |
| Rating Instruktur vs Completion Rate | Scatter plot | Instructor Performance | Uji visual korelasi rating terhadap hasil belajar |
| Top 10 Kursus Prioritas Revisi | Tabel/matrix dengan bar in-cell | Course Performance | Enrollment tinggi + completion rendah = kandidat revisi |
| Distribusi Completion per Level Kursus | Stacked bar (Beginner/Intermediate/Advanced) | Course Performance | Apakah tingkat kesulitan memengaruhi completion |
| Completion Rate per Enrollment Source | Bar chart | Overview atau Course Performance | Evaluasi efektivitas channel akuisisi terhadap hasil belajar |
| Distribusi Rating (1–5) | Bar chart vertikal | Instructor Performance | Sebaran kepuasan user secara umum |

**Prinsip pemilihan grafik:**
- Satu grafik = satu insight utama. Hindari menggabungkan terlalu banyak metrik dalam satu visual.
- Drop-off funnel harus bisa **difilter per kursus** karena setiap kursus punya jumlah modul berbeda — funnel gabungan semua kursus akan menyesatkan.
- Heatmap jam × hari dipisah sebagai halaman sendiri karena ini insight yang sering diminta terpisah oleh tim Marketing untuk atur jadwal campaign.

---

## 3. Filter (Page-level / Report-level)

Filter diterapkan di level laman atau seluruh laporan, biasanya tidak terlihat langsung oleh user (di panel filter Power BI) tapi memengaruhi semua visual di halaman tersebut.

- **Rentang tanggal enrollment** (date range filter) — default: 6 bulan terakhir, bisa diperluas.
- **Status kursus** (aktif/nonaktif dipublikasikan) — agar kursus lama yang sudah tidak dijual tidak mengganggu analisis kursus aktif.
- **Bahasa kursus** (Indonesia/English) — relevan jika strategi konten dibedakan per bahasa.

---

## 4. Slicer (Interaktif, terlihat oleh user di kanvas)

Slicer ditaruh langsung di kanvas dashboard agar user non-teknis bisa klik langsung tanpa masuk ke panel filter.

- **Slicer Kategori Kursus** — dropdown/list, multi-select (Programming, Data Science, Business, dll)
- **Slicer Level Kursus** — button slicer (Beginner / Intermediate / Advanced), karena hanya 3 opsi cocok pakai tombol horizontal
- **Slicer Instruktur** — dropdown search-enabled (karena ada 60 instruktur, tidak cocok pakai list panjang)
- **Slicer Enrollment Source** — button slicer (organic/promo/referral/ads)
- **Slicer Kursus Spesifik** — khusus di halaman Drop-off Analysis, dropdown search untuk memilih 1 kursus yang ingin dilihat funnel drop-off-nya

**Ketentuan slicer:**
- Semua slicer disinkronkan (sync visual) antar halaman yang relevan, supaya saat user pilih "Data Science" di halaman Overview, halaman Course Performance ikut ter-filter.
- Sediakan tombol **"Reset Filter"** di setiap halaman agar user tidak bingung saat filter menumpuk.

---

## 5. Warna (Color Palette & Conditional Formatting)

**Prinsip:** warna harus punya makna konsisten di seluruh dashboard — bukan sekadar estetika.

| Elemen | Warna | Makna |
|---|---|---|
| Completion Rate tinggi (≥ 70%) | Hijau (#2E7D32) | Performa baik |
| Completion Rate sedang (40–69%) | Kuning/Oranye (#F9A825) | Perlu perhatian |
| Completion Rate rendah (< 40%) | Merah (#C62828) | Prioritas revisi |
| Warna aksen brand/kategori | 1 warna primer konsisten (mis. Biru #1565C0) | Dipakai untuk elemen netral (bar chart, garis tren) |
| Heatmap jam × hari | Gradasi 1 warna (light → dark, mis. skala biru) | Hindari multi-warna acak yang membingungkan pola intensitas |
| Background | Putih/abu sangat muda (#FAFAFA) | Netral, tidak mengganggu fokus ke data |

**Aturan tambahan:**
- Maksimal 1 warna aksen brand + 3 warna status (hijau/kuning/merah) di seluruh dashboard — jangan lebih, agar tidak terlihat "ramai" dan tetap profesional.
- Hindari warna merah-hijau berdampingan tanpa label angka (pertimbangkan aksesibilitas untuk user color-blind) — selalu sertakan angka di samping indikator warna.

---

## 6. Layout Halaman

Dashboard terdiri dari **5 halaman**, urutan navigasi dari umum ke spesifik:

```
1. Overview
   → KPI Cards (baris atas) + Enrollment Trend + Completion Rate per Kategori (ringkas)

2. Course Performance
   → Completion Rate per Kategori (detail) + per Level + Top 10 Kursus Prioritas Revisi

3. Drop-off Analysis
   → Slicer pilih 1 kursus + Funnel drop-off per modul + tabel detail modul

4. Learning Pattern
   → Heatmap jam × hari + insight singkat pola waktu aktif

5. Instructor Performance
   → Scatter rating vs completion rate + tabel ranking instruktur + distribusi rating
```

**Prinsip layout tiap halaman:**
- **Grid 12 kolom** standar — KPI card di baris atas (span penuh), grafik utama di tengah (ukuran besar), grafik pendukung di sisi kanan/bawah (ukuran kecil).
- Judul halaman & 1 kalimat konteks di pojok kiri atas setiap halaman (misal: "Halaman ini menunjukkan di modul mana user paling banyak berhenti").
- Navigasi antar halaman via tab/menu di sisi kiri atau atas — konsisten posisinya di semua halaman.
- Hindari scroll vertikal berlebihan — 1 halaman idealnya muat dalam 1 layar (1920×1080 atau ukuran standar Power BI).

---

## 7. User Experience (UX)

Karena dashboard ini akan dipakai oleh tim **non-teknis** (Product Manager, Curriculum Team), prinsip UX yang diutamakan:

- **Self-explanatory dalam 5 detik** — setiap visual punya judul yang jelas dan langsung menjawab pertanyaan (bukan "Chart 1" tapi "Completion Rate per Kategori Kursus").
- **Tooltip informatif** — saat hover di grafik, tampilkan angka pendukung (jumlah enrollment, jumlah completed) bukan hanya persentase, agar user paham konteks di balik angka.
- **Drill-down bertahap** — dari Overview (ringkasan) → Course Performance (per kategori) → Drop-off Analysis (per modul dalam 1 kursus), sehingga user tidak overwhelmed di halaman pertama.
- **Cross-highlight antar visual** — klik 1 kategori di bar chart otomatis menyorot data terkait di visual lain pada halaman yang sama.
- **Konsistensi posisi elemen** — slicer selalu di posisi yang sama (misal kiri atas) di semua halaman, agar user tidak perlu "mencari ulang" tiap pindah halaman.
- **Bahasa label dalam Bahasa Indonesia, jelas dan non-teknis** — hindari istilah seperti "funnel conversion" tanpa penjelasan; gunakan "Alur Penyelesaian Modul" dengan sub-label yang jelas.
- **Loading cepat** — dashboard tidak boleh lambat saat filter diganti; jika data terlalu besar, pertimbangkan agregasi di level data model (bukan real-time kalkulasi berat di visual).
- **Mobile-friendly (opsional tapi nilai tambah)** — jika klien juga mengakses dari HP/tablet, siapkan layout mobile Power BI khusus halaman Overview.

---

## Catatan untuk Data Analyst

- Prioritaskan halaman **Overview** dan **Drop-off Analysis** terlebih dahulu — ini dua halaman yang paling sering dibuka klien berdasarkan Business Questions Level 2 & 4 yang sudah disusun sebelumnya.
- Sebelum finalisasi warna & layout, lakukan **1 sesi review internal** membayangkan diri sebagai Product Manager EduSmart yang buka dashboard pertama kali tanpa penjelasan — apakah langsung paham?
- Setelah draft pertama selesai, ini jadi **Checkpoint 3** sesuai Roadmap (review layout/visual sebelum finalisasi).

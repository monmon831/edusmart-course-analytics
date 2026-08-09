# Laporan Rekomendasi — EduSmart Course Performance & Completion Rate

**Untuk:** Tim Manajemen, Product Manager, dan Tim Kurikulum EduSmart
**Dari:** Data Analyst (Freelance)
**Konteks:** Rekomendasi ini disusun berdasarkan analisis menyeluruh terhadap 7.947 data enrollment, mencakup data cleaning, exploratory data analysis, SQL analysis, uji korelasi statistik, dan dashboard monitoring interaktif (lihat dashboard/EduSmart_Dashboard.pbix dan reports/key_findings.md untuk detail lengkap).

---

## Ringkasan Eksekutif

Completion rate keseluruhan platform EduSmart saat ini **28.74%** — angka ini konsisten di seluruh kategori kursus (gap hanya ~5 poin) maupun periode waktu, menandakan ini adalah **masalah struktural platform**, bukan masalah satu-dua kursus tertentu. Tiga akar masalah paling signifikan yang teridentifikasi:

1. User kehilangan momentum di **minggu pertama** setelah enrollment
2. **Modul-modul akhir** kursus (terutama 3 modul terakhir) memiliki drop-off yang sangat tinggi
3. Variasi completion rate antar **instruktur individual** jauh lebih besar daripada antar kategori kursus — menunjukkan faktor manusia (cara mengajar, desain modul) lebih berpengaruh daripada topik kursusnya sendiri

**Yang PERLU diluruskan dari asumsi awal:** rating instruktur/kursus **tidak berkorelasi sama sekali** dengan completion rate (r = -0.008, p = 0.95). Strategi apapun yang mengandalkan "instruktur rating tinggi = completion tinggi" tidak akan efektif dan sebaiknya tidak dijadikan dasar keputusan. Demikian pula, karakteristik demografis user (gender, usia, kota) tidak menunjukkan pola yang berarti terhadap completion rate — strategi segmentasi campaign sebaiknya berbasis **perilaku** (kecepatan progress awal, riwayat drop-off), bukan demografi.

---

## Rekomendasi 1 — Early Warning System untuk Minggu Pertama
**Prioritas: Tinggi | Effort: Sedang | Dampak: Tinggi**

**Temuan pendukung:** User yang akhirnya menyelesaikan kursus rata-rata menuntaskan 1.13 modul di 7 hari pertama; yang tidak menyelesaikan rata-rata hanya 0.60 modul (lebih dari separuh bahkan 0 modul). Kecepatan progress minggu pertama adalah sinyal paling kuat yang kita temukan untuk memprediksi siapa yang akan drop-off.

**Rekomendasi konkret:**
- Bangun sistem trigger otomatis: jika user belum menyelesaikan modul apapun dalam 3-5 hari sejak enrollment, kirim notifikasi/reminder personal
- Pertimbangkan insentif kecil untuk menyelesaikan modul pertama dalam 48 jam (misal badge, progress bar visual yang mendorong)
- Kirim reminder pada jam-jam paling aktif user (lihat Rekomendasi 4)

---

## Rekomendasi 2 — Revisi Struktur Modul Akhir Kursus
**Prioritas: Tinggi | Effort: Tinggi | Dampak: Tinggi**

**Temuan pendukung:** Drop-off rate melonjak drastis di modul-modul akhir — modul 9 (25.46%), modul 10 (35.52%), modul 11 (51.16%). User yang sudah menempuh sebagian besar perjalanan belajar justru paling berisiko berhenti sebelum benar-benar tuntas.

**Rekomendasi konkret:**
- Audit konten 3 modul terakhir di kursus-kursus dengan total modul ≥10 — evaluasi apakah durasi terlalu panjang, materi tiba-tiba lebih berat, atau kurang elemen motivasi menjelang akhir
- Pertimbangkan memecah modul akhir yang berat jadi 2 bagian lebih kecil
- Tambahkan elemen "hampir selesai" yang eksplisit (progress bar, pesan motivasi) khusus di modul-modul akhir
- Prioritaskan audit pada course_id 299 ("Data Analysis dengan Python - Batch 2", 16.22%) dan course_id 129 ("Financial Analysis untuk Manajer", 21.05%) sebagai kandidat revisi paling mendesak — keduanya populer (>35 enrollment) namun completion rate jauh di bawah rata-rata
- Dengan mempertimbangkan estimasi revenue (price × enrollment), tambahkan juga "Entrepreneurship Fundamentals" (~Rp18 juta estimasi revenue, completion rate 13.89%, 31 dari 36 user belum selesai), "Manajemen Proyek Agile - Batch 2" (~Rp17.5 juta, 14.29%), dan "Data Visualization dengan Power BI" (~Rp16.5 juta, 15.15%) sebagai prioritas tambahan — kombinasi revenue besar dengan completion rate sangat rendah berarti kerugian ganda: biaya akuisisi/produksi tinggi namun nilai yang diterima user sangat rendah
- Pelajari pola sukses dari course_id 235 ("Editing Foto dengan Lightroom - Batch 5", 52.27%) sebagai benchmark internal

---

## Rekomendasi 3 — Program Coaching Instruktur Berbasis Data
**Prioritas: Sedang | Effort: Sedang | Dampak: Sedang-Tinggi**

**Temuan pendukung:** Gap completion rate antar instruktur (20.55% – 37.50%, selisih 17 poin) jauh lebih lebar dari gap antar kategori kursus (~5 poin). Ini menunjukkan cara mengajar dan desain kursus oleh instruktur individual berpengaruh lebih besar daripada topik itu sendiri.

**Rekomendasi konkret:**
- Prioritaskan coaching untuk instruktur dengan completion rate konsisten rendah dan sampel enrollment besar (bukan kebetulan sampel kecil) — lihat daftar lengkap di sql/01_completion_rate_per_category.sql (Query 3)
- **Jangan** gunakan rating sebagai kriteria seleksi coaching — tidak berkorelasi dengan completion rate
- Pelajari pendekatan instruktur dengan completion rate tertinggi (Jelita Sihotang 37.50%, R.A. Hamima Gunawan 37.33%) sebagai referensi best practice, lalu bagikan ke instruktur lain

---

## Rekomendasi 4 — Optimalkan Waktu Notifikasi/Campaign
**Prioritas: Rendah-Sedang | Effort: Rendah | Dampak: Sedang**

**Temuan pendukung:** Pola akses sangat jelas — hari kerja puncak di 19.00-22.00 dan jam istirahat siang 12.00-13.00; akhir pekan lebih merata di 09.00-16.00. Data lengkap tersedia di dashboard halaman "Learning Pattern".

**Rekomendasi konkret:**
- Jadwalkan notifikasi/reminder push di jam 19.00-22.00 pada hari kerja untuk hasil keterbacaan maksimal
- Untuk kampanye akhir pekan, kirim lebih awal (09.00-10.00 pagi) karena jendela aktif lebih lebar
- Hindari mengirim komunikasi di dini hari (00.00-05.00) — engagement sangat rendah di jam ini

---

## Rekomendasi 5 — Tinjau Ulang Strategi Akuisisi via Ads
**Prioritas: Rendah | Effort: Rendah | Dampak: Sedang**

**Temuan pendukung:** User dari sumber organic memiliki completion rate tertinggi (30.22%), sementara ads terendah (27.64%).

**Rekomendasi konkret:**
- Evaluasi ROI campaign ads tidak hanya dari jumlah enrollment, tapi juga kualitas (completion rate) yang dihasilkan
- Investasi lebih lanjut ke strategi yang mendorong pertumbuhan organic (SEO, referral, community) sebagai pelengkap ads

---

## Rekomendasi 6 — Klarifikasi Makna Field `account_status`
**Prioritas: Rendah | Effort: Rendah | Dampak: Operasional**

**Temuan pendukung:** Tidak ada perbedaan aktivitas belajar antara user "active" dan "inactive" (rata-rata progress 18.1 vs 17.9). 99.5% user "inactive" tetap memiliki histori belajar substansial.

**Rekomendasi konkret:**
- Klarifikasi ke tim engineering/product apakah field ini memang dimaksudkan sebagai status akun/langganan, bukan status keterlibatan belajar
- **Jangan** gunakan account_status sebagai proxy engagement dalam laporan atau keputusan bisnis ke depan — gunakan data progress/aktivitas langsung dari fact_progress

---

## Prioritas Eksekusi (Effort vs Impact)

| Rekomendasi | Effort | Dampak | Prioritas |
|---|---|---|---|
| 1. Early warning system minggu pertama | Sedang | Tinggi | **Quick win — kerjakan dulu** |
| 2. Revisi modul akhir kursus | Tinggi | Tinggi | Prioritas utama, butuh waktu |
| 3. Coaching instruktur berbasis data | Sedang | Sedang-Tinggi | Jalan paralel dengan #2 |
| 4. Optimalkan waktu notifikasi | Rendah | Sedang | **Quick win — kerjakan dulu** |
| 5. Tinjau strategi ads | Rendah | Sedang | Bisa menyusul |
| 6. Klarifikasi account_status | Rendah | Operasional | Bisa menyusul |

**Saran urutan kerja:** Mulai dari Rekomendasi 1 dan 4 (effort rendah-sedang, bisa dieksekusi cepat, dampak langsung terasa), sambil menyiapkan audit mendalam untuk Rekomendasi 2 dan 3 yang butuh waktu lebih lama namun berdampak paling besar terhadap completion rate secara keseluruhan.

---

## Alat Pendukung yang Tersedia

- **Dashboard interaktif** (`dashboard/EduSmart_Dashboard.pbix`) — monitoring completion rate, drop-off, dan pola belajar secara real-time, dapat difilter per kategori/level/periode
- **SQL Query Documentation** (`sql/`) — 5 file query siap pakai ulang untuk analisis lanjutan oleh tim internal
- **Notebook Python** (`notebooks/`) — proses data cleaning, EDA, feature engineering, dan uji statistik yang dapat direproduksi dan diperbarui

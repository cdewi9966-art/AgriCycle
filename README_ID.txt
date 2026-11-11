AGRICYCLE — PAKET STARTER WEBSITE ONLINE + PWA + SUPABASE

ISI PAKET
- index.html: aplikasi responsif, daftar/masuk, peran pemasok/pemanfaat, unggah penawaran dan foto, pasar, hapus penawaran milik sendiri.
- schema.sql: tabel, trigger profil, Row Level Security, dan bucket foto Supabase.
- manifest.webmanifest, sw.js, icon.svg: dukungan PWA untuk pemasangan dari browser.

PENTING
Paket ini belum online sampai Anda membuat proyek Supabase dan mengunggah folder ini ke hosting HTTPS. Jangan masukkan Supabase service_role key ke index.html. Hanya gunakan Project URL dan anon/public key.

LANGKAH 1 — DATABASE DAN LOGIN (SUPABASE)
1. Buka https://supabase.com lalu daftar/masuk dan buat proyek baru bernama AgriCycle. Simpan password database dengan aman.
2. Di proyek Supabase buka SQL Editor > New query. Salin seluruh isi schema.sql, lalu tekan Run.
3. Buka Project Settings > API. Salin Project URL dan anon/public key.
4. Buka index.html. Ganti nilai SUPABASE_URL dan SUPABASE_ANON_KEY di bagian awal script dengan nilai proyek Anda.
5. Buka Authentication > URL Configuration setelah domain hosting dibuat. Isi Site URL dengan URL website HTTPS Anda. Tambahkan URL callback/redirect yang diperlukan.
6. Untuk uji awal, nonaktifkan email confirmation hanya jika Anda memahami konsekuensi keamanan; untuk penggunaan publik, sebaiknya aktifkan dan konfigurasi SMTP email.

LANGKAH 2 — WEBSITE PUBLIK
1. Buka https://app.netlify.com/drop dan masuk/daftar.
2. Unggah folder AgriCycle_Online_Starter (atau isi foldernya) ke area deploy.
3. Netlify memberi URL publik HTTPS berbentuk nama-situs.netlify.app.
4. Masukkan URL itu ke Supabase Authentication > URL Configuration > Site URL dan Redirect URLs.
5. Tes pendaftaran dua akun: satu sebagai Penyetor/Pemasok, satu sebagai Pemanfaat. Tes unggah, foto, dan tampilan Pasar.

LANGKAH 3 — PASANG DI ANDROID / IPHONE
- Android: buka URL publik di Chrome > menu titik tiga > Install app / Add to Home screen.
- iPhone: buka URL publik di Safari > tombol Share > Add to Home Screen.
PWA tidak otomatis masuk Play Store atau App Store. Untuk listing toko aplikasi diperlukan proses build dan publikasi terpisah.

BATASAN MVP SAAT INI
- Login email/password, peran pemasok/pemanfaat, daftar penawaran, foto, pasar, dan hapus penawaran.
- Belum ada pembayaran, kurir sungguhan, chat, notifikasi, verifikasi admin, klaim/transaksi final, moderasi, atau panel admin.
- Bucket foto dibuat publik agar foto penawaran dapat tampil pada pasar. Jangan unggah dokumen pribadi atau foto sensitif.
- Sebelum dipakai publik, perlu uji keamanan, kebijakan privasi, ketentuan layanan, validasi data, dan backup.

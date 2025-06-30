# UAS PBM - Aplikasi Manajemen Keuangan
Nama Kelompok :
- Jimly Asidiq Anwar (4522210018)
- Muhamad Farhan (4522210057)
- Rizky Galih Dwiyanto (4522210074)


# Manajemen Keuangan App

Aplikasi Manajemen Keuangan adalah aplikasi berbasis Flutter yang dirancang untuk membantu pengguna mencatat dan memantau pemasukan serta pengeluaran mereka. Dengan tampilan yang modern dan fitur yang sederhana, aplikasi ini cocok digunakan oleh siapa saja yang ingin mengelola keuangan pribadi dengan lebih baik.

---

## Tampilan Aplikasi

### Login

![foto 1](https://github.com/user-attachments/assets/5671fc6c-c86b-4fcf-890c-e5265ccdbabc)


---

### Register

![foto 2](https://github.com/user-attachments/assets/10b22f9f-31d3-4cf7-9921-9bec0621a5e0)


---

### Beranda

![foto 6](https://github.com/user-attachments/assets/c2bbc732-cab2-4b66-811c-c50c276998c6)


---

### Tambah Transaksi

![foto 4](https://github.com/user-attachments/assets/57c8eed7-5de0-4fd8-bbf6-a39c8acbf6fa)


---

### Notifikasi

![foto 3](https://github.com/user-attachments/assets/83f7474c-4086-4889-9a49-7846290e88b3)


---

### Akun

![foto 5](https://github.com/user-attachments/assets/c1e196e3-231d-4746-a17b-ad6a30739259)


---

##  Fitur Utama

- **Autentikasi Pengguna**: Fitur login dan register agar data transaksi tersimpan per pengguna.
- **Dashboard Beranda**: Menampilkan ringkasan saldo, total pemasukan, dan total pengeluaran.
- **Tambah Transaksi**: Memungkinkan pengguna menambahkan transaksi pemasukan atau pengeluaran dengan detail nominal dan deskripsi.
- **Daftar Transaksi Terbaru**: Mempermudah memantau riwayat transaksi.
- **Mode Gelap (Dark Mode)**: Pengguna dapat beralih ke tema gelap sesuai preferensi.
- **Manajemen Akun**: Fitur ubah password, logout, dan hapus akun.

---

##  Struktur Proyek
lib/
├── main.dart
├── login_page.dart
├── register_page.dart
├── home_page.dart
├── add_transaction_page.dart
├── account_page.dart
├── notification_page.dart
├── transaction_model.dart

##  Penjelasan File Utama
* 'main.dart'
Titik masuk aplikasi. File ini menginisialisasi aplikasi dan menjalankan widget utama.

- login_page.dart
Mendefinisikan tampilan dan fungsi login untuk pengguna.

- register_page.dart
Mendefinisikan tampilan dan fungsi registrasi akun baru.

- home_page.dart
Menampilkan ringkasan saldo, pemasukan, pengeluaran, dan daftar transaksi terakhir.

- add_transaction_page.dart
Mendefinisikan halaman untuk menambah transaksi baru (pemasukan atau pengeluaran).

- account_page.dart
Mendefinisikan halaman profil pengguna, termasuk fitur ubah password, logout, hapus akun, dan dark mode.

- notification_page.dart
Menampilkan daftar notifikasi yang diterima oleh pengguna.

- transaction_model.dart
Berisi model data transaksi yang digunakan dalam aplikasi.

---

##  Teknologi

- Flutter
- Dart

---

##  Cara Menjalankan
1. Pastikan Flutter sudah terpasang.
2. Clone repositori ini.
3. Jalankan perintah berikut di terminal:

```bash
flutter pub get
flutter run

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

<img src="https://github.com/user-attachments/assets/5671fc6c-c86b-4fcf-890c-e5265ccdbabc" width="300">



---

### Register

<img src="https://github.com/user-attachments/assets/10b22f9f-31d3-4cf7-9921-9bec0621a5e0" width="300">


---

### Beranda

<img src="https://github.com/user-attachments/assets/b6d2e05f-9903-4d6f-8430-f64448632e2d" width="300">



---

### Tambah Transaksi

<img src="https://github.com/user-attachments/assets/ee519240-260d-49c0-82f6-0891127ae642" width="300">



---

### Notifikasi

<img src="https://github.com/user-attachments/assets/83f7474c-4086-4889-9a49-7846290e88b3" width="300">


---

### Akun

<img src="https://github.com/user-attachments/assets/8efee299-ac1e-4410-8a50-37f987c28367" width="300">


---

### Tablet mode

<img src="https://github.com/user-attachments/assets/bd09fd46-af41-496d-8f6c-f5a9283093cd" width="600">

---

##  Fitur Utama

- **Autentikasi Pengguna**: Fitur login dan register agar data transaksi tersimpan per pengguna.
- **Dashboard Beranda**: Menampilkan ringkasan saldo, total pemasukan, dan total pengeluaran.
- **Tambah Transaksi**: Memungkinkan pengguna menambahkan transaksi pemasukan atau pengeluaran dengan detail nominal, kategori dan deskripsi.
- **Daftar Transaksi Terbaru**: Mempermudah memantau riwayat transaksi.
- **Manajemen Akun**: Fitur ubah foto profil, password, username, email, logout, dan hapus akun.
- **API Cuaca**: Memunculkan Cuaca di lokasi device berada.

---

##  Struktur Proyek
```
lib/
├── database/
│   └── db_helper.dart
├── models/
│   └── user_model.dart
├── screens/
│   ├── change_password_page.dart
│   ├── connection_page.dart
│   ├── edit_profile_page.dart
│   ├── finance_form_page.dart
│   ├── homepage.dart
│   ├── login_page.dart
│   ├── notifications_page.dart
│   ├── profile_page.dart
│   └── register_page.dart
└── main.dart

```

##  Penjelasan File Utama
* `main.dart`
Titik masuk aplikasi. File ini menginisialisasi aplikasi dan menjalankan widget utama.

* `login_page.dart`
Mendefinisikan tampilan dan fungsi login untuk pengguna.

* `register_page.dart`
Mendefinisikan tampilan dan fungsi registrasi akun baru.

* `home_page.dart`
Menampilkan ringkasan saldo, pemasukan, pengeluaran, dan daftar transaksi terakhir.

* `finance_form_page.dart`
Mendefinisikan halaman untuk menambah transaksi baru (pemasukan atau pengeluaran).

* `account_page.dart`
Mendefinisikan halaman profil pengguna, termasuk fitur ubah password, logout, hapus akun, dan dark mode.

* `notification_page.dart`
Menampilkan daftar notifikasi yang diterima oleh pengguna.

*`change_password_page.dart`
Mendefinisikan halaman untuk mengubah password akun.

*`profile_page.dart`
Menampilkan halaman informasi akun pengguna.

*`edit_profile_page`
Mendefinisikan halam untuk pengguna agar dapat mengubah informasi akun.

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

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

<img src="https://github.com/user-attachments/assets/ee175366-9f0e-4e48-a48d-1d24e3e6eb62" width="300">



---

### Beranda

<img src="https://github.com/user-attachments/assets/809948db-b8c7-4595-b6a0-81e0c1eb6b35" width="300">




---

### Tambah Transaksi

<img src="https://github.com/user-attachments/assets/2538bfe4-03cf-4b81-8ed0-70889e8b9e7c" width="300">




---

### Notifikasi

<img src="https://github.com/user-attachments/assets/83f7474c-4086-4889-9a49-7846290e88b3" width="300">


---

### Akun

<img src="https://github.com/user-attachments/assets/f907c91d-592f-427a-b8db-dccebfdbffb3" width="300">



---

### Edit Profile
<img src="https://github.com/user-attachments/assets/e2aae5c7-f2f5-49f2-bf17-8bc1f5f98601" width="300">



---

### Koneksi
<img src="https://github.com/user-attachments/assets/76a16146-cb13-4e49-b56c-407c5b4b9191" width="300">



---

### Ubah Password
<img src="https://github.com/user-attachments/assets/811d8ff4-c674-4d0b-8a99-ed723a46136b" width="300">




---

### Tablet mode

<img src="https://github.com/user-attachments/assets/d1efb51f-e7e1-42bb-aec9-9f6a8019c3a1" width="600">



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

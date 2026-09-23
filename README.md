# Screenly 🎬

Screenly adalah aplikasi mobile katalog film dan serial TV modern berbasis Flutter yang terintegrasi langsung dengan **The Movie Database (TMDB) API**. Aplikasi ini memungkinkan pengguna menjelajahi film dan serial TV populer/trending, melakukan pencarian dengan *infinite scroll pagination*, melihat detail lengkap, serta mengelola daftar tontonan (*Watchlist*) yang tersinkronisasi langsung dengan akun TMDB.

---

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart SDK `>=3.5.3 <=4.0.0`)
- **State Management & Routing**: [GetX](https://pub.dev/packages/get)
- **API & Networking**: [HTTP](https://pub.dev/packages/http) terintegrasi ke TMDB API v3
- **Local Storage**: [Hive](https://pub.dev/packages/hive) & [Path Provider](https://pub.dev/packages/path_provider)
- **UI & Animation**:
  - `cached_network_image` (Image caching & placeholder)
  - `flutter_carousel_widget` (Carousel banner)
  - `google_nav_bar` (Bottom navigation bar modern)
- **Deep Linking**: `app_links`

---

## 📋 Prasyarat Sistem

Sebelum memulai, pastikan perangkat Anda telah terpasang:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi 3.5.3 atau lebih baru)
- [Dart SDK](https://dart.dev/get-dart)
- Editor kode seperti VS Code atau Android Studio
- Emulator Android / iOS Simulator atau perangkat fisik aktif

---

## 🚀 Cara Instalasi

### Opsi 1: Build dari Source Code (Development)

1. **Clone Repository**
   ```bash
   git clone <URL_REPOSITORY>
   cd screenly
   ```

2. **Install Dependensi**
   Jalankan perintah berikut untuk mengunduh semua package yang diperlukan:
   ```bash
   flutter pub get
   ```

### Opsi 2: Instalasi Langsung via `screenly.apk`

Jika ingin langsung mencoba aplikasi di perangkat Android tanpa perlu *setup environment* Flutter atau melakukan *build*:

File APK siap pakai sudah tersedia di root proyek: `screenly.apk`.

1. **Melalui File Manager (Perangkat Android)**:
   - Salin / pindahkan file `screenly.apk` ke memori perangkat Android Anda.
   - Buka aplikasi **File Manager**, lalu ketuk file `screenly.apk`.
   - Izinkan opsi **"Install from unknown sources"** (*Instal aplikasi dari sumber tidak dikenal*) jika diminta oleh sistem.
   - Pilih **Install** dan buka Screenly setelah proses selesai.

2. **Melalui Komputer (Menggunakan ADB)**:
   - Hubungkan HP Android ke komputer menggunakan kabel data dengan mode **USB Debugging** aktif.
   - Buka terminal di direktori proyek dan jalankan perintah:
     ```bash
     adb install screenly.apk
     ```
     *(Gunakan `adb install -r screenly.apk` jika sebelumnya aplikasi sudah pernah terpasang)*.

---

## ▶️ Cara Menjalankan Program

Pastikan emulator atau perangkat fisik Anda telah terhubung:

1. **Menjalankan Mode Standar**
   ```bash
   flutter run
   ```

2. **Menjalankan Berdasarkan Flavor / Environment (Opsional)**
   ```bash
   # Development Flavor
   flutter run -t lib/main_dev.dart

   # Staging Flavor
   flutter run -t lib/main_staging.dart

   # Production Flavor
   flutter run -t lib/main_prod.dart
   ```

3. **Menjalankan Pengujian (Testing)**
   ```bash
   flutter test
   ```

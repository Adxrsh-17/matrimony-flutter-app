# 💑 Matrimony Flutter App

A modern, feature-rich matrimony application built with Flutter and Firebase. This cross-platform app helps users find their perfect life partner with features like profile browsing, matchmaking, real-time chat, and more.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Integrated-FFCA28?logo=firebase)](https://firebase.google.com/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📋 Table of Contents

- [Features](#-features)
- [Screenshots](#-screenshots)
- [Demo](#-demo)
- [Tech Stack](#-tech-stack)
- [Prerequisites](#-prerequisites)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [Firebase Setup](#-firebase-setup)
- [Running the App](#-running-the-app)
- [Building for Production](#-building-for-production)
- [Contributing](#-contributing)
- [License](#-license)
- [Contact](#-contact)

---

## ✨ Features

### Core Functionality
- 🔐 **User Authentication** - Secure email/password authentication with Firebase Auth
- 👤 **Profile Management** - Create and edit detailed user profiles
- 🔍 **Browse Profiles** - Discover potential matches with detailed profile views
- ❤️ **Shortlist Profiles** - Save favorite profiles for later review
- 🎯 **Smart Matching** - View matched profiles based on preferences
- 💬 **Real-time Chat** - Communicate with matches instantly using Firebase Firestore
- 📱 **Bottom Navigation** - Easy navigation between main app sections
- 📸 **Image Upload** - Upload and manage profile pictures
- 🌐 **Cross-Platform** - Available on Android, iOS, Web, Linux, macOS, and Windows

### User Experience
- 🎨 Material Design UI with Google Fonts
- ⚡ Fast image loading with caching
- 🔔 Toast notifications for user feedback
- 📊 State management with Provider
- 🖼️ Profile image picker and cropper

---

## 📱 Screenshots

> **Note:** Add your app screenshots here

| Home Screen | Browse Profiles | Chat Screen |
|-------------|-----------------|-------------|
| ![Home](screenshots/home.png) | ![Browse](screenshots/browse.png) | ![Chat](screenshots/chat.png) |

| Profile Details | Shortlist | My Profile |
|-----------------|-----------|------------|
| ![Details](screenshots/details.png) | ![Shortlist](screenshots/shortlist.png) | ![Profile](screenshots/profile.png) |

---

## 🎬 Demo

> **Note:** Add links to your app demo here

- 📹 **Video Demo:** [YouTube Link](#)
- 🌐 **Live Demo:** [Web App Link](#)
- 📦 **APK Download:** [Latest Release](#)

---

## 🛠 Tech Stack

### Frontend
- **Framework:** Flutter 3.0+
- **Language:** Dart 3.0+
- **State Management:** Provider
- **UI Components:** Material Design

### Backend & Services
- **Authentication:** Firebase Auth
- **Database:** Cloud Firestore
- **Storage:** Firebase Storage (for profile images)
- **Real-time Communication:** Firestore real-time listeners

### Key Packages
| Package | Purpose | Version |
|---------|---------|---------|
| `firebase_core` | Firebase initialization | ^2.27.0 |
| `firebase_auth` | User authentication | ^4.17.4 |
| `cloud_firestore` | NoSQL database | ^4.15.0 |
| `provider` | State management | ^6.0.0 |
| `google_fonts` | Custom typography | ^6.1.0 |
| `cached_network_image` | Efficient image loading | ^3.3.0 |
| `image_picker` | Profile image selection | ^1.0.4 |
| `fluttertoast` | User notifications | ^8.2.4 |
| `http` | HTTP requests | ^1.2.1 |

---

## ⚙️ Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.0.0 or higher) - [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK** (3.0.0 or higher) - Comes with Flutter
- **Android Studio** or **VS Code** with Flutter extensions
- **Git** - [Install Git](https://git-scm.com/downloads)
- **Firebase Account** - [Create Firebase Account](https://firebase.google.com/)

### Platform-Specific Requirements

#### For Android Development:
- Android SDK (API level 21 or higher)
- Android Emulator or physical device

#### For iOS Development:
- Xcode (latest version)
- iOS Simulator or physical device
- CocoaPods

#### For Web Development:
- Chrome browser

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/Adxrsh-17/matrimony-flutter-app.git
cd matrimony-flutter-app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

Follow the [Firebase Setup](#-firebase-setup) section below to configure Firebase for your project.

### 4. Run the App

```bash
flutter run
```

---

## 📁 Project Structure

```
matrimony-flutter-app/
│
├── android/                    # Android platform-specific files
├── ios/                        # iOS platform-specific files
├── web/                        # Web platform-specific files
├── linux/                      # Linux platform-specific files
├── macos/                      # macOS platform-specific files
├── windows/                    # Windows platform-specific files
│
├── assets/                     # Static assets
│   └── images/                 # Image assets
│       ├── background_image.jpg
│       └── male_2.png
│
├── lib/                        # Main application code
│   ├── main.dart              # App entry point
│   └── pages/                 # UI screens/pages
│       ├── login_page.dart            # User login screen
│       ├── register_page.dart         # User registration screen
│       ├── profile_list_page.dart     # Browse all profiles
│       ├── shortlist_page.dart        # Shortlisted profiles
│       ├── user_profile.dart          # User's own profile view
│       ├── edit_profile_page.dart     # Edit profile screen
│       ├── chat_page.dart             # Real-time chat interface
│       └── matched_page.dart          # Matched profiles display
│
├── test/                       # Unit and widget tests
│   └── widget_test.dart
│
├── pubspec.yaml               # Project dependencies and metadata
├── pubspec.lock               # Locked dependency versions
├── analysis_options.yaml      # Dart analyzer configuration
├── .gitignore                 # Git ignore rules
├── .metadata                  # Flutter project metadata
└── README.md                  # Project documentation (this file)
```

### Key Directories

- **`lib/pages/`** - Contains all UI screens and page components
- **`assets/images/`** - Stores static images and icons
- **Platform folders** - Native code and configuration for each platform

### Main Screens

| File | Screen | Description |
|------|--------|-------------|
| `login_page.dart` | Login | Email/password authentication |
| `register_page.dart` | Register | New user signup |
| `profile_list_page.dart` | Browse | View all available profiles |
| `user_profile.dart` | My Profile | View own profile details |
| `edit_profile_page.dart` | Edit Profile | Update profile information |
| `shortlist_page.dart` | Shortlist | Saved/favorited profiles |
| `matched_page.dart` | Matches | Compatible profiles |
| `chat_page.dart` | Chat | Real-time messaging |

---

## 🔥 Firebase Setup

### Step 1: Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project" and follow the setup wizard
3. Enable Google Analytics (optional)

### Step 2: Register Your App

#### For Android:
1. In Firebase Console, click "Add app" and select Android
2. Register app with package name: `com.example.matrimony_app` (or your custom package)
3. Download `google-services.json`
4. Place it in `android/app/` directory

#### For iOS:
1. In Firebase Console, click "Add app" and select iOS
2. Register app with bundle ID from `ios/Runner.xcodeproj`
3. Download `GoogleService-Info.plist`
4. Add it to `ios/Runner/` directory via Xcode

#### For Web:
1. In Firebase Console, click "Add app" and select Web
2. Copy the Firebase configuration
3. Add it to `web/index.html` in the appropriate location

### Step 3: Enable Firebase Services

In your Firebase Console, enable the following services:

1. **Authentication**
   - Go to Authentication > Sign-in method
   - Enable "Email/Password" provider

2. **Cloud Firestore**
   - Go to Firestore Database
   - Create database in production mode or test mode
   - Set up security rules as needed

3. **Storage** (if using profile images)
   - Go to Storage
   - Set up storage bucket
   - Configure security rules

### Step 4: Configure Security Rules

Example Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read and write their own data
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow authenticated users to read all profiles
    match /profiles/{profileId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == profileId;
    }
  }
}
```

---

## 🏃 Running the App

### Development Mode

```bash
# Run on default device
flutter run

# Run on specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

### Platform-Specific Commands

```bash
# Android
flutter run -d android

# iOS (macOS only)
flutter run -d ios

# Web
flutter run -d chrome

# Desktop (Windows)
flutter run -d windows

# Desktop (macOS)
flutter run -d macos

# Desktop (Linux)
flutter run -d linux
```

### Hot Reload

While the app is running:
- Press `r` to hot reload
- Press `R` to hot restart
- Press `q` to quit

---

## 📦 Building for Production

### Android APK

```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Google Play)

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

The web build will be in the `build/web/` directory.

### Desktop

```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

---

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

### How to Contribute

1. **Fork the Repository**
   ```bash
   # Click the 'Fork' button on GitHub
   ```

2. **Clone Your Fork**
   ```bash
   git clone https://github.com/YOUR-USERNAME/matrimony-flutter-app.git
   cd matrimony-flutter-app
   ```

3. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make Your Changes**
   - Write clean, documented code
   - Follow the existing code style
   - Test your changes thoroughly

5. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "Add: description of your changes"
   ```

6. **Push to Your Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Open a Pull Request**
   - Go to the original repository on GitHub
   - Click "New Pull Request"
   - Provide a clear description of your changes

### Contribution Guidelines

- ✅ Follow Flutter's [style guide](https://dart.dev/guides/language/effective-dart/style)
- ✅ Write meaningful commit messages
- ✅ Add comments for complex logic
- ✅ Update documentation when needed
- ✅ Test on multiple platforms if possible
- ✅ Keep pull requests focused and atomic
- ❌ Don't submit untested code
- ❌ Don't include generated or build files

### Code Style

This project follows the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart). Run the linter before submitting:

```bash
flutter analyze
```

Format your code:

```bash
dart format .
```

### Reporting Issues

If you find a bug or have a suggestion:

1. Check if the issue already exists
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Screenshots (if applicable)
   - Device/platform information

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### MIT License Summary

```
Copyright (c) 2024 Adarsh Pradeep

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 👨‍💻 Contact

**Adarsh Pradeep**

- GitHub: [@Adxrsh-17](https://github.com/Adxrsh-17)
- Repository: [matrimony-flutter-app](https://github.com/Adxrsh-17/matrimony-flutter-app)

For questions, suggestions, or support, please:
- Open an issue on GitHub
- Star ⭐ the repository if you find it helpful

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend infrastructure
- The open-source community for various packages
- Material Design for UI guidelines

---

## 📚 Additional Resources

### Flutter Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Flutter YouTube Channel](https://www.youtube.com/flutterdev)

### Firebase Resources
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)

### Community
- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)

---

<div align="center">

**Made with ❤️ using Flutter**

If you found this project helpful, please give it a ⭐!

</div>

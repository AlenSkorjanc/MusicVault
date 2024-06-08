# MusicVault

MusicVault is a Flutter-based mobile and web application designed for music enthusiasts to explore, store, and manage their music collections. The application integrates with Firebase for authentication, storage, and real-time data synchronization. It also features PDF viewing and editing capabilities for music sheets.

## Features

- **User Authentication**: Sign up, login, and logout functionalities using Firebase Authentication.
- **Profile Management**: Update profile information including display name, email, and profile picture.
- **PDF Viewing and Editing**: View and edit music sheets in PDF format.
- **Auto-Scroll for PDFs**: Automatically scroll through PDFs with adjustable speed.
- **Cross-Platform Support**: Runs on Android, iOS and web.

## Installation

### Prerequisites

- Flutter SDK: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- Firebase account: [Firebase Setup Guide](https://firebase.google.com/docs/web/setup)
- Android Studio or Visual Studio Code for development

### Setup

1. **Clone the repository**:
   ```sh
   git clone https://github.com/your-username/music-vault.git
   cd music-vault
   ```

2. **Install dependencies**:
   ```sh
   flutter pub get
   ```

3. **Configure Firebase**:
   - Create a new project on Firebase.
   - Add your app to the Firebase project (Android, iOS, Web).
   - Download the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) and place them in the respective directories.

4. **Update Gradle Files**:
   Ensure your `android/build.gradle` and `android/app/build.gradle` files are configured correctly with Firebase.

### Running the App

To run the app on your preferred platform, use the following commands:

- **Android**:
  ```sh
  flutter run
  ```

- **iOS**:
  ```sh
  flutter run
  ```

- **Web**:
  ```sh
  flutter run -d chrome
  ```

## Usage

### Profile Management

- **Update Profile Picture**: Navigate to the profile page, pick an image from your gallery or camera, and save.
- **Edit Profile**: Update your display name and email.

### PDF Viewer

- **View PDF**: Open a PDF file from the URL.
- **Auto-Scroll**: Use the auto-scroll feature with adjustable speed to read through music sheets hands-free.

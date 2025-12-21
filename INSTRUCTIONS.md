# Ecclesia App - Setup Instructions

I have generated the complete code for your Flutter app. However, since this app uses Firebase, there are a few steps you must complete manually to connect the app to your Firebase project.

## 🛑 REQUIRED STEPS (Do these before running the app)

### 1. Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Click **"Add project"** and name it `ecclesia-flutter`.
3. Disable Google Analytics (for simplicity) and create the project.

### 2. Configure Android

1. In your Firebase project dashboard, click the **Android icon** to add an Android app.
2. **Package Name**: Enter `com.example.ecclesia_flutter` (this matches your `android/app/build.gradle.kts` file).
3. Click **Register app**.
4. **Download `google-services.json`**.
5. Move this file into your project at this location:  
   `android/app/google-services.json`
6. You can skip the "Add Firebase SDK" steps in the console (I have already done this for you in the code).

### 3. Configure iOS (If you are on a Mac)

1. In Firebase Console, add an **iOS app**.
2. **Bundle ID**: Enter `com.example.ecclesiaFlutter` (or check `ios/Runner.xcodeproj/project.pbxproj` if unsure, usually it's similar).
3. **Download `GoogleService-Info.plist`**.
4. Move this file into `ios/Runner/GoogleService-Info.plist`.
5. **Important**: You must open `ios/Runner.xcworkspace` in Xcode and drag the file into the Runner folder there to ensure it's linked correctly.

### 4. Enable Firebase Services

Go to the **Build** menu in Firebase Console and enable these services:

- **Authentication**:

  - Click "Get Started".
  - Select **Email/Password** provider.
  - Enable it and click Save.

- **Firestore Database**:
  - Click "Create Database".
  - Choose a location (e.g., `nam5` or `us-central1`).
  - **Start in Test Mode** (this allows read/write access for 30 days, which is easier for development).

## 🚀 How to Run the App

1.  Open a terminal in VS Code.
2.  Run the following command to install dependencies:
    ```bash
    flutter pub get
    ```
3.  Start the app:
    ```bash
    flutter run
    ```

## 📱 App Features & Usage

- **Login/Sign Up**: Create a new account to start.
- **Home**: View community info and upcoming events.
- **Admin Features**:
  - To test Admin features (like "Add Event"), you need to manually update your user role in Firestore.
  - Go to Firebase Console -> Firestore Database -> `users` collection.
  - Find your user document and change the `role` field from `"user"` to `"admin"`.
  - Restart the app to see the "+" button on the home screen.

## ⚠️ Troubleshooting

- **"google-services.json is missing"**: Make sure you downloaded the file and placed it exactly in `android/app/`.
- **Build errors**: Try running `flutter clean` and then `flutter pub get`.
- **Firestore permission errors**: Ensure your database rules are set to Test Mode or allow read/write.

Enjoy building with Flutter! 🚀

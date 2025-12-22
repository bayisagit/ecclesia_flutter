# 📱 AASTU Focus Fellowship App

A full-stack **Flutter-based church mobile application** built to digitally connect **AASTU Focus Fellowship** members with sermons, devotionals, events, and community engagement—while empowering administrators to manage content dynamically from within the app.

---

## 🚀 Project Overview

The **AASTU Focus Fellowship App** serves as a centralized digital hub for the fellowship community.  
It enables members to stay spiritually connected and informed, and provides administrators with a built-in content management system (CMS) without requiring a separate backend dashboard.

> **Elevator Pitch:**  
> *I developed a full-stack mobile application using Flutter and Firebase that allows fellowship members to access sermons, devotionals, and events, while enabling admins to manage content dynamically through role-based access control.*

---

## 🎯 What Does the App Do?

The app connects fellowship members with the ministry through **four main pillars**:

---

### 📖 Content Delivery
- **Sermons**
  - Watch or listen to sermons via integrated video players
  - Supports YouTube video embedding and thumbnails
- **Devotionals & Annual Verses**
  - Daily spiritual content with rich text and images
- **Ministries**
  - Detailed information about fellowship teams (Worship, Prayer, Media, etc.)

---

### 🤝 Community Engagement
- **Events**
  - Calendar of upcoming fellowship programs
- **Interactivity**
  - Users can like and comment on posts
- **Profile Management**
  - Email & Google sign-up
  - Email verification
  - Profile updates including profile photo upload

---

### 🛠️ Admin Dashboard (In-App CMS)
- **Role-Based Access Control**
  - Admin users have elevated privileges
- **Content Management**
  - Admins can create, read, and delete:
    - Sermons
    - Events
    - Posts
- No separate admin panel required — everything is managed directly inside the app

---

### 🔐 Security & Architecture
- Secure authentication using Firebase Auth
- Email verification enforcement
- Role-based authorization for admin features
- Real-time data syncing using Firestore listeners

---

## 🧱 Tech Stack

### Frontend
- **Flutter (Dart)**  
  - Cross-platform native mobile development

### Backend & Services
- **Firebase (Google)**
  - Authentication (Email/Password & Google Sign-In)
  - Cloud Firestore (real-time NoSQL database)
  - Firebase Storage
- **Cloudinary**
  - Optimized image hosting and delivery

### State Management
- **Provider Pattern**
  - Efficient and scalable state handling

---

## ⚙️ Key Challenges & Solutions

### Media Optimization
**Challenge:** Handling heavy media content efficiently  
**Solution:**
- Integrated **Cloudinary** for image optimization
- Implemented caching strategies to improve performance and reduce bandwidth usage

### Admin Content Management
**Challenge:** Avoiding a separate admin dashboard  
**Solution:**
- Built a role-based system allowing admins to manage content directly within the app

---

## 🚀 Getting Started

This project is a **Flutter application**.

### Prerequisites
- Flutter SDK
- Android Studio or VS Code
- Android Emulator or Physical Android Device
- Firebase project configured

### Run the App
```bash
flutter pub get
flutter run
````

---

## 📚 Resources

If this is your first Flutter project, these resources can help:

* [https://docs.flutter.dev/get-started/codelab](https://docs.flutter.dev/get-started/codelab)
* [https://docs.flutter.dev/cookbook](https://docs.flutter.dev/cookbook)
* [https://docs.flutter.dev/](https://docs.flutter.dev/)

---

## 🤝 Contribution

Contributions, ideas, and suggestions are welcome.
Feel free to fork the repository and submit a pull request.

---

## 📄 License

This project is open-source and available under the **MIT License**.

---

## 🧑‍💻 Author

**Bayisa**
Software Engineering Student
Flutter & Firebase Developer

---

## 📌 Notes

This project was developed for **academic purposes**, but follows real-world software engineering practices including modular architecture, scalable state management, and cloud-based backend services.

```
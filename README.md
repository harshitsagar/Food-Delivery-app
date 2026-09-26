# QuickEats - Food Delivery App 🍔🍕

A full-featured Food Delivery mobile application built with **Flutter**, **GetX**, and **Firebase**. It provides a seamless experience for users to browse food items, manage carts, make secure online payments, track orders, and includes a dedicated **Admin/Seller Panel** for managing food listings and orders.

---

## 🚀 Features

### 👤 User Panel
- **Onboarding & Authentication**: Email/Password Sign-In, Google Sign-In, Password Reset.
- **Home & Catalog**: Browse food items by category (Burgers, Pizzas, Ice-cream, Salads, etc.).
- **Food Details**: Detailed views with quantity customization and item descriptions.
- **Cart & Wallet**: Add items to cart, manage quantities, and wallet integration.
- **Payment Gateways**: Payment processing with **Razorpay** and **Stripe**.
- **Order Tracking & Notifications**: Live order tracking and real-time push notifications via **Firebase Cloud Messaging (FCM)**.
- **User Profile**: Manage personal details and order history.

### 🛠️ Admin / Seller Panel
- Admin login and dashboard.
- Add and manage new food items with images (Firebase Storage integration).
- View and manage orders.

---

## 🛠️ Tech Stack & Libraries

- **Framework**: [Flutter](https://flutter.dev) (Dart SDK ^3.7.2)
- **State Management & Navigation**: [GetX](https://pub.dev/packages/get)
- **Backend & Database**: Firebase Authentication, Cloud Firestore, Firebase Storage
- **Push Notifications**: Firebase Messaging & Flutter Local Notifications
- **Payment Gateways**: Razorpay Flutter & Flutter Stripe
- **UI & Screen Adaptability**: Flutter ScreenUtil, Google Fonts, Curved Navigation Bar

---

## 📦 Getting Started

### 1. Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (v3.x or higher)
- Android Studio / VS Code with Flutter extension
- Firebase account

### 2. Clone Repository
```bash
git clone https://github.com/harshitsagar/Food-Delivery-app.git
cd Food-Delivery-app
```

### 3. Install Dependencies
```bash
flutter pub get
```

---

## 🔥 Firebase Setup Guide

Since configuration files are excluded from version control (`.gitignore`), follow these steps to configure Firebase:

### Step 1: Create Firebase Project
1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Click **Add Project** and name it **QuickEats App** (or your preferred name).

### Step 2: Android Setup
1. Register an Android App in Firebase Console:
   - **Package Name**: `com.example.quick_eats_app`
2. Download `google-services.json`.
3. Place it in the directory:
   - `android/app/google-services.json`

### Step 3: iOS Setup (Optional)
1. Register an iOS App in Firebase Console:
   - **Bundle ID**: `com.example.quick_eats_app`
2. Download `GoogleService-Info.plist`.
3. Place it in the directory:
   - `ios/Runner/GoogleService-Info.plist`

### Step 4: Configure `firebase_options.dart`
Run FlutterFire CLI to auto-generate `lib/firebase_options.dart`:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
*(Or manually create `lib/firebase_options.dart` with your Firebase credentials).*

### Step 5: Enable Firebase Services
1. **Authentication**: Enable **Email/Password** and **Google** sign-in methods.
2. **Firestore Database**: Create database rules in Test/Production mode.
3. **Storage**: Enable Firebase Storage for food image uploads.

---

## 📱 Running the Application

Connect a physical device or start an emulator, then execute:

```bash
flutter run
```

To run specifically on Android:
```bash
flutter run -d android
```

---

## 📁 Project Structure

```
lib/
├── core/                  # Constants, Routes, Services (Auth, DB, FCM, Prefs), Custom Widgets
│   ├── constant/
│   ├── routes/
│   ├── services/
│   └── widget/
├── module/                # Feature Modules (Clean GetX Architecture)
│   ├── admin/
│   ├── auth/
│   ├── cart/
│   ├── food_details/
│   ├── home/
│   ├── main_navigation/
│   ├── notifications/
│   ├── onboarding/
│   ├── profile/
│   ├── splash/
│   └── wallet/
└── main.dart              # Application Entry Point
```

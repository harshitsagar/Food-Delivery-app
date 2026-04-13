# How to Run

1. **Clone repository**
   ```bash
   git clone https://github.com/harshitsagar/Food-Delivery-app.git

2. **Install dependencies**
   ```bash
   flutter pub get

3. **Run the App**
   ```bash
    flutter run

# Firebase Setup Guide

## Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create new project: "Task Manager App"
3. Register your app

## Step 2: Android Setup
1. In Firebase Console, add Android app
2. Package name: `com.example.taskmanager` (update with your package name)
3. Download `google-services.json`
4. Place in: `android/app/google-services.json`

## Step 3: iOS Setup
1. In Firebase Console, add iOS app
2. Bundle ID: `com.example.taskmanager` (update with your bundle ID)
3. Download `GoogleService-Info.plist`
4. Place in: `ios/Runner/GoogleService-Info.plist`

## Step 4: Enable Services
1. **Authentication** → Sign-in method → Enable Email/Password
2. **Firestore Database** → Create database in test mode

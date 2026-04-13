## Firebase Setup :

1. Get Firebase Config Files
   Android:
   Go to Firebase Console

Add Android app → Package name: your.package.name

Download google-services.json

Place in: android/app/google-services.json

iOS:
Add iOS app → Bundle ID: your.bundle.id

Download GoogleService-Info.plist

Place in: ios/Runner/GoogleService-Info.plist

2. Generate Firebase Options
   Run in terminal:
   flutterfire configure

3. Update .gitignore
   Add these lines to your .gitignore:
   android/app/google-services.json
   ios/Runner/GoogleService-Info.plist
   lib/firebase_options.dart

4. Initialize Firebase
   In your main.dart:
   import 'firebase_options.dart';
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    );

# Flutter Stripe R8 / Proguard Rules
-dontwarn com.stripe.android.pushProvisioning.**
-dontwarn com.stripe.android.**
-dontwarn com.reactnativestripesdk.**
-keep class com.stripe.android.** { *; }

# Razorpay Rules
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# General Suppressions & Keeps
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**

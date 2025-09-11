package com.example.quick_eats_app

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.stripe.android.PaymentConfiguration

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // Initialize Stripe
        PaymentConfiguration.init(
            applicationContext,
            "pk_test_51PcApuRqUsIutDoPmrG868svy9r3hlJhc9NmxjxuU3SpGitv87LTWu1lDP4wGoQqjs1NYMoCn3WpNk3L5S1v5F7800DNUMlSBc")

        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}
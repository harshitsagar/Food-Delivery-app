import 'package:get/get.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/module/auth/presentation/views/login_view.dart';
import 'package:quick_eats_app/module/auth/presentation/views/signup_view.dart';
import 'package:quick_eats_app/module/auth/presentation/views/forgot_view.dart';
import 'package:quick_eats_app/module/admin/presentation/views/add_food_view.dart';
import 'package:quick_eats_app/module/admin/presentation/views/admin_login_view.dart';
import 'package:quick_eats_app/module/admin/presentation/views/home_admin_view.dart';
import 'package:quick_eats_app/module/cart/presentation/views/order_tracking_view.dart';
import 'package:quick_eats_app/module/food_details/presentation/views/details_view.dart';
import 'package:quick_eats_app/module/main_navigation/presentation/views/navigation_view.dart';
import 'package:quick_eats_app/module/notifications/presentation/views/notification_view.dart';
import 'package:quick_eats_app/module/notifications/presentation/bindings/notification_binding.dart';
import 'package:quick_eats_app/module/onboarding/presentation/views/onboarding_view.dart';
import 'package:quick_eats_app/module/onboarding/presentation/bindings/onboarding_binding.dart';
import 'package:quick_eats_app/module/splash/presentation/views/splash_view.dart';
import 'package:quick_eats_app/module/splash/presentation/bindings/splash_binding.dart';
import 'package:quick_eats_app/module/auth/presentation/bindings/auth_binding.dart';
import 'package:quick_eats_app/module/home/presentation/bindings/home_binding.dart';
import 'package:quick_eats_app/module/profile/presentation/bindings/profile_binding.dart';
import 'package:quick_eats_app/module/cart/presentation/bindings/cart_binding.dart';
import 'package:quick_eats_app/module/wallet/presentation/bindings/wallet_binding.dart';
import 'package:quick_eats_app/module/admin/presentation/bindings/admin_binding.dart';
import 'package:quick_eats_app/module/main_navigation/presentation/bindings/navigation_binding.dart';
import 'package:quick_eats_app/module/food_details/presentation/bindings/details_binding.dart';

class AppPages {
  static const initial = AppRoute.splash;

  static final routes = [
    GetPage(
      name: AppRoute.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: AppRoute.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: AppRoute.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: AppRoute.signup,
      page: () => const SignupView(),
      binding: AuthBinding(),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: AppRoute.home,
      page: () => const NavigationView(),
      bindings: [
        MainNavigationBinding(),
        HomeBinding(),
        CartBinding(),
        WalletBinding(),
        ProfileBinding(),
      ],
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: AppRoute.notifications,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: AppRoute.foodDetails,
      page: () => const DetailsView(),
      binding: DetailsBinding(),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: AppRoute.orderTracking,
      page: () => const OrderTrackingView(),
      binding: CartBinding(),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: AppRoute.forgotPassword,
      page: () => const ForgotView(),
      binding: AuthBinding(),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: AppRoute.adminLogin,
      page: () => const AdminLoginView(),
      binding: AdminBinding(),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: AppRoute.adminHome,
      page: () => const HomeAdminView(),
      binding: AdminBinding(),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: AppRoute.addFood,
      page: () => const AddFoodView(),
      binding: AdminBinding(),
      transition: Transition.leftToRightWithFade,
    ),
  ];
}

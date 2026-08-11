import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/module/cart/presentation/views/cart_view.dart';
import 'package:quick_eats_app/module/home/presentation/views/home_view.dart';
import 'package:quick_eats_app/module/profile/presentation/views/profile_view.dart';
import 'package:quick_eats_app/module/wallet/presentation/views/wallet_view.dart';
import 'package:quick_eats_app/module/main_navigation/presentation/controllers/navigation_controller.dart';

class NavigationView extends GetView<NavigationController> {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const CartView(),
      const WalletView(),
      const ProfileView(),
    ];

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 65.h,
          backgroundColor: ColorConst.white,
          color: ColorConst.black,
          animationDuration: const Duration(milliseconds: 500),
          onTap: (index) => controller.changeIndex(index),
          items: [
            Icon(Icons.home_outlined, color: ColorConst.white, size: 28.r),
            Icon(Icons.shopping_bag_outlined, color: ColorConst.white, size: 28.r),
            Icon(Icons.wallet_outlined, color: ColorConst.white, size: 28.r),
            Icon(Icons.person_outline, color: ColorConst.white, size: 28.r),
          ]
      ),
      body: Obx(() => pages[controller.currentIndex.value]),
    );
  }
}

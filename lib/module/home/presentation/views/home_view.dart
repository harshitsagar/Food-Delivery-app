import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/image_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/module/home/presentation/controllers/home_controller.dart';
import 'package:quick_eats_app/module/main_navigation/presentation/controllers/navigation_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: 1.sw,
          height: 1.sh,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: ColorConst.screenBackgroundGradient,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Top Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Section Column (Shifted slightly down)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 0.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(
                                "${TextConst.hello}${controller.userName.value},",
                                style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorConst.black,
                                ),
                              )),
                              SizedBox(height: 2.h),
                              // Single Line Fitted Headline
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    text: "What are you ",
                                    style: GoogleFonts.poppins(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConst.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "craving?",
                                        style: GoogleFonts.poppins(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFFF5722),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                TextConst.discoverFood,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),

                      // Right Section Buttons Row
                      Row(
                        children: [
                          // Notification Button
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoute.notificationHistory),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 38.r,
                                  height: 38.r,
                                  decoration: BoxDecoration(
                                    color: ColorConst.black,
                                    borderRadius: BorderRadius.circular(11.r),
                                  ),
                                  child: Icon(
                                    Icons.notifications,
                                    color: ColorConst.white,
                                    size: 19.r,
                                  ),
                                ),
                                Obx(() => controller.unreadCount.value > 0
                                    ? Positioned(
                                        right: -2.w,
                                        top: -2.h,
                                        child: Container(
                                          padding: EdgeInsets.all(3.r),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          constraints: BoxConstraints(
                                            minWidth: 14.r,
                                            minHeight: 14.r,
                                          ),
                                          child: Text(
                                            '${controller.unreadCount.value}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink()),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // Cart Button
                          GestureDetector(
                            onTap: () {
                              if (Get.isRegistered<NavigationController>()) {
                                Get.find<NavigationController>().changeIndex(1);
                              }
                            },
                            child: Container(
                              width: 38.r,
                              height: 38.r,
                              decoration: BoxDecoration(
                                color: ColorConst.black,
                                borderRadius: BorderRadius.circular(11.r),
                              ),
                              child: Icon(
                                Icons.shopping_cart,
                                color: ColorConst.white,
                                size: 19.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Category List
                  showCategoryItems(),
                  SizedBox(height: 20.h),

                  // Special Offer Banner
                  _buildSpecialOfferBanner(),
                  SizedBox(height: 24.h),

                  // Popular Near You Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Popular Near You",
                        style: GoogleFonts.poppins(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorConst.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              "See all ",
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFFF5722),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12.r,
                              color: const Color(0xFFFF5722),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  // Horizontal Popular List
                  SizedBox(
                    height: 290.h,
                    child: allItems(),
                  ),
                  SizedBox(height: 24.h),

                  // Best Deals Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Best Deals ",
                            style: GoogleFonts.poppins(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorConst.black,
                            ),
                          ),
                          Text(
                            "🔥",
                            style: TextStyle(fontSize: 18.sp),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              "See all ",
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFFF5722),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12.r,
                              color: const Color(0xFFFF5722),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  // Vertical Best Deals List
                  allItemsVertically(context),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Category Row
  Widget showCategoryItems() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryCard(TextConst.iceCream, "Ice Cream", ImageConst.iceCream),
        _buildCategoryCard(TextConst.pizza, "Pizza", ImageConst.pizza),
        _buildCategoryCard(TextConst.salad, "Healthy", ImageConst.salad),
        _buildCategoryCard(TextConst.burger, "Burger", ImageConst.burger),
      ],
    );
  }

  Widget _buildCategoryCard(String categoryKey, String displayName, String imagePath) {
    return Obx(() {
      bool isSelected = controller.isSelected(categoryKey);
      return GestureDetector(
        onTap: () => controller.loadFoodItems(categoryKey),
        child: Container(
          width: 76.w,
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: isSelected ? ColorConst.black : ColorConst.white,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath,
                height: 36.r,
                width: 36.r,
                fit: BoxFit.contain,
                color: isSelected ? ColorConst.white : ColorConst.black,
              ),
              SizedBox(height: 8.h),
              Text(
                displayName,
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? ColorConst.white : ColorConst.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    });
  }

  // Special Offer Banner
  Widget _buildSpecialOfferBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF0E6), Color(0xFFFFD1B3)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE8DC),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "SPECIAL OFFER",
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE65100),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                RichText(
                  text: TextSpan(
                    text: "Get ",
                    style: GoogleFonts.poppins(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorConst.black,
                    ),
                    children: [
                      TextSpan(
                        text: "50% OFF",
                        style: GoogleFonts.poppins(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFF5722),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "On your first order",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: const Color(0xFF6B5E55),
                  ),
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () {
                    if (Get.isRegistered<NavigationController>()) {
                      Get.find<NavigationController>().changeIndex(1);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5722),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Order Now",
                          style: GoogleFonts.poppins(
                            color: ColorConst.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.arrow_forward,
                          color: ColorConst.white,
                          size: 14.r,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.asset(
              ImageConst.burger,
              height: 100.r,
              width: 100.r,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  // Horizontal Items (Popular Near You)
  Widget allItems() {
    return Obx(() => StreamBuilder(
      stream: controller.foodItemStream.value,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.docs.isEmpty) {
          return Center(
            child: Text(
              "No items found",
              style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed(AppRoute.foodDetails, arguments: {
                  "image": ds["Image"],
                  "detail": ds["Detail"],
                  "name": ds["Name"],
                  "price": ds["Price"]
                });
              },
              child: Container(
                width: 210.w,
                margin: EdgeInsets.only(right: 16.w, top: 4.h, bottom: 6.h),
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: ColorConst.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.network(
                            ds["Image"],
                            height: 135.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 135.h,
                              color: Colors.grey[200],
                              child: const Icon(Icons.fastfood, size: 40),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8.r,
                          right: 8.r,
                          child: Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.favorite_border,
                              size: 16.r,
                              color: ColorConst.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      ds["Name"],
                      style: GoogleFonts.poppins(
                        color: ColorConst.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      ds["Detail"],
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 11.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹${ds["Price"]}",
                          style: GoogleFonts.poppins(
                            color: ColorConst.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5722),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            "Add",
                            style: GoogleFonts.poppins(
                              color: ColorConst.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ));
  }

  // Vertical Items (Best Deals)
  Widget allItemsVertically(BuildContext context) {
    return Obx(() => StreamBuilder(
      stream: controller.foodItemStream.value,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.docs.isEmpty) {
          return const SizedBox.shrink();
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed(AppRoute.foodDetails, arguments: {
                  "image": ds["Image"],
                  "detail": ds["Detail"],
                  "name": ds["Name"],
                  "price": ds["Price"]
                });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 14.h),
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: ColorConst.white,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: Image.network(
                        ds["Image"],
                        height: 85.h,
                        width: 85.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 85.h,
                          width: 85.w,
                          color: Colors.grey[200],
                          child: const Icon(Icons.fastfood, size: 30),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ds["Name"],
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorConst.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            ds["Detail"],
                            style: GoogleFonts.poppins(
                              fontSize: 11.sp,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "₹${ds["Price"]}",
                                style: GoogleFonts.poppins(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConst.black,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF5722),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  "Add",
                                  style: GoogleFonts.poppins(
                                    color: ColorConst.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import '../controllers/notification_history_controller.dart';

class NotificationHistoryView extends GetView<NotificationHistoryController> {
  const NotificationHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: ColorConst.screenBackgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: Text(
                  "Notifications",
                  style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.w600, color: ColorConst.black),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: ColorConst.black),
                  onPressed: () => Get.back(),
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.notifications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_off_outlined, size: 60.r, color: ColorConst.grey),
                          SizedBox(height: 16.h),
                          Text(
                            "No notifications yet",
                            style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w500, color: ColorConst.grey),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(16.r),
                    itemCount: controller.notifications.length,
                    itemBuilder: (context, index) {
                      var notif = controller.notifications[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          color: ColorConst.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    notif["title"] ?? "",
                                    style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w600, color: ColorConst.black),
                                  ),
                                ),
                                Text(
                                  notif["time"] ?? "",
                                  style: GoogleFonts.poppins(fontSize: 12.sp, color: ColorConst.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              notif["body"] ?? "",
                              style: GoogleFonts.poppins(fontSize: 14.sp, color: ColorConst.darkGrey),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

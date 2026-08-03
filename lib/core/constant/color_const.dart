import 'package:flutter/material.dart';

class ColorConst {
  static const Color screenBackground = Color(0xFFFCF7EC);

  static const Color primary = Color(0xFF2944C1);
  static const Color primaryWithOpacity = Color(0xFF2944C1); // 80% opacity

  static const Color secondary = Color(0xFF2944C1);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color blue = Color(0xff0160BB);
  static const Color grey = Colors.grey;

  static const Color errorColor = Color(0xFFBA1A1A);

  static const Color darkBlue = Color(0xFF2D4279);

  static const Color splashDark = Color(0xFF45240F);
  static const Color splashOrange = Color(0xFFFA872B);
  static const Color splashblack = Color(0xFF705848);

  // New Design Colors
  static const Color headerGradientStart = Color(0xFF3D2114);
  static const Color headerGradientEnd = Color(0xFF5F3D24);
  static const Color surfaceColor = Color(0xFF87756B);
  static const Color carouselDarkBrown = Color(0xFF48280B);
  static const Color paragraphColor = Color(0xFF705848);

  static final Color headerSearchBg = surfaceColor.withOpacity(0.26);
  static final Color carouselOverlayGradientStart = carouselDarkBrown.withOpacity(0.95);
  static final Color carouselOverlayGradientEnd = carouselDarkBrown.withOpacity(0.0);
  static final Color activeCallShadow = black.withOpacity(0.05);
  static final Color importOfferDesc = splashblack.withOpacity(0.6);
  static final Color shortcutShadow = black.withOpacity(0.25);
  static final Color statusLabelColor = splashblack.withOpacity(0.6);
  static final Color marketCardShadow = black.withOpacity(0.05);

  static const Color approvedGreen = Color(0xFF2A8225);
  static const Color approvedBg = Color(0xFFB1F8BF);
  static const Color rejectedRed = Color(0xFFE71616);
  static const Color rejectBg = Color(0xFFFFE6E6);
  static final Color rejectBorder = const Color(0xFFBA1A1A).withOpacity(0.5);
  static const Color rejectText = Color(0xFFD45555);
  static final Color statusBannerBorder = const Color(0xFFFA872B).withOpacity(0.2);
  static const Color disabledButton = Color(0xFFA69991);

  static final Color bulkOfferFilterBg = const Color(0xFFF1E2CF).withOpacity(0.4);
  static final Color bulkOfferGradeBg = const Color(0xFFF1E2CF).withOpacity(0.5);
  static final Color dialogBarrierColor = black.withOpacity(0.6);
  static final Color dialogShadow = black.withOpacity(0.1);

  static const Color onboardingSkipBg = Color(0xFFFCF7EC);
  static const Color creamyWhite = Color(0xFFFCF7EC);
  static const Color orangeGradientStart = Color(0xFFFA872B);
  static const Color orangeGradientEnd = Color(0xFFDE5A1E);
  static const Color onboardingIndicatorInactive = Color(0xFFDFD5BF);

  static const Color cF4F4F4 = Color(0xFFF4F4F4);

  // New Background Gradient Colors
  static const Color bgGradientStart = Color(0xFFFCF7EC);
  static const Color bgGradientEnd = Color(0xFFF1E5CC);

  static const List<Color> screenBackgroundGradient = [
    bgGradientStart,
    bgGradientEnd,
  ];

  // Auth Screen specific colors
  static final Color authFieldFill = white.withOpacity(0.5);
  static final Color authFieldBorder = splashDark.withOpacity(0.2);
  static final Color authHintText = splashblack.withOpacity(0.5);
  static final Color authTermsText = splashDark.withOpacity(0.6);
  static final Color authCheckboxBorder = splashOrange.withOpacity(0.5);
  static const Color authFieldBorderInactive = Color(0xFFC1BCB9);
  static const Color activeCallFilterBg = Color(0xFFF1E2CF);
  static const Color buyCallsBorder = Color(0xFF583D2E);
  static final Color successStatusBg = const Color(0xFFB1F8BF).withOpacity(0.5);
  static const Color successStatusText = Color(0xFF2A8225);
  static const Color redeemColor = Color(0xFFE71616);
  static final Color redeemBg = const Color(0xFFF1B1B1).withOpacity(0.3);
  static const Color notificationIconBg = Color(0xFFF1E2CF);
  static const Color pendingGrey = Color(0xFF7D7D7D);
  static const Color pendingBg = Color(0xFFE0E0E0);
  static const Color transparent = Colors.transparent;
}
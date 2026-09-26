import 'package:quick_eats_app/core/constant/image_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';

class UnboardingContent {
  String image;
  String title1;
  String title2;
  String description;

  UnboardingContent({
    required this.description,
    required this.image,
    required this.title1,
    required this.title2,
  });
}

List<UnboardingContent> contents = [
  UnboardingContent(
    description: TextConst.onboarding1Desc,
    image: ImageConst.onboarding1,
    title1: TextConst.onboarding1Title1,
    title2: TextConst.onboarding1Title2,
  ),
  UnboardingContent(
    description: TextConst.onboarding2Desc,
    image: ImageConst.onboarding2,
    title1: TextConst.onboarding2Title1,
    title2: TextConst.onboarding2Title2,
  ),
  UnboardingContent(
    description: TextConst.onboarding3Desc,
    image: ImageConst.onboarding3,
    title1: TextConst.onboarding3Title1,
    title2: TextConst.onboarding3Title2,
  ),
];

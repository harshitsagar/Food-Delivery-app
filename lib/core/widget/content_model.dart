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
    description: 'Pick your food from our menu\n          More than 35 items',
    image: "assets/images/onboarding/onboarding_img1.png",
    title1: 'Select from Our',
    title2: ' Best Menu',
  ),
  UnboardingContent(
    description: 'You can pay cash on delivery and\n       Card payment is available',
    image: "assets/images/onboarding/onboarding_img2.png",
    title1: 'Easy and Online',
    title2: ' Payment',
  ),
  UnboardingContent(
    description: 'Deliver your food at your\n              Doorstep',
    image: "assets/images/onboarding/onboarding_img3.png",
    title1: 'Quick Delivery at',
    title2: ' Your Doorstep',
  ),
];

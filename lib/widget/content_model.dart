class UnboardingContent {
  String image;
  String title1;
  String title2;
  String description;

  UnboardingContent({
    required this.image,
    required this.title1,
    required this.title2,
    required this.description,
  });
}

List<UnboardingContent> contents = [
  UnboardingContent(
    image: "assets/images/onboarding/onboarding_img1.png",
    title1: 'Discover',
    title2: 'Delicious Food',
    description: "Browse hundreds of dishes from\ntop restaurants near you.",
  ),
  UnboardingContent(
    image: "assets/images/onboarding/onboarding_img2.png",
    title1: 'Track',
    title2: 'Every Order',
    description: "Live tracking from restaurant\nto your doorstep.",
  ),
  UnboardingContent(
    image: "assets/images/onboarding/onboarding_img3.png",
    title1: 'Exciting',
    title2: 'Offers Awaits',
    description: "Grab exclusive deals, discounts and\noffers on your favorite meals.",
  ),
];

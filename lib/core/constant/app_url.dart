class AppUrl {
  static const String baseUrl = 'https://your-api-base-url.com';
  
  // Auth endpoints
  static const String loginApi = '$baseUrl/api/login';
  static const String signupApi = '$baseUrl/api/signup';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String cartCollection = 'Cart';
  
  // Field Names
  static const String walletField = 'Wallet';
  static const String nameField = 'Name';
  static const String emailField = 'Email';
  static const String idField = 'Id';
  static const String loginField = 'login';
}

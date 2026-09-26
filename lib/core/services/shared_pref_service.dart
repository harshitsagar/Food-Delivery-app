import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String userIdKey = "USERKEY";
  static const String userNameKey = "USERNAMEKEY";
  static const String userEmailKey = "USEREMAILKEY";
  static const String userWalletKey = "USERWALLETKEY";
  static const String userProfileKey = "USERPROFILEKEY";
  static const String userlogin = "USERLOGIN";
  static const String isOnboardingKey = "ISONBOARDINGKEY";

  static Future<bool> saveIsOnboarding(bool isOnboarding) async {
    return await _prefs!.setBool(isOnboardingKey, isOnboarding);
  }

  static Future<bool?> getIsOnboarding() async {
    return _prefs?.getBool(isOnboardingKey);
  }

  static Future<bool> saveUserId(String getUserId) async {
    return await _prefs!.setString(userIdKey, getUserId);
  }

  static Future<bool> saveUserName(String getUserName) async {
    return await _prefs!.setString(userNameKey, getUserName);
  }

  static Future<bool> saveUserEmail(String getUserEmail) async {
    return await _prefs!.setString(userEmailKey, getUserEmail);
  }

  static Future<bool> saveUserWallet(String getUserWallet) async {
    return await _prefs!.setString(userWalletKey, getUserWallet);
  }

  static Future<bool> saveUserLOGIN(String getUserLOGIN) async {
    return await _prefs!.setString(userlogin, getUserLOGIN);
  }

  static Future<bool> saveUserProfile(String getUserProfile) async {
    return await _prefs!.setString(userProfileKey, getUserProfile);
  }

  static Future<String?> getUserId() async {
    return _prefs?.getString(userIdKey);
  }

  static Future<String?> getUserName() async {
    return _prefs?.getString(userNameKey);
  }

  static Future<String?> getUserEmail() async {
    return _prefs?.getString(userEmailKey);
  }

  static Future<String?> getUserWallet() async {
    return _prefs?.getString(userWalletKey);
  }

  static Future<String?> getUserLOGIN() async {
    return _prefs?.getString(userlogin);
  }

  static Future<String?> getUserProfile() async {
    return _prefs?.getString(userProfileKey);
  }

  static const String notificationHistoryKey = "NOTIFICATION_HISTORY_KEY";
  static const String unreadNotificationCountKey = "UNREAD_NOTIFICATION_COUNT_KEY";

  static Future<bool> saveNotificationHistory(List<String> history) async {
    return await _prefs!.setStringList(notificationHistoryKey, history);
  }

  static List<String> getNotificationHistory() {
    return _prefs?.getStringList(notificationHistoryKey) ?? [];
  }

  static Future<bool> saveUnreadNotificationCount(int count) async {
    return await _prefs!.setInt(unreadNotificationCountKey, count);
  }

  static int getUnreadNotificationCount() {
    return _prefs?.getInt(unreadNotificationCountKey) ?? 0;
  }
}

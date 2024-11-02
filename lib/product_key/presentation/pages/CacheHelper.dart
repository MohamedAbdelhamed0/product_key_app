// lib/helpers/cache_helper.dart
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // Save user authentication data
  static Future<void> cacheAuthData({
    required String userId,
    required String name,
    required String phone,
  }) async {
    await _sharedPreferences.setString('userId', userId);
    await _sharedPreferences.setString('name', name);
    await _sharedPreferences.setString('phone', phone);

    // Save the timestamp when the user signed in
    int signInTimestamp = DateTime.now().millisecondsSinceEpoch;
    await _sharedPreferences.setInt('signInTimestamp', signInTimestamp);
  }

  // Check if the user is authenticated and the cache is valid
  static bool isAuthValid() {
    String? userId = _sharedPreferences.getString('userId');
    int? signInTimestamp = _sharedPreferences.getInt('signInTimestamp');

    if (userId != null && signInTimestamp != null) {
      // Calculate the difference between now and the sign-in timestamp
      DateTime signInDate =
          DateTime.fromMillisecondsSinceEpoch(signInTimestamp);
      Duration difference = DateTime.now().difference(signInDate);

      // Check if the difference is less than 14 days
      if (difference.inDays < 14) {
        return true;
      } else {
        // Cache has expired, clear the data
        clearAuthData();
        return false;
      }
    }
    return false;
  }

  // Get cached user data
  static String? getUserId() {
    return _sharedPreferences.getString('userId');
  }

  static String? getName() {
    return _sharedPreferences.getString('name');
  }

  static String? getPhone() {
    return _sharedPreferences.getString('phone');
  }

  // Clear cached authentication data
  static Future<void> clearAuthData() async {
    await _sharedPreferences.remove('userId');
    await _sharedPreferences.remove('name');
    await _sharedPreferences.remove('phone');
    await _sharedPreferences.remove('signInTimestamp');
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserAge = 'user_age';
  static const String _keyUserCountry = 'user_country';
  static const String _keyUserHabits = 'user_habits';
  static const String _keyCompletedHabits = 'completed_habits';
  static const String _keyUserActions = 'user_actions';
  static const String _keyNotifications = 'notifications';

  static Future<void> saveUserProfile({
    required String name,
    required String email,
    required String age,
    required String country,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserAge, age);
    await prefs.setString(_keyUserCountry, country);
  }

  static Future<Map<String, String>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_keyUserName) ?? 'Guest',
      'email': prefs.getString(_keyUserEmail) ?? 'Not set',
      'age': prefs.getString(_keyUserAge) ?? 'Not set',
      'country': prefs.getString(_keyUserCountry) ?? 'Not set',
    };
  }

  static Future<void> saveCompletedHabit(String habitTitle) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> completedHabits = prefs.getStringList(_keyCompletedHabits) ?? [];
    completedHabits.add('$habitTitle|${DateTime.now().toIso8601String()}');
    await prefs.setStringList(_keyCompletedHabits, completedHabits);
  }

  static Future<void> saveUserAction(String actionType, String actionValue) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> userActions = prefs.getStringList(_keyUserActions) ?? [];
    Map<String, String> action = {
      'type': actionType,
      'value': actionValue,
      'timestamp': DateTime.now().toIso8601String(),
    };
    userActions.add(jsonEncode(action));
    if (userActions.length > 50) userActions = userActions.sublist(userActions.length - 50);
    await prefs.setStringList(_keyUserActions, userActions);
  }

  static Future<void> saveNotification(String title, String body) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList(_keyNotifications) ?? [];
    Map<String, String> notification = {
      'title': title,
      'body': body,
      'timestamp': DateTime.now().toIso8601String(),
      'read': 'false',
    };
    notifications.add(jsonEncode(notification));
    if (notifications.length > 20) notifications = notifications.sublist(notifications.length - 20);
    await prefs.setStringList(_keyNotifications, notifications);
  }

  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
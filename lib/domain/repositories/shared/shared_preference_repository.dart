import 'package:car_ticket/domain/models/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketAppSharedPreferenceRepository {
  static const String _isFirstTime = 'isFirstTime';

  Future<bool> get isFirstTime async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstTime) ?? true;
  }

  Future<void> setFirstTime(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstTime, value);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<MyUser> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id') ?? '';
    final email = prefs.getString('email') ?? '';
    final name = prefs.getString('name') ?? '';
    return MyUser(id: id, email: email, name: name);
  }

  Future<void> setUser(MyUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', user.id);
    await prefs.setString('email', user.email);
    await prefs.setString('name', user.name);
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('email');
    await prefs.remove('name');
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static StorageUtil _storageUtil;
  static SharedPreferences _preferences;

  static Future getInstance() async {
    if (_storageUtil == null) {
      // keep local instance till it is fully initialized.
      var secureStorage = StorageUtil._();
      await secureStorage._init();
      _storageUtil = secureStorage;
    }
    return _storageUtil;
  }

  StorageUtil._();

  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static saveOpenPage() async {
    if (_preferences == null) return;
    await _preferences.setBool("OnBoarding", false);
  }

  static Future<bool> getOpenPage() async {
    if (_preferences == null) return true;
    return _preferences.getBool("OnBoarding")??true;
  }

  //TODO 6 tasks
  static bool hasProfile() {
    if (_preferences == null) return false;
    return _preferences.getBool('HasProfile') == true;
  }

  static removeProfile() async {
    if (_preferences == null) return null;
    await _preferences.clear();
  }

  static Future saveNotification(bool value) async {
    if (_preferences == null) return;
    await _preferences.setBool("Notification", value);
  }

  static Future<bool> getNotification() async {
    if (_preferences == null) return true;
    return _preferences.getBool("Notification")??true;
  }

  static void saveSound(bool value) async {
    if (_preferences == null) return;
    await _preferences.setBool("Sound", value);
  }

  static Future<bool> getSound() async {
    if (_preferences == null) return true;
    return _preferences.getBool("Sound")??true;
  }
}

import 'package:flutter_session_manager/flutter_session_manager.dart';

class UserIDSession {
  var sessionManager = SessionManager();
  late String key;
  late String value;

  Future<void> setStringValue(String key, String value) async {
    await sessionManager.set(this.key = key, this.value = value);
  }

  Future<String?> getStringValue(String key) async {
    return await sessionManager.get(this.key = key);
  }
}

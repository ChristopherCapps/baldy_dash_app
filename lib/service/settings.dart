import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Settings {
  static const _uuid = 'uuid';

  final SharedPreferences _prefs;

  Settings._(this._prefs) {
    if (!_prefs.containsKey(_uuid)) {
      _prefs.setString(_uuid, const Uuid().v1());
    }
  }

  String get uuid => //'2';
      'f2b9b4b0-d993-11ed-83f3-e7422e01ce10';
  //_prefs.getString(_uuid)!;

  static Future<Settings> create() async =>
      await SharedPreferences.getInstance().then(
        Settings._,
      );
}



import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'selected_language';
  static LanguageService? _instance;
  static late SharedPreferences _prefs;
  bool _isEnglish = true;

  LanguageService._();

  static Future<LanguageService> getInstance() async {
    if (_instance == null) {
      _instance = LanguageService._();
      _prefs = await SharedPreferences.getInstance();
      _instance!._isEnglish = _prefs.getBool(_languageKey) ?? true;
    }
    return _instance!;
  }

  bool get isEnglish => _isEnglish;

  Future<void> setLanguage(bool isEnglish) async {
    _isEnglish = isEnglish;
    await _prefs.setBool(_languageKey, isEnglish);
  }
}

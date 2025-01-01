import 'package:flutter/material.dart';
import '../services/language_service.dart';

class LanguageSwitch extends StatefulWidget {
  final bool darkMode;
  final Function(bool)? onLanguageChanged;

  const LanguageSwitch({
    Key? key,
    this.darkMode = false,
    this.onLanguageChanged,
  }) : super(key: key);

  @override
  _LanguageSwitchState createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<LanguageSwitch> {
  late bool _isEnglish;
  bool _canChangeLanguage = true;

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    final languageService = await LanguageService.getInstance();
    setState(() {
      _isEnglish = languageService.isEnglish;
    });
  }

  Future<void> _changeLanguage() async {
    if (_canChangeLanguage) {
      setState(() {
        _isEnglish = !_isEnglish;
        _canChangeLanguage = false;
      });

      final languageService = await LanguageService.getInstance();
      await languageService.setLanguage(_isEnglish);

      if (widget.onLanguageChanged != null) {
        widget.onLanguageChanged!(_isEnglish);
      }

      Future.delayed(Duration(seconds: 10), () {
        if (mounted) {
          setState(() {
            _canChangeLanguage = true;
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEnglish
                ? "Please wait 10 seconds before changing the language again!"
                : "Dili tekrar değiştirmek için 10 saniye bekleyin!",
          ),
          backgroundColor: Colors.black87,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.darkMode
        ? Colors.white.withOpacity(0.2)
        : Color(0xFF7277E4).withOpacity(0.1);
    final textColor = widget.darkMode ? Colors.white : Color(0xFF7277E4);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: widget.darkMode
              ? Colors.white.withOpacity(0.2)
              : Color(0xFF7277E4).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: _changeLanguage,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: widget.darkMode
                        ? Colors.white.withOpacity(0.1)
                        : Color(0xFF7277E4).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    _isEnglish ? "🇹🇷" : "🇬🇧",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  _isEnglish ? "Türkçe" : "English",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: textColor.withOpacity(0.7),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

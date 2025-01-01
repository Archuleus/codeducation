import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'main_screen.dart';
import 'widgets/edu_bot.dart';
import 'widgets/language_switch.dart';
import 'services/language_service.dart';
import 'assessment_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  String? selectedLanguage;
  int _currentStep = 0;
  bool _isTyping = false;
  late bool _isEnglish;
  late AnimationController _transitionController;

  final List<String> programmingLanguages = [
    'Python',
    'JavaScript',
    'Java',
    'C++'
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    _transitionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
  }

  Future<void> _loadLanguagePreference() async {
    final languageService = await LanguageService.getInstance();
    setState(() {
      _isEnglish = languageService.isEnglish;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  void _simulateTyping(String message, VoidCallback onComplete) {
    setState(() => _isTyping = true);
    Future.delayed(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _isTyping = false);
        onComplete();
      }
    });
  }

  void _navigateToMainScreen() {
    _transitionController.forward().then((_) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: MainScreen(),
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  Widget _buildUsernameStep() {
    return Column(
      children: [
        EduBot(
          message: _isEnglish
              ? "Hi! I'm Edu, your coding companion. Let's start by choosing a username for your journey!"
              : "Merhaba! Ben Edu, kodlama yolculuğundaki arkadaşınız. Önce bir kullanıcı adı seçelim!",
          isTyping: _isTyping,
        ),
        SizedBox(height: 16),
        FadeInUp(
          duration: Duration(milliseconds: 500),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: _isEnglish ? 'Enter username' : 'Kullanıcı adı girin',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        FadeInUp(
          duration: Duration(milliseconds: 700),
          child: ElevatedButton(
            onPressed: () {
              if (_usernameController.text.isNotEmpty) {
                setState(() => _currentStep = 1);
                _simulateTyping(
                  _isEnglish
                      ? "Great choice! Now, which programming language would you like to learn?"
                      : "Harika seçim! Şimdi, hangi programlama dilini öğrenmek istersin?",
                  () {},
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7277E4),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              _isEnglish ? 'Continue' : 'Devam Et',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelectionStep() {
    return Column(
      children: [
        EduBot(
          message: _isEnglish
              ? "Great choice! Now, which programming language would you like to learn?"
              : "Harika seçim! Şimdi, hangi programlama dilini öğrenmek istersin?",
          isTyping: _isTyping,
        ),
        SizedBox(height: 24),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            physics: NeverScrollableScrollPhysics(),
            children: programmingLanguages.map((language) {
              bool isSelected = selectedLanguage == language;
              return FadeInUp(
                duration: Duration(milliseconds: 500),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLanguage = language;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF7277E4) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Color(0xFF7277E4)
                            : Colors.grey.shade300,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getLanguageIcon(language),
                          color: isSelected ? Colors.white : Color(0xFF7277E4),
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          language,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 32),
        if (selectedLanguage != null)
          FadeInUp(
            duration: Duration(milliseconds: 700),
            child: ElevatedButton(
              onPressed: () {
                setState(() => _currentStep = 2);
                _simulateTyping(
                  _isEnglish
                      ? "Perfect! Let's assess your current knowledge with a quick placement test."
                      : "Mükemmel! Hadi kısa bir seviye testiyle mevcut bilgini değerlendirelim.",
                  () {},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7277E4),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                _isEnglish ? 'Start Placement Test' : 'Seviye Testini Başlat',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
      ],
    );
  }

  IconData _getLanguageIcon(String language) {
    switch (language) {
      case 'Python':
        return Icons.code;
      case 'JavaScript':
        return Icons.javascript;
      case 'Java':
        return Icons.coffee;
      case 'C++':
        return Icons.terminal;
      default:
        return Icons.code;
    }
  }

  Widget _buildPlacementTest() {
    return Column(
      children: [
        EduBot(
          message: _isEnglish
              ? "Perfect! Let's assess your current knowledge with a quick placement test."
              : "Mükemmel! Hadi kısa bir seviye testiyle mevcut bilgini değerlendirelim.",
          isTyping: _isTyping,
        ),
        SizedBox(height: 24),
        FadeInUp(
          duration: Duration(milliseconds: 500),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  _isEnglish ? "Placement Test" : "Seviye Testi",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7277E4),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  _isEnglish
                      ? "This test will help us personalize your learning experience. Don't worry if you're not sure about some answers - just do your best!"
                      : "Bu test, öğrenme deneyimini kişiselleştirmemize yardımcı olacak. Bazı cevaplardan emin değilsen endişelenme - sadece elinden geleni yap!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 800),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return FadeTransition(
                            opacity: animation,
                            child: AssessmentScreen(
                              selectedLanguage: selectedLanguage!,
                              isEnglish: _isEnglish,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7277E4),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _isEnglish ? 'Begin Test' : 'Testi Başlat',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF5F6FF)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: LanguageSwitch(
                        onLanguageChanged: (isEnglish) {
                          setState(() {
                            _isEnglish = isEnglish;
                          });
                        },
                      ),
                    ),
                    if (_currentStep == 0) _buildUsernameStep(),
                    if (_currentStep == 1) _buildLanguageSelectionStep(),
                    if (_currentStep == 2) _buildPlacementTest(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_app/main_screen.dart';
import 'register_screen.dart';
import 'widgets/language_switch.dart';
import 'services/language_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isEnglish = false; // Varsayılan dil Türkçe
  bool canChangeLanguage = true;
  Timer? _timer;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _forgotPasswordEmailController =
      TextEditingController();

  void _changeLanguage() {
    if (canChangeLanguage) {
      setState(() {
        isEnglish = !isEnglish;
        canChangeLanguage = false;
      });

      _timer = Timer(Duration(seconds: 10), () {
        setState(() {
          canChangeLanguage = true;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isEnglish
            ? "Please wait 10 seconds before changing the language again!"
            : "Dili tekrar değiştirmek için 10 saniye bekleyin!"),
        backgroundColor: Color.fromRGBO(0, 1, 0, .6),
      ));
    }
  }

  void _navigateToRegisterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen(isEnglish: isEnglish),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Column(
          children: [
            Icon(
              Icons.lock_reset,
              size: 50,
              color: Color.fromRGBO(143, 148, 251, 1),
            ),
            SizedBox(height: 10),
            Text(
              isEnglish ? 'Reset Password' : 'Şifre Sıfırlama',
              style: TextStyle(
                color: Color.fromRGBO(143, 148, 251, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEnglish
                    ? 'Enter your email address to reset your password'
                    : 'Şifrenizi sıfırlamak için e-posta adresinizi girin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _forgotPasswordEmailController,
                decoration: InputDecoration(
                  hintText: isEnglish ? 'Email' : 'E-posta',
                  prefixIcon: Icon(Icons.email,
                      color: Color.fromRGBO(143, 148, 251, 1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromRGBO(143, 148, 251, 1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(143, 148, 251, 1), width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              isEnglish ? 'Cancel' : 'İptal',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement password reset logic
              if (_forgotPasswordEmailController.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEnglish
                          ? 'Password reset link has been sent to your email'
                          : 'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(143, 148, 251, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              isEnglish ? 'Send' : 'Gönder',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/codelingo_loginscreen.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      children: <Widget>[
                        FadeInUp(
                          duration: Duration(milliseconds: 1800),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.zero,
                              border: Border.all(
                                  color: Color.fromRGBO(143, 148, 251, 1)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color.fromRGBO(143, 148, 251, 1),
                                      ),
                                    ),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: isEnglish
                                          ? "Email or Phone number"
                                          : "E-posta veya Telefon numarası",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700]),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText:
                                          isEnglish ? "Password" : "Şifre",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        FadeInUp(
                          duration: Duration(milliseconds: 1900),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MainScreen(), // Burada FirstScreen'e yönlendiriyoruz
                                ),
                              );
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.zero,
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(143, 148, 251, 1),
                                    Color.fromRGBO(143, 148, 251, .6),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  isEnglish ? "Login" : "Giriş Yap",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 35),
                        FadeInUp(
                          duration: Duration(milliseconds: 2000),
                          child: GestureDetector(
                            onTap: _showForgotPasswordDialog,
                            child: Text(
                              isEnglish ? "Forgot Password" : "Şifremi Unuttum",
                              style: TextStyle(
                                color: Color.fromRGBO(143, 148, 251, 1),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 2100),
                          child: Divider(
                            color: Colors.grey[300],
                            thickness: 0,
                            height: 40,
                          ),
                        ),
                        SizedBox(height: 5),
                        FadeInUp(
                          duration: Duration(milliseconds: 2000),
                          child: GestureDetector(
                            onTap: _navigateToRegisterScreen,
                            child: Container(
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.zero,
                                border: Border.all(
                                    color: Color.fromRGBO(143, 148, 251, 1)),
                              ),
                              child: Text(
                                isEnglish ? "Register" : "Üye Ol",
                                style: TextStyle(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FadeInUp(
              duration: Duration(milliseconds: 2100),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: _changeLanguage,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Text(
                        isEnglish ? "🇹🇷" : "🇬🇧",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

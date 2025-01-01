import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_app/main_screen.dart';
import 'register_screen.dart';
import 'first_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isEnglish = false; // Varsayılan dil Türkçe
  bool canChangeLanguage = true;
  Timer? _timer;

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
                                 builder: (context) => MainScreen(), // Burada FirstScreen'e yönlendiriyoruz
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
                          child: Text(
                            isEnglish ? "Forgot Password" : "Şifremi Unuttum",
                            style: TextStyle(
                                color: Color.fromRGBO(143, 148, 251, 1),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
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
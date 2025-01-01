import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final bool isEnglish;

  EmailVerificationScreen({required this.email, required this.isEnglish});

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  void _onCodeComplete() {
    String code = _controllers.map((controller) => controller.text).join();
    if (code.length == 6) {
      // Here you would typically verify the code with your backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEnglish
                ? "Email verified successfully!"
                : "E-posta başarıyla doğrulandı!",
          ),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate to next screen after verification
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop(true); // Return true to indicate success
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7277E4), Color(0xFF5A5F9D)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(height: 30),
                Text(
                  widget.isEnglish ? "Email Verification" : "E-posta Doğrulama",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  widget.isEnglish
                      ? "Enter the 6-digit code sent to"
                      : "Gönderilen 6 haneli kodu girin",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.email,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) => Container(
                      width: 50,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white38),
                      ),
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (value.length == 1 && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          }
                          if (value.length == 1 && index == 5) {
                            _onCodeComplete();
                          }
                          if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Resend code logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            widget.isEnglish
                                ? "Verification code resent!"
                                : "Doğrulama kodu tekrar gönderildi!",
                          ),
                        ),
                      );
                    },
                    child: Text(
                      widget.isEnglish ? "Resend Code" : "Kodu Tekrar Gönder",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  final bool isEnglish;

  RegisterScreen({required this.isEnglish});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;
  late bool isEnglish;

  @override
  void initState() {
    super.initState();
    isEnglish = widget.isEnglish;
  }

  void _changeLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  bool _validateEmail(String value) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7277E4), Color(0xFF5A5F9D)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40),
                        Center(
                          child: Image.asset(
                            'images/6.png',
                            height: 120,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 40),
                        FadeInUp(
                          duration: Duration(milliseconds: 1000),
                          child: Text(
                            isEnglish ? "Create Account" : "Hesap Oluştur",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        _buildInputField(
                          controller: _emailController,
                          label: isEnglish ? "Email" : "E-posta",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return isEnglish
                                  ? "Email is required"
                                  : "E-posta gerekli";
                            }
                            if (!_validateEmail(value)) {
                              return isEnglish
                                  ? "Enter a valid email"
                                  : "Geçerli bir e-posta girin";
                            }
                            return null;
                          },
                        ),
                        _buildInputField(
                          controller: _confirmEmailController,
                          label: isEnglish ? "Confirm Email" : "E-posta Tekrar",
                          validator: (value) {
                            if (value != _emailController.text) {
                              return isEnglish
                                  ? "Emails do not match"
                                  : "E-postalar eşleşmiyor";
                            }
                            return null;
                          },
                        ),
                        _buildInputField(
                          controller: _passwordController,
                          label: isEnglish ? "Password" : "Şifre",
                          isPassword: true,
                          isPasswordVisible: _isPasswordVisible,
                          onVisibilityToggle: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return isEnglish
                                  ? "Password is required"
                                  : "Şifre gerekli";
                            }
                            if (value.length < 6) {
                              return isEnglish
                                  ? "Password must be at least 6 characters"
                                  : "Şifre en az 6 karakter olmalı";
                            }
                            return null;
                          },
                        ),
                        _buildInputField(
                          controller: _confirmPasswordController,
                          label:
                              isEnglish ? "Confirm Password" : "Şifre Tekrar",
                          isPassword: true,
                          isPasswordVisible: _isConfirmPasswordVisible,
                          onVisibilityToggle: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return isEnglish
                                  ? "Passwords do not match"
                                  : "Şifreler eşleşmiyor";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        _buildTermsCheckbox(),
                        SizedBox(height: 30),
                        _buildRegisterButton(),
                        SizedBox(height: 20),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: isEnglish
                                        ? "Already have an account? "
                                        : "Zaten hesabınız var mı? ",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    text: isEnglish ? "Login" : "Giriş Yap",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: _changeLanguage,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isEnglish ? "🇹🇷" : "🇬🇧",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(width: 8),
                            Text(
                              isEnglish ? "TR" : "EN",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onVisibilityToggle,
    String? Function(String?)? validator,
  }) {
    return FadeInUp(
      duration: Duration(milliseconds: 1000),
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: TextFormField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          validator: validator,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white70),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white38),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade200),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade200),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white70,
                    ),
                    onPressed: onVisibilityToggle,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return FadeInUp(
      duration: Duration(milliseconds: 1000),
      child: Row(
        children: [
          Checkbox(
            value: _acceptTerms,
            onChanged: (value) {
              setState(() {
                _acceptTerms = value ?? false;
              });
            },
            fillColor: MaterialStateProperty.resolveWith(
              (states) => states.contains(MaterialState.selected)
                  ? Colors.white
                  : Colors.white38,
            ),
            checkColor: Color(0xFF7277E4),
          ),
          Expanded(
            child: Text(
              isEnglish
                  ? "I accept the terms and conditions"
                  : "Kullanım koşullarını kabul ediyorum",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return FadeInUp(
      duration: Duration(milliseconds: 1000),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate() && _acceptTerms) {
              // Navigate to verification screen
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmailVerificationScreen(
                    email: _emailController.text,
                    isEnglish: isEnglish,
                  ),
                ),
              );

              if (result == true) {
                // Registration and verification successful
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEnglish
                          ? "Registration successful!"
                          : "Kayıt işlemi başarılı!",
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                // Navigate to main screen or login
                Navigator.pop(context);
              }
            } else if (!_acceptTerms) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isEnglish
                        ? "Please accept the terms and conditions"
                        : "Lütfen kullanım koşullarını kabul edin",
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            isEnglish ? "Register" : "Kaydol",
            style: TextStyle(
              color: Color(0xFF7277E4),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

class CustomNavigationBar extends StatelessWidget {
  final bool isEnglish;
  final VoidCallback onMenuTap;
  final int lives;

  const CustomNavigationBar({
    required this.isEnglish,
    required this.onMenuTap,
    this.lives = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7277E4), Color(0xFF5A5F9D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu Button
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: onMenuTap,
          ),
          // Lives Counter
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.red.shade400,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  "$lives",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Level Display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  isEnglish ? "Level 1" : "Seviye 1",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Profile Button
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: Icon(Icons.person, color: Colors.white, size: 24),
              onPressed: () {
                // Handle profile tap
              },
            ),
          ),
        ],
      ),
    );
  }
}

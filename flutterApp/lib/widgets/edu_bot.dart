import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class EduBot extends StatelessWidget {
  final String message;
  final bool isTyping;

  const EduBot({
    Key? key,
    required this.message,
    this.isTyping = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Robot Avatar
          FadeInLeft(
            duration: Duration(milliseconds: 800),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFF7277E4),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Robot Face
                  Center(
                    child: Icon(
                      Icons.smart_toy_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  // Glowing Effect
                  if (isTyping)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),
          // Speech Bubble
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInRight(
                  duration: Duration(milliseconds: 800),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isTyping)
                          Row(
                            children: [
                              _buildTypingDot(0),
                              _buildTypingDot(1),
                              _buildTypingDot(2),
                            ],
                          )
                        else
                          Text(
                            message,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return FadeInUp(
      duration: Duration(milliseconds: 600),
      delay: Duration(milliseconds: index * 200),
      child: Container(
        width: 8,
        height: 8,
        margin: EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: Color(0xFF7277E4),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

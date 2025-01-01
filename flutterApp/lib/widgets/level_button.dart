import 'package:flutter/material.dart';

class LevelButton extends StatelessWidget {
  final IconData icon;
  final String level;
  final bool isCompleted;
  final bool isActive;
  final bool isEnglish;

  const LevelButton({
    required this.icon,
    required this.level,
    required this.isCompleted,
    required this.isActive,
    this.isEnglish = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: isActive
                  ? [Color(0xFF7986CB), Color(0xFFC5CAE9)]
                  : [Colors.grey.shade400, Colors.grey.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0, 4),
                blurRadius: 8,
              ),
            ],
            border: Border.all(
              color: isCompleted ? Colors.yellow : Colors.transparent,
              width: isCompleted ? 3 : 0,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  icon,
                  color: isActive ? Colors.white : Colors.grey.shade600,
                  size: 35,
                ),
              ),
              if (isCompleted)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isActive ? Color(0xFF5A5F9D) : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            isEnglish ? "Level $level" : "Seviye $level",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

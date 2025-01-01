import 'package:flutter/material.dart';

import 'package:fluttermoji/fluttermoji.dart';
import 'avatar_customizer_screen.dart';
import 'points_system.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  bool _isDrawerOpen = false;
  int _selectedIndex = 0;
  double _health = 1.0; // Full health

  late AnimationController _drawerAnimationController;
  late Animation<double> _healthAnimation;

  @override
  void initState() {
    super.initState();

    _drawerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _healthAnimation = Tween<double>(
      begin: 1.0,
      end: _health,
    ).animate(
      CurvedAnimation(
        parent: _drawerAnimationController,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    // Start with full health
    _health = 1.0;
  }

  void toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;

      _isDrawerOpen
          ? _drawerAnimationController.forward()
          : _drawerAnimationController.reverse();
    });
  }

  @override
  void dispose() {
    _drawerAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background

          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/bg_codelingo.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),

          // Top Bar with Animated Health Bar

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              child: Stack(
                children: [
                  // Main App Bar
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7277E4), Color(0xFF5A5F9D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Menu Button with Animation
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: _isDrawerOpen
                                ? Colors.white.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: IconButton(
                            icon: AnimatedIcon(
                              icon: AnimatedIcons.menu_close,
                              progress: _drawerAnimationController,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: toggleDrawer,
                          ),
                        ),
                        // Modern Animated Health Bar
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Glowing Background
                                Container(
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.1),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                ),
                                // Animated Health Bar
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 1500),
                                  curve: Curves.easeInOut,
                                  height: 16,
                                  width: MediaQuery.of(context).size.width *
                                      0.6 *
                                      _health,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        _health > 0.6
                                            ? Color(0xFF4CAF50)
                                            : Color(0xFFFF5252),
                                        _health > 0.6
                                            ? Color(0xFF81C784)
                                            : Color(0xFFFF8A80),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (_health > 0.6
                                                ? Colors.green
                                                : Colors.red)
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                ),
                                // Health Text with Icon
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      size: 14,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "${(_health * 100).toInt()}%",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Avatar Preview
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: FluttermojiCircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Level Indicator
                  Positioned(
                    bottom: 0,
                    left: 50,
                    right: 50,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF7277E4), Color(0xFF5A5F9D)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Level 1",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Stack(
                      children: [
                        // Path connector lines
                        CustomPaint(
                          size: Size(MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.height * 0.6),
                          painter: PathPainter(),
                        ),

                        // Level buttons - Adjusted positions
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.5 - 40,
                          top: 10,
                          child: LevelButton(
                            icon: Icons.star,
                            level: "1",
                            isCompleted: true,
                            isActive: true,
                          ),
                        ),

                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.2,
                          top: 100,
                          child: LevelButton(
                            icon: Icons.fitness_center,
                            level: "2",
                            isCompleted: false,
                            isActive: true,
                          ),
                        ),

                        Positioned(
                          right: MediaQuery.of(context).size.width * 0.2,
                          top: 190,
                          child: LevelButton(
                            icon: Icons.fast_forward,
                            level: "3",
                            isCompleted: false,
                            isActive: false,
                          ),
                        ),

                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.2,
                          top: 280,
                          child: LevelButton(
                            icon: Icons.star_half,
                            level: "4",
                            isCompleted: false,
                            isActive: false,
                          ),
                        ),

                        Positioned(
                          right: MediaQuery.of(context).size.width * 0.2,
                          top: 370,
                          child: LevelButton(
                            icon: Icons.grid_view,
                            level: "5",
                            isCompleted: false,
                            isActive: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Drawer Background

          if (_isDrawerOpen)
            GestureDetector(
              onTap: toggleDrawer,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),

          // Modern Animated Drawer

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: _isDrawerOpen ? 0 : -280,
            top: 0,
            bottom: 0,
            child: Container(
              width: 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7277E4), Color(0xFF5A5F9D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: Offset(5, 0),
                  ),
                ],
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF8B8FE5), Color(0xFF6A6FB8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AvatarCustomizerScreen(),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    FluttermojiCircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.white,
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          size: 16,
                                          color: Color(0xFF7277E4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Points Badge
                            Positioned(
                              left: -5,
                              top: -5,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.stars,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '${PointsSystem().points}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Player Name",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            "Level 1 Master",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildDrawerItem(Icons.favorite, "Lives", "3", Colors.red),
                  _buildDrawerItem(Icons.star, "Score", "1250", Colors.amber),
                  _buildDrawerItem(Icons.stars, "Points",
                      "${PointsSystem().points}", Colors.amber),
                  Divider(color: Colors.white.withOpacity(0.1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Available Unlocks",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ...PointsSystem().getAvailableUnlocks().take(3).map((unlock) {
                    final featureName = unlock.key
                        .split('_')
                        .map(
                            (word) => word[0].toUpperCase() + word.substring(1))
                        .join(' ');
                    return UnlockableFeatureCard(
                      featureId: unlock.key,
                      featureName: featureName,
                      cost: unlock.value,
                      isUnlocked: false,
                      onUnlock: () {
                        if (PointsSystem().unlockFeature(unlock.key)) {
                          setState(() {});
                        }
                      },
                    );
                  }).toList(),
                  if (PointsSystem().getAvailableUnlocks().length > 3)
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "And ${PointsSystem().getAvailableUnlocks().length - 3} more...",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Divider(color: Colors.white.withOpacity(0.1)),
                  _buildDrawerItem(Icons.settings, "Settings", "", Colors.grey),
                  _buildDrawerItem(
                      Icons.info_outline, "About", "", Colors.blue),
                  _buildDrawerItem(Icons.logout, "Logout", "", Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      IconData icon, String title, String value, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: value.isNotEmpty
            ? Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: () {
          // Handle drawer item tap
        },
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFF7277E4).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Color(0xFF7277E4) : Colors.grey,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Color(0xFF7277E4) : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AvatarCustomizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customize Avatar"),
      ),
      body: FluttermojiCustomizer(),
    );
  }
}

class LevelButton extends StatelessWidget {
  final IconData icon;

  final String level;

  final bool isCompleted;

  final bool isActive;

  const LevelButton({
    required this.icon,
    required this.level,
    required this.isCompleted,
    required this.isActive,
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
            "Level $level",
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

class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final centerX = size.width / 2;

    // Starting from the top center (Level 1)
    path.moveTo(centerX, 50);

    // Path to Level 2 (left)
    path.quadraticBezierTo(
      centerX - 40,
      75,
      size.width * 0.2 + 40,
      140,
    );

    // Path to Level 3 (right)
    path.quadraticBezierTo(
      size.width * 0.2,
      165,
      size.width * 0.8 - 40,
      230,
    );

    // Path to Level 4 (left)
    path.quadraticBezierTo(
      size.width * 0.8,
      255,
      size.width * 0.2 + 40,
      320,
    );

    // Path to Level 5 (right)
    path.quadraticBezierTo(
      size.width * 0.2,
      345,
      size.width * 0.8 - 40,
      410,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

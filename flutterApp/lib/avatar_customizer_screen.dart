import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'points_system.dart';

class AvatarCustomizerScreen extends StatefulWidget {
  @override
  _AvatarCustomizerScreenState createState() => _AvatarCustomizerScreenState();
}

class _AvatarCustomizerScreenState extends State<AvatarCustomizerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategory = 0;

  final List<Map<String, dynamic>> _categories = [
    {
      'icon': Icons.face,
      'label': 'Face',
      'options': ['Shape', 'Skin', 'Freckles', 'Age Lines']
    },
    {
      'icon': Icons.visibility,
      'label': 'Eyes',
      'options': ['Shape', 'Color', 'Eyebrows', 'Lashes']
    },
    {
      'icon': Icons.face_retouching_natural,
      'label': 'Hair',
      'options': ['Style', 'Color', 'Treatment', 'Accessories']
    },
    {
      'icon': Icons.mood,
      'label': 'Mouth',
      'options': ['Shape', 'Color', 'Expression']
    },
    {
      'icon': Icons.accessibility_new,
      'label': 'Body',
      'options': ['Build', 'Height', 'Shoulders']
    },
    {
      'icon': Icons.checkroom,
      'label': 'Outfit',
      'options': ['Style', 'Color', 'Pattern']
    },
    {
      'icon': Icons.auto_awesome,
      'label': 'Extras',
      'options': ['Glasses', 'Jewelry', 'Tattoos']
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _categories.length,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        _selectedCategory = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Customize Your Avatar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.blue),
                    onPressed: () {
                      // Save avatar changes
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            // Avatar Preview
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7277E4), Color(0xFF5A5F9D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background Pattern
                  Positioned.fill(
                    child: CustomPaint(
                      painter: GridPatternPainter(),
                    ),
                  ),
                  // Avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: FluttermojiCircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),

            // Category Tabs
            Container(
              height: 90,
              color: Color(0xFF2A2A2A),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                padding: EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = index;
                        _tabController.animateTo(index);
                      });
                    },
                    child: Container(
                      width: 70,
                      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Color(0xFF7277E4) : Color(0xFF3A3A3A),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Color(0xFF7277E4).withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                )
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            category['icon'] as IconData,
                            color: isSelected ? Colors.white : Colors.grey,
                            size: 28,
                          ),
                          SizedBox(height: 4),
                          Text(
                            category['label'] as String,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Options Area
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _categories.map((category) {
                  return Container(
                    color: Color(0xFF1E1E1E),
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: (category['options'] as List).length,
                      itemBuilder: (context, index) {
                        final option = category['options'][index] as String;
                        return _buildOptionTile(category['label'], option);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionDetails(
      BuildContext context, String category, String option) {
    final pointsSystem = PointsSystem();
    final featureId = '${category.toLowerCase()}_${option.toLowerCase()}'
        .replaceAll(' ', '_');
    final isUnlocked = pointsSystem.isFeatureUnlocked(featureId);
    final cost = pointsSystem.featureCosts[featureId] ?? 0;

    if (!isUnlocked) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color(0xFF2A2A2A),
          title: Text(
            'Locked Feature',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock,
                color: Colors.amber,
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                'This feature requires $cost points to unlock.',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Current points: ${pointsSystem.points}',
                style: TextStyle(color: Colors.amber),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            if (pointsSystem.canUnlockFeature(featureId))
              TextButton(
                onPressed: () {
                  pointsSystem.unlockFeature(featureId);
                  Navigator.pop(context);
                  _showOptionDetailsSheet(context, category, option);
                },
                child: Text('Unlock', style: TextStyle(color: Colors.amber)),
              ),
          ],
        ),
      );
      return;
    }

    _showOptionDetailsSheet(context, category, option);
  }

  void _showOptionDetailsSheet(
      BuildContext context, String category, String option) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$category - $option',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FluttermojiCustomizer(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionTile(String category, String option) {
    final pointsSystem = PointsSystem();
    final featureId = '${category.toLowerCase()}_${option.toLowerCase()}'
        .replaceAll(' ', '_');
    final isUnlocked = pointsSystem.isFeatureUnlocked(featureId);
    final cost = pointsSystem.featureCosts[featureId] ?? 0;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked
              ? Colors.green.withOpacity(0.3)
              : Colors.amber.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          isUnlocked ? Icons.lock_open : Icons.lock,
          color: isUnlocked ? Colors.green : Colors.amber,
        ),
        title: Text(
          option,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        subtitle: !isUnlocked && cost > 0
            ? Text(
                '$cost points required',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 12,
                ),
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: () => _showOptionDetails(context, category, option),
      ),
    );
  }
}

class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    final spacing = 20.0;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

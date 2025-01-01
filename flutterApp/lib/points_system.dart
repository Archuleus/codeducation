import 'package:flutter/material.dart';

class PointsSystem {
  static final PointsSystem _instance = PointsSystem._internal();
  factory PointsSystem() => _instance;
  PointsSystem._internal();

  int _points = 0;
  final Map<String, bool> _unlockedFeatures = {
    // Face Features
    'face_shape_round': true, // Free
    'face_shape_oval': true, // Free
    'face_shape_heart': false, // 100 points
    'skin_light': true, // Free
    'skin_medium': true, // Free
    'skin_dark': true, // Free
    'freckles_light': false, // 50 points
    'freckles_heavy': false, // 100 points

    // Eyes Features
    'eyes_round': true, // Free
    'eyes_almond': true, // Free
    'eyes_cat': false, // 150 points
    'eye_color_brown': true, // Free
    'eye_color_blue': false, // 100 points
    'eye_color_green': false, // 100 points
    'eyebrows_natural': true, // Free
    'eyebrows_thick': false, // 50 points
    'eyebrows_arched': false, // 100 points

    // Hair Features
    'hair_short': true, // Free
    'hair_medium': true, // Free
    'hair_long': false, // 100 points
    'hair_curly': false, // 150 points
    'hair_color_black': true, // Free
    'hair_color_brown': true, // Free
    'hair_color_blonde': false, // 100 points
    'hair_color_red': false, // 150 points
    'hair_color_fantasy': false, // 200 points

    // Outfit Features
    'outfit_casual': true, // Free
    'outfit_formal': false, // 200 points
    'outfit_sporty': false, // 150 points
    'outfit_fantasy': false, // 300 points

    // Accessories
    'glasses_regular': true, // Free
    'glasses_sunglasses': false, // 100 points
    'glasses_fancy': false, // 150 points
    'jewelry_necklace': false, // 100 points
    'jewelry_earrings': false, // 100 points
    'tattoo_small': false, // 200 points
    'tattoo_sleeve': false, // 300 points
  };

  final Map<String, int> _featureCosts = {
    'face_shape_heart': 100,
    'freckles_light': 50,
    'freckles_heavy': 100,
    'eyes_cat': 150,
    'eye_color_blue': 100,
    'eye_color_green': 100,
    'eyebrows_thick': 50,
    'eyebrows_arched': 100,
    'hair_long': 100,
    'hair_curly': 150,
    'hair_color_blonde': 100,
    'hair_color_red': 150,
    'hair_color_fantasy': 200,
    'outfit_formal': 200,
    'outfit_sporty': 150,
    'outfit_fantasy': 300,
    'glasses_sunglasses': 100,
    'glasses_fancy': 150,
    'jewelry_necklace': 100,
    'jewelry_earrings': 100,
    'tattoo_small': 200,
    'tattoo_sleeve': 300,
  };

  int get points => _points;
  Map<String, bool> get unlockedFeatures => Map.unmodifiable(_unlockedFeatures);
  Map<String, int> get featureCosts => Map.unmodifiable(_featureCosts);

  void addPoints(int amount) {
    _points += amount;
    _checkUnlockables();
  }

  bool isFeatureUnlocked(String featureId) {
    return _unlockedFeatures[featureId] ?? false;
  }

  bool canUnlockFeature(String featureId) {
    final cost = _featureCosts[featureId] ?? 0;
    return _points >= cost;
  }

  bool unlockFeature(String featureId) {
    if (!_unlockedFeatures.containsKey(featureId)) return false;
    if (_unlockedFeatures[featureId] ?? false) return true;

    final cost = _featureCosts[featureId] ?? 0;
    if (_points >= cost) {
      _points -= cost;
      _unlockedFeatures[featureId] = true;
      return true;
    }
    return false;
  }

  void _checkUnlockables() {
    // Auto-unlock features if points are sufficient
    _featureCosts.forEach((feature, cost) {
      if (_points >= cost && !(_unlockedFeatures[feature] ?? false)) {
        _unlockedFeatures[feature] = true;
      }
    });
  }

  List<MapEntry<String, int>> getAvailableUnlocks() {
    return _featureCosts.entries
        .where((entry) => !(_unlockedFeatures[entry.key] ?? false))
        .toList();
  }
}

class UnlockableFeatureCard extends StatelessWidget {
  final String featureId;
  final String featureName;
  final int cost;
  final bool isUnlocked;
  final VoidCallback onUnlock;

  const UnlockableFeatureCard({
    required this.featureId,
    required this.featureName,
    required this.cost,
    required this.isUnlocked,
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isUnlocked
            ? Colors.green.withOpacity(0.1)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked
              ? Colors.green.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isUnlocked
                ? Colors.green.withOpacity(0.2)
                : Colors.amber.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isUnlocked ? Icons.lock_open : Icons.lock,
            color: isUnlocked ? Colors.green : Colors.amber,
          ),
        ),
        title: Text(
          featureName,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isUnlocked ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Text(
          isUnlocked ? 'Unlocked' : '$cost points required',
          style: TextStyle(
            color: isUnlocked ? Colors.green : Colors.amber,
          ),
        ),
        trailing: isUnlocked
            ? Icon(Icons.check_circle, color: Colors.green)
            : TextButton(
                onPressed: onUnlock,
                child: Text(
                  'Unlock',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// خريطة أسماء الأيقونات إلى IconData لاستخدامها في عرض الفئات.
/// تتطابق مع القيم المخزنة في لوحة التحكم.
const Map<String, IconData> categoryIcons = {
  'spa_rounded': Icons.spa_rounded,
  'face_rounded': Icons.face_rounded,
  'face_retouching_natural_rounded': Icons.face_retouching_natural_rounded,
  'palette_rounded': Icons.palette_rounded,
  'diamond_rounded': Icons.diamond_rounded,
  'local_offer_rounded': Icons.local_offer_rounded,
  'shopping_bag_rounded': Icons.shopping_bag_rounded,
  'inventory_2_rounded': Icons.inventory_2_rounded,
  'checkroom_rounded': Icons.checkroom_rounded,
  'water_drop_rounded': Icons.water_drop_rounded,
  'self_improvement_rounded': Icons.self_improvement_rounded,
  'eco_rounded': Icons.eco_rounded,
  'star_rounded': Icons.star_rounded,
  'favorite_rounded': Icons.favorite_rounded,
  'celebration_rounded': Icons.celebration_rounded,
};

/// يُرجع IconData المطابق للاسم، أو الأيقونة الافتراضية.
IconData getCategoryIcon(String? iconName) {
  if (iconName != null && iconName.isNotEmpty && categoryIcons.containsKey(iconName)) {
    return categoryIcons[iconName]!;
  }
  return Icons.spa_rounded;
}

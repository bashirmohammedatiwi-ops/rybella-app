import 'package:flutter/material.dart';

/// لوحة ألوان Rybella - أبيض ووردي فاتح أنيق
class AppColors {
  AppColors._();

  // الأبيض - نقاء وأناقة
  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteSoft = Color(0xFFFDFCFC);

  // الوردي الفاتح - تدرجات ناعمة
  static const Color pinkLight = Color(0xFFFFE4EC);
  static const Color pinkLighter = Color(0xFFFFF0F4);
  static const Color pinkSoft = Color(0xFFFFD6E0);
  static const Color pinkMedium = Color(0xFFFFB8CC);
  static const Color pinkAccent = Color(0xFFFF9BB8);
  static const Color pinkDeep = Color(0xFFF08BA3);

  // للتوافق مع الكود القديم
  static const Color salmon = Color(0xFFFFE4EC);
  static const Color salmonDark = Color(0xFFFFB8CC);
  static const Color salmonLight = Color(0xFFFFF0F4);
  static const Color peach = Color(0xFFFFD6E0);
  static const Color peachDark = Color(0xFFFFB8CC);
  static const Color peachLight = Color(0xFFFFE4EC);
  static const Color coral = Color(0xFFFF9BB8);
  static const Color coralLight = Color(0xFFFFE4EC);

  // المحايدات
  static const Color ivory = Color(0xFFFFFBFB);
  static const Color pearl = Color(0xFFFFF8F8);
  static const Color cream = Color(0xFFFFF5F7);
  static const Color linen = Color(0xFFF5EBEE);
  static const Color stone = Color(0xFFEBE0E3);

  // السطح والبطاقات
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // النصوص
  static const Color textPrimary = Color(0xFF2A2A2A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textMuted = Color(0xFF9A9A9A);

  // التدرجات
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFF8F9),
      Color(0xFFFFFFFF),
    ],
    stops: [0.0, 1.0],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB8CC), Color(0xFFFF9BB8)],
  );

  static const LinearGradient peachGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pinkLight, pinkSoft],
  );

  static const LinearGradient blushGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pinkAccent, pinkDeep],
  );

  static const LinearGradient champagneGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pinkLighter, pinkLight],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFFFFCFC)],
  );

  static const LinearGradient premiumAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pinkLight, pinkSoft],
  );

  // الظلال الناعمة
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: pinkAccent.withValues(alpha: 0.06),
          blurRadius: 24,
          offset: const Offset(0, 8),
          spreadRadius: -4,
        ),
        BoxShadow(
          color: const Color(0xFF2D2D2D).withValues(alpha: 0.03),
          blurRadius: 12,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: pinkAccent.withValues(alpha: 0.12),
          blurRadius: 28,
          offset: const Offset(0, 10),
          spreadRadius: -6,
        ),
      ];

  static List<BoxShadow> get buttonGlow => [
        BoxShadow(
          color: pinkAccent.withValues(alpha: 0.4),
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: -2,
        ),
      ];

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: pinkAccent.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ];

  static Color get glassWhite => Colors.white.withValues(alpha: 0.98);
  static Color get glassBorder => Colors.white.withValues(alpha: 0.9);

  static LinearGradient get roseGoldGradient => accentGradient;

  static Color get blush => pinkAccent;
  static Color get dustyRose => pinkSoft;

  // التوافق
  static Color get roseGold => pinkSoft;
  static Color get roseGoldDark => pinkAccent;
  static Color get roseGoldLight => pinkLight;
  static Color get terracotta => pinkAccent;
  static Color get terracottaDark => pinkDeep;
  static Color get terracottaLight => pinkLight;
  static Color get gold => pinkAccent;
  static Color get goldLight => pinkLight;
  static Color get goldDark => pinkMedium;
  static Color get sage => pinkMedium;
  static Color get sageLight => pinkLight;
  static Color get sageDark => pinkAccent;
  static LinearGradient get sageGradient => blushGradient;
  static Color get mauve => pinkMedium;
  static Color get mauveLight => pinkLight;
  static Color get mint => pinkLight;
  static Color get pink => pinkSoft;
  static Color get rose => pinkLight;
  static Color get clay => pinkSoft;
  static const Color sand = Color(0xFFF5EBEE);
  static Color get parchment => pearl;
}

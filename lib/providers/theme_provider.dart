import 'package:flutter/material.dart';

/// ألوان التطبيق الثابتة (الأساسي / الثانوي / الخطر)
class AppColors {
  static const Color primary = Color(0xFF1976D2);
  static const Color accent = Color(0xFFFFC107);
  static const Color danger = Color(0xFFE53935);
}

/// مزوّد حالة الوضع الداكن.
/// يبدأ بوضع النظام (ThemeMode.system) ثم يتبع اختيار المستخدم.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  /// هل الوضع الداكن فعّال حالياً؟ (يأخذ وضع النظام بالحسبان)
  bool isDark(BuildContext context) {
    if (_mode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return _mode == ThemeMode.dark;
  }

  /// تبديل الوضع الداكن من مفتاح التبديل
  void setDark(bool value) {
    _mode = value ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// بناء السمة الفاتحة أو الداكنة
  static ThemeData buildTheme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      error: AppColors.danger,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: const AppBarTheme(centerTitle: false),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.black,
        shape: CircleBorder(),
      ),
    );
  }
}

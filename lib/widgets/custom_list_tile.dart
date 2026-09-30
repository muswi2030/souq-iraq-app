import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// عنصر قائمة قابل لإعادة الاستخدام: أيقونة + عنوان + سهم (أو عنصر مخصص)
class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  /// عنصر بديل عن السهم (مثل Switch)
  final Widget? trailing;

  /// لون مخصص للأيقونة والنص (مثل الأحمر لمنطقة الخطر)
  final Color? color;

  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      minVerticalPadding: 6.h,
      leading: Icon(icon, color: color ?? scheme.primary, size: 24.sp),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      // أيقونة chevron_right تنعكس تلقائياً في واجهة RTL فتشير لليسار
      trailing: trailing ??
          Icon(Icons.chevron_right, color: scheme.outline, size: 22.sp),
    );
  }
}

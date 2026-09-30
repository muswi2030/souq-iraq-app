import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/theme_provider.dart';
import '../widgets/custom_list_tile.dart';
import '../widgets/settings_group.dart';

/// شاشة "الإعدادات" مقسّمة إلى 5 مجموعات
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const String _siteUrl = 'https://souq-iraq.example';

  bool _notifications = false;
  bool _backupReminder = true;

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _info(String title, String body) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('حسناً')),
        ],
      ),
    );
  }

  /// نسخ رابط التطبيق (بديل آمن عن حزمة مشاركة خارجية)
  Future<void> _copyLink() async {
    await Clipboard.setData(const ClipboardData(text: _siteUrl));
    if (!mounted) return;
    _snack('تم نسخ رابط سوق العراق');
  }

  Future<void> _shareWhatsApp() async {
    final uri = Uri.parse(
        'https://wa.me/?text=${Uri.encodeComponent('سوق العراق - بيع واشترِ بسهولة\n$_siteUrl')}');
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!mounted) return;
    if (!ok) _snack('تعذر فتح واتساب');
  }

  /// تأكيد مسح البيانات قبل التنفيذ
  Future<void> _confirmClear() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('مسح بيانات الحساب'),
        content: const Text('سيتم حذف كل بيانات الحساب من هذا الجهاز نهائياً.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('مسح'),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    // TODO: امسح التخزين المحلي هنا (SharedPreferences / قاعدة البيانات)
    _snack('تم مسح بيانات الحساب من هذا الجهاز');
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    Widget gap() => SizedBox(height: 24.h);

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // المجموعة 1: التفضيلات
          SettingsGroup(title: 'التفضيلات', children: [
            CustomListTile(
              icon: Icons.dark_mode_outlined,
              title: 'الوضع الداكن',
              trailing: Switch(
                  value: theme.isDark(context), onChanged: theme.setDark),
              onTap: () => theme.setDark(!theme.isDark(context)),
            ),
            CustomListTile(
              icon: Icons.notifications_active_outlined,
              title: 'تفعيل إشعارات المتصفح',
              trailing: Switch(
                  value: _notifications,
                  onChanged: (v) => setState(() => _notifications = v)),
              onTap: () => setState(() => _notifications = !_notifications),
            ),
            CustomListTile(
              icon: Icons.notification_add_outlined,
              title: 'اختبار الإشعارات',
              onTap: () => _snack('هذا إشعار تجريبي'),
            ),
            CustomListTile(
              icon: Icons.notifications_off_outlined,
              title: 'إلغاء جميع الإشعارات',
              onTap: () => _snack('تم إلغاء جميع الإشعارات'),
            ),
          ]),
          gap(),
          // المجموعة 2: المشاركة
          SettingsGroup(title: 'المشاركة', children: [
            CustomListTile(
                icon: Icons.share_outlined,
                title: 'مشاركة سوق العراق',
                onTap: _copyLink),
            CustomListTile(
                icon: Icons.chat_outlined,
                title: 'مشاركة سوق العراق عبر واتساب',
                onTap: _shareWhatsApp),
            CustomListTile(
              icon: Icons.add_to_home_screen,
              title: 'تثبيت التطبيق على الشاشة الرئيسية',
              onTap: () => _info('تثبيت التطبيق',
                  'التطبيق مثبّت على جهازك بالفعل. هذا الخيار مخصص لنسخة الويب.'),
            ),
          ]),
          gap(),
          // المجموعة 3: البيانات والأمان
          SettingsGroup(title: 'البيانات والأمان', children: [
            CustomListTile(
                icon: Icons.block,
                title: 'إدارة البائعين المحظورين',
                onTap: () => _snack('قائمة المحظورين')),
            CustomListTile(
                icon: Icons.upload_file,
                title: 'تصدير نسخة احتياطية',
                onTap: () => _snack('جارٍ التصدير...')),
            CustomListTile(
                icon: Icons.download,
                title: 'استيراد نسخة احتياطية',
                onTap: () => _snack('اختر ملف النسخة الاحتياطية')),
            CustomListTile(
              icon: Icons.event_repeat,
              title: 'تذكير النسخ الاحتياطي (كل 7 أيام)',
              trailing: Switch(
                  value: _backupReminder,
                  onChanged: (v) => setState(() => _backupReminder = v)),
              onTap: () => setState(() => _backupReminder = !_backupReminder),
            ),
          ]),
          gap(),
          // المجموعة 4: معلومات
          SettingsGroup(title: 'معلومات', children: [
            CustomListTile(
                icon: Icons.info_outline,
                title: 'من نحن',
                onTap: () => _info('من نحن',
                    'سوق العراق منصة إعلانات مبوبة للبيع والشراء في كل المحافظات.')),
            CustomListTile(
                icon: Icons.phone_outlined,
                title: 'اتصل بنا',
                onTap: () => _info('اتصل بنا', 'support@souq-iraq.example')),
            CustomListTile(
                icon: Icons.privacy_tip_outlined,
                title: 'سياسة الخصوصية',
                onTap: () => _info('سياسة الخصوصية',
                    'بياناتك تبقى على جهازك ولا تُشارك دون موافقتك.')),
          ]),
          gap(),
          // المجموعة 5: منطقة الخطر (نص أحمر)
          SettingsGroup(
            title: 'منطقة الخطر',
            titleColor: AppColors.danger,
            children: [
              CustomListTile(
                icon: Icons.delete_forever_outlined,
                title: 'مسح بيانات الحساب من هذا الجهاز',
                color: AppColors.danger,
                onTap: _confirmClear,
              ),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

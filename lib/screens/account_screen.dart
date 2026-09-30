import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_list_tile.dart';
import '../widgets/settings_group.dart';
import 'settings_screen.dart';

/// شاشة "حسابي": نشاط المستخدم فقط، والإعدادات خلف أيقونة الترس
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  void _soon(BuildContext context, String name) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('فتح: $name')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حسابي'),
        // في RTL تظهر actions في الزاوية اليسرى العليا
        actions: [
          IconButton(
            tooltip: 'الإعدادات',
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: ListView(
        // مسافة سفلية كي لا يغطي زر (+) آخر عنصر
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 96.h),
        children: [
          SettingsGroup(
            children: [
              CustomListTile(
                icon: Icons.description,
                title: 'إعلاناتي',
                onTap: () => _soon(context, 'إعلاناتي'),
              ),
              CustomListTile(
                icon: Icons.favorite_border,
                title: 'إعلاناتي المفضلة',
                onTap: () => _soon(context, 'المفضلة'),
              ),
              CustomListTile(
                icon: Icons.chat_bubble_outline,
                title: 'محادثاتي',
                onTap: () => _soon(context, 'المحادثات'),
              ),
              CustomListTile(
                icon: Icons.search,
                title: 'عمليات البحث المحفوظة',
                onTap: () => _soon(context, 'البحث المحفوظ'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

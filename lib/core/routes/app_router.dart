import 'package:flutter/material.dart';
import '../../features/azkar_screen/ui/azkar_main_screen.dart';
import '../../features/home_screen/UI/home_screen.dart';
import '../../features/prayer_times_screen/ui/prayer_times_screen.dart';
import '../../features/quran_screen/ui/quran_screen.dart';

import '../../features/quran_screen/ui/quran_screen.dart';
import '../../features/settings_screen/ui/settings_screen.dart';

import '../style/my_colors.dart';
import '../style/my_text_style.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  int currentIndex = 4; // الرئيسية افتراضيًا

  final List<Widget> pages = [
    const SettingsScreen(), // الإعدادات
    const PrayerTimesScreen(), // المواقيت
    const AzkarMainScreen(), // الأذكار
    const QuranScreen(), // القرآن
    const HomeScreen(), // الرئيسية
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: MyColors.darkBackground,
        selectedItemColor: MyColors.primaryGold,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: MyColors.white54,
        currentIndex: currentIndex,
        selectedLabelStyle: MyTextStyle.tajawal.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        unselectedLabelStyle: MyTextStyle.tajawal.copyWith(fontSize: 10),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          // ── الإعدادات ──────────────────────────────────────────
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            activeIcon: const Icon(Icons.settings, color: MyColors.primaryGold),
            label: 'الإعدادات',
          ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.access_time_outlined),
            activeIcon: const Icon(Icons.access_time_filled),
            label: 'المواقيت',
          ),
          // ── الأذكار ────────────────────────────────────────────
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/islam.png',
              width: 24,
              height: 24,
              color: MyColors.white54,
            ),
            activeIcon: Image.asset(
              'assets/images/islam.png',
              width: 24,
              height: 24,
              color: MyColors.primaryGold,
            ),
            label: 'الأذكار',
          ),
          // ── القرآن ─────────────────────────────────────────────
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/quran.png',
              width: 24,
              height: 24,
              color: MyColors.white54,
            ),
            activeIcon: Image.asset(
              'assets/images/quran.png',
              width: 24,
              height: 24,
              color: MyColors.primaryGold,
            ),
            label: 'القرآن',
          ),
          // ── الرئيسية ───────────────────────────────────────────
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/main.png',
              width: 24,
              height: 24,
              color: MyColors.white54,
            ),
            activeIcon: Image.asset(
              'assets/images/main.png',
              width: 24,
              height: 24,
              color: MyColors.primaryGold,
            ),
            label: 'الرئيسية',
          ),
        ],
      ),
    );
  }
}

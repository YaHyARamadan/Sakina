import 'package:flutter/material.dart';
import 'package:noorr/features/azkar_screen/ui/azkar_viewer_screen.dart';

import '../../../core/core_widgets/custom_scaffold.dart';
import '../../../core/core_widgets/custom_text.dart';
import '../../../core/style/my_colors.dart';
import '../../../core/style/my_text_style.dart';

class AzkarMainScreen extends StatelessWidget {
  const AzkarMainScreen({super.key});

  static const List<Map<String, dynamic>> azkarCategories = [
    {'id': 'salah', 'title': 'بعد الصلاة', 'icon': Icons.auto_awesome_outlined},
    {
      'id': 'masaa',
      'title': 'أذكار المساء',
      'icon': Icons.nights_stay_outlined,
    },
    {'id': 'nawm', 'title': 'أذكار النوم', 'icon': Icons.bedtime_outlined},
    {
      'id': 'safar',
      'title': 'أذكار السفر',
      'icon': Icons.flight_takeoff_rounded,
    },
    {'id': 'manzil', 'title': 'أذكار المنزل', 'icon': Icons.home_outlined},
    {'id': 'taaam', 'title': 'أذكار الطعام', 'icon': Icons.restaurant_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 15),
              CustomText(
                text: 'الأذكار',
                style: MyTextStyle.appbarTitle,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AzkarViewer(
                      categoryId: 'sabah',
                      categoryTitle: 'أذكار الصباح',
                    ),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 22,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [MyColors.primaryGold, MyColors.darkGold],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.primaryGold.withOpacity(0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            text: 'أذكار الصباح',
                            style: MyTextStyle.welcomeTitle.copyWith(fontSize: 22),
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            text: 'ابدأ يومك بذكر الله',
                            style: MyTextStyle.lastReadInfo.copyWith(
                              color: MyColors.darkBackground.withOpacity(0.75),
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: MyColors.darkBackground.withOpacity(0.15),
                        ),
                        child: const Icon(
                          Icons.wb_sunny_rounded,
                          color: MyColors.darkBackground,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.15,
                  ),
                  itemCount: azkarCategories.length,
                  itemBuilder: (context, index) {
                    final category = azkarCategories[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AzkarViewer(
                            categoryId: category['id'] as String,
                            categoryTitle: category['title'] as String,
                          ),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: MyColors.cardBackground.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: MyColors.white.withOpacity(0.07),
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyColors.secondaryGold.withOpacity(0.15),
                              ),
                              child: Icon(
                                category['icon'] as IconData,
                                color: MyColors.primaryGold,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 12),
                            CustomText(
                              text: category['title'].toString(),
                              style: MyTextStyle.cardSubtitle.copyWith(
                                color: MyColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }
}

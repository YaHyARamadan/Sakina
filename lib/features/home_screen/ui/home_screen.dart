import 'package:flutter/material.dart';
import 'package:noorr/features/home_screen/ui/widgets/zikr_counter.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../core/core_widgets/custom_appbar.dart';
import '../../../core/core_widgets/custom_scaffold.dart';
import '../../../core/core_widgets/custom_text.dart';
import '../../../core/style/my_text_style.dart';
import '../../../core/style/my_colors.dart';
import '../../azkar_screen/ui/azkar_viewer_screen.dart';
import '../../sora_screen/ui/surah_viewer.dart';
import '../UI/widgets/azker_card.dart';
import '../../quran_screen/logic/quran_provider.dart';
import '../../prayer_times_screen/logic/prayer_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HijriCalendar.setLocal('ar');
    var today = HijriCalendar.now();
    String hijriDate = '\u200F${today.hDay} ${today.longMonthName} ${today.hYear}هـ';

    return CustomScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomAppbar(
                  icon: Icons.notifications_none_outlined,
                  describeText: hijriDate,
                  text: "السلام عليكم",
                ),
                const SizedBox(height: 20),
                
                // Quran Quick Access
                Consumer<QuranProvider>(
                  builder: (context, quranProvider, child) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SurahViewer(
                              initialPage: quranProvider.lastReadPage,
                              surahName: quranProvider.lastReadSurah,
                            ),
                          ),
                        ).then((_) => quranProvider.loadLastReadPage());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              MyColors.primaryGold.withOpacity(0.8),
                              MyColors.darkGold.withOpacity(0.85),
                            ],
                            begin: AlignmentGeometry.topLeft,
                            end: AlignmentGeometry.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.menu_book, size: 55, color: MyColors.darkBackground),
                            const SizedBox(width: 15),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomText(
                                    text: "القرآن الكريم",
                                    style: MyTextStyle.welcomeTitle,
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerRight,
                                    child: CustomText(
                                      text: "آخر قراءة: سورة ${quranProvider.lastReadSurah}",
                                      style: MyTextStyle.lastReadInfo,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Azkar Sections
                Row(
                  children: [
                    Expanded(
                      child: AzkarSection(
                        icon: Icons.nights_stay_rounded,
                        title: "أذكار المساء",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AzkarViewer(
                              categoryId: 'masaa',
                              categoryTitle: 'أذكار المساء',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: AzkarSection(
                        icon: Icons.wb_sunny_outlined,
                        title: "أذكار الصباح",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AzkarViewer(
                              categoryId: 'sabah',
                              categoryTitle: 'أذكار الصباح',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                const ZikrCounter(),
                const SizedBox(height: 20),
                
                // Next Prayer Info
                Consumer<PrayerProvider>(
                  builder: (context, prayerProvider, child) {
                    if (prayerProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator(color: MyColors.primaryGold));
                    }
                    
                    final nextIndex = prayerProvider.getNextPrayerIndex();
                    final nextName = prayerProvider.prayerInfo[nextIndex]['name'] as String;
                    final nextTime = prayerProvider.getAllPrayerTimes()[nextIndex];
                    
                    return Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.white.withOpacity(0.05), width: 1.5),
                        color: MyColors.cardBackground.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            text: prayerProvider.formatTime(nextTime),
                            style: MyTextStyle.nextPrayerTime,
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: 'الصلاة القادمة',
                                style: MyTextStyle.nextPrayerLabel,
                              ),
                              CustomText(
                                text: 'صلاة $nextName',
                                style: MyTextStyle.prayerNameLarge,
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: MyColors.secondaryGold.withOpacity(0.2),
                            ),
                            child: const Icon(
                              Icons.access_time_outlined,
                              color: MyColors.primaryGold,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

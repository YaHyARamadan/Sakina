import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core_widgets/custom_scaffold.dart';
import '../../../core/core_widgets/custom_text.dart';
import '../../../core/style/my_colors.dart';
import '../../../core/style/my_text_style.dart';
import '../logic/prayer_provider.dart';
import 'Widgets/prayer_card.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Consumer<PrayerProvider>(
        builder: (context, prayerProvider, child) {
          if (prayerProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: MyColors.primaryGold),
            );
          }

          final nextIndex = prayerProvider.getNextPrayerIndex();
          final nextName =
              prayerProvider.prayerInfo[nextIndex]['name'] as String;
          final countdown = prayerProvider.getTimeUntilNextPrayer();
          final times = prayerProvider.getAllPrayerTimes();
          final currentIndex = prayerProvider.getCurrentPrayerIndex();

          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: MyColors.primaryGold,
                          size: 22,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomText(
                              text: 'مواقيت الصلاة',
                              style: MyTextStyle.prayerHeaderTitle,
                            ),
                            CustomText(
                              text: prayerProvider.cityName,
                              style: MyTextStyle.locationLabel,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Countdown Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 22,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            MyColors.primaryGold,
                            MyColors.secondaryGold,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: MyColors.primaryGold.withOpacity(0.35),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CustomText(
                            text: 'الصلاة القادمة: $nextName',
                            style: MyTextStyle.nextPrayerStatus,
                          ),
                          const SizedBox(height: 10),
                          CustomText(
                            text: prayerProvider.formatCountdown(countdown),
                            style: MyTextStyle.countdownText,
                          ),
                          const SizedBox(height: 6),
                          CustomText(
                            text: 'متبقي على رفع الأذان',
                            style: MyTextStyle.countdownDesc,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Prayer List
                    Column(
                      children: List.generate(
                        prayerProvider.prayerInfo.length,
                        (i) {
                          final bool isCurrent = (i == currentIndex);
                          final bool isNext = (i == nextIndex);
                          final String timeStr = times.isNotEmpty
                              ? prayerProvider.formatTime(times[i])
                              : '--:--';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: PrayerCard(
                              name:
                                  prayerProvider.prayerInfo[i]['name']
                                      as String,
                              icon:
                                  prayerProvider.prayerInfo[i]['icon']
                                      as IconData,
                              time: timeStr,
                              isCurrent: isCurrent,
                              isNext: isNext,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noorr/features/settings_screen/ui/widgets/setting_card.dart';
import 'package:provider/provider.dart';

import '../../../core/core_widgets/custom_appbar.dart';
import '../../../core/core_widgets/custom_scaffold.dart';
import '../../../core/core_widgets/custom_text.dart';
import '../../../core/style/my_colors.dart';
import '../../../core/style/my_text_style.dart';
import '../../prayer_times_screen/logic/prayer_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(22.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CustomAppbar(
                  text: "الإعدادات",
                  icon: Icons.settings_outlined,
                ),
                SizedBox(height: 30.h),
                Container(
                  decoration: BoxDecoration(
                    color: MyColors.cardBackground.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: MyColors.white.withOpacity(0.05),
                      width: 1.w,
                    ),
                  ),
                  child: Column(
                    children: [
                      SettingCard(
                        title: 'التنبيهات',
                        icon: Icons.notifications_active,
                        showDivider: true,
                        onTap: () {},
                      ),
                      SettingCard(
                        title: 'مظهر التطبيق',
                        subtitle: 'الوضع الداكن',
                        icon: Icons.palette,
                        showDivider: true,
                        onTap: () {},
                      ),
                      SettingCard(
                        title: 'اللغة',
                        subtitle: 'العربية',
                        icon: Icons.language,
                        showDivider: true,
                        onTap: () {},
                      ),

                      Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          collapsedIconColor: MyColors.white24,
                          iconColor: MyColors.primaryGold,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomText(
                                text: 'إعدادات أوقات الصلاة',
                                style: MyTextStyle.settingsTitle,
                              ),
                              SizedBox(width: 16.w),
                              Container(
                                padding: EdgeInsets.all(10.r),
                                decoration: BoxDecoration(
                                  color: MyColors.primaryGold.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.update,
                                  color: MyColors.primaryGold,
                                  size: 22.r,
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Consumer<PrayerProvider>(
                              builder: (context, prayerProvider, child) {
                                return Column(
                                  children: [
                                    SettingCard(
                                      title: 'تحسين دقة الموقع',
                                      subtitle:
                                          'تحديث الموقع الحالي وخطوط العرض/الطول',
                                      icon: Icons.my_location,
                                      showDivider: true,
                                      onTap: () async {
                                        await prayerProvider.refreshLocation();
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: CustomText(
                                                text: 'تم تحديث الموقع بنجاح',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    SettingCard(
                                      title: 'التوقيت الصيفي (+1 ساعة)',
                                      subtitle:
                                          'فعله إذا كانت مواقيت الصلاة متأخرة ساعة',
                                      icon: Icons.wb_sunny_outlined,
                                      showDivider: false,
                                      trailing: CupertinoSwitch(
                                        activeColor: MyColors.primaryGold,
                                        value: prayerProvider.isSummerTime,
                                        onChanged: (value) {
                                          // Intelligent check
                                          bool isSystemAlreadyDST =
                                              DateTime.now()
                                                  .timeZoneOffset
                                                  .inHours >=
                                              3;
                                          if (value && isSystemAlreadyDST) {
                                            _showDSTWarning(
                                              context,
                                              prayerProvider,
                                              value,
                                            );
                                          } else {
                                            prayerProvider.toggleSummerTime(
                                              value,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      Divider(
                        color: MyColors.white.withOpacity(0.05),
                        height: 1.h,
                        thickness: 1.h,
                      ),

                      SettingCard(
                        title: 'عن التطبيق',
                        icon: Icons.info,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                Align(
                  alignment: AlignmentGeometry.center,
                  child: CustomText(
                    text: "تطبيق نور - الإصدار 1.0.0",
                    style: MyTextStyle.locationLabel.copyWith(fontSize: 14.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDSTWarning(
    BuildContext context,
    PrayerProvider provider,
    bool value,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MyColors.darkBackground,
        title: const CustomText(
          text: 'تنبيه ذكي',
          textAlign: TextAlign.center,
          style: TextStyle(color: MyColors.primaryGold),
        ),
        content: const CustomText(
          text:
              'يبدو أن هاتفك مضبوط بالفعل على التوقيت الصيفي. تفعيل هذا الخيار قد يؤدي لزيادة ساعة إضافية خاطئة. هل تريد التفعيل على أي حال؟',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: MyColors.textGray),
            ),
          ),
          TextButton(
            onPressed: () {
              provider.toggleSummerTime(value);
              Navigator.pop(context);
            },
            child: const Text(
              'تفعيل على أي حال',
              style: TextStyle(color: MyColors.primaryGold),
            ),
          ),
        ],
      ),
    );
  }
}

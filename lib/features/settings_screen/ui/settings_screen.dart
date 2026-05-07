import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                      _buildSettingItem(
                        title: 'التنبيهات',
                        icon: Icons.notifications_active,
                        showDivider: true,
                        onTap: () {},
                      ),
                      _buildSettingItem(
                        title: 'مظهر التطبيق',
                        subtitle: 'الوضع الداكن',
                        icon: Icons.palette,
                        showDivider: true,
                        onTap: () {},
                      ),
                      _buildSettingItem(
                        title: 'اللغة',
                        subtitle: 'العربية',
                        icon: Icons.language,
                        showDivider: true,
                        onTap: () {},
                      ),
                      
                      // Prayer Times Settings Section
                      Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
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
                                    _buildSettingItem(
                                      title: 'تحسين دقة الموقع',
                                      subtitle: 'تحديث الموقع الحالي وخطوط العرض/الطول',
                                      icon: Icons.my_location,
                                      showDivider: true,
                                      onTap: () async {
                                        await prayerProvider.refreshLocation();
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: CustomText(text: 'تم تحديث الموقع بنجاح', style: TextStyle(color: Colors.white)),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    _buildSettingItem(
                                      title: 'التوقيت الصيفي (+1 ساعة)',
                                      subtitle: 'فعله إذا كانت مواقيت الصلاة متأخرة ساعة',
                                      icon: Icons.wb_sunny_outlined,
                                      showDivider: false,
                                      trailing: CupertinoSwitch(
                                        activeColor: MyColors.primaryGold,
                                        value: prayerProvider.isSummerTime,
                                        onChanged: (value) {
                                          // Intelligent check
                                          bool isSystemAlreadyDST = DateTime.now().timeZoneOffset.inHours >= 3;
                                          if (value && isSystemAlreadyDST) {
                                            _showDSTWarning(context, prayerProvider, value);
                                          } else {
                                            prayerProvider.toggleSummerTime(value);
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
                      
                      _buildSettingItem(
                        title: 'عن التطبيق',
                        icon: Icons.info,
                        showDivider: false,
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

  void _showDSTWarning(BuildContext context, PrayerProvider provider, bool value) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MyColors.darkBackground,
        title: const CustomText(text: 'تنبيه ذكي', textAlign: TextAlign.center, style: TextStyle(color: MyColors.primaryGold)),
        content: const CustomText(
          text: 'يبدو أن هاتفك مضبوط بالفعل على التوقيت الصيفي. تفعيل هذا الخيار قد يؤدي لزيادة ساعة إضافية خاطئة. هل تريد التفعيل على أي حال؟',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء', style: TextStyle(color: MyColors.textGray))),
          TextButton(
            onPressed: () {
              provider.toggleSummerTime(value);
              Navigator.pop(context);
            },
            child: const Text('تفعيل على أي حال', style: TextStyle(color: MyColors.primaryGold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    String? subtitle,
    required IconData icon,
    required bool showDivider,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                trailing ?? Icon(
                  Icons.arrow_back_ios_new,
                  color: MyColors.white24,
                  size: 16.r,
                ),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomText(
                              text: title,
                              style: MyTextStyle.settingsTitle,
                              textAlign: TextAlign.end,
                            ),
                            if (subtitle != null) ...[
                              SizedBox(height: 2.h),
                              CustomText(
                                text: subtitle,
                                style: MyTextStyle.settingsSubtitle,
                                textAlign: TextAlign.end,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),

                      Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: MyColors.primaryGold.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: MyColors.primaryGold,
                          size: 22.r,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        if (showDivider)
          Divider(
            color: MyColors.white.withOpacity(0.05),
            height: 1.h,
            thickness: 1.h,
          ),
      ],
    );
  }
}


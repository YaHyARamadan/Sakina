import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/core_widgets/custom_text.dart';
import '../../../core/style/my_text_style.dart';
import '../../../core/style/my_colors.dart';
import '../logic/azkar_provider.dart';

class AzkarViewer extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;

  const AzkarViewer({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
  });

  @override
  State<AzkarViewer> createState() => _AzkarViewerState();
}

class _AzkarViewerState extends State<AzkarViewer> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AzkarProvider>().loadAzkar(widget.categoryId);
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: MyColors.darkBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: MyColors.secondaryGold.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          title: const Center(
            child: Icon(
              Icons.verified,
              color: MyColors.secondaryGold,
              size: 50,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: 'تقبل الله طاعتك!',
                textAlign: TextAlign.center,
                style: MyTextStyle.tajawal.copyWith(
                  color: MyColors.secondaryGold,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              CustomText(
                text:
                    'لقد أتممت هذه الأذكار المباركة.\nجعلها الله في ميزان حسناتك ونفعك بها في الدنيا والآخرة.',
                textAlign: TextAlign.center,
                style: MyTextStyle.tajawal.copyWith(
                  color: MyColors.white,
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to main azkar screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.secondaryGold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: CustomText(
                text: 'جزاك الله خيراً',
                style: MyTextStyle.tajawal.copyWith(
                  color: MyColors.darkBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.darkBackground,
      body: Consumer<AzkarProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: MyColors.secondaryGold),
            );
          }

          if (provider.azkar.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(
                    text: "لا توجد أذكار أو حدث خطأ في التحميل",
                    style: TextStyle(color: MyColors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: MyColors.secondaryGold,
                    ),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  // Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Share.share(
                            'جرب تطبيق الأذكار ❤️\n${provider.currentZikr}',
                          );
                        },
                        icon: const Icon(
                          Icons.share,
                          color: MyColors.secondaryGold,
                        ),
                      ),
                      CustomText(
                        text: widget.categoryTitle,
                        style: MyTextStyle.azkarCategoryTitle,
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: MyColors.secondaryGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Zikr Content
                  Flexible(
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 120),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 25,
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.cardBackground.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: MyColors.secondaryGold.withOpacity(0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: RawScrollbar(
                        controller: _scrollController,
                        thumbColor: MyColors.secondaryGold.withOpacity(0.8),
                        thickness: 3,
                        radius: const Radius.circular(10),
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.format_quote_rounded,
                                color: MyColors.secondaryGold.withOpacity(0.6),
                                size: 28,
                              ),
                              const SizedBox(height: 12),
                              CustomText(
                                text: provider.currentZikr,
                                textAlign: TextAlign.center,
                                style: MyTextStyle.zikrText.copyWith(
                                  fontFamily: 'UthmanicHafs',
                                ),
                              ),
                              const SizedBox(height: 12),
                              Icon(
                                Icons.format_quote_rounded,
                                color: MyColors.secondaryGold.withOpacity(0.6),
                                size: 28,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Counter Stack
                  GestureDetector(
                    onTap: () => provider.increment(_showCompletionDialog),
                    behavior: HitTestBehavior.opaque,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: MyColors.darkBackground,
                            boxShadow: [
                              BoxShadow(
                                color: MyColors.secondaryGold.withOpacity(0.4),
                                blurRadius: 18,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: CircularProgressIndicator(
                            value: provider.progress,
                            strokeWidth: 5,
                            backgroundColor: MyColors.white10,
                            valueColor: const AlwaysStoppedAnimation(
                              MyColors.secondaryGold,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              text: '${provider.count}',
                              style: MyTextStyle.counterText,
                            ),
                            CustomText(
                              text: '/ ${provider.targetCount}',
                              style: MyTextStyle.cardSubtitle.copyWith(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 5),
                            CustomText(
                              text: 'العدّاد الحالي',
                              style: MyTextStyle.nextPrayerLabel.copyWith(
                                color: MyColors.white54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: GestureDetector(
                            onTap: provider.reset,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyColors.darkBackground.withOpacity(
                                  0.85,
                                ),
                                border: Border.all(
                                  color: MyColors.secondaryGold.withOpacity(.9),
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: MyColors.secondaryGold.withOpacity(
                                      0.5,
                                    ),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.refresh,
                                color: MyColors.secondaryGold,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

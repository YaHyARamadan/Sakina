import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../../core/services/format_arabic_number.dart';
import '../../../../core/style/my_colors.dart';
import '../../../../core/style/my_text_style.dart';
import '../../../../core/core_widgets/custom_text.dart';
import '../../quran_screen/logic/quran_provider.dart';

class SurahViewer extends StatefulWidget {
  final int initialPage;
  final String surahName;

  const SurahViewer({
    super.key,
    required this.initialPage,
    required this.surahName,
  });

  @override
  State<SurahViewer> createState() => _SurahViewerState();
}

class _SurahViewerState extends State<SurahViewer> {
  late int _currentPage;
  bool _showOverlay = true;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
    });
  }


  @override
  Widget build(BuildContext context) {
    final quranProvider = context.watch<QuranProvider>();
    final isDark = quranProvider.isDarkMode;

    int currentSurahNumber = 1;
    int currentJuzNumber = 1;
    int currentHizbNumber = 1;
    int firstVerse = 1;

    try {
      final pageData = getPageData(_currentPage);
      if (pageData.isNotEmpty) {
        currentSurahNumber = pageData.first['surah'] as int;
        firstVerse = pageData.first['start'] as int;
        currentJuzNumber = getJuzNumber(currentSurahNumber, firstVerse);
      }
    } catch (e) {
      debugPrint("Error calculating page info: $e");
    }

    final bgColor = isDark ? const Color(0xFF121212) : MyColors.quranPageBg;
    final textColor = isDark ? const Color(0xFFE0E0E0) : const Color(0xFF1A1A1A);
    final accentColor = isDark ? MyColors.primaryGold : const Color(0xFF8B7355);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header: Surah Name & Juz ──────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'الجزء ${toArabicDigits(currentJuzNumber)}',
                    style: MyTextStyle.pageNumber.copyWith(
                      color: accentColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomText(
                    text: getSurahNameArabic(currentSurahNumber),
                    style: MyTextStyle.pageNumber.copyWith(
                      color: accentColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'UthmanicHafs',
                    ),
                  ),
                ],
              ),
            ),

            // ─── Quran Reader Area ──────────────────────────────
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.h),
                child: PageviewQuran(
                  initialPageNumber: widget.initialPage,
                  sp: 1.sp,
                  h: 0.88.h,
                  theme: QcfThemeData(
                    pageBackgroundColor: bgColor,
                    verseTextColor: textColor,
                  ),
                  onPageChanged: (page) {
                    setState(() => _currentPage = page);
                    context.read<QuranProvider>().saveLastPage(page);
                  },
                  physics: const BouncingScrollPhysics(),
                ),
              ),
            ),
            
            // ─── Footer: Decorated Page Number ──────────────────
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                   // Decorative frame (Using a container with border if image not ready)
                   Container(
                     width: 60.r,
                     height: 45.r,
                     decoration: BoxDecoration(
                       image: const DecorationImage(
                         image: AssetImage('assets/images/ZakhrafaNum.png'),
                         fit: BoxFit.contain,
                       ),
                     ),
                     alignment: Alignment.center,
                     child: Padding(
                       padding: EdgeInsets.only(top: 4.h),
                       child: CustomText(
                        text: toArabicDigits(_currentPage),
                        style: MyTextStyle.pageNumber.copyWith(
                          color: textColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                       ),
                     ),
                   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



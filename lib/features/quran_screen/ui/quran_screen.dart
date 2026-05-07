import 'package:flutter/material.dart';

import 'package:qcf_quran/qcf_quran.dart';
import '../../../core/core_widgets/custom_appbar.dart';
import '../../../core/core_widgets/custom_scaffold.dart';
import '../../sora_screen/ui/surah_viewer.dart';
import '../../sora_screen/ui/widgets/sora_card.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              const CustomAppbar(
                text: "القرآن الكريم",
                imgPath: "assets/images/quran.png",
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: 114,
                  itemBuilder: (context, index) {
                    final surahIndex = index + 1;
                    return SoraCard(
                      soraName: getSurahNameArabic(surahIndex),
                      soraNum: surahIndex,
                      ayatNum: getVerseCount(surahIndex),
                      revelationType: getPlaceOfRevelation(surahIndex),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurahViewer(
                              initialPage: getPageNumber(surahIndex, 1),
                              surahName: getSurahNameArabic(surahIndex),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/core_widgets/custom_text.dart';
import '../../../../core/style/my_colors.dart';
import '../../../../core/style/my_text_style.dart';

class PrayerCard extends StatelessWidget {
  const PrayerCard({
    super.key,
    required this.name,
    required this.icon,
    required this.time,
    required this.isCurrent,
    required this.isNext,
  });

  final String name;
  final IconData icon;
  final String time;
  final bool isCurrent;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final bool isHighlighted = isNext;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: isHighlighted
            ? MyColors.primaryGold.withOpacity(0.1)
            : MyColors.cardBackground.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNext
              ? MyColors.primaryGold.withOpacity(0.5)
              : MyColors.white.withOpacity(0.05),
          width: isNext ? 1.5 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: time,
            style: MyTextStyle.tajawal.copyWith(
              color: isHighlighted ? MyColors.primaryGold : MyColors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          Row(
            children: [
              CustomText(
                text: name,
                style: MyTextStyle.tajawal.copyWith(
                  color: isHighlighted ? MyColors.primaryGold : MyColors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(width: 10),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? MyColors.primaryGold.withOpacity(0.2)
                      : MyColors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isHighlighted
                      ? MyColors.primaryGold
                      : MyColors.textGray,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

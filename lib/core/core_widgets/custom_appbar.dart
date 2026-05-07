import 'package:flutter/material.dart';

import '../style/my_text_style.dart';
import '../style/my_colors.dart';
import 'custom_text.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    this.icon,
    this.describeText,
    required this.text,
    this.imgPath,
  });

  final IconData? icon;
  final String? describeText;
  final String? imgPath;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: MyColors.primaryGold.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: MyColors.primaryGold.withOpacity(0.13),
            child: icon != null
                ? Icon(icon, color: MyColors.primaryGold, size: 28)
                : Image.asset(
                    imgPath!,
                    width: 28,
                    height: 28,
                    color: MyColors.primaryGold,
                  ),
          ),
        ),
        const SizedBox(width: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(
              text: text,
              style: MyTextStyle.appbarTitle.copyWith(
                color: MyColors.secondaryGold,
                fontSize: 28,
              ),
            ),
            if (describeText != null)
              CustomText(
                text: describeText!,
                style: MyTextStyle.appbarSubtitle.copyWith(fontSize: 16),
              ),
          ],
        ),
      ],
    );
  }
}

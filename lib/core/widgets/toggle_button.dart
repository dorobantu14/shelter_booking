import 'package:flutter/material.dart';
import 'package:shelter_booking/core/core.dart';

class ToggleButton extends StatelessWidget {
  final bool value;
  final String text;
  final GestureTapCallback? onTap;
  final IconData iconData;
  final bool centeredContent;

  const ToggleButton({
    super.key,
    required this.value,
    required this.text,
    this.onTap,
    required this.iconData,
    required this.centeredContent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
            color: value ? AppColors.blue : AppColors.lightGrey,
          ),
        ),
        child: Row(
          mainAxisAlignment: centeredContent
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                iconData,
                color: value ? AppColors.blue : AppColors.pink,
              ),
            ),
            Text(
              text,
              style: value
                  ? TextStyles.normalBlueTextStyle
                  : TextStyles.normalGreyTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

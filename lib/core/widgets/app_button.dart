import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shelter_booking/core/core.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? iconPath;
  final String text;
  final Color color;
  final bool? buttonEnabled;
  final bool? whiteText;

  const AppButton({
    Key? key,
    this.onPressed,
    required this.color,
    this.iconPath,
    required this.text,
    this.buttonEnabled,
    this.whiteText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: buttonEnabled ?? true ? onPressed : () {},
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
            buttonEnabled ?? true ? color : AppColors.disabledButtonColor),
        elevation: const MaterialStatePropertyAll(4.0),
        fixedSize: MaterialStatePropertyAll(
          Size(MediaQuery.of(context).size.width, 48),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: iconPath != null
                ? SvgPicture.asset(
                    iconPath!,
                    fit: BoxFit.cover,
                    width: 32,
                    height: 32,
                  )
                : null,
          ),
          Text(
            text,
            style: whiteText ?? false
                ? TextStyles.whiteButtonTextStyle
                : TextStyles.blackButtonTextStyle,
          ),
        ],
      ),
    );
  }
}

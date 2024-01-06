import 'package:flutter/material.dart';
import 'package:shelter_booking/core/core.dart';

abstract class TextStyles {
  static const boldTitleTextStyle = TextStyle(
    fontSize: 54,
    fontWeight: FontWeight.bold,
    color: AppColors.blue,
  );

  static const boldSubtitleTextStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const normalBoldTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const blackButtonTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.black,
  );

  static const whiteButtonTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.white,
  );

  static const whiteBoldTextStyle = TextStyle(
    fontSize: 18,
    color: AppColors.white,
    fontWeight: FontWeight.w600,
  );

  static const whiteNormalTextStyle = TextStyle(
    fontSize: 14,
    color: AppColors.white,
  );

  static const normalGreyTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.lightGrey,
  );

  static const boldGreyTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.lightGrey,
  );

  static const normalBlueTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.blue,
  );

  static const greySubtitleTextStyle = TextStyle(
    fontSize: 18,
    color: AppColors.lightGrey,
  );
}

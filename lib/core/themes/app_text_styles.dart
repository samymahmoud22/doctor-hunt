import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColors.textMain,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.rubik(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // Headings
  static TextStyle get h1 => _base(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      );

  static TextStyle get h2 => _base(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      );

  static TextStyle get h3 => _base(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );

  static TextStyle get h4 => _base(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );

  // Titles
  static TextStyle get titleLarge => _base(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textMain,
      );

  static TextStyle get titleMedium => _base(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textMain,
      );

  static TextStyle get titleSmall => _base(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textMain,
      );

  // Body
  static TextStyle get bodyLarge => _base(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textMain,
      );

  static TextStyle get bodyMedium => _base(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textMain,
      );

  static TextStyle get bodySmall => _base(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textMain,
      );

  // Subtext / Secondary
  static TextStyle get subtext => _base(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textSub,
      );

  static TextStyle get subtextMedium => _base(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: AppColors.textSub,
      );

  static TextStyle get subtextSmall => _base(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textSub,
      );

  // Captions & Badges
  static TextStyle get caption => _base(
        fontSize: 11,
        fontWeight: FontWeight.normal,
        color: AppColors.textSub,
      );

  static TextStyle get captionBold => _base(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: AppColors.textSub,
        letterSpacing: 0.5,
      );

  // Labels
  static TextStyle get label => _base(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textDark,
      );

  static TextStyle get labelBold => _base(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      );

  // Buttons
  static TextStyle get button => _base(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      );

  static TextStyle get buttonSmall => _base(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      );
}

extension AppTextStyleExtensions on TextStyle {
  TextStyle get withPrimary => copyWith(color: AppColors.primary);
  TextStyle get withPrimaryLight => copyWith(color: AppColors.primaryLight);
  TextStyle get withSecondary => copyWith(color: AppColors.secondary);
  TextStyle get withTextMain => copyWith(color: AppColors.textMain);
  TextStyle get withTextSub => copyWith(color: AppColors.textSub);
  TextStyle get withTextDark => copyWith(color: AppColors.textDark);
  TextStyle get withPlaceholder => copyWith(color: AppColors.textPlaceholder);
  TextStyle get withWhite => copyWith(color: AppColors.white);
  TextStyle get withDanger => copyWith(color: AppColors.danger);
  TextStyle get withActiveTeal => copyWith(color: AppColors.activeTeal);
  TextStyle get withBold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get withSemiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get withMedium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get withRegular => copyWith(fontWeight: FontWeight.normal);
}


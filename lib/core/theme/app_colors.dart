import 'package:flutter/material.dart';

/// Raw design tokens 
class AppColors {
  AppColors._();

  // ---- Light scheme ----
  static const Color surface = Color(0xFFF8F9FF);
  static const Color surfaceDim = Color(0xFFCBDBF5);
  static const Color surfaceBright = Color(0xFFF8F9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFEFF4FF);
  static const Color surfaceContainer = Color(0xFFE5EEFF);
  static const Color surfaceContainerHigh = Color(0xFFDCE9FF);
  static const Color surfaceContainerHighest = Color(0xFFD3E4FE);

  static const Color onSurface = Color(0xFF0B1C30);
  static const Color onSurfaceVariant = Color(0xFF434750);

  static const Color inverseSurface = Color(0xFF213145);
  static const Color inverseOnSurface = Color(0xFFEAF1FF);

  static const Color outline = Color(0xFF747781);
  static const Color outlineVariant = Color(0xFFC4C6D2);

  static const Color surfaceTint = Color(0xFF3B5D9E);

  static const Color primary = Color(0xFF002558); // ALU Blue
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF123B7A);
  static const Color onPrimaryContainer = Color(0xFF87A7ED);
  static const Color inversePrimary = Color(0xFFAEC6FF);

  static const Color secondary = Color(0xFFBA0031); // ALU Red
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE12345);
  static const Color onSecondaryContainer = Color(0xFFFFFBFF);

  static const Color tertiary = Color(0xFF451A00);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF672B00);
  static const Color onTertiaryContainer = Color(0xFFEA925F);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color primaryFixed = Color(0xFFD8E2FF);
  static const Color primaryFixedDim = Color(0xFFAEC6FF);
  static const Color onPrimaryFixed = Color(0xFF001A42);
  static const Color onPrimaryFixedVariant = Color(0xFF204584);

  static const Color secondaryFixed = Color(0xFFFFDADA);
  static const Color secondaryFixedDim = Color(0xFFFFB3B4);
  static const Color onSecondaryFixed = Color(0xFF40000B);
  static const Color onSecondaryFixedVariant = Color(0xFF920024);

  static const Color tertiaryFixed = Color(0xFFFFDBCA);
  static const Color tertiaryFixedDim = Color(0xFFFFB68E);
  static const Color onTertiaryFixed = Color(0xFF331200);
  static const Color onTertiaryFixedVariant = Color(0xFF743508);

  static const Color background = Color(0xFFF8F9FF);
  static const Color onBackground = Color(0xFF0B1C30);
  static const Color surfaceVariant = Color(0xFFD3E4FE);

  // ---- Dark scheme ----
  
  static const Color darkBackground = Color(0xFF0B1526);
  static const Color darkSurface = Color(0xFF0B1526);
  static const Color darkSurfaceContainerLowest = Color(0xFF081020);
  static const Color darkSurfaceContainerLow = Color(0xFF111D33);
  static const Color darkSurfaceContainer = Color(0xFF16233D);
  static const Color darkSurfaceContainerHigh = Color(0xFF1D2C49);
  static const Color darkSurfaceContainerHighest = Color(0xFF253656);

  static const Color darkOnSurface = Color(0xFFEAF1FF);
  static const Color darkOnSurfaceVariant = Color(0xFFC4C6D2);
  static const Color darkOutline = Color(0xFF8D909B);
  static const Color darkOutlineVariant = Color(0xFF2D3E5D); // per spec: card stroke in dark mode

  static const Color darkPrimary = Color(0xFFAEC6FF); // inverse-primary token
  static const Color darkOnPrimary = Color(0xFF001A42);
  static const Color darkPrimaryContainer = Color(0xFF204584);
  static const Color darkOnPrimaryContainer = Color(0xFFD8E2FF);

  static const Color darkSecondary = Color(0xFFFFB3B4);
  static const Color darkOnSecondary = Color(0xFF40000B);
  static const Color darkSecondaryContainer = Color(0xFF920024);
  static const Color darkOnSecondaryContainer = Color(0xFFFFDADA);

  static const Color darkTertiary = Color(0xFFFFB68E);
  static const Color darkOnTertiary = Color(0xFF331200);
  static const Color darkTertiaryContainer = Color(0xFF743508);
  static const Color darkOnTertiaryContainer = Color(0xFFFFDBCA);

  static const Color darkError = Color(0xFFFFB4AB);
  static const Color darkOnError = Color(0xFF690005);
  static const Color darkErrorContainer = Color(0xFF93000A);
  static const Color darkOnErrorContainer = Color(0xFFFFDAD6);

  static const Color darkInverseSurface = Color(0xFFEAF1FF);
  static const Color darkInverseOnSurface = Color(0xFF213145);
}
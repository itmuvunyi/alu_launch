import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Type scale Font is Inter everywhere ("exclusively" per spec).
///
/// Usage: `Theme.of(context).textTheme.headlineLarge` - this class maps
/// the named tokens (display-lg, headline-lg, ...) onto Flutter's standard
/// TextTheme slots so normal Material widgets pick them up automatically.
class AppTypography {
  AppTypography._();

  static TextTheme textTheme(Color onSurface, Color onSurfaceVariant) {
    final base = GoogleFonts.interTextTheme();

    return base.copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: -0.02 * 32,
        color: onSurface,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        letterSpacing: -0.01 * 24,
        color: onSurface,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: onSurface,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 24 / 18,
        color: onSurface,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: onSurface,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: onSurfaceVariant,
      ),
 
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        letterSpacing: 0.01 * 12,
        color: onSurfaceVariant,
      ),
      // label-sm: 11/600/14 — reserved for ALL-CAPS secondary status labels
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 14 / 11,
        color: onSurfaceVariant,
      ),
    );
  }
}
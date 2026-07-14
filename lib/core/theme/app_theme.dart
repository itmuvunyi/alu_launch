import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_semantic_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(brightness: Brightness.light);
  static ThemeData get dark => _build(brightness: Brightness.dark);

  static ThemeData _build({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = isDark
        ? const ColorScheme(
            brightness: Brightness.dark,
            primary: AppColors.darkPrimary,
            onPrimary: AppColors.darkOnPrimary,
            primaryContainer: AppColors.darkPrimaryContainer,
            onPrimaryContainer: AppColors.darkOnPrimaryContainer,
            secondary: AppColors.darkSecondary,
            onSecondary: AppColors.darkOnSecondary,
            secondaryContainer: AppColors.darkSecondaryContainer,
            onSecondaryContainer: AppColors.darkOnSecondaryContainer,
            tertiary: AppColors.darkTertiary,
            onTertiary: AppColors.darkOnTertiary,
            tertiaryContainer: AppColors.darkTertiaryContainer,
            onTertiaryContainer: AppColors.darkOnTertiaryContainer,
            error: AppColors.darkError,
            onError: AppColors.darkOnError,
            errorContainer: AppColors.darkErrorContainer,
            onErrorContainer: AppColors.darkOnErrorContainer,
            surface: AppColors.darkSurface,
            onSurface: AppColors.darkOnSurface,
            onSurfaceVariant: AppColors.darkOnSurfaceVariant,
            outline: AppColors.darkOutline,
            outlineVariant: AppColors.darkOutlineVariant,
            inverseSurface: AppColors.darkInverseSurface,
            onInverseSurface: AppColors.darkInverseOnSurface,
            inversePrimary: AppColors.primary,
            surfaceContainerLowest: AppColors.darkSurfaceContainerLowest,
            surfaceContainerLow: AppColors.darkSurfaceContainerLow,
            surfaceContainer: AppColors.darkSurfaceContainer,
            surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
            surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
          )
        : const ColorScheme(
            brightness: Brightness.light,
            primary: AppColors.primary,
            onPrimary: AppColors.onPrimary,
            primaryContainer: AppColors.primaryContainer,
            onPrimaryContainer: AppColors.onPrimaryContainer,
            secondary: AppColors.secondary,
            onSecondary: AppColors.onSecondary,
            secondaryContainer: AppColors.secondaryContainer,
            onSecondaryContainer: AppColors.onSecondaryContainer,
            tertiary: AppColors.tertiary,
            onTertiary: AppColors.onTertiary,
            tertiaryContainer: AppColors.tertiaryContainer,
            onTertiaryContainer: AppColors.onTertiaryContainer,
            error: AppColors.error,
            onError: AppColors.onError,
            errorContainer: AppColors.errorContainer,
            onErrorContainer: AppColors.onErrorContainer,
            surface: AppColors.surface,
            onSurface: AppColors.onSurface,
            onSurfaceVariant: AppColors.onSurfaceVariant,
            outline: AppColors.outline,
            outlineVariant: AppColors.outlineVariant,
            inverseSurface: AppColors.inverseSurface,
            onInverseSurface: AppColors.inverseOnSurface,
            inversePrimary: AppColors.inversePrimary,
            surfaceContainerLowest: AppColors.surfaceContainerLowest,
            surfaceContainerLow: AppColors.surfaceContainerLow,
            surfaceContainer: AppColors.surfaceContainer,
            surfaceContainerHigh: AppColors.surfaceContainerHigh,
            surfaceContainerHighest: AppColors.surfaceContainerHighest,
          );

    final textTheme = AppTypography.textTheme(
      colorScheme.onSurface,
      colorScheme.onSurfaceVariant,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.darkBackground : AppColors.background,
      textTheme: textTheme,
      extensions: [
        isDark ? AppSemanticColors.dark : AppSemanticColors.light,
      ],

      // ---- AppBar: matches the navy/white header on every screenshot ----
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.primary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),

      // ---- Cards: 16px padding handled per-widget; here just radius/elevation/stroke ----
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLowest,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          side: isDark
              ? BorderSide(color: colorScheme.outlineVariant, width: 1)
              : BorderSide.none,
        ),
        margin: EdgeInsets.zero,
      ),

      // ---- Primary button: solid ALU Blue ----
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(64, AppSpacing.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: textTheme.titleLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),

      // ---- Outline button: ALU Blue border/text ----
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: const Size(64, AppSpacing.minTouchTarget),
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: textTheme.titleLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: const Size(64, AppSpacing.minTouchTarget),
          textStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      // ---- Inputs: 1px border, ALU Blue focus + glow ----
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        labelStyle: textTheme.labelMedium,
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),

      // ---- Chips: skill tags, low-contrast pills ----
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        labelStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        side: BorderSide.none,
      ),

      // ---- Bottom nav: matches the 4-tab pattern in every screenshot ----
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainerLowest,
        indicatorColor: colorScheme.primaryContainer.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelMedium?.copyWith(
            color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          );
        }),
        elevation: 0,
        height: 64,
      ),

      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainerLowest,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl2)),
        ),
      ),
    );
  }
}
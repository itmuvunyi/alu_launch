import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show BuildContext;

/// Status colors used across badges/chips (verified, pending, rejected, live, etc.)

@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
  });

  /// Verified, Approved, Live, Accepted
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;

  /// Pending, Awaiting Review, Draft
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  /// Under Review, Interviewing, Live-tracking states
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;

  static const light = AppSemanticColors(
    success: Color(0xFF1B8A5A),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFD4F3E4),
    onSuccessContainer: Color(0xFF04432A),
    warning: Color(0xFFB6790A),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFCE8C7),
    onWarningContainer: Color(0xFF4A2E00),
    info: Color(0xFF8A3B1D), // maroon-ish, matches "Under Review" dot in prototype
    onInfo: Color(0xFFFFFFFF),
    infoContainer: Color(0xFFFBE4DC),
    onInfoContainer: Color(0xFF451A00),
  );

  static const dark = AppSemanticColors(
    success: Color(0xFF6FDDA8),
    onSuccess: Color(0xFF04391F),
    successContainer: Color(0xFF0B5A38),
    onSuccessContainer: Color(0xFFD4F3E4),
    warning: Color(0xFFFFC876),
    onWarning: Color(0xFF4A2E00),
    warningContainer: Color(0xFF6A4600),
    onWarningContainer: Color(0xFFFCE8C7),
    info: Color(0xFFEA925F),
    onInfo: Color(0xFF451A00),
    infoContainer: Color(0xFF672B00),
    onInfoContainer: Color(0xFFFFDBCA),
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
    );
  }
}

/// Convenience getter: `context.semanticColors.success`
extension AppSemanticColorsX on BuildContext {
  AppSemanticColors get semanticColors =>
      Theme.of(this).extension<AppSemanticColors>() ?? AppSemanticColors.light;
}
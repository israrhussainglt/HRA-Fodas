import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Utility class for responsive design decisions based on screen size.
///
/// This class provides helper methods to determine the current screen size
/// category and adjust spacing and font sizes accordingly.
class ResponsiveUtils {
  /// Determines if the current screen is in compact mode (width < 360px).
  ///
  /// Compact mode is typically used for small mobile devices where space
  /// is limited and UI elements need to be condensed.
  ///
  /// Returns `true` if screen width is less than [AppConstraints.compactBreakpoint].
  static bool isCompact(BuildContext context) {
    return MediaQuery.of(context).size.width < AppConstraints.compactBreakpoint;
  }

  /// Determines if the current screen is in expanded mode (width >= 600px).
  ///
  /// Expanded mode is typically used for tablets and larger devices where
  /// more space is available for UI elements.
  ///
  /// Returns `true` if screen width is greater than or equal to
  /// [AppConstraints.expandedBreakpoint].
  static bool isExpanded(BuildContext context) {
    return MediaQuery.of(context).size.width >=
        AppConstraints.expandedBreakpoint;
  }

  /// Returns the appropriate spacing value based on the current screen size.
  ///
  /// - Compact screens (< 360px): Returns [AppSpacing.sm] (8px)
  /// - Expanded screens (>= 600px): Returns [AppSpacing.lg] (16px)
  /// - Standard screens (360-600px): Returns [AppSpacing.md] (12px)
  ///
  /// This method helps maintain consistent spacing across different screen sizes
  /// while adapting to available space.
  static double getResponsiveSpacing(BuildContext context) {
    if (isCompact(context)) return AppSpacing.sm;
    if (isExpanded(context)) return AppSpacing.lg;
    return AppSpacing.md;
  }

  /// Returns a responsive font size based on the current screen size.
  ///
  /// For compact screens (< 360px), the font size is reduced by 10% to fit
  /// more content. For standard and expanded screens, the base size is used.
  ///
  /// Parameters:
  /// - [context]: The build context to access screen size information
  /// - [baseSize]: The base font size to adjust
  ///
  /// Returns the adjusted font size (0.9x for compact, 1.0x otherwise).
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    if (isCompact(context)) return baseSize * 0.9;
    return baseSize;
  }
}

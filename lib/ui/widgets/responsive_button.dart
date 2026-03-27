import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/responsive_utils.dart';

/// A responsive button widget that prevents overflow and adapts to screen size.
///
/// This widget wraps an [ElevatedButton] with responsive behavior:
/// - Applies consistent padding using [AppSpacing] constants
/// - Adjusts text size based on screen width
/// - Supports icon-only mode for compact screens (< 360px)
/// - Handles text overflow with ellipsis
///
/// **Important**: When using multiple buttons in a Row, wrap them in a Wrap widget
/// or use the buttons inside a Wrap to allow proper wrapping behavior.
///
/// Example usage:
/// ```dart
/// // Single button
/// ResponsiveButton(
///   text: 'Submit',
///   onPressed: () => print('Pressed'),
/// )
///
/// // Multiple buttons with wrapping
/// Wrap(
///   children: [
///     ResponsiveButton(text: 'Button 1', onPressed: () {}),
///     ResponsiveButton(text: 'Button 2', onPressed: () {}),
///   ],
/// )
/// ```
class ResponsiveButton extends StatelessWidget {
  /// The text to display on the button.
  ///
  /// This text will be displayed unless [isIconOnly] is true and the screen
  /// is in compact mode (< 360px).
  final String text;

  /// Callback function when the button is pressed.
  final VoidCallback onPressed;

  /// Whether to show only the icon in compact mode.
  ///
  /// When true and screen width < 360px, only the [icon] will be displayed.
  /// When false or screen width >= 360px, the [text] will be displayed.
  final bool isIconOnly;

  /// The icon to display when in icon-only mode.
  ///
  /// This icon is only shown when [isIconOnly] is true and the screen is
  /// in compact mode (< 360px).
  final IconData? icon;

  /// Creates a responsive button widget.
  ///
  /// The [text] and [onPressed] parameters are required.
  /// The [isIconOnly] parameter defaults to false.
  /// The [icon] parameter is optional but should be provided if [isIconOnly] is true.
  const ResponsiveButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isIconOnly = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = ResponsiveUtils.isCompact(context);

    final buttonWidget = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md, // 12px
        vertical: AppSpacing.sm, // 8px
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: isCompact && isIconOnly && icon != null
            ? Icon(icon, size: AppIconSize.md)
            : Text(
                text,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                ),
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );

    // Only wrap in Flexible if inside a Flex widget (Row, Column, Wrap, etc.)
    // This prevents errors when the button is used standalone
    return buttonWidget;
  }
}

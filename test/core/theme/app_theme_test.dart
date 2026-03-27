import 'package:flutter_test/flutter_test.dart';
import 'package:food_donation_app/core/theme/app_theme.dart';

void main() {
  group('AppSpacing', () {
    test('should have correct spacing constants', () {
      expect(AppSpacing.xs, 4.0);
      expect(AppSpacing.sm, 8.0);
      expect(AppSpacing.md, 12.0);
      expect(AppSpacing.lg, 16.0);
      expect(AppSpacing.xl, 24.0);
    });
  });

  group('AppIconSize', () {
    test('should have correct icon size constants', () {
      expect(AppIconSize.sm, 16.0);
      expect(AppIconSize.md, 20.0);
      expect(AppIconSize.lg, 24.0);
    });
  });

  group('AppConstraints', () {
    test('should have correct breakpoint constants', () {
      expect(AppConstraints.minScreenWidth, 320.0);
      expect(AppConstraints.compactBreakpoint, 360.0);
      expect(AppConstraints.expandedBreakpoint, 600.0);
    });

    test('should have correct donation card constraints', () {
      expect(AppConstraints.donationCardCategoryMaxWidth, 80.0);
      expect(AppConstraints.donationCardMinTextWidth, 0.6);
      expect(AppConstraints.donationCardIconActionWidth, 0.3);
    });
  });
}

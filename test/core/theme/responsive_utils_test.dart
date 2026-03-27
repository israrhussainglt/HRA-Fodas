import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_donation_app/core/theme/app_theme.dart';
import 'package:food_donation_app/core/theme/responsive_utils.dart';

void main() {
  group('ResponsiveUtils', () {
    group('isCompact', () {
      testWidgets('should return true for screen width less than 360px', (
        WidgetTester tester,
      ) async {
        // Test at 320px (minimum screen width)
        tester.view.physicalSize = const Size(320, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(ResponsiveUtils.isCompact(context), isTrue);
                return Container();
              },
            ),
          ),
        );

        // Test at 359px (just below breakpoint)
        tester.view.physicalSize = const Size(359, 600);
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(ResponsiveUtils.isCompact(context), isTrue);
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets(
        'should return false for screen width equal to or greater than 360px',
        (WidgetTester tester) async {
          // Test at 360px (exactly at breakpoint)
          tester.view.physicalSize = const Size(360, 600);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);

          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (context) {
                  expect(ResponsiveUtils.isCompact(context), isFalse);
                  return Container();
                },
              ),
            ),
          );

          // Test at 400px (standard screen)
          tester.view.physicalSize = const Size(400, 600);
          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (context) {
                  expect(ResponsiveUtils.isCompact(context), isFalse);
                  return Container();
                },
              ),
            ),
          );
        },
      );
    });

    group('isExpanded', () {
      testWidgets(
        'should return true for screen width greater than or equal to 600px',
        (WidgetTester tester) async {
          // Test at 600px (exactly at breakpoint)
          tester.view.physicalSize = const Size(600, 800);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);

          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (context) {
                  expect(ResponsiveUtils.isExpanded(context), isTrue);
                  return Container();
                },
              ),
            ),
          );

          // Test at 800px (tablet size)
          tester.view.physicalSize = const Size(800, 1024);
          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (context) {
                  expect(ResponsiveUtils.isExpanded(context), isTrue);
                  return Container();
                },
              ),
            ),
          );
        },
      );

      testWidgets('should return false for screen width less than 600px', (
        WidgetTester tester,
      ) async {
        // Test at 599px (just below breakpoint)
        tester.view.physicalSize = const Size(599, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(ResponsiveUtils.isExpanded(context), isFalse);
                return Container();
              },
            ),
          ),
        );

        // Test at 400px (standard screen)
        tester.view.physicalSize = const Size(400, 600);
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(ResponsiveUtils.isExpanded(context), isFalse);
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('getResponsiveSpacing', () {
      testWidgets('should return small spacing for compact screens (< 360px)', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(320, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(
                  ResponsiveUtils.getResponsiveSpacing(context),
                  equals(AppSpacing.sm),
                );
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets(
        'should return medium spacing for standard screens (360-600px)',
        (WidgetTester tester) async {
          // Test at 360px
          tester.view.physicalSize = const Size(360, 600);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);

          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (context) {
                  expect(
                    ResponsiveUtils.getResponsiveSpacing(context),
                    equals(AppSpacing.md),
                  );
                  return Container();
                },
              ),
            ),
          );

          // Test at 400px
          tester.view.physicalSize = const Size(400, 600);
          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (context) {
                  expect(
                    ResponsiveUtils.getResponsiveSpacing(context),
                    equals(AppSpacing.md),
                  );
                  return Container();
                },
              ),
            ),
          );

          // Test at 599px
          tester.view.physicalSize = const Size(599, 800);
          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (context) {
                  expect(
                    ResponsiveUtils.getResponsiveSpacing(context),
                    equals(AppSpacing.md),
                  );
                  return Container();
                },
              ),
            ),
          );
        },
      );

      testWidgets(
        'should return large spacing for expanded screens (>= 600px)',
        (WidgetTester tester) async {
          // Test at 600px
          tester.view.physicalSize = const Size(600, 800);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);

          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (context) {
                  expect(
                    ResponsiveUtils.getResponsiveSpacing(context),
                    equals(AppSpacing.lg),
                  );
                  return Container();
                },
              ),
            ),
          );

          // Test at 800px
          tester.view.physicalSize = const Size(800, 1024);
          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (context) {
                  expect(
                    ResponsiveUtils.getResponsiveSpacing(context),
                    equals(AppSpacing.lg),
                  );
                  return Container();
                },
              ),
            ),
          );
        },
      );
    });

    group('getResponsiveFontSize', () {
      testWidgets('should reduce font size by 10% for compact screens', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(320, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                const baseSize = 14.0;
                final responsiveSize = ResponsiveUtils.getResponsiveFontSize(
                  context,
                  baseSize,
                );
                expect(responsiveSize, equals(baseSize * 0.9));
                expect(responsiveSize, equals(12.6));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should keep base font size for standard screens', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(400, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                const baseSize = 14.0;
                final responsiveSize = ResponsiveUtils.getResponsiveFontSize(
                  context,
                  baseSize,
                );
                expect(responsiveSize, equals(baseSize));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should keep base font size for expanded screens', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(800, 1024);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                const baseSize = 14.0;
                final responsiveSize = ResponsiveUtils.getResponsiveFontSize(
                  context,
                  baseSize,
                );
                expect(responsiveSize, equals(baseSize));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should work with different base font sizes', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(320, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // Test with 16px base
                expect(
                  ResponsiveUtils.getResponsiveFontSize(context, 16.0),
                  equals(14.4),
                );

                // Test with 12px base
                expect(
                  ResponsiveUtils.getResponsiveFontSize(context, 12.0),
                  equals(10.8),
                );

                // Test with 20px base
                expect(
                  ResponsiveUtils.getResponsiveFontSize(context, 20.0),
                  equals(18.0),
                );

                return Container();
              },
            ),
          ),
        );
      });
    });

    group('Edge cases', () {
      testWidgets('should handle exact breakpoint values correctly', (
        WidgetTester tester,
      ) async {
        // Test at exactly 360px (compact breakpoint)
        tester.view.physicalSize = const Size(360, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(ResponsiveUtils.isCompact(context), isFalse);
                expect(ResponsiveUtils.isExpanded(context), isFalse);
                expect(
                  ResponsiveUtils.getResponsiveSpacing(context),
                  equals(AppSpacing.md),
                );
                return Container();
              },
            ),
          ),
        );

        // Test at exactly 600px (expanded breakpoint)
        tester.view.physicalSize = const Size(600, 800);
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(ResponsiveUtils.isCompact(context), isFalse);
                expect(ResponsiveUtils.isExpanded(context), isTrue);
                expect(
                  ResponsiveUtils.getResponsiveSpacing(context),
                  equals(AppSpacing.lg),
                );
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should handle minimum screen width (320px)', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(
          AppConstraints.minScreenWidth,
          600,
        );
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(ResponsiveUtils.isCompact(context), isTrue);
                expect(ResponsiveUtils.isExpanded(context), isFalse);
                expect(
                  ResponsiveUtils.getResponsiveSpacing(context),
                  equals(AppSpacing.sm),
                );
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should handle very large screen widths', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(ResponsiveUtils.isCompact(context), isFalse);
                expect(ResponsiveUtils.isExpanded(context), isTrue);
                expect(
                  ResponsiveUtils.getResponsiveSpacing(context),
                  equals(AppSpacing.lg),
                );
                return Container();
              },
            ),
          ),
        );
      });
    });
  });
}

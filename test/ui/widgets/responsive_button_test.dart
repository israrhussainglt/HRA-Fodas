import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_donation_app/core/theme/app_theme.dart';
import 'package:food_donation_app/ui/widgets/responsive_button.dart';

void main() {
  group('ResponsiveButton', () {
    testWidgets('should render with text on standard screens', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveButton(text: 'Submit', onPressed: () {}),
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets(
      'should render with icon on compact screens when isIconOnly is true',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(320, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ResponsiveButton(
                text: 'Submit',
                onPressed: () {},
                isIconOnly: true,
                icon: Icons.send,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.send), findsOneWidget);
        expect(find.text('Submit'), findsNothing);
      },
    );

    testWidgets(
      'should render with text on compact screens when isIconOnly is false',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(320, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ResponsiveButton(
                text: 'Submit',
                onPressed: () {},
                isIconOnly: false,
              ),
            ),
          ),
        );

        expect(find.text('Submit'), findsOneWidget);
        expect(find.byType(Icon), findsNothing);
      },
    );

    testWidgets(
      'should render with text when icon is not provided even if isIconOnly is true',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(320, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ResponsiveButton(
                text: 'Submit',
                onPressed: () {},
                isIconOnly: true,
                // icon not provided
              ),
            ),
          ),
        );

        expect(find.text('Submit'), findsOneWidget);
        expect(find.byType(Icon), findsNothing);
      },
    );

    testWidgets('should apply correct padding', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveButton(text: 'Submit', onPressed: () {}),
          ),
        ),
      );

      // Find the first Padding widget that is a direct child of ResponsiveButton
      final padding = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(ResponsiveButton),
              matching: find.byType(Padding),
            )
            .first,
      );

      expect(
        padding.padding,
        equals(
          EdgeInsets.symmetric(
            horizontal: AppSpacing.md, // 12px
            vertical: AppSpacing.sm, // 8px
          ),
        ),
      );
    });

    testWidgets('should work in Wrap widget for overflow prevention', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Wrap(
              children: [ResponsiveButton(text: 'Submit', onPressed: () {})],
            ),
          ),
        ),
      );

      expect(find.byType(ResponsiveButton), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should apply responsive font size on compact screens', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveButton(text: 'Submit', onPressed: () {}),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Submit'));
      expect(textWidget.style?.fontSize, equals(14.0 * 0.9)); // 12.6
    });

    testWidgets('should apply base font size on standard screens', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveButton(text: 'Submit', onPressed: () {}),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Submit'));
      expect(textWidget.style?.fontSize, equals(14.0));
    });

    testWidgets('should apply TextOverflow.ellipsis to text', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveButton(
              text: 'Very Long Button Text That Should Overflow',
              onPressed: () {},
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(
        find.text('Very Long Button Text That Should Overflow'),
      );
      expect(textWidget.overflow, equals(TextOverflow.ellipsis));
    });

    testWidgets('should call onPressed when button is tapped', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveButton(
              text: 'Submit',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      expect(pressed, isTrue);
    });

    testWidgets('should use correct icon size in icon-only mode', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveButton(
              text: 'Submit',
              onPressed: () {},
              isIconOnly: true,
              icon: Icons.send,
            ),
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.send));
      expect(iconWidget.size, equals(AppIconSize.md)); // 20px
    });

    group('Multiple buttons in Wrap', () {
      testWidgets('should not overflow when multiple buttons are in a Wrap', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(400, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Wrap(
                children: [
                  ResponsiveButton(text: 'Button 1', onPressed: () {}),
                  ResponsiveButton(text: 'Button 2', onPressed: () {}),
                  ResponsiveButton(text: 'Button 3', onPressed: () {}),
                ],
              ),
            ),
          ),
        );

        // Should render without overflow errors
        expect(tester.takeException(), isNull);
        expect(find.byType(ResponsiveButton), findsNWidgets(3));
      });
    });

    group('Edge cases', () {
      testWidgets('should handle empty text', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(400, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ResponsiveButton(text: '', onPressed: () {}),
            ),
          ),
        );

        expect(find.text(''), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle very long text', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(400, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        const longText =
            'This is a very long button text that should be '
            'truncated with ellipsis when it exceeds the available space';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ResponsiveButton(text: longText, onPressed: () {}),
            ),
          ),
        );

        expect(find.text(longText), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle screen width at exact breakpoint (360px)', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(360, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ResponsiveButton(
                text: 'Submit',
                onPressed: () {},
                isIconOnly: true,
                icon: Icons.send,
              ),
            ),
          ),
        );

        // At exactly 360px, should not be compact, so should show text
        expect(find.text('Submit'), findsOneWidget);
        expect(find.byType(Icon), findsNothing);
      });

      testWidgets('should handle screen width just below breakpoint (359px)', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(359, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ResponsiveButton(
                text: 'Submit',
                onPressed: () {},
                isIconOnly: true,
                icon: Icons.send,
              ),
            ),
          ),
        );

        // At 359px, should be compact, so should show icon
        expect(find.byIcon(Icons.send), findsOneWidget);
        expect(find.text('Submit'), findsNothing);
      });
    });
  });
}

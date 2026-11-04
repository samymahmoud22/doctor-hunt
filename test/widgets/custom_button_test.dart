import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/core/widgets/custom_button.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: child),
      ),
    );
  }

  group('CustomButton Widget Tests', () {
    testWidgets('renders button text correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          CustomButton(
            text: 'Confirm Booking',
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Confirm Booking'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('triggers onPressed callback when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        createTestWidget(
          CustomButton(
            text: 'Book Now',
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('Book Now'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          CustomButton(
            text: 'With Icon',
            icon: Icons.calendar_today,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.text('With Icon'), findsOneWidget);
    });

    testWidgets('edge case: shows CircularProgressIndicator and disables tap when isLoading is true', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        createTestWidget(
          CustomButton(
            text: 'Loading Action',
            isLoading: true,
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading Action'), findsNothing);

      // Verify button is disabled when loading
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);

      // Attempt to tap
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('renders OutlinedButton when isOutlined is true', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          CustomButton(
            text: 'Cancel',
            isOutlined: true,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('edge case: disabled state when onPressed is null', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const CustomButton(
            text: 'Disabled Button',
            onPressed: null,
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });
}


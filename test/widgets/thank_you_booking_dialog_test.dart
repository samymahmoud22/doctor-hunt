import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/features/patient/appointments/presentation/widgets/thank_you_booking_dialog.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: child),
      ),
    );
  }

  group('ThankYouBookingDialog Widget Tests', () {
    testWidgets('renders doctor name, date, time, and success confirmation', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          ThankYouBookingDialog(
            doctorName: 'Dr. Shruti Kedia',
            date: '10 Nov 2026',
            time: '02:00 PM',
            onDone: () {},
          ),
        ),
      );

      expect(find.text('Thank You !'), findsOneWidget);
      expect(find.text('Your Appointment Successful'), findsOneWidget);
      expect(
        find.text('You booked an appointment with Dr. Shruti Kedia on 10 Nov 2026 at 02:00 PM'),
        findsOneWidget,
      );
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('tapping Done triggers onDone callback', (tester) async {
      bool doneCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          ThankYouBookingDialog(
            doctorName: 'Dr. Ananya Shah',
            date: '12 Nov 2026',
            time: '11:00 AM',
            onDone: () {
              doneCalled = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('Done'));
      await tester.pump();

      expect(doneCalled, isTrue);
    });

    testWidgets('edge case: show dialog helper opens dialog with modal barrier', (tester) async {
      bool doneClicked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ThankYouBookingDialog.show(
                    context,
                    doctorName: 'Dr. Luke Whitesell',
                    date: '15 Nov 2026',
                    time: '03:30 PM',
                    onDone: () {
                      doneClicked = true;
                    },
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Thank You !'), findsOneWidget);
      expect(find.text('You booked an appointment with Dr. Luke Whitesell on 15 Nov 2026 at 03:30 PM'), findsOneWidget);

      await tester.tap(find.text('Done'));
      await tester.pump();

      expect(doneClicked, isTrue);
    });
  });
}


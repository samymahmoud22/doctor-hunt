import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_appointment_model.dart';
import 'package:doctor_hunt/features/admin/presentation/widgets/admin_appointment_card.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }

  const tUpcomingAdminApt = AdminAppointmentModel(
    id: 'apt_admin_1',
    patientName: 'Maya Patel',
    patientEmail: 'maya@example.com',
    doctorId: 'doc_1',
    doctorName: 'Dr. Fillerup Grab',
    doctorSpecialty: 'Medicine Specialist',
    date: '15 Nov 2026',
    time: '10:00 AM',
    fee: 30.0,
    status: AdminAppointmentStatus.upcoming,
  );

  const tCompletedAdminApt = AdminAppointmentModel(
    id: 'apt_admin_2',
    patientName: 'John Doe',
    patientEmail: 'john@example.com',
    doctorId: 'doc_2',
    doctorName: 'Dr. Shruti Kedia',
    doctorSpecialty: 'Specialist Dentist',
    date: '10 Nov 2026',
    time: '01:00 PM',
    fee: 32.0,
    status: AdminAppointmentStatus.completed,
    rating: 5.0,
  );

  group('AdminAppointmentCard Widget Tests', () {
    testWidgets('displays patient name, doctor name, and upcoming actions', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          AdminAppointmentCard(
            appointment: tUpcomingAdminApt,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Maya Patel'), findsOneWidget);
      expect(find.text('Dr. Fillerup Grab • Medicine Specialist'), findsOneWidget);
      expect(find.text('Upcoming'), findsOneWidget);
      expect(find.text('Mark as Completed'), findsOneWidget);
      expect(find.text('Cancel Appointment'), findsOneWidget);
    });

    testWidgets('triggers onComplete and onCancel callbacks on button taps', (tester) async {
      bool completeTapped = false;
      bool cancelTapped = false;

      await tester.pumpWidget(
        createTestWidget(
          AdminAppointmentCard(
            appointment: tUpcomingAdminApt,
            onTap: () {},
            onComplete: () {
              completeTapped = true;
            },
            onCancel: () {
              cancelTapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('Mark as Completed'));
      await tester.pump();
      expect(completeTapped, isTrue);

      await tester.tap(find.text('Cancel Appointment'));
      await tester.pump();
      expect(cancelTapped, isTrue);
    });

    testWidgets('completed appointment does not display action buttons (Edge Case)', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          AdminAppointmentCard(
            appointment: tCompletedAdminApt,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Mark as Completed'), findsNothing);
      expect(find.text('Cancel Appointment'), findsNothing);
    });

    testWidgets('tapping card invokes onTap callback', (tester) async {
      bool cardTapped = false;

      await tester.pumpWidget(
        createTestWidget(
          AdminAppointmentCard(
            appointment: tUpcomingAdminApt,
            onTap: () {
              cardTapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('Maya Patel'));
      await tester.pump();

      expect(cardTapped, isTrue);
    });
  });
}

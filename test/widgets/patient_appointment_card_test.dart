import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/features/patient/appointments/data/models/patient_appointment_model.dart';
import 'package:doctor_hunt/features/patient/appointments/presentation/widgets/patient_appointment_card.dart';

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

  const tUpcomingAppointment = PatientAppointmentModel(
    id: 'apt_test_1',
    doctorId: 'doc_1',
    doctorName: 'Dr. Fillerup Grab',
    doctorSpecialty: 'Medicine Specialist',
    date: '10 Nov 2026',
    time: '10:00 AM',
    fee: 30.0,
    status: PatientAppointmentStatus.upcoming,
  );

  const tCompletedAppointment = PatientAppointmentModel(
    id: 'apt_test_2',
    doctorId: 'doc_2',
    doctorName: 'Dr. Shruti Kedia',
    doctorSpecialty: 'Specialist Dentist',
    date: '01 Nov 2026',
    time: '02:00 PM',
    fee: 32.0,
    status: PatientAppointmentStatus.completed,
    isRated: false,
  );

  const tRatedAppointment = PatientAppointmentModel(
    id: 'apt_test_3',
    doctorId: 'doc_2',
    doctorName: 'Dr. Shruti Kedia',
    doctorSpecialty: 'Specialist Dentist',
    date: '01 Nov 2026',
    time: '02:00 PM',
    fee: 32.0,
    status: PatientAppointmentStatus.completed,
    isRated: true,
    rating: 5.0,
    userRating: 5.0,
  );

  const tCancelledAppointment = PatientAppointmentModel(
    id: 'apt_test_4',
    doctorId: 'doc_3',
    doctorName: 'Dr. Ananya Shah',
    doctorSpecialty: 'Specialist Cardiologist',
    date: '25 Oct 2026',
    time: '11:00 AM',
    fee: 28.0,
    status: PatientAppointmentStatus.cancelled,
  );

  group('PatientAppointmentCard Widget Tests', () {
    testWidgets('displays doctor information and status badge for upcoming appointment', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          PatientAppointmentCard(
            appointment: tUpcomingAppointment,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Dr. Fillerup Grab'), findsOneWidget);
      expect(find.text('Medicine Specialist'), findsOneWidget);
      expect(find.text('Upcoming'), findsOneWidget);
      expect(find.text('Cancel Appointment'), findsOneWidget);
      expect(find.text('View Details'), findsOneWidget);
    });

    testWidgets('triggers onCancel callback when Cancel Appointment is tapped', (tester) async {
      bool cancelTapped = false;

      await tester.pumpWidget(
        createTestWidget(
          PatientAppointmentCard(
            appointment: tUpcomingAppointment,
            onTap: () {},
            onCancel: () {
              cancelTapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('Cancel Appointment'));
      await tester.pump();

      expect(cancelTapped, isTrue);
    });

    testWidgets('completed appointment shows Rate Doctor button when unrated', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          PatientAppointmentCard(
            appointment: tCompletedAppointment,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Rate Doctor'), findsOneWidget);
      expect(find.text('Cancel Appointment'), findsNothing);
    });

    testWidgets('completed appointment shows disabled "Rated" button when already rated (Edge Case)', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          PatientAppointmentCard(
            appointment: tRatedAppointment,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Rated'), findsOneWidget);
    });

    testWidgets('cancelled appointment displays Cancelled badge and hides cancel button', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          PatientAppointmentCard(
            appointment: tCancelledAppointment,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Cancelled'), findsOneWidget);
      expect(find.text('Cancel Appointment'), findsNothing);
      expect(find.text('View Details'), findsOneWidget);
    });

    testWidgets('tapping appointment card invokes onTap callback', (tester) async {
      bool cardTapped = false;

      await tester.pumpWidget(
        createTestWidget(
          PatientAppointmentCard(
            appointment: tUpcomingAppointment,
            onTap: () {
              cardTapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('Dr. Fillerup Grab'));
      await tester.pump();

      expect(cardTapped, isTrue);
    });
  });
}


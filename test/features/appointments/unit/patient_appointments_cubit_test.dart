import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doctor_hunt/features/patient/appointments/data/models/patient_appointment_model.dart';
import 'package:doctor_hunt/features/patient/appointments/data/repo/patient_appointments_repository.dart';
import 'package:doctor_hunt/features/patient/appointments/presentation/controllers/patient_appointments_cubit.dart';
import 'package:doctor_hunt/features/patient/appointments/presentation/controllers/patient_appointments_state.dart';

class MockPatientAppointmentsRepository extends Mock implements PatientAppointmentsRepository {}

void main() {
  late PatientAppointmentsCubit cubit;
  late MockPatientAppointmentsRepository mockRepository;

  const tUpcomingApt = PatientAppointmentModel(
    id: 'apt_u1',
    doctorId: 'doc_1',
    doctorName: 'Dr. Fillerup Grab',
    doctorSpecialty: 'Medicine Specialist',
    date: '10 Nov 2026',
    time: '10:00 AM',
    fee: 30.0,
    status: PatientAppointmentStatus.upcoming,
  );

  const tCompletedApt = PatientAppointmentModel(
    id: 'apt_c1',
    doctorId: 'doc_2',
    doctorName: 'Dr. Shruti Kedia',
    doctorSpecialty: 'Specialist Dentist',
    date: '01 Nov 2026',
    time: '02:00 PM',
    fee: 32.0,
    status: PatientAppointmentStatus.completed,
    rating: 5.0,
    userRating: 5.0,
    isRated: true,
  );

  const tCancelledApt = PatientAppointmentModel(
    id: 'apt_x1',
    doctorId: 'doc_3',
    doctorName: 'Dr. Ananya Shah',
    doctorSpecialty: 'Specialist Cardiologist',
    date: '25 Oct 2026',
    time: '11:00 AM',
    fee: 28.0,
    status: PatientAppointmentStatus.cancelled,
  );

  setUpAll(() {
    registerFallbackValue(tUpcomingApt);
  });

  setUp(() {
    mockRepository = MockPatientAppointmentsRepository();
    cubit = PatientAppointmentsCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('PatientAppointmentsState - Getters & Filtering Logic', () {
    test('filters upcoming, completed, and cancelled correctly', () {
      final state = PatientAppointmentsState(
        allAppointments: [tUpcomingApt, tCompletedApt, tCancelledApt],
      );

      expect(state.upcomingAppointments, [tUpcomingApt]);
      expect(state.completedAppointments, [tCompletedApt]);
      expect(state.cancelledAppointments, [tCancelledApt]);
    });

    test('currentTabAppointments reflects the active selectedTab', () {
      final state = PatientAppointmentsState(
        allAppointments: [tUpcomingApt, tCompletedApt, tCancelledApt],
        selectedTab: PatientAppointmentStatus.upcoming,
      );

      expect(state.currentTabAppointments, [tUpcomingApt]);

      final completedTabState = state.copyWith(selectedTab: PatientAppointmentStatus.completed);
      expect(completedTabState.currentTabAppointments, [tCompletedApt]);

      final cancelledTabState = state.copyWith(selectedTab: PatientAppointmentStatus.cancelled);
      expect(cancelledTabState.currentTabAppointments, [tCancelledApt]);
    });

    test('edge case: empty appointments returns empty list for all tabs', () {
      const state = PatientAppointmentsState(allAppointments: []);

      expect(state.upcomingAppointments, isEmpty);
      expect(state.completedAppointments, isEmpty);
      expect(state.cancelledAppointments, isEmpty);
      expect(state.currentTabAppointments, isEmpty);
    });

    test('props check ensures equality comparison handles all fields', () {
      const s1 = PatientAppointmentsState(isLoading: false);
      const s2 = PatientAppointmentsState(isLoading: false);
      const s3 = PatientAppointmentsState(isLoading: true);

      expect(s1, equals(s2));
      expect(s1 == s3, isFalse);
    });
  });

  group('PatientAppointmentsCubit - loadAppointments', () {
    test('happy path: emits [isLoading: true, allAppointments with isLoading: false]', () async {
      when(() => mockRepository.getAppointments())
          .thenAnswer((_) async => [tUpcomingApt, tCompletedApt]);

      final expectedStates = [
        const PatientAppointmentsState(isLoading: true),
        const PatientAppointmentsState(
          allAppointments: [tUpcomingApt, tCompletedApt],
          isLoading: false,
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadAppointments();
      verify(() => mockRepository.getAppointments()).called(1);
    });

    test('edge case: repository exception emits [isLoading: true, isLoading: false with errorMessage]', () async {
      when(() => mockRepository.getAppointments())
          .thenThrow(Exception('Failed to fetch patient appointments'));

      final expectedStates = [
        const PatientAppointmentsState(isLoading: true),
        const PatientAppointmentsState(
          isLoading: false,
          errorMessage: 'Exception: Failed to fetch patient appointments',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadAppointments();
    });
  });

  group('PatientAppointmentsCubit - setSelectedTab', () {
    test('switches tab without altering loaded appointments', () async {
      when(() => mockRepository.getAppointments())
          .thenAnswer((_) async => [tUpcomingApt, tCompletedApt]);

      await cubit.loadAppointments();

      cubit.setSelectedTab(PatientAppointmentStatus.completed);
      expect(cubit.state.selectedTab, PatientAppointmentStatus.completed);
      expect(cubit.state.allAppointments.length, 2);

      cubit.setSelectedTab(PatientAppointmentStatus.cancelled);
      expect(cubit.state.selectedTab, PatientAppointmentStatus.cancelled);
    });
  });

  group('PatientAppointmentsCubit - cancelAppointment', () {
    test('happy path: cancels appointment and triggers reload', () async {
      when(() => mockRepository.cancelAppointment('apt_u1'))
          .thenAnswer((_) async => {});
      when(() => mockRepository.getAppointments())
          .thenAnswer((_) async => [tCancelledApt]);

      await cubit.cancelAppointment('apt_u1');

      verify(() => mockRepository.cancelAppointment('apt_u1')).called(1);
      verify(() => mockRepository.getAppointments()).called(1);
      expect(cubit.state.allAppointments, [tCancelledApt]);
    });

    test('edge case: repository cancellation throws error and sets errorMessage', () async {
      when(() => mockRepository.cancelAppointment(any()))
          .thenThrow(Exception('Cannot cancel past appointment'));

      await cubit.cancelAppointment('apt_invalid');

      expect(cubit.state.errorMessage, contains('Cannot cancel past appointment'));
    });
  });

  group('PatientAppointmentsCubit - rateDoctor', () {
    test('happy path: submits rating with comment and reloads appointments', () async {
      when(() => mockRepository.rateDoctor(
            'apt_c1',
            4.5,
            comment: 'Great service!',
          )).thenAnswer((_) async => {});
      when(() => mockRepository.getAppointments())
          .thenAnswer((_) async => [tCompletedApt]);

      await cubit.rateDoctor('apt_c1', 4.5, comment: 'Great service!');

      verify(() => mockRepository.rateDoctor(
            'apt_c1',
            4.5,
            comment: 'Great service!',
          )).called(1);
      verify(() => mockRepository.getAppointments()).called(1);
    });

    test('edge case: rateDoctor fails emits error message gracefully', () async {
      when(() => mockRepository.rateDoctor(any(), any(), comment: any(named: 'comment')))
          .thenThrow(Exception('Appointment already rated'));

      await cubit.rateDoctor('apt_c1', 5.0);

      expect(cubit.state.errorMessage, contains('Appointment already rated'));
    });
  });

  group('PatientAppointmentsCubit - bookAppointment', () {
    test('happy path: books new appointment and reloads appointments', () async {
      when(() => mockRepository.bookAppointment(tUpcomingApt))
          .thenAnswer((_) async => {});
      when(() => mockRepository.getAppointments())
          .thenAnswer((_) async => [tUpcomingApt]);

      await cubit.bookAppointment(tUpcomingApt);

      verify(() => mockRepository.bookAppointment(tUpcomingApt)).called(1);
      verify(() => mockRepository.getAppointments()).called(1);
      expect(cubit.state.allAppointments, [tUpcomingApt]);
    });

    test('edge case: bookAppointment fails emits errorMessage', () async {
      when(() => mockRepository.bookAppointment(any()))
          .thenThrow(Exception('Doctor is not available at this slot'));

      await cubit.bookAppointment(tUpcomingApt);

      expect(cubit.state.errorMessage, contains('Doctor is not available at this slot'));
    });
  });
}


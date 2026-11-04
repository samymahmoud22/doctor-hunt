import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_appointment_model.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';
import 'package:doctor_hunt/features/admin/presentation/controllers/admin_appointments_cubit.dart';
import 'package:doctor_hunt/features/admin/presentation/controllers/admin_appointments_state.dart';

class MockAdminRepository extends Mock implements AdminRepository {}

void main() {
  late AdminAppointmentsCubit cubit;
  late MockAdminRepository mockRepository;

  const tApt1 = AdminAppointmentModel(
    id: 'apt_1',
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

  const tApt2 = AdminAppointmentModel(
    id: 'apt_2',
    patientName: 'John Doe',
    patientEmail: 'john@example.com',
    doctorId: 'doc_2',
    doctorName: 'Dr. Shruti Kedia',
    doctorSpecialty: 'Specialist Dentist',
    date: '10 Nov 2026',
    time: '01:00 PM',
    fee: 32.0,
    status: AdminAppointmentStatus.completed,
  );

  const tApt3 = AdminAppointmentModel(
    id: 'apt_3',
    patientName: 'Alice Green',
    patientEmail: 'alice@example.com',
    doctorId: 'doc_3',
    doctorName: 'Dr. Ananya Shah',
    doctorSpecialty: 'Specialist Cardiologist',
    date: '05 Nov 2026',
    time: '03:00 PM',
    fee: 28.0,
    status: AdminAppointmentStatus.cancelled,
  );

  setUpAll(() {
    registerFallbackValue(AdminAppointmentStatus.upcoming);
  });

  setUp(() {
    mockRepository = MockAdminRepository();
    cubit = AdminAppointmentsCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('AdminAppointmentsState - Tab filtering and edge cases', () {
    final state = AdminAppointmentsState(
      allAppointments: [tApt1, tApt2, tApt3],
    );

    test('default tab is "all" and returns all appointments', () {
      expect(state.selectedTab, AdminAppointmentTab.all);
      expect(state.currentTabAppointments.length, 3);
    });

    test('filters tabs correctly when switching selectedTab', () {
      expect(state.upcomingAppointments, [tApt1]);
      expect(state.completedAppointments, [tApt2]);
      expect(state.cancelledAppointments, [tApt3]);

      final upcomingTab = state.copyWith(selectedTab: AdminAppointmentTab.upcoming);
      expect(upcomingTab.currentTabAppointments, [tApt1]);

      final completedTab = state.copyWith(selectedTab: AdminAppointmentTab.completed);
      expect(completedTab.currentTabAppointments, [tApt2]);

      final cancelledTab = state.copyWith(selectedTab: AdminAppointmentTab.cancelled);
      expect(cancelledTab.currentTabAppointments, [tApt3]);
    });

    test('edge case: empty appointments returns empty list across all tab queries', () {
      const emptyState = AdminAppointmentsState();
      expect(emptyState.currentTabAppointments, isEmpty);
      expect(emptyState.upcomingAppointments, isEmpty);
      expect(emptyState.completedAppointments, isEmpty);
      expect(emptyState.cancelledAppointments, isEmpty);
    });
  });

  group('AdminAppointmentsCubit - loadAppointments', () {
    test('happy path: emits [loading, allAppointments]', () async {
      when(() => mockRepository.getAppointments())
          .thenAnswer((_) async => [tApt1, tApt2]);

      final expectedStates = [
        const AdminAppointmentsState(isLoading: true),
        const AdminAppointmentsState(
          allAppointments: [tApt1, tApt2],
          isLoading: false,
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadAppointments();
      verify(() => mockRepository.getAppointments()).called(1);
    });

    test('edge case: repository error emits failure message with isLoading: false', () async {
      when(() => mockRepository.getAppointments())
          .thenThrow(Exception('Supabase connection lost'));

      final expectedStates = [
        const AdminAppointmentsState(isLoading: true),
        const AdminAppointmentsState(
          isLoading: false,
          errorMessage: 'Exception: Supabase connection lost',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadAppointments();
    });
  });

  group('AdminAppointmentsCubit - markAsCompleted and cancelAppointment', () {
    test('happy path: markAsCompleted updates status and refreshes appointments', () async {
      when(() => mockRepository.updateAppointmentStatus('apt_1', AdminAppointmentStatus.completed))
          .thenAnswer((_) async => {});
      when(() => mockRepository.getAppointments())
          .thenAnswer((_) async => [tApt2]);

      await cubit.markAsCompleted('apt_1');

      verify(() => mockRepository.updateAppointmentStatus('apt_1', AdminAppointmentStatus.completed)).called(1);
      verify(() => mockRepository.getAppointments()).called(1);
      expect(cubit.state.allAppointments, [tApt2]);
    });

    test('edge case: markAsCompleted error caught and emits errorMessage', () async {
      when(() => mockRepository.updateAppointmentStatus(any(), any()))
          .thenThrow(Exception('Update status error'));

      await cubit.markAsCompleted('apt_error');

      expect(cubit.state.errorMessage, contains('Update status error'));
    });

    test('happy path: cancelAppointment updates status to cancelled and refreshes', () async {
      when(() => mockRepository.updateAppointmentStatus('apt_1', AdminAppointmentStatus.cancelled))
          .thenAnswer((_) async => {});
      when(() => mockRepository.getAppointments())
          .thenAnswer((_) async => [tApt3]);

      await cubit.cancelAppointment('apt_1');

      verify(() => mockRepository.updateAppointmentStatus('apt_1', AdminAppointmentStatus.cancelled)).called(1);
      verify(() => mockRepository.getAppointments()).called(1);
      expect(cubit.state.allAppointments, [tApt3]);
    });

    test('edge case: cancelAppointment error sets errorMessage', () async {
      when(() => mockRepository.updateAppointmentStatus(any(), any()))
          .thenThrow(Exception('Failed to cancel appointment'));

      await cubit.cancelAppointment('apt_999');

      expect(cubit.state.errorMessage, contains('Failed to cancel appointment'));
    });
  });
}


import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:doctor_hunt/core/errors/app_exceptions.dart';
import 'package:doctor_hunt/core/utils/app_logger.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_appointment_model.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLogger Tests', () {
    test('logger methods execute safely without uncaught exceptions', () {
      expect(() => AppLogger.debug('test debug'), returnsNormally);
      expect(() => AppLogger.info('test info'), returnsNormally);
      expect(() => AppLogger.warning('test warning', Exception('warning ex')), returnsNormally);
      expect(() => AppLogger.error('test error', Exception('error ex'), StackTrace.current), returnsNormally);
    });
  });

  group('AppExceptions Tests', () {
    test('ServerException has default and custom messages', () {
      const defaultEx = ServerException();
      expect(defaultEx.toString(), contains('server error'));

      const customEx = ServerException('Custom database failure');
      expect(customEx.toString(), 'Custom database failure');
    });

    test('NetworkException has default and custom messages', () {
      const defaultEx = NetworkException();
      expect(defaultEx.toString(), contains('internet connection'));

      const customEx = NetworkException('Connection timeout');
      expect(customEx.toString(), 'Connection timeout');
    });
  });

  group('AdminRepository - Error Propagation & No Fake Static Fallback', () {
    late MockSupabaseClient mockClient;
    late AdminRepository repository;

    setUp(() {
      mockClient = MockSupabaseClient();
      repository = AdminRepository(client: mockClient);
    });

    test('getDoctors rethrows ServerException when backend query fails with PostgrestException', () async {
      when(() => mockClient.from('doctors')).thenThrow(
        const PostgrestException(message: 'Database connection failed', code: '500'),
      );

      expect(
        () => repository.getDoctors(),
        throwsA(isA<ServerException>()),
      );
    });

    test('getAppointments rethrows ServerException when backend query fails', () async {
      when(() => mockClient.from('appointments')).thenThrow(
        const PostgrestException(message: 'Table does not exist', code: '404'),
      );

      expect(
        () => repository.getAppointments(),
        throwsA(isA<ServerException>()),
      );
    });

    test('addDoctor rethrows ServerException when insert query fails', () async {
      when(() => mockClient.from('doctors')).thenThrow(
        const PostgrestException(message: 'Row level security violation', code: '403'),
      );

      const doctor = AdminDoctorModel(
        id: 'new_doc_test',
        name: 'Dr. Test Failure',
        specialty: 'Dentist',
        consultationFee: 50.0,
        isActive: true,
      );

      expect(
        () => repository.addDoctor(doctor),
        throwsA(isA<ServerException>()),
      );
    });

    test('deleteDoctor rethrows ServerException when delete query fails', () async {
      when(() => mockClient.from('doctors')).thenThrow(
        const PostgrestException(message: 'Foreign key constraint violation', code: '409'),
      );

      expect(
        () => repository.deleteDoctor('doc_1'),
        throwsA(isA<ServerException>()),
      );
    });

    test('addAppointment rethrows ServerException when backend insert fails with network error', () async {
      when(() => mockClient.from('appointments')).thenThrow(
        const PostgrestException(message: 'Connection timeout to backend', code: '504'),
      );

      const newApt = AdminAppointmentModel(
        id: 'apt_network_fail',
        patientName: 'Jane',
        patientEmail: 'jane@test.com',
        doctorId: 'doc_1',
        doctorName: 'Dr. Test',
        doctorSpecialty: 'Cardiology',
        date: '25 Dec 2026',
        time: '11:00 AM',
        fee: 30.0,
        status: AdminAppointmentStatus.upcoming,
      );

      expect(
        () => repository.addAppointment(newApt),
        throwsA(isA<ServerException>()),
      );
    });
  });
}


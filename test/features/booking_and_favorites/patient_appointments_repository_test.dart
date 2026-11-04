import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_appointment_model.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';
import 'package:doctor_hunt/features/patient/appointments/data/models/patient_appointment_model.dart';
import 'package:doctor_hunt/features/patient/appointments/data/repo/patient_appointments_repository.dart';
import 'package:doctor_hunt/features/patient/doctors/data/models/doctor_review_model.dart';

class MockAdminRepository extends Mock implements AdminRepository {}
class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockUser extends Mock implements User {}

void main() {
  late PatientAppointmentsRepository repository;
  late MockAdminRepository mockAdminRepo;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockAuth;
  late MockUser mockUser;

  const tAdminApt1 = AdminAppointmentModel(
    id: 'apt_1',
    patientId: 'patient_123',
    patientName: 'Sarah',
    patientEmail: 'sarah@example.com',
    doctorId: 'doc_1',
    doctorName: 'Dr. Fillerup Grab',
    doctorSpecialty: 'Medicine Specialist',
    date: '10 Nov 2026',
    time: '10:00 AM',
    fee: 30.0,
    clinicLocation: 'DoctorHunt HQ Clinic • 24 Garden Avenue',
    status: AdminAppointmentStatus.upcoming,
  );

  const tAdminAptOther = AdminAppointmentModel(
    id: 'apt_2',
    patientId: 'patient_other_456',
    patientName: 'Other Person',
    patientEmail: 'other@example.com',
    doctorId: 'doc_2',
    doctorName: 'Dr. Shruti Kedia',
    doctorSpecialty: 'Specialist Dentist',
    date: '12 Nov 2026',
    time: '02:00 PM',
    fee: 32.0,
    clinicLocation: 'DoctorHunt HQ Clinic • 24 Garden Avenue',
    status: AdminAppointmentStatus.completed,
    rating: 4.8,
    reviewText: 'Great dentist',
  );

  const tAdminAptNullPatient = AdminAppointmentModel(
    id: 'apt_3',
    patientId: null,
    patientName: 'Anonymous',
    patientEmail: 'anon@example.com',
    doctorId: null, // edge case: null doctorId
    doctorName: 'Dr. Ananya Shah',
    doctorSpecialty: 'Specialist Cardiologist',
    date: '15 Nov 2026',
    time: '04:00 PM',
    fee: 28.0,
    clinicLocation: 'DoctorHunt HQ Clinic • 24 Garden Avenue',
    status: AdminAppointmentStatus.cancelled,
  );

  setUpAll(() {
    registerFallbackValue(tAdminApt1);
    registerFallbackValue(AdminAppointmentStatus.upcoming);
    registerFallbackValue(DoctorReviewModel(
      id: 'rev_fallback',
      appointmentId: 'apt_1',
      patientId: 'pat_1',
      doctorId: 'doc_1',
      rating: 5.0,
      createdAt: DateTime.now(),
    ));
  });

  setUp(() {
    mockAdminRepo = MockAdminRepository();
    mockSupabaseClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockUser = MockUser();

    when(() => mockSupabaseClient.auth).thenReturn(mockAuth);
    when(() => mockAdminRepo.centralLocation).thenReturn('DoctorHunt HQ Clinic • 24 Garden Avenue');

    repository = PatientAppointmentsRepository(
      adminRepository: mockAdminRepo,
      client: mockSupabaseClient,
    );
  });

  group('PatientAppointmentsRepository - getAppointments & Filtering', () {
    test('filters appointments matching logged in user ID and null patientId', () async {
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.id).thenReturn('patient_123');

      when(() => mockAdminRepo.getAppointments())
          .thenAnswer((_) async => [tAdminApt1, tAdminAptOther, tAdminAptNullPatient]);

      final results = await repository.getAppointments();

      // Should include tAdminApt1 and tAdminAptNullPatient, but exclude tAdminAptOther
      expect(results.length, 2);
      expect(results.any((a) => a.id == 'apt_1'), isTrue);
      expect(results.any((a) => a.id == 'apt_3'), isTrue);
      expect(results.any((a) => a.id == 'apt_2'), isFalse);
    });

    test('edge case: unauthenticated user (currentUser == null) returns all appointments', () async {
      when(() => mockAuth.currentUser).thenReturn(null);
      when(() => mockAdminRepo.getAppointments())
          .thenAnswer((_) async => [tAdminApt1, tAdminAptOther, tAdminAptNullPatient]);

      final results = await repository.getAppointments();

      expect(results.length, 3);
    });

    test('edge case: null doctorId maps safely to fallback "doc_1"', () async {
      when(() => mockAuth.currentUser).thenReturn(null);
      when(() => mockAdminRepo.getAppointments())
          .thenAnswer((_) async => [tAdminAptNullPatient]);

      final results = await repository.getAppointments();

      expect(results.first.doctorId, 'doc_1');
    });

    test('maps status and rating fields accurately', () async {
      when(() => mockAuth.currentUser).thenReturn(null);
      when(() => mockAdminRepo.getAppointments())
          .thenAnswer((_) async => [tAdminApt1, tAdminAptOther, tAdminAptNullPatient]);

      final results = await repository.getAppointments();

      final upcoming = results.firstWhere((a) => a.id == 'apt_1');
      expect(upcoming.status, PatientAppointmentStatus.upcoming);
      expect(upcoming.isRated, isFalse);

      final completed = results.firstWhere((a) => a.id == 'apt_2');
      expect(completed.status, PatientAppointmentStatus.completed);
      expect(completed.isRated, isTrue);
      expect(completed.rating, 4.8);
      expect(completed.reviewComment, 'Great dentist');

      final cancelled = results.firstWhere((a) => a.id == 'apt_3');
      expect(cancelled.status, PatientAppointmentStatus.cancelled);
    });
  });

  group('PatientAppointmentsRepository - bookAppointment (Edge Cases)', () {
    test('happy path: books appointment with user metadata and upcoming status', () async {
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.id).thenReturn('patient_123');
      when(() => mockUser.email).thenReturn('sarah@example.com');
      when(() => mockUser.userMetadata).thenReturn({'full_name': 'Sarah Johnson'});

      when(() => mockAdminRepo.addAppointment(any())).thenAnswer((_) async => {});

      const newPatientApt = PatientAppointmentModel(
        id: 'new_apt_1',
        doctorId: 'doc_1',
        doctorName: 'Dr. Fillerup Grab',
        doctorSpecialty: 'Medicine Specialist',
        date: '20 Nov 2026',
        time: '11:00 AM',
        fee: 30.0,
        clinicLocation: 'Custom Location',
        status: PatientAppointmentStatus.upcoming,
      );

      await repository.bookAppointment(newPatientApt);

      final captured = verify(() => mockAdminRepo.addAppointment(captureAny())).captured.first as AdminAppointmentModel;
      expect(captured.id, 'new_apt_1');
      expect(captured.patientId, 'patient_123');
      expect(captured.patientName, 'Sarah Johnson');
      expect(captured.patientEmail, 'sarah@example.com');
      expect(captured.clinicLocation, 'Custom Location');
      expect(captured.status, AdminAppointmentStatus.upcoming);
    });

    test('edge case: unauthenticated guest user falls back to default patient credentials and centralLocation', () async {
      when(() => mockAuth.currentUser).thenReturn(null);
      when(() => mockAdminRepo.addAppointment(any())).thenAnswer((_) async => {});

      const newPatientApt = PatientAppointmentModel(
        id: 'new_apt_guest',
        doctorId: 'doc_2',
        doctorName: 'Dr. Shruti Kedia',
        doctorSpecialty: 'Specialist Dentist',
        date: '22 Nov 2026',
        time: '02:00 PM',
        fee: 32.0,
        clinicLocation: '', // empty to test central location fallback
        status: PatientAppointmentStatus.upcoming,
      );

      await repository.bookAppointment(newPatientApt);

      final captured = verify(() => mockAdminRepo.addAppointment(captureAny())).captured.first as AdminAppointmentModel;
      expect(captured.patientName, 'Patient');
      expect(captured.patientEmail, 'patient@doctorhunt.com');
      expect(captured.clinicLocation, 'DoctorHunt HQ Clinic • 24 Garden Avenue');
      expect(captured.patientId, isNull);
    });
  });

  group('PatientAppointmentsRepository - cancelAppointment & rateDoctor', () {
    test('cancelAppointment delegates to adminRepository with cancelled status', () async {
      when(() => mockAdminRepo.updateAppointmentStatus('apt_1', AdminAppointmentStatus.cancelled))
          .thenAnswer((_) async => {});

      await repository.cancelAppointment('apt_1');

      verify(() => mockAdminRepo.updateAppointmentStatus('apt_1', AdminAppointmentStatus.cancelled)).called(1);
    });

    test('rateDoctor looks up appointment & doctor, and adds doctor review', () async {
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.id).thenReturn('patient_123');

      when(() => mockAdminRepo.getAppointments()).thenAnswer((_) async => [tAdminApt1]);
      const mockDoc = AdminDoctorModel(
        id: 'doc_1',
        name: 'Dr. Fillerup Grab',
        specialty: 'Medicine Specialist',
      );
      when(() => mockAdminRepo.getDoctors()).thenAnswer((_) async => [mockDoc]);
      when(() => mockAdminRepo.addDoctorReview(any())).thenAnswer((_) async => {});

      await repository.rateDoctor('apt_1', 4.5, comment: 'Very attentive');

      final capturedReview = verify(() => mockAdminRepo.addDoctorReview(captureAny())).captured.first as DoctorReviewModel;
      expect(capturedReview.appointmentId, 'apt_1');
      expect(capturedReview.doctorId, 'doc_1');
      expect(capturedReview.patientId, 'patient_123');
      expect(capturedReview.rating, 4.5);
      expect(capturedReview.comment, 'Very attentive');
    });
  });
}


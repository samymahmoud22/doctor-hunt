import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:doctor_hunt/core/errors/booking_exceptions.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_appointment_model.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';
import 'package:doctor_hunt/features/patient/appointments/data/models/patient_appointment_model.dart';
import 'package:doctor_hunt/features/patient/appointments/data/repo/patient_appointments_repository.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  late AdminRepository adminRepository;
  late PatientAppointmentsRepository patientRepository;
  late MockSupabaseClient mockClient;

  setUp(() {
    mockClient = MockSupabaseClient();
    adminRepository = AdminRepository(client: mockClient);
    patientRepository = PatientAppointmentsRepository(
      adminRepository: adminRepository,
      client: mockClient,
    );
  });

  group('Date and Time Normalization Helpers', () {
    test('normalizeDate normalizes single-digit and double-digit day formats', () {
      expect(AdminRepository.normalizeDate('02 Oct 2026'), '2 oct 2026');
      expect(AdminRepository.normalizeDate('2 Oct 2026'), '2 oct 2026');
      expect(AdminRepository.normalizeDate('  08   Nov   2026  '), '8 nov 2026');
      expect(AdminRepository.normalizeDate('21 Sep 2026'), '21 sep 2026');
    });

    test('normalizeTime normalizes leading zeros in time strings', () {
      expect(AdminRepository.normalizeTime('02:00 PM'), '2:00 PM');
      expect(AdminRepository.normalizeTime('2:00 PM'), '2:00 PM');
      expect(AdminRepository.normalizeTime('09:30 AM'), '9:30 AM');
      expect(AdminRepository.normalizeTime('10:00 AM'), '10:00 AM');
      expect(AdminRepository.normalizeTime('  01:00 PM  '), '1:00 PM');
    });
  });

  group('Slot Availability & Conflict Detection', () {
    test('isSlotBooked returns true for existing upcoming appointment', () async {
      // apt_1 is: Dr. Ananya Shah (doc_3), date: '02 Oct 2026', time: '10:30 AM', status: upcoming
      expect(
        adminRepository.isSlotBooked(
          doctorId: 'doc_3',
          date: '02 Oct 2026',
          time: '10:30 AM',
        ),
        isTrue,
      );

      // Verify date normalization match (2 Oct 2026 vs 02 Oct 2026)
      expect(
        adminRepository.isSlotBooked(
          doctorId: 'doc_3',
          date: '2 Oct 2026',
          time: '10:30 AM',
        ),
        isTrue,
      );
    });

    test('isSlotBooked returns false when appointment at that slot was cancelled (Edge Case)', () async {
      // apt_5 is: Dr. Luke Whitesell (doc_5), date: '30 Aug 2026', time: '11:00 AM', status: cancelled
      expect(
        adminRepository.isSlotBooked(
          doctorId: 'doc_5',
          date: '30 Aug 2026',
          time: '11:00 AM',
        ),
        isFalse,
      );
    });

    test('isSlotBooked returns false for different doctor or unbooked time slot', () {
      expect(
        adminRepository.isSlotBooked(
          doctorId: 'doc_1', // different doctor
          date: '02 Oct 2026',
          time: '10:30 AM',
        ),
        isFalse,
      );

      expect(
        adminRepository.isSlotBooked(
          doctorId: 'doc_3',
          date: '02 Oct 2026',
          time: '04:00 PM', // different time
        ),
        isFalse,
      );
    });

    test('getBookedSlotsForDoctor returns normalized set of active booked times', () {
      final booked = adminRepository.getBookedSlotsForDoctor(
        doctorId: 'doc_2',
        date: '08 Oct 2026',
      );

      // apt_2: '02:00 PM' -> normalized to '2:00 PM'
      expect(booked, contains('2:00 PM'));
      expect(booked.contains('10:00 AM'), isFalse);
    });
  });

  group('Double-Booking Prevention (Repository Validation & Edge Cases)', () {
    const tAppointment = AdminAppointmentModel(
      id: 'apt_test_double_book',
      patientName: 'Alice',
      patientEmail: 'alice@test.com',
      doctorId: 'doc_1',
      doctorName: 'Dr. Fillerup Grab',
      doctorSpecialty: 'Medicine Specialist',
      date: '15 Dec 2026',
      time: '02:00 PM',
      fee: 28.0,
      clinicLocation: 'DoctorHunt HQ Clinic',
      status: AdminAppointmentStatus.upcoming,
    );

    test('happy path: first booking of available slot succeeds', () async {
      expect(
        adminRepository.isSlotBooked(
          doctorId: 'doc_1',
          date: '15 Dec 2026',
          time: '02:00 PM',
        ),
        isFalse,
      );

      await adminRepository.addAppointment(tAppointment);

      expect(
        adminRepository.isSlotBooked(
          doctorId: 'doc_1',
          date: '15 Dec 2026',
          time: '02:00 PM',
        ),
        isTrue,
      );
    });

    test('edge case: second user attempting to book the SAME doctor, date, and time is REJECTED', () async {
      // First booking succeeds
      await adminRepository.addAppointment(tAppointment);

      // Second booking attempt by a different patient for the same doctor and slot
      const conflictingAppointment = AdminAppointmentModel(
        id: 'apt_conflicting_patient',
        patientName: 'Bob (Different User)',
        patientEmail: 'bob@test.com',
        doctorId: 'doc_1',
        doctorName: 'Dr. Fillerup Grab',
        doctorSpecialty: 'Medicine Specialist',
        date: '15 Dec 2026',
        time: '2:00 PM', // Note: without leading zero, normalization should catch it!
        fee: 28.0,
        clinicLocation: 'DoctorHunt HQ Clinic',
        status: AdminAppointmentStatus.upcoming,
      );

      expect(
        () => adminRepository.addAppointment(conflictingAppointment),
        throwsA(isA<AlreadyBookedException>()),
      );
    });

    test('edge case: cancelled appointment frees up the slot and allows re-booking', () async {
      await adminRepository.addAppointment(tAppointment);
      expect(
        adminRepository.isSlotBooked(
          doctorId: 'doc_1',
          date: '15 Dec 2026',
          time: '02:00 PM',
        ),
        isTrue,
      );

      // Cancel the appointment
      await adminRepository.updateAppointmentStatus(
        tAppointment.id,
        AdminAppointmentStatus.cancelled,
      );

      expect(
        adminRepository.isSlotBooked(
          doctorId: 'doc_1',
          date: '15 Dec 2026',
          time: '02:00 PM',
        ),
        isFalse,
      );

      // Re-booking the same slot now succeeds!
      const newBooking = AdminAppointmentModel(
        id: 'apt_rebooked',
        patientName: 'Charlie',
        patientEmail: 'charlie@test.com',
        doctorId: 'doc_1',
        doctorName: 'Dr. Fillerup Grab',
        doctorSpecialty: 'Medicine Specialist',
        date: '15 Dec 2026',
        time: '02:00 PM',
        fee: 28.0,
        clinicLocation: 'DoctorHunt HQ Clinic',
        status: AdminAppointmentStatus.upcoming,
      );

      await adminRepository.addAppointment(newBooking);

      expect(
        adminRepository.isSlotBooked(
          doctorId: 'doc_1',
          date: '15 Dec 2026',
          time: '02:00 PM',
        ),
        isTrue,
      );
    });

    test('PatientAppointmentsRepository propagates AlreadyBookedException when booking duplicate slot', () async {
      const patientApt1 = PatientAppointmentModel(
        id: 'pat_apt_1',
        doctorId: 'doc_2',
        doctorName: 'Dr. Shruti Kedia',
        doctorSpecialty: 'Specialist Dentist',
        date: '18 Dec 2026',
        time: '03:00 PM',
        fee: 32.0,
        status: PatientAppointmentStatus.upcoming,
      );

      const patientApt2 = PatientAppointmentModel(
        id: 'pat_apt_2',
        doctorId: 'doc_2',
        doctorName: 'Dr. Shruti Kedia',
        doctorSpecialty: 'Specialist Dentist',
        date: '18 Dec 2026',
        time: '3:00 PM',
        fee: 32.0,
        status: PatientAppointmentStatus.upcoming,
      );

      await patientRepository.bookAppointment(patientApt1);

      expect(
        () => patientRepository.bookAppointment(patientApt2),
        throwsA(isA<AlreadyBookedException>()),
      );
    });
  });
}


import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doctor_hunt/core/errors/booking_exceptions.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';
import 'package:doctor_hunt/features/patient/appointments/data/models/patient_appointment_model.dart';
import 'package:doctor_hunt/features/patient/appointments/data/repo/patient_appointments_repository.dart';
import 'package:doctor_hunt/features/patient/doctors/presentation/controllers/booking_cubit.dart';

class MockAdminRepository extends Mock implements AdminRepository {}
class MockPatientAppointmentsRepository extends Mock implements PatientAppointmentsRepository {}

void main() {
  late MockAdminRepository mockAdminRepository;
  late MockPatientAppointmentsRepository mockAppointmentsRepository;
  late BookingCubit cubit;

  final testDoctor = AdminDoctorModel(
    id: 'doc_1',
    name: 'Dr. Shruti Kedia',
    specialty: 'Dentist',
    consultationFee: 35.0,
    clinicLocation: 'Dokki, Giza',
    workingDays: const {
      'Monday': true,
      'Tuesday': true,
      'Wednesday': true,
      'Thursday': true,
      'Friday': true,
      'Saturday': true,
      'Sunday': true,
    },
  );

  setUpAll(() {
    registerFallbackValue(
      const PatientAppointmentModel(
        id: 'fallback_apt',
        doctorId: 'doc_1',
        doctorName: 'Dr. Shruti Kedia',
        doctorSpecialty: 'Dentist',
        date: '1 Nov 2026',
        time: '1:00 PM',
        fee: 35.0,
        status: PatientAppointmentStatus.upcoming,
      ),
    );
  });

  setUp(() {
    mockAdminRepository = MockAdminRepository();
    mockAppointmentsRepository = MockPatientAppointmentsRepository();

    when(() => mockAdminRepository.isFavorite('doc_1')).thenReturn(false);
    when(() => mockAdminRepository.getBookedSlotsForDoctor(
      doctorId: any(named: 'doctorId'),
      date: any(named: 'date'),
    )).thenReturn({'2:00 PM'});

    cubit = BookingCubit(
      adminRepository: mockAdminRepository,
      appointmentsRepository: mockAppointmentsRepository,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('BookingCubit - loadBookingData', () {
    test('happy path: loads doctor, generates 10 dates, selects working date and first free slot', () async {
      when(() => mockAdminRepository.getDoctors()).thenAnswer((_) async => [testDoctor]);
      when(() => mockAdminRepository.getAppointments()).thenAnswer((_) async => []);

      await cubit.loadBookingData('Dr. Shruti Kedia');

      expect(cubit.state.isLoading, false);
      expect(cubit.state.doctor, testDoctor);
      expect(cubit.state.dates.length, 10);
      expect(cubit.state.selectedDate, isNotNull);
      expect(cubit.state.selectedSlot, '1:00 PM'); // first free slot
      expect(cubit.isSlotBooked('2:00 PM'), true);
      expect(cubit.isSlotBooked('1:00 PM'), false);
    });

    test('edge case: repository error emits errorMessage', () async {
      when(() => mockAdminRepository.getDoctors()).thenThrow(Exception('Failed to fetch'));
      when(() => mockAdminRepository.getAppointments()).thenAnswer((_) async => []);

      await cubit.loadBookingData('Dr. Shruti Kedia');

      expect(cubit.state.isLoading, false);
      expect(cubit.state.errorMessage, 'Failed to fetch');
    });
  });

  group('BookingCubit - Slot Selection', () {
    setUp(() async {
      when(() => mockAdminRepository.getDoctors()).thenAnswer((_) async => [testDoctor]);
      when(() => mockAdminRepository.getAppointments()).thenAnswer((_) async => []);
      await cubit.loadBookingData('Dr. Shruti Kedia');
    });

    test('selectSlot sets selectedSlot when slot is available', () {
      cubit.selectSlot('3:00 PM');
      expect(cubit.state.selectedSlot, '3:00 PM');
    });

    test('edge case: selectSlot ignores already booked slot', () {
      cubit.selectSlot('1:00 PM');
      expect(cubit.state.selectedSlot, '1:00 PM');

      // Attempt to select booked slot
      cubit.selectSlot('2:00 PM');
      // Remains on previous slot
      expect(cubit.state.selectedSlot, '1:00 PM');
    });
  });

  group('BookingCubit - confirmBooking', () {
    setUp(() async {
      when(() => mockAdminRepository.getDoctors()).thenAnswer((_) async => [testDoctor]);
      when(() => mockAdminRepository.getAppointments()).thenAnswer((_) async => []);
      await cubit.loadBookingData('Dr. Shruti Kedia');
    });

    test('happy path: books appointment successfully and emits bookingSuccess', () async {
      when(() => mockAppointmentsRepository.isSlotBooked(
        doctorId: any(named: 'doctorId'),
        date: any(named: 'date'),
        time: any(named: 'time'),
      )).thenReturn(false);

      when(() => mockAppointmentsRepository.bookAppointment(any()))
          .thenAnswer((_) async => 'apt_new_123');

      final success = await cubit.confirmBooking();

      expect(success, true);
      expect(cubit.state.bookingSuccess, true);
      expect(cubit.state.isSubmitting, false);
      verify(() => mockAppointmentsRepository.bookAppointment(any())).called(1);
    });

    test('edge case: double booking validation prevents booking and emits error', () async {
      when(() => mockAppointmentsRepository.isSlotBooked(
        doctorId: any(named: 'doctorId'),
        date: any(named: 'date'),
        time: any(named: 'time'),
      )).thenReturn(true);

      final success = await cubit.confirmBooking();

      expect(success, false);
      expect(cubit.state.bookingSuccess, false);
      expect(cubit.state.errorMessage, contains('already been booked'));
      verifyNever(() => mockAppointmentsRepository.bookAppointment(any()));
    });

    test('edge case: backend AlreadyBookedException emits error message gracefully', () async {
      when(() => mockAppointmentsRepository.isSlotBooked(
        doctorId: any(named: 'doctorId'),
        date: any(named: 'date'),
        time: any(named: 'time'),
      )).thenReturn(false);

      when(() => mockAppointmentsRepository.bookAppointment(any()))
          .thenThrow(const AlreadyBookedException());

      final success = await cubit.confirmBooking();

      expect(success, false);
      expect(cubit.state.bookingSuccess, false);
      expect(cubit.state.errorMessage, 'This time slot has already been booked. Please choose another time.');
    });
  });
}

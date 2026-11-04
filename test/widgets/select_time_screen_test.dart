import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_appointment_model.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';
import 'package:doctor_hunt/features/patient/appointments/data/repo/patient_appointments_repository.dart';
import 'package:doctor_hunt/features/patient/doctors/presentation/screens/select_time_screen.dart';
import 'package:doctor_hunt/features/patient/doctors/presentation/controllers/booking_cubit.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  late AdminRepository adminRepository;
  late PatientAppointmentsRepository patientAppointmentsRepository;
  late MockSupabaseClient mockSupabaseClient;

  setUpAll(() {
    LocaleSettings.setLocale(AppLocale.en);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await sl.reset();
    mockSupabaseClient = MockSupabaseClient();
    adminRepository = AdminRepository(client: mockSupabaseClient);
    patientAppointmentsRepository = PatientAppointmentsRepository(
      adminRepository: adminRepository,
      client: mockSupabaseClient,
    );

    sl.registerLazySingleton<AdminRepository>(() => adminRepository);
    sl.registerLazySingleton<PatientAppointmentsRepository>(() => patientAppointmentsRepository);
    sl.registerFactory<BookingCubit>(
      () => BookingCubit(
        adminRepository: adminRepository,
        appointmentsRepository: patientAppointmentsRepository,
      ),
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  Widget createWidget(Widget child) {
    return TranslationProvider(
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('SelectTimeScreen renders doctor info and marks booked slots as Booked', (tester) async {
    // Seed an existing appointment for Dr. Shruti Kedia on their first available working date at 2:00 PM
    final doctor = adminRepository.findDoctorByName('Dr. Shruti Kedia')!;
    final now = DateTime.now();
    DateTime workingDate = now;
    const weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    for (int i = 0; i < 10; i++) {
      final d = now.add(Duration(days: i));
      final dayName = weekDays[d.weekday - 1];
      if (doctor.workingDays[dayName] == true) {
        workingDate = d;
        break;
      }
    }
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = '${workingDate.day} ${months[workingDate.month - 1]} ${workingDate.year}';

    await adminRepository.addAppointment(
      AdminAppointmentModel(
        id: 'apt_already_booked',
        patientName: 'Existing Patient',
        patientEmail: 'existing@patient.com',
        doctorId: 'doc_2',
        doctorName: 'Dr. Shruti Kedia',
        doctorSpecialty: 'Specialist Dentist',
        date: dateStr,
        time: '02:00 PM', // booked slot
        fee: 32.0,
        status: AdminAppointmentStatus.upcoming,
      ),
    );

    await tester.pumpWidget(
      createWidget(
        const SelectTimeScreen(doctorName: 'Dr. Shruti Kedia'),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Dr. Shruti Kedia'), findsOneWidget);

    // Verify 'Booked' badge is displayed for the 2:00 PM slot
    expect(find.text('Booked'), findsOneWidget);

    // Verify 11 slots are available instead of static 12
    expect(find.text('11 slots available'), findsOneWidget);
  });
}


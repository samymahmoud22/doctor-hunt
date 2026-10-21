import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:doctor_hunt/core/services/supabase_storage_service.dart';
import 'package:doctor_hunt/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/features/common/auth/data/repo/auth_repository.dart';
import 'package:doctor_hunt/features/common/auth/presentation/controller/auth_cubit.dart';
import 'package:doctor_hunt/features/common/choose_role/presentation/controller/choose_role_cubit.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';
import 'package:doctor_hunt/features/admin/presentation/controllers/admin_doctors_cubit.dart';
import 'package:doctor_hunt/features/admin/presentation/controllers/admin_appointments_cubit.dart';
import 'package:doctor_hunt/features/admin/presentation/controllers/admin_profile_cubit.dart';
import 'package:doctor_hunt/features/patient/appointments/data/repo/patient_appointments_repository.dart';
import 'package:doctor_hunt/features/patient/appointments/presentation/controllers/patient_appointments_cubit.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  sl.registerLazySingleton<SupabaseStorageService>(
    () => SupabaseStorageService(client: sl<SupabaseClient>()),
  );

  sl.registerLazySingleton<AuthService>(
    () => AuthService(client: sl<SupabaseClient>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(authService: sl<AuthService>()),
  );
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepository(client: sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<PatientAppointmentsRepository>(
    () => PatientAppointmentsRepository(adminRepository: sl<AdminRepository>()),
  );

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(repository: sl<AuthRepository>()),
  );
  sl.registerFactory<ChooseRoleCubit>(() => ChooseRoleCubit());
  sl.registerFactory<AdminDoctorsCubit>(
    () => AdminDoctorsCubit(repository: sl<AdminRepository>()),
  );
  sl.registerFactory<AdminAppointmentsCubit>(
    () => AdminAppointmentsCubit(repository: sl<AdminRepository>()),
  );
  sl.registerFactory<AdminProfileCubit>(
    () => AdminProfileCubit(repository: sl<AdminRepository>()),
  );
  sl.registerFactory<PatientAppointmentsCubit>(
    () => PatientAppointmentsCubit(repository: sl<PatientAppointmentsRepository>()),
  );
}

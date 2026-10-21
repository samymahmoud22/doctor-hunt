import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/core/enums/user_role.dart';
import 'package:doctor_hunt/features/common/splash/presentation/screens/splash_screen.dart';
import 'package:doctor_hunt/features/common/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:doctor_hunt/features/common/choose_role/presentation/screens/choose_role_screen.dart';
import 'package:doctor_hunt/features/common/auth/presentation/screens/login_screen.dart';
import 'package:doctor_hunt/features/common/auth/presentation/screens/register_screen.dart';
import 'package:doctor_hunt/features/common/auth/presentation/screens/forgot_password_screen.dart';
import 'package:doctor_hunt/features/common/main/presentation/screens/main_screen.dart';
import 'package:doctor_hunt/features/patient/doctors/presentation/screens/find_doctors_screen.dart';
import 'package:doctor_hunt/features/patient/doctors/presentation/screens/select_time_screen.dart';
import 'package:doctor_hunt/features/patient/doctors/presentation/screens/popular_doctors_screen.dart';
import 'package:doctor_hunt/features/patient/doctors/presentation/screens/favourite_doctors_screen.dart';
import 'package:doctor_hunt/features/patient/doctors/presentation/screens/doctor_details_screen.dart';
import 'package:doctor_hunt/features/admin/presentation/screens/admin_doctor_details_screen.dart';
import 'package:doctor_hunt/features/admin/presentation/screens/admin_create_doctor_screen.dart';
import 'package:doctor_hunt/features/admin/presentation/screens/admin_appointment_details_screen.dart';
import 'package:doctor_hunt/features/admin/presentation/screens/admin_edit_profile_screen.dart';
import 'package:doctor_hunt/features/patient/appointments/presentation/screens/patient_appointments_screen.dart';
import 'package:doctor_hunt/features/patient/appointments/presentation/screens/patient_appointment_details_screen.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';
import 'package:doctor_hunt/features/admin/presentation/screens/admin_edit_doctor_screen.dart';
import 'package:doctor_hunt/features/admin/presentation/screens/admin_doctor_availability_screen.dart';
import 'package:doctor_hunt/features/patient/home/presentation/screens/privacy_policy_screen.dart';
import 'package:doctor_hunt/features/patient/home/presentation/screens/patient_profile_details_screen.dart';
import 'package:doctor_hunt/features/patient/home/presentation/widgets/patient_menu_drawer.dart';

part 'app_router.g.dart';

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashScreen();
  }
}

@TypedGoRoute<MainRoute>(path: '/main')
class MainRoute extends GoRouteData {
  final UserRole? role;
  const MainRoute({this.role});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MainScreen(initialRole: role);
  }
}

@TypedGoRoute<OnboardingRoute>(path: '/onboarding')
class OnboardingRoute extends GoRouteData {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OnboardingScreen();
  }
}

@TypedGoRoute<ChooseRoleRoute>(path: '/choose-role')
class ChooseRoleRoute extends GoRouteData {
  const ChooseRoleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChooseRoleScreen();
  }
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData {
  final UserRole? role;
  const LoginRoute({this.role});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoginScreen(role: role);
  }
}

@TypedGoRoute<RegisterRoute>(path: '/register')
class RegisterRoute extends GoRouteData {
  final UserRole? role;
  const RegisterRoute({this.role});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return RegisterScreen(role: role);
  }
}

@TypedGoRoute<ForgotPasswordRoute>(path: '/forgot-password')
class ForgotPasswordRoute extends GoRouteData {
  const ForgotPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ForgotPasswordScreen();
  }
}

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      ...$appRoutes,
      GoRoute(
        path: '/find-doctors',
        builder: (context, state) => FindDoctorsScreen(
          initialQuery: state.uri.queryParameters['query'],
        ),
      ),
      GoRoute(
        path: '/select-time',
        builder: (context, state) => SelectTimeScreen(
          doctorName: state.uri.queryParameters['doctorName'] ?? 'Dr. Shruti Kedia',
        ),
      ),
      GoRoute(
        path: '/popular-doctors',
        builder: (context, state) => const PopularDoctorsScreen(),
      ),
      GoRoute(
        path: '/favourite-doctors',
        builder: (context, state) => const FavouriteDoctorsScreen(),
      ),
      GoRoute(
        path: '/doctor-details',
        builder: (context, state) => DoctorDetailsScreen(
          name: state.uri.queryParameters['name'] ?? 'Dr. Pediatrician',
          specialty: state.uri.queryParameters['specialty'] ?? 'Specialist Cardiologist',
        ),
      ),
      GoRoute(
        path: '/admin/doctor-details',
        builder: (context, state) => AdminDoctorDetailsScreen(
          doctorId: state.uri.queryParameters['doctorId'] ?? 'doc_1',
        ),
      ),
      GoRoute(
        path: '/admin/create-doctor',
        builder: (context, state) => const AdminCreateDoctorScreen(),
      ),
      GoRoute(
        path: '/admin/edit-doctor',
        builder: (context, state) {
          final doctor = state.extra as AdminDoctorModel? ??
              sl<AdminRepository>().findDoctorById(
                state.uri.queryParameters['doctorId'] ?? 'doc_1',
              );
          return AdminEditDoctorScreen(
            doctor: doctor ?? sl<AdminRepository>().findDoctorById('doc_1')!,
          );
        },
      ),
      GoRoute(
        path: '/admin/doctor-availability',
        builder: (context, state) {
          final doctor = state.extra as AdminDoctorModel? ??
              sl<AdminRepository>().findDoctorById(
                state.uri.queryParameters['doctorId'] ?? 'doc_1',
              );
          return AdminDoctorAvailabilityScreen(
            doctor: doctor ?? sl<AdminRepository>().findDoctorById('doc_1')!,
          );
        },
      ),
      GoRoute(
        path: '/admin/appointment-details',
        builder: (context, state) => AdminAppointmentDetailsScreen(
          appointmentId: state.uri.queryParameters['appointmentId'] ?? 'apt_1',
        ),
      ),
      GoRoute(
        path: '/admin/edit-profile',
        builder: (context, state) => const AdminEditProfileScreen(),
      ),
      GoRoute(
        path: '/appointments',
        builder: (context, state) => const PatientAppointmentsScreen(showBackButton: true),
      ),
      GoRoute(
        path: '/patient/appointment-details',
        builder: (context, state) => PatientAppointmentDetailsScreen(
          appointmentId: state.uri.queryParameters['appointmentId'] ?? 'p_apt_1',
        ),
      ),
      GoRoute(
        path: '/privacy-policy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/patient/profile',
        builder: (context, state) => const PatientProfileDetailsScreen(),
      ),
      GoRoute(
        path: '/menu',
        builder: (context, state) => Scaffold(
          body: PatientMenuDrawer(
            selectedIndex: 0,
            onSelectTab: (index) {
              context.go('/main');
            },
            onClose: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/main');
              }
            },
          ),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route error: ${state.error}'),
      ),
    ),
  );
}

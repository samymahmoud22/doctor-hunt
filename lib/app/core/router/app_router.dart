import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/choose_role/presentation/screens/choose_role_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/home/presentation/screens/main_screen.dart';

import '../../features/doctors/presentation/screens/find_doctors_screen.dart';
import '../../features/doctors/presentation/screens/doctor_live_chat_screen.dart';
import '../../features/doctors/presentation/screens/select_time_screen.dart';
import '../../features/doctors/presentation/screens/popular_doctors_screen.dart';
import '../../features/doctors/presentation/screens/favourite_doctors_screen.dart';
import '../../features/doctors/presentation/screens/doctor_details_screen.dart';

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
  final String? role;
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
  final String? role;
  const LoginRoute({this.role});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoginScreen(role: role);
  }
}

@TypedGoRoute<RegisterRoute>(path: '/register')
class RegisterRoute extends GoRouteData {
  final String? role;
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
        path: '/live-chat',
        builder: (context, state) => DoctorLiveChatScreen(
          doctorName: state.uri.queryParameters['doctorName'],
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
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route error: ${state.error}'),
      ),
    ),
  );
}


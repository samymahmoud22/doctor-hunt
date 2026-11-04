import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/enums/user_role.dart';
import 'package:doctor_hunt/core/router/app_router.dart';
import 'package:doctor_hunt/core/services/session_manager.dart';
import 'package:doctor_hunt/features/common/auth/data/models/user_model.dart';
import 'package:doctor_hunt/features/common/auth/data/repo/auth_repository.dart';
import 'package:doctor_hunt/features/common/auth/presentation/controller/auth_cubit.dart';

class MockBuildContext extends Mock implements BuildContext {}
class MockGoRouterState extends Mock implements GoRouterState {}
class MockAuthRepository extends Mock implements AuthRepository {}
class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  setUpAll(() {
    registerFallbackValue(UserRole.patient);
  });

  late SharedPreferences prefs;
  late SessionManager sessionManager;
  late MockBuildContext mockContext;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    sessionManager = SessionManager(prefs: prefs);
    mockContext = MockBuildContext();

    await sl.reset();
    sl.registerLazySingleton<SharedPreferences>(() => prefs);
    sl.registerLazySingleton<SessionManager>(() => sessionManager);
  });

  tearDown(() async {
    await sl.reset();
  });

  group('SessionManager Unit Tests', () {
    test('initial state defaults are correct', () {
      expect(sessionManager.isOnboardingCompleted, isFalse);
      expect(sessionManager.isAuthenticated, isFalse);
      expect(sessionManager.userRole, UserRole.patient);
      expect(sessionManager.userId, isNull);
      expect(sessionManager.userEmail, isNull);
      expect(sessionManager.userName, isNull);
    });

    test('setOnboardingCompleted persists and notifies listeners', () async {
      int notifyCount = 0;
      sessionManager.addListener(() => notifyCount++);

      await sessionManager.setOnboardingCompleted(true);

      expect(sessionManager.isOnboardingCompleted, isTrue);
      expect(prefs.getBool('onboarding_completed'), isTrue);
      expect(notifyCount, 1);
    });

    test('saveUserSession persists user and updates auth state', () async {
      int notifyCount = 0;
      sessionManager.addListener(() => notifyCount++);

      final user = UserModel(
        id: 'usr_123',
        email: 'doctor@test.com',
        fullName: 'Dr. Jane Smith',
        role: UserRole.admin,
      );

      await sessionManager.saveUserSession(user);

      expect(sessionManager.isAuthenticated, isTrue);
      expect(sessionManager.userRole, UserRole.admin);
      expect(sessionManager.userId, 'usr_123');
      expect(sessionManager.userEmail, 'doctor@test.com');
      expect(sessionManager.userName, 'Dr. Jane Smith');
      expect(notifyCount, 1);
    });

    test('clearUserSession removes user details but retains onboarding status', () async {
      await sessionManager.setOnboardingCompleted(true);
      await sessionManager.saveUserSession(
        UserModel(
          id: 'p_1',
          email: 'p@test.com',
          fullName: 'John Doe',
          role: UserRole.patient,
        ),
      );

      expect(sessionManager.isAuthenticated, isTrue);
      expect(sessionManager.isOnboardingCompleted, isTrue);

      await sessionManager.clearUserSession();

      expect(sessionManager.isAuthenticated, isFalse);
      expect(sessionManager.userId, isNull);
      expect(sessionManager.userEmail, isNull);
      // Onboarding must remain true so returning users don't see onboarding again
      expect(sessionManager.isOnboardingCompleted, isTrue);
    });

    test('setRole updates role and notifies listeners', () async {
      int notifyCount = 0;
      sessionManager.addListener(() => notifyCount++);

      await sessionManager.setRole(UserRole.admin);

      expect(sessionManager.userRole, UserRole.admin);
      expect(notifyCount, 1);
    });
  });

  group('AppRouter Route Guards Tests', () {
    GoRouterState createMockState(String path) {
      final state = MockGoRouterState();
      when(() => state.uri).thenReturn(Uri.parse(path));
      return state;
    }

    test('splash screen (/splash) is never guarded', () {
      final state = createMockState('/splash');
      final result = AppRouter.guardRoute(mockContext, state);
      expect(result, isNull);
    });

    test('when onboarding is not completed, redirect non-onboarding routes to /onboarding', () async {
      expect(sessionManager.isOnboardingCompleted, isFalse);

      final mainState = createMockState('/main');
      expect(AppRouter.guardRoute(mockContext, mainState), '/onboarding');

      final roleState = createMockState('/choose-role');
      expect(AppRouter.guardRoute(mockContext, roleState), '/onboarding');

      final onboardingState = createMockState('/onboarding');
      expect(AppRouter.guardRoute(mockContext, onboardingState), isNull);
    });

    test('when onboarding is completed, redirect away from /onboarding', () async {
      await sessionManager.setOnboardingCompleted(true);

      final onboardingState = createMockState('/onboarding');
      // Unauthenticated -> /choose-role
      expect(AppRouter.guardRoute(mockContext, onboardingState), '/choose-role');

      // Authenticated -> /main?role=...
      await sessionManager.saveUserSession(
        UserModel(id: 'u1', email: 'u@test.com', fullName: 'User', role: UserRole.patient),
      );
      expect(AppRouter.guardRoute(mockContext, onboardingState), '/main?role=patient');
    });

    test('admin routes guard: unauthenticated redirect to /login?role=admin', () async {
      await sessionManager.setOnboardingCompleted(true);
      expect(sessionManager.isAuthenticated, isFalse);

      final adminState = createMockState('/admin/create-doctor');
      expect(AppRouter.guardRoute(mockContext, adminState), '/login?role=admin');
    });

    test('admin routes guard: patient role redirect to /main?role=patient', () async {
      await sessionManager.setOnboardingCompleted(true);
      await sessionManager.saveUserSession(
        UserModel(id: 'p1', email: 'p@test.com', fullName: 'Patient', role: UserRole.patient),
      );

      final adminState = createMockState('/admin/edit-doctor');
      expect(AppRouter.guardRoute(mockContext, adminState), '/main?role=patient');
    });

    test('admin routes guard: admin role allows access', () async {
      await sessionManager.setOnboardingCompleted(true);
      await sessionManager.saveUserSession(
        UserModel(id: 'adm1', email: 'adm@test.com', fullName: 'Admin', role: UserRole.admin),
      );

      final adminState = createMockState('/admin/doctor-details');
      expect(AppRouter.guardRoute(mockContext, adminState), isNull);
    });

    test('authenticated user visiting /login or /register is redirected to /main', () async {
      await sessionManager.setOnboardingCompleted(true);
      await sessionManager.saveUserSession(
        UserModel(id: 'p1', email: 'p@test.com', fullName: 'Patient', role: UserRole.patient),
      );

      final loginState = createMockState('/login');
      expect(AppRouter.guardRoute(mockContext, loginState), '/main?role=patient');

      final regState = createMockState('/register');
      expect(AppRouter.guardRoute(mockContext, regState), '/main?role=patient');
    });

    test('guest choosing role or quick demo is allowed on /choose-role and /main', () async {
      await sessionManager.setOnboardingCompleted(true);

      final chooseState = createMockState('/choose-role');
      expect(AppRouter.guardRoute(mockContext, chooseState), isNull);

      final mainState = createMockState('/main');
      expect(AppRouter.guardRoute(mockContext, mainState), isNull);
    });
  });

  group('AuthCubit with SessionManager Integration Tests', () {
    test('login saves session to SessionManager', () async {
      final mockRepo = MockAuthRepository();
      final user = UserModel(
        id: 'user_live',
        email: 'live@test.com',
        fullName: 'Live User',
        role: UserRole.admin,
      );

      when(() => mockRepo.login(
        email: 'live@test.com',
        password: 'password123',
        role: any(named: 'role'),
      )).thenAnswer((_) async => user);

      final cubit = AuthCubit(
        repository: mockRepo,
        sessionManager: sessionManager,
      );

      expect(sessionManager.isAuthenticated, isFalse);

      await cubit.login(email: 'live@test.com', password: 'password123');

      expect(sessionManager.isAuthenticated, isTrue);
      expect(sessionManager.userId, 'user_live');
      expect(sessionManager.userRole, UserRole.admin);
    });

    test('logout clears session from SessionManager', () async {
      final mockRepo = MockAuthRepository();
      when(() => mockRepo.signOut()).thenAnswer((_) async {});

      await sessionManager.saveUserSession(
        UserModel(id: 'u1', email: 'u@test.com', fullName: 'U', role: UserRole.patient),
      );
      expect(sessionManager.isAuthenticated, isTrue);

      final cubit = AuthCubit(
        repository: mockRepo,
        sessionManager: sessionManager,
      );

      await cubit.logout();

      expect(sessionManager.isAuthenticated, isFalse);
      expect(sessionManager.userId, isNull);
    });
  });
}

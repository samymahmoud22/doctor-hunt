import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doctor_hunt/core/enums/user_role.dart';
import 'package:doctor_hunt/features/common/auth/data/models/user_model.dart';
import 'package:doctor_hunt/features/common/auth/data/repo/auth_repository.dart';
import 'package:doctor_hunt/features/common/auth/presentation/controller/auth_cubit.dart';
import 'package:doctor_hunt/features/common/auth/presentation/controller/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthCubit cubit;
  late MockAuthRepository mockRepository;

  const tPatientUser = UserModel(
    id: 'user_patient_123',
    email: 'test@doctorhunt.com',
    fullName: 'Jane Doe',
    role: UserRole.patient,
  );

  const tAdminUser = UserModel(
    id: 'user_admin_123',
    email: 'admin@doctorhunt.com',
    fullName: 'Admin User',
    role: UserRole.admin,
  );

  setUpAll(() {
    registerFallbackValue(UserRole.patient);
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    cubit = AuthCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('AuthCubit - Initial State & Synchronous Actions', () {
    test('initial state has default values', () {
      expect(cubit.state, const AuthState());
      expect(cubit.state.status, AuthStatus.initial);
      expect(cubit.state.role, UserRole.patient);
      expect(cubit.state.rememberMe, false);
      expect(cubit.state.user, isNull);
      expect(cubit.state.errorMessage, isNull);
    });

    test('setRole updates role to admin and retains other fields', () {
      cubit.setRole(UserRole.admin);
      expect(cubit.state.role, UserRole.admin);
      expect(cubit.state.status, AuthStatus.initial);

      // Edge case: switching back to patient
      cubit.setRole(UserRole.patient);
      expect(cubit.state.role, UserRole.patient);
    });

    test('toggleRememberMe toggles the rememberMe flag', () {
      cubit.toggleRememberMe(true);
      expect(cubit.state.rememberMe, isTrue);

      cubit.toggleRememberMe(false);
      expect(cubit.state.rememberMe, isFalse);
    });
  });

  group('AuthCubit - Login', () {
    test('happy path: emits [loading, authenticated] on successful login', () async {
      when(() => mockRepository.login(
            email: 'test@doctorhunt.com',
            password: 'password123',
            role: UserRole.patient,
          )).thenAnswer((_) async => tPatientUser);

      final expectedStates = [
        const AuthState(status: AuthStatus.loading, role: UserRole.patient),
        const AuthState(
          status: AuthStatus.authenticated,
          user: tPatientUser,
          role: UserRole.patient,
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.login(email: 'test@doctorhunt.com', password: 'password123');
      verify(() => mockRepository.login(
            email: 'test@doctorhunt.com',
            password: 'password123',
            role: UserRole.patient,
          )).called(1);
    });

    test('happy path: admin login succeeds with admin role', () async {
      cubit.setRole(UserRole.admin);

      when(() => mockRepository.login(
            email: 'admin@doctorhunt.com',
            password: 'adminPassword',
            role: UserRole.admin,
          )).thenAnswer((_) async => tAdminUser);

      final expectedStates = [
        const AuthState(status: AuthStatus.loading, role: UserRole.admin),
        const AuthState(
          status: AuthStatus.authenticated,
          user: tAdminUser,
          role: UserRole.admin,
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.login(email: 'admin@doctorhunt.com', password: 'adminPassword');
    });

    test('edge case: invalid credentials exception emits [loading, failure]', () async {
      when(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
            role: any(named: 'role'),
          )).thenThrow(Exception('Incorrect email or password.'));

      final expectedStates = [
        const AuthState(status: AuthStatus.loading),
        const AuthState(
          status: AuthStatus.failure,
          errorMessage: 'Incorrect email or password.',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.login(email: 'wrong@mail.com', password: 'bad');
    });

    test('edge case: network connection error strips "Exception: " prefix cleanly', () async {
      when(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
            role: any(named: 'role'),
          )).thenThrow(Exception('Network timeout or connection refused'));

      final expectedStates = [
        const AuthState(status: AuthStatus.loading),
        const AuthState(
          status: AuthStatus.failure,
          errorMessage: 'Network timeout or connection refused',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.login(email: 'test@mail.com', password: 'password123');
    });

    test('edge case: preserves rememberMe setting across failed login', () async {
      cubit.toggleRememberMe(true);

      when(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
            role: any(named: 'role'),
          )).thenThrow(Exception('Auth error'));

      await cubit.login(email: 'test@mail.com', password: '123');

      expect(cubit.state.status, AuthStatus.failure);
      expect(cubit.state.rememberMe, isTrue);
      expect(cubit.state.errorMessage, 'Auth error');
    });
  });

  group('AuthCubit - Register', () {
    test('happy path: emits [loading, authenticated] on successful registration', () async {
      when(() => mockRepository.register(
            fullName: 'Jane Doe',
            email: 'test@doctorhunt.com',
            password: 'password123',
            role: UserRole.patient,
          )).thenAnswer((_) async => tPatientUser);

      final expectedStates = [
        const AuthState(status: AuthStatus.loading),
        const AuthState(
          status: AuthStatus.authenticated,
          user: tPatientUser,
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.register(
        fullName: 'Jane Doe',
        email: 'test@doctorhunt.com',
        password: 'password123',
      );
    });

    test('edge case: email already registered emits failure', () async {
      when(() => mockRepository.register(
            fullName: any(named: 'fullName'),
            email: any(named: 'email'),
            password: any(named: 'password'),
            role: any(named: 'role'),
          )).thenThrow(Exception('An account already exists for this email.'));

      final expectedStates = [
        const AuthState(status: AuthStatus.loading),
        const AuthState(
          status: AuthStatus.failure,
          errorMessage: 'An account already exists for this email.',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.register(
        fullName: 'Jane Doe',
        email: 'existing@doctorhunt.com',
        password: 'password123',
      );
    });

    test('edge case: weak password exception emits failure', () async {
      when(() => mockRepository.register(
            fullName: any(named: 'fullName'),
            email: any(named: 'email'),
            password: any(named: 'password'),
            role: any(named: 'role'),
          )).thenThrow(Exception('The password provided is too weak. Please use at least 6 characters.'));

      await cubit.register(
        fullName: 'Jane Doe',
        email: 'test@doctorhunt.com',
        password: '12',
      );

      expect(cubit.state.status, AuthStatus.failure);
      expect(cubit.state.errorMessage, contains('too weak'));
    });
  });

  group('AuthCubit - Google Sign In', () {
    test('happy path: emits [loading, authenticated] on successful Google login', () async {
      when(() => mockRepository.loginWithGoogle(role: UserRole.patient))
          .thenAnswer((_) async => tPatientUser);

      final expectedStates = [
        const AuthState(status: AuthStatus.loading),
        const AuthState(status: AuthStatus.authenticated, user: tPatientUser),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loginWithGoogle();
    });

    test('edge case: user cancels Google dialog emits failure gracefully', () async {
      when(() => mockRepository.loginWithGoogle(role: any(named: 'role')))
          .thenThrow(Exception('Google Sign-In canceled by user'));

      final expectedStates = [
        const AuthState(status: AuthStatus.loading),
        const AuthState(
          status: AuthStatus.failure,
          errorMessage: 'Google Sign-In canceled by user',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loginWithGoogle();
    });

    test('edge case: missing ID token emits failure', () async {
      when(() => mockRepository.loginWithGoogle(role: any(named: 'role')))
          .thenThrow(Exception('No ID Token found from Google Sign-In'));

      await cubit.loginWithGoogle();

      expect(cubit.state.status, AuthStatus.failure);
      expect(cubit.state.errorMessage, 'No ID Token found from Google Sign-In');
    });
  });

  group('AuthCubit - Password Reset & OTP Flow', () {
    test('sendPasswordReset happy path: emits [loading, otpSent] and returns true', () async {
      when(() => mockRepository.sendPasswordResetEmail('patient@doctorhunt.com'))
          .thenAnswer((_) async => {});

      final expectedStates = [
        const AuthState(status: AuthStatus.loading),
        const AuthState(status: AuthStatus.otpSent, errorMessage: null),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      final result = await cubit.sendPasswordReset('patient@doctorhunt.com');
      expect(result, isTrue);
    });

    test('sendPasswordReset edge case: rate limit exception emits failure and returns false', () async {
      when(() => mockRepository.sendPasswordResetEmail(any()))
          .thenThrow(Exception('Too many requests. Please wait a moment before trying again.'));

      final expectedStates = [
        const AuthState(status: AuthStatus.loading),
        const AuthState(
          status: AuthStatus.failure,
          errorMessage: 'Too many requests. Please wait a moment before trying again.',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      final result = await cubit.sendPasswordReset('rate_limited@doctorhunt.com');
      expect(result, isFalse);
    });

    test('verifyOtp happy path: emits [loading, otpVerified] and returns true', () async {
      when(() => mockRepository.verifyOtp(
            email: 'patient@doctorhunt.com',
            token: '123456',
          )).thenAnswer((_) async => {});

      final expectedStates = [
        const AuthState(status: AuthStatus.loading),
        const AuthState(status: AuthStatus.otpVerified, errorMessage: null),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      final result = await cubit.verifyOtp(email: 'patient@doctorhunt.com', token: '123456');
      expect(result, isTrue);
    });

    test('verifyOtp edge case: expired OTP emits failure and returns false', () async {
      when(() => mockRepository.verifyOtp(
            email: any(named: 'email'),
            token: any(named: 'token'),
          )).thenThrow(Exception('The verification code has expired. Please request a new code.'));

      final expectedStates = [
        const AuthState(status: AuthStatus.loading),
        const AuthState(
          status: AuthStatus.failure,
          errorMessage: 'The verification code has expired. Please request a new code.',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      final result = await cubit.verifyOtp(email: 'patient@doctorhunt.com', token: '000000');
      expect(result, isFalse);
    });

    test('updatePassword happy path: emits [loading, passwordUpdated] and returns true', () async {
      when(() => mockRepository.updatePassword('NewPass123!'))
          .thenAnswer((_) async => {});

      final expectedStates = [
        const AuthState(status: AuthStatus.loading),
        const AuthState(status: AuthStatus.passwordUpdated, errorMessage: null),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      final result = await cubit.updatePassword('NewPass123!');
      expect(result, isTrue);
    });

    test('updatePassword edge case: failure emits failure and returns false', () async {
      when(() => mockRepository.updatePassword(any()))
          .thenThrow(Exception('Server error'));

      final result = await cubit.updatePassword('weak');
      expect(result, isFalse);
      expect(cubit.state.status, AuthStatus.failure);
      expect(cubit.state.errorMessage, 'Server error');
    });
  });

  group('AuthCubit - Logout', () {
    test('happy path: calls signOut and resets state to AuthState() initial', () async {
      when(() => mockRepository.signOut()).thenAnswer((_) async => {});

      // Simulate prior logged in state with admin role and rememberMe
      cubit.setRole(UserRole.admin);
      cubit.toggleRememberMe(true);

      await cubit.logout();

      verify(() => mockRepository.signOut()).called(1);
      expect(cubit.state, const AuthState());
      expect(cubit.state.status, AuthStatus.initial);
      expect(cubit.state.role, UserRole.patient);
      expect(cubit.state.rememberMe, false);
      expect(cubit.state.user, isNull);
    });
  });
}


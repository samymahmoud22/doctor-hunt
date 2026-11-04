import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doctor_hunt/core/enums/user_role.dart';
import 'package:doctor_hunt/features/common/auth/data/models/user_model.dart';
import 'package:doctor_hunt/features/common/auth/data/repo/auth_repository.dart';
import 'package:doctor_hunt/features/common/auth/data/service/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late AuthRepository repository;
  late MockAuthService mockAuthService;

  const tUser = UserModel(
    id: 'u_1',
    email: 'test@doctorhunt.com',
    fullName: 'Test User',
    role: UserRole.patient,
  );

  setUpAll(() {
    registerFallbackValue(UserRole.patient);
  });

  setUp(() {
    mockAuthService = MockAuthService();
    repository = AuthRepository(authService: mockAuthService);
  });

  group('AuthRepository - Happy Paths', () {
    test('login delegates to authService with exact parameters and returns user', () async {
      when(() => mockAuthService.login(
            email: 'test@doctorhunt.com',
            password: 'pass',
            role: UserRole.patient,
          )).thenAnswer((_) async => tUser);

      final result = await repository.login(
        email: 'test@doctorhunt.com',
        password: 'pass',
        role: UserRole.patient,
      );

      expect(result, tUser);
      verify(() => mockAuthService.login(
            email: 'test@doctorhunt.com',
            password: 'pass',
            role: UserRole.patient,
          )).called(1);
    });

    test('register delegates to authService and returns registered user', () async {
      when(() => mockAuthService.register(
            fullName: 'Test User',
            email: 'test@doctorhunt.com',
            password: 'pass',
            role: UserRole.patient,
          )).thenAnswer((_) async => tUser);

      final result = await repository.register(
        fullName: 'Test User',
        email: 'test@doctorhunt.com',
        password: 'pass',
        role: UserRole.patient,
      );

      expect(result, tUser);
      verify(() => mockAuthService.register(
            fullName: 'Test User',
            email: 'test@doctorhunt.com',
            password: 'pass',
            role: UserRole.patient,
          )).called(1);
    });

    test('loginWithGoogle delegates to authService and returns user', () async {
      when(() => mockAuthService.loginWithGoogle(role: UserRole.patient))
          .thenAnswer((_) async => tUser);

      final result = await repository.loginWithGoogle(role: UserRole.patient);

      expect(result, tUser);
      verify(() => mockAuthService.loginWithGoogle(role: UserRole.patient)).called(1);
    });

    test('sendPasswordResetEmail delegates to authService', () async {
      when(() => mockAuthService.sendPasswordResetEmail('test@doctorhunt.com'))
          .thenAnswer((_) async => {});

      await repository.sendPasswordResetEmail('test@doctorhunt.com');
      verify(() => mockAuthService.sendPasswordResetEmail('test@doctorhunt.com')).called(1);
    });

    test('verifyOtp delegates to authService', () async {
      when(() => mockAuthService.verifyOtp(email: 'test@doctorhunt.com', token: '123456'))
          .thenAnswer((_) async => {});

      await repository.verifyOtp(email: 'test@doctorhunt.com', token: '123456');
      verify(() => mockAuthService.verifyOtp(email: 'test@doctorhunt.com', token: '123456')).called(1);
    });

    test('updatePassword delegates to authService', () async {
      when(() => mockAuthService.updatePassword('NewPass123!'))
          .thenAnswer((_) async => {});

      await repository.updatePassword('NewPass123!');
      verify(() => mockAuthService.updatePassword('NewPass123!')).called(1);
    });

    test('signOut delegates to authService', () async {
      when(() => mockAuthService.signOut()).thenAnswer((_) async => {});

      await repository.signOut();
      verify(() => mockAuthService.signOut()).called(1);
    });
  });

  group('AuthRepository - Edge Cases & Exceptions', () {
    test('login propagates exception directly when authService fails', () async {
      when(() => mockAuthService.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
            role: any(named: 'role'),
          )).thenThrow(Exception('Incorrect email or password.'));

      expect(
        () => repository.login(
          email: 'wrong@doctorhunt.com',
          password: 'wrong',
          role: UserRole.patient,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('register propagates exception when email is duplicate', () async {
      when(() => mockAuthService.register(
            fullName: any(named: 'fullName'),
            email: any(named: 'email'),
            password: any(named: 'password'),
            role: any(named: 'role'),
          )).thenThrow(Exception('An account already exists for this email.'));

      expect(
        () => repository.register(
          fullName: 'Test User',
          email: 'dup@doctorhunt.com',
          password: 'pass',
          role: UserRole.patient,
        ),
        throwsA(predicate((e) => e.toString().contains('already exists'))),
      );
    });

    test('signOut failure is caught or thrown according to service contract', () async {
      when(() => mockAuthService.signOut()).thenThrow(Exception('Network error during logout'));

      expect(() => repository.signOut(), throwsA(isA<Exception>()));
    });
  });
}


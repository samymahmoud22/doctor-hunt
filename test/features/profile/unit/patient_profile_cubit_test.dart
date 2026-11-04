import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doctor_hunt/features/common/auth/data/repo/auth_repository.dart';
import 'package:doctor_hunt/features/patient/home/presentation/controllers/patient_profile_cubit.dart';
import 'package:doctor_hunt/features/patient/home/presentation/controllers/patient_profile_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late PatientProfileCubit cubit;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    cubit = PatientProfileCubit(repository: mockAuthRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('PatientProfileCubit - loadProfile', () {
    test('happy path: loads profile and updates state with fullName and phone', () async {
      when(() => mockAuthRepository.getPatientProfile()).thenAnswer(
        (_) async => {'fullName': 'Ayman Nour', 'phone': '+201001234567'},
      );

      final expectedStates = [
        const PatientProfileState(isLoading: true, isSaved: false),
        const PatientProfileState(
          fullName: 'Ayman Nour',
          phone: '+201001234567',
          isLoading: false,
          isSaved: false,
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadProfile();
    });

    test('edge case: error during profile fetch emits errorMessage with isLoading false', () async {
      when(() => mockAuthRepository.getPatientProfile()).thenThrow(Exception('User not authenticated'));

      final expectedStates = [
        const PatientProfileState(isLoading: true, isSaved: false),
        const PatientProfileState(
          isLoading: false,
          isSaved: false,
          errorMessage: 'User not authenticated',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadProfile();
    });
  });

  group('PatientProfileCubit - updateProfile', () {
    test('happy path: updates patient profile and emits success', () async {
      when(() => mockAuthRepository.updatePatientProfile(
        fullName: 'New Name',
        phone: '+201112223334',
      )).thenAnswer((_) async {});

      final expectedStates = [
        const PatientProfileState(isLoading: true, isSaved: false),
        const PatientProfileState(
          fullName: 'New Name',
          phone: '+201112223334',
          isLoading: false,
          isSaved: true,
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      final success = await cubit.updateProfile(
        fullName: 'New Name',
        phone: '+201112223334',
      );

      expect(success, true);
      verify(() => mockAuthRepository.updatePatientProfile(
        fullName: 'New Name',
        phone: '+201112223334',
      )).called(1);
    });

    test('edge case: failure during profile update returns false and emits errorMessage', () async {
      when(() => mockAuthRepository.updatePatientProfile(
        fullName: any(named: 'fullName'),
        phone: any(named: 'phone'),
      )).thenThrow(Exception('Update failed'));

      final expectedStates = [
        const PatientProfileState(isLoading: true, isSaved: false),
        const PatientProfileState(
          isLoading: false,
          isSaved: false,
          errorMessage: 'Update failed',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      final success = await cubit.updateProfile(
        fullName: 'New Name',
        phone: '+201112223334',
      );

      expect(success, false);
    });
  });
}

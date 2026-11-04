import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';
import 'package:doctor_hunt/features/admin/presentation/controllers/admin_doctors_cubit.dart';
import 'package:doctor_hunt/features/admin/presentation/controllers/admin_doctors_state.dart';

class MockAdminRepository extends Mock implements AdminRepository {}

void main() {
  late AdminDoctorsCubit cubit;
  late MockAdminRepository mockRepository;

  const tDoc1 = AdminDoctorModel(
    id: 'doc_1',
    name: 'Dr. Fillerup Grab',
    specialty: 'Medicine Specialist',
    rating: 5.0,
    reviewsCount: 520,
    consultationFee: 28.0,
  );

  const tDoc2 = AdminDoctorModel(
    id: 'doc_2',
    name: 'Dr. Shruti Kedia',
    specialty: 'Specialist Dentist',
    rating: 4.9,
    reviewsCount: 420,
    consultationFee: 32.0,
  );

  const tDoc3 = AdminDoctorModel(
    id: 'doc_3',
    name: 'Dr. Ananya Shah',
    specialty: 'Specialist Cardiologist',
    rating: 4.8,
    reviewsCount: 380,
    consultationFee: 28.0,
  );

  setUpAll(() {
    registerFallbackValue(tDoc1);
  });

  setUp(() {
    mockRepository = MockAdminRepository();
    cubit = AdminDoctorsCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('AdminDoctorsCubit - loadDoctors & Filtering', () {
    test('happy path: loads doctors and applies current filter', () async {
      when(() => mockRepository.getDoctors())
          .thenAnswer((_) async => [tDoc1, tDoc2, tDoc3]);

      final expectedStates = [
        const AdminDoctorsState(isLoading: true),
        const AdminDoctorsState(
          allDoctors: [tDoc1, tDoc2, tDoc3],
          filteredDoctors: [tDoc1, tDoc2, tDoc3],
          isLoading: false,
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadDoctors();
    });

    test('edge case: repository error emits failure message with isLoading: false', () async {
      when(() => mockRepository.getDoctors())
          .thenThrow(Exception('Failed to load doctors list'));

      final expectedStates = [
        const AdminDoctorsState(isLoading: true),
        const AdminDoctorsState(
          isLoading: false,
          errorMessage: 'Exception: Failed to load doctors list',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadDoctors();
    });
  });

  group('AdminDoctorsCubit - Search & Specialty Filters (Edge Cases)', () {
    setUp(() async {
      when(() => mockRepository.getDoctors())
          .thenAnswer((_) async => [tDoc1, tDoc2, tDoc3]);
      await cubit.loadDoctors();
    });

    test('setSearchQuery filters by name case-insensitively', () {
      cubit.setSearchQuery('shruti');
      expect(cubit.state.filteredDoctors, [tDoc2]);

      cubit.setSearchQuery('ANANYA');
      expect(cubit.state.filteredDoctors, [tDoc3]);
    });

    test('setSearchQuery filters by specialty case-insensitively', () {
      cubit.setSearchQuery('dentist');
      expect(cubit.state.filteredDoctors, [tDoc2]);
    });

    test('setSelectedSpecialty filters by specialty or returns all when "All"', () {
      cubit.setSelectedSpecialty('Specialist Cardiologist');
      expect(cubit.state.filteredDoctors, [tDoc3]);

      cubit.setSelectedSpecialty('All');
      expect(cubit.state.filteredDoctors.length, 3);
    });

    test('edge case: non-matching query returns empty list without error', () {
      cubit.setSearchQuery('NonExistentDoctorXYZ');
      expect(cubit.state.filteredDoctors, isEmpty);
    });
  });

  group('AdminDoctorsCubit - CRUD Operations', () {
    test('addDoctor calls repo and reloads doctors', () async {
      when(() => mockRepository.addDoctor(any())).thenAnswer((_) async => {});
      when(() => mockRepository.getDoctors()).thenAnswer((_) async => [tDoc1]);

      await cubit.addDoctor(tDoc1);

      verify(() => mockRepository.addDoctor(tDoc1)).called(1);
      verify(() => mockRepository.getDoctors()).called(1);
    });

    test('deleteDoctor calls repo and reloads doctors', () async {
      when(() => mockRepository.deleteDoctor('doc_1')).thenAnswer((_) async => {});
      when(() => mockRepository.getDoctors()).thenAnswer((_) async => [tDoc2]);

      await cubit.deleteDoctor('doc_1');

      verify(() => mockRepository.deleteDoctor('doc_1')).called(1);
      verify(() => mockRepository.getDoctors()).called(1);
    });
  });
}

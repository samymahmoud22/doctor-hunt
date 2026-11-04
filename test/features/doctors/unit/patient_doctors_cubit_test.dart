import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';
import 'package:doctor_hunt/features/patient/doctors/presentation/controllers/patient_doctors_cubit.dart';
import 'package:doctor_hunt/features/patient/doctors/presentation/controllers/patient_doctors_state.dart';

class MockAdminRepository extends Mock implements AdminRepository {}

void main() {
  late MockAdminRepository mockAdminRepository;
  late PatientDoctorsCubit cubit;

  final sampleDoctors = [
    const AdminDoctorModel(
      id: 'doc_1',
      name: 'Dr. Ahmed Ali',
      specialty: 'Cardiologist',
      consultationFee: 40.0,
      rating: 4.8,
      reviewsCount: 15,
      isActive: true,
    ),
    const AdminDoctorModel(
      id: 'doc_2',
      name: 'Dr. Mona Samir',
      specialty: 'Dentist',
      consultationFee: 35.0,
      rating: 4.9,
      reviewsCount: 25,
      isActive: true,
    ),
    const AdminDoctorModel(
      id: 'doc_3',
      name: 'Dr. Tarek Inactive',
      specialty: 'Cardiologist',
      consultationFee: 30.0,
      rating: 4.0,
      reviewsCount: 5,
      isActive: false, // inactive doctor
    ),
  ];

  setUp(() {
    mockAdminRepository = MockAdminRepository();
    when(() => mockAdminRepository.favoriteDoctorIds).thenReturn({'doc_1'});
    cubit = PatientDoctorsCubit(repository: mockAdminRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('PatientDoctorsCubit - loadDoctors', () {
    test('happy path: loads active doctors, popular doctors, and favorites', () async {
      when(() => mockAdminRepository.getDoctors()).thenAnswer((_) async => sampleDoctors);

      final expectedStates = [
        const PatientDoctorsState(isLoading: true),
        PatientDoctorsState(
          isLoading: false,
          allDoctors: [sampleDoctors[0], sampleDoctors[1]],
          popularDoctors: [sampleDoctors[1], sampleDoctors[0]], // sorted by rating (4.9 before 4.8)
          filteredDoctors: [sampleDoctors[0], sampleDoctors[1]],
          favoriteDoctorIds: const {'doc_1'},
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadDoctors();
    });

    test('edge case: repository failure emits errorMessage gracefully', () async {
      when(() => mockAdminRepository.getDoctors()).thenThrow(Exception('Database error'));

      final expectedStates = [
        const PatientDoctorsState(isLoading: true),
        const PatientDoctorsState(
          isLoading: false,
          errorMessage: 'Database error',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadDoctors();
    });
  });

  group('PatientDoctorsCubit - Filtering & Search', () {
    setUp(() async {
      when(() => mockAdminRepository.getDoctors()).thenAnswer((_) async => sampleDoctors);
      await cubit.loadDoctors();
    });

    test('search query filters doctors by name or specialty (case-insensitive)', () {
      cubit.setSearchQuery('mona');
      expect(cubit.state.filteredDoctors.length, 1);
      expect(cubit.state.filteredDoctors.first.name, 'Dr. Mona Samir');

      cubit.setSearchQuery('cardio');
      expect(cubit.state.filteredDoctors.length, 1);
      expect(cubit.state.filteredDoctors.first.name, 'Dr. Ahmed Ali');

      // Edge case: no matches
      cubit.setSearchQuery('NonExistent');
      expect(cubit.state.filteredDoctors.isEmpty, true);
    });

    test('specialty selection filters doctors correctly', () {
      cubit.setSelectedSpecialty('Dentist');
      expect(cubit.state.filteredDoctors.length, 1);
      expect(cubit.state.filteredDoctors.first.specialty, 'Dentist');

      // 'All' resets filter
      cubit.setSelectedSpecialty('All');
      expect(cubit.state.filteredDoctors.length, 2);
    });

    test('setOnlyFavorites filters list to favorites only', () {
      cubit.setOnlyFavorites(true);
      expect(cubit.state.onlyFavorites, true);
      expect(cubit.state.filteredDoctors.length, 1);
      expect(cubit.state.filteredDoctors.first.id, 'doc_1');

      cubit.setOnlyFavorites(false);
      expect(cubit.state.onlyFavorites, false);
      expect(cubit.state.filteredDoctors.length, 2);
    });
  });

  group('PatientDoctorsCubit - toggleFavorite', () {
    test('toggles favorite and updates favorites set in state', () async {
      when(() => mockAdminRepository.getDoctors()).thenAnswer((_) async => sampleDoctors);
      when(() => mockAdminRepository.favoriteDoctorIds).thenReturn({'doc_1'});
      when(() => mockAdminRepository.toggleFavorite('doc_2')).thenAnswer((_) {});

      await cubit.loadDoctors();
      cubit.toggleFavorite('doc_2');

      verify(() => mockAdminRepository.toggleFavorite('doc_2')).called(1);
      expect(cubit.state.isFavorite('doc_2'), true);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';
import 'package:doctor_hunt/features/patient/doctors/data/models/doctor_review_model.dart';
import 'package:doctor_hunt/features/patient/doctors/presentation/controllers/doctor_details_cubit.dart';
import 'package:doctor_hunt/features/patient/doctors/presentation/controllers/doctor_details_state.dart';

class MockAdminRepository extends Mock implements AdminRepository {}

void main() {
  late MockAdminRepository mockAdminRepository;
  late DoctorDetailsCubit cubit;

  const doctor1 = AdminDoctorModel(
    id: 'doc_1',
    name: 'Dr. Ahmed Ali',
    specialty: 'Cardiologist',
    clinicLocation: 'Zamalek Clinic, Cairo',
    consultationFee: 45.0,
  );

  final review1 = DoctorReviewModel(
    id: 'rev_1',
    appointmentId: 'apt_1',
    patientId: 'patient_1',
    doctorId: 'doc_1',
    rating: 5.0,
    comment: 'Excellent doctor!',
    createdAt: DateTime(2026, 10, 31),
  );

  setUp(() {
    mockAdminRepository = MockAdminRepository();
    when(() => mockAdminRepository.centralLocation).thenReturn('DoctorHunt Central, Cairo');
    cubit = DoctorDetailsCubit(repository: mockAdminRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('DoctorDetailsCubit - loadDoctorDetails', () {
    test('happy path: loads doctor details, reviews, favorite status and clinic location', () async {
      when(() => mockAdminRepository.getDoctors()).thenAnswer((_) async => [doctor1]);
      when(() => mockAdminRepository.getDoctorReviews('doc_1')).thenAnswer((_) async => [review1]);
      when(() => mockAdminRepository.isFavorite('doc_1')).thenReturn(true);

      final expectedStates = [
        const DoctorDetailsState(isLoading: true),
        DoctorDetailsState(
          doctor: doctor1,
          reviews: [review1],
          isFavorite: true,
          clinicLocation: 'Zamalek Clinic, Cairo',
          isLoading: false,
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadDoctorDetails('Dr. Ahmed Ali');
    });

    test('edge case: repository error emits errorMessage gracefully', () async {
      when(() => mockAdminRepository.getDoctors()).thenThrow(Exception('Network error'));

      final expectedStates = [
        const DoctorDetailsState(isLoading: true),
        const DoctorDetailsState(
          isLoading: false,
          errorMessage: 'Network error',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadDoctorDetails('Dr. Ahmed Ali');
    });
  });

  group('DoctorDetailsCubit - toggleFavorite', () {
    test('toggles favorite when doctor is loaded', () async {
      when(() => mockAdminRepository.getDoctors()).thenAnswer((_) async => [doctor1]);
      when(() => mockAdminRepository.getDoctorReviews('doc_1')).thenAnswer((_) async => []);
      when(() => mockAdminRepository.isFavorite('doc_1')).thenReturn(false);
      when(() => mockAdminRepository.toggleFavorite('doc_1')).thenAnswer((_) {});

      await cubit.loadDoctorDetails('Dr. Ahmed Ali');

      when(() => mockAdminRepository.isFavorite('doc_1')).thenReturn(true);
      cubit.toggleFavorite();

      expect(cubit.state.isFavorite, true);
      verify(() => mockAdminRepository.toggleFavorite('doc_1')).called(1);
    });

    test('edge case: toggleFavorite does nothing when state.doctor is null', () {
      cubit.toggleFavorite();
      verifyNever(() => mockAdminRepository.toggleFavorite(any()));
    });
  });
}

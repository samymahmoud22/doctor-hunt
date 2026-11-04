import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:doctor_hunt/features/admin/data/models/admin_appointment_model.dart';
import 'package:doctor_hunt/features/admin/data/repo/admin_repository.dart';
import 'package:doctor_hunt/features/patient/doctors/data/models/doctor_review_model.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AdminRepository repository;
  late MockSupabaseClient mockClient;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockClient = MockSupabaseClient();
    repository = AdminRepository(client: mockClient);
  });

  group('Favorites Logic & Edge Cases', () {
    test('initial state for a new user starts with empty favorites', () {
      final initialFavorites = repository.favoriteDoctorIds;
      expect(initialFavorites, isEmpty);
      expect(repository.isFavorite('doc_1'), isFalse);
      expect(repository.isFavorite('doc_2'), isFalse);
      expect(repository.isFavorite('doc_4'), isFalse);
    });

    test('isFavorite returns false for non-existent or empty doctor ID', () {
      expect(repository.isFavorite(''), isFalse);
      expect(repository.isFavorite('unknown_id_999'), isFalse);
    });

    test('toggleFavorite toggles an unfavorited doctor to favorited', () {
      expect(repository.isFavorite('doc_4'), isFalse);

      repository.toggleFavorite('doc_4');
      expect(repository.isFavorite('doc_4'), isTrue);
      expect(repository.favoriteDoctorIds.contains('doc_4'), isTrue);
    });

    test('toggleFavorite toggles a favorited doctor back to unfavorited', () {
      repository.toggleFavorite('doc_1');
      expect(repository.isFavorite('doc_1'), isTrue);

      repository.toggleFavorite('doc_1');
      expect(repository.isFavorite('doc_1'), isFalse);
      expect(repository.favoriteDoctorIds.contains('doc_1'), isFalse);
    });

    test('edge case: double toggle returns favorite state to its original status', () {
      final original = repository.isFavorite('doc_7');
      expect(original, isFalse);

      repository.toggleFavorite('doc_7');
      expect(repository.isFavorite('doc_7'), isTrue);

      repository.toggleFavorite('doc_7');
      expect(repository.isFavorite('doc_7'), isFalse);
    });

    test('edge case: favoriteDoctorIds getter returns unmodifiable set', () {
      final favs = repository.favoriteDoctorIds;
      expect(() => favs.add('doc_99'), throwsA(isA<UnsupportedError>()));
    });

    test('edge case: deleting a doctor automatically removes them from favorites', () async {
      repository.toggleFavorite('doc_1');
      expect(repository.isFavorite('doc_1'), isTrue);

      await repository.deleteDoctor('doc_1');

      expect(repository.isFavorite('doc_1'), isFalse);
      expect(repository.favoriteDoctorIds.contains('doc_1'), isFalse);
    });
  });

  group('Booking & Appointments Repository Logic', () {
    test('getAppointments returns initial seeded appointments', () async {
      final appointments = await repository.getAppointments();
      expect(appointments, isNotEmpty);
      expect(appointments.any((a) => a.id == 'apt_1'), isTrue);
    });

    test('addAppointment prepends new appointment with central clinic location', () async {
      const newApt = AdminAppointmentModel(
        id: 'new_apt_100',
        patientName: 'Test Patient',
        patientEmail: 'patient@test.com',
        doctorId: 'doc_2',
        doctorName: 'Dr. Shruti Kedia',
        doctorSpecialty: 'Specialist Dentist',
        date: '20 Nov 2026',
        time: '04:00 PM',
        fee: 32.0,
        clinicLocation: '', // empty to test central location fallback
        status: AdminAppointmentStatus.upcoming,
      );

      await repository.addAppointment(newApt);

      final appointments = await repository.getAppointments();
      expect(appointments.first.id, 'new_apt_100');
      expect(appointments.first.clinicLocation, repository.centralLocation);
      expect(appointments.first.status, AdminAppointmentStatus.upcoming);
    });

    test('updateAppointmentStatus updates the target appointment status', () async {
      final appointmentsBefore = await repository.getAppointments();
      final targetApt = appointmentsBefore.firstWhere((a) => a.status == AdminAppointmentStatus.upcoming);

      await repository.updateAppointmentStatus(targetApt.id, AdminAppointmentStatus.completed);

      final appointmentsAfter = await repository.getAppointments();
      final updated = appointmentsAfter.firstWhere((a) => a.id == targetApt.id);
      expect(updated.status, AdminAppointmentStatus.completed);
    });

    test('edge case: updateAppointmentStatus with non-existent id gracefully does nothing', () async {
      final before = await repository.getAppointments();
      final beforeLength = before.length;

      await repository.updateAppointmentStatus('non_existent_apt_id', AdminAppointmentStatus.cancelled);

      final after = await repository.getAppointments();
      expect(after.length, beforeLength);
    });
  });

  group('Doctor Reviews & Rating Recalculation (Edge Cases)', () {
    test('addDoctorReview updates appointment rating and reviewText', () async {
      final review = DoctorReviewModel(
        id: 'test_rev_1',
        appointmentId: 'apt_1',
        patientId: 'pat_1',
        doctorId: 'doc_3',
        rating: 4.0,
        comment: 'Great appointment experience',
        createdAt: DateTime.now(),
      );

      await repository.addDoctorReview(review);

      final appointments = await repository.getAppointments();
      final apt = appointments.firstWhere((a) => a.id == 'apt_1');
      expect(apt.rating, 4.0);
      expect(apt.reviewText, 'Great appointment experience');
    });

    test('addDoctorReview recalculates doctor rating average and review count', () async {
      final docBefore = repository.findDoctorById('doc_1');
      expect(docBefore, isNotNull);
      final initialReviewCount = docBefore!.reviewsCount;

      final review = DoctorReviewModel(
        id: 'rev_calc_1',
        appointmentId: 'apt_test',
        patientId: 'pat_test',
        doctorId: 'doc_1',
        rating: 4.0,
        comment: 'Good doctor',
        createdAt: DateTime.now(),
      );

      await repository.addDoctorReview(review);

      final docAfter = repository.findDoctorById('doc_1');
      expect(docAfter!.reviewsCount, initialReviewCount + 1);
      expect(docAfter.rating, isA<double>());
      expect(docAfter.rating, inInclusiveRange(1.0, 5.0));
    });

    test('getDoctorReviews returns filtered reviews for specific doctor', () async {
      final reviewsDoc1 = await repository.getDoctorReviews('doc_1');
      for (final r in reviewsDoc1) {
        expect(r.doctorId, 'doc_1');
      }

      // Edge case: doctor with no reviews returns empty list
      final emptyReviews = await repository.getDoctorReviews('doc_non_existent');
      expect(emptyReviews, isEmpty);
    });
  });

  group('Doctor Lookups - Happy Path & Edge Cases', () {
    test('findDoctorById returns correct doctor for valid ID', () {
      final doc = repository.findDoctorById('doc_2');
      expect(doc, isNotNull);
      expect(doc!.id, 'doc_2');
      expect(doc.name, 'Dr. Shruti Kedia');
    });

    test('edge case: findDoctorById returns fallback doctor if ID does not exist', () {
      final doc = repository.findDoctorById('unknown_id');
      expect(doc, isNotNull);
    });

    test('findDoctorByName handles case-insensitivity and whitespace trimming', () {
      final doc1 = repository.findDoctorByName('dr. fillerup grab');
      expect(doc1, isNotNull);
      expect(doc1!.id, 'doc_1');

      final doc2 = repository.findDoctorByName('   DR. SHRUTI KEDIA   ');
      expect(doc2, isNotNull);
      expect(doc2!.id, 'doc_2');
    });

    test('edge case: findDoctorByName returns null when doctor is not found', () {
      final doc = repository.findDoctorByName('Dr. Completely Fictional Nonexistent');
      expect(doc, isNull);
    });
  });
}


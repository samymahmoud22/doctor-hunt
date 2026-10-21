import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:doctor_hunt/core/utils/doctor_image_helper.dart';
import 'package:doctor_hunt/generated/image_assets.dart';
import '../models/admin_doctor_model.dart';
import '../models/admin_appointment_model.dart';
import '../../../patient/doctors/data/models/doctor_review_model.dart';

class AdminRepository {
  final SupabaseClient _client;
  static const String _defaultCentralLocation = 'DoctorHunt HQ Clinic • 24 Garden Avenue';

  AdminRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Map<String, String> _adminProfile = {
    'fullName': 'Ahmed Khaled',
    'email': 'admin@doctorhunt.com',
    'clinicLocation': _defaultCentralLocation,
    'initials': 'AK',
  };

  String get centralLocation => _adminProfile['clinicLocation'] ?? _defaultCentralLocation;

  final Set<String> _favoriteDoctorIds = {'doc_1', 'doc_2', 'doc_3', 'doc_5'};

  final List<DoctorReviewModel> _reviews = [
    DoctorReviewModel(
      id: 'rev_1',
      appointmentId: 'apt_3',
      patientId: 'pat_1',
      doctorId: 'doc_1',
      rating: 5.0,
      comment: 'Very professional, attentive, and reassuring consultation.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    DoctorReviewModel(
      id: 'rev_2',
      appointmentId: 'apt_4',
      patientId: 'pat_2',
      doctorId: 'doc_1',
      rating: 4.6,
      comment: 'Clear explanation of treatment plan. Highly recommended!',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    DoctorReviewModel(
      id: 'rev_3',
      appointmentId: 'apt_4b',
      patientId: 'pat_3',
      doctorId: 'doc_2',
      rating: 4.8,
      comment: 'Great orthopedic specialist, answered all my concerns patiently.',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  late final List<AdminDoctorModel> _doctors = [
    AdminDoctorModel(
      id: 'doc_1',
      name: 'Dr. Fillerup Grab',
      specialty: 'Medicine Specialist',
      rating: 5.0,
      reviewsCount: 520,
      consultationFee: 28.0,
      isActive: true,
      imageUrl: ImageAssets.doctorPopularFemale,
      clinicLocation: centralLocation,
      workingDays: const {
        'Monday': true,
        'Tuesday': true,
        'Wednesday': true,
        'Thursday': true,
        'Friday': true,
        'Saturday': false,
        'Sunday': false,
      },
      startTime: '09:00 AM',
      endTime: '05:00 PM',
      slotDuration: '30 Minutes',
    ),
    AdminDoctorModel(
      id: 'doc_2',
      name: 'Dr. Shruti Kedia',
      specialty: 'Specialist Dentist',
      rating: 4.9,
      reviewsCount: 420,
      consultationFee: 32.0,
      isActive: true,
      imageUrl: ImageAssets.doctorCard1,
      clinicLocation: 'Upasana Dental Clinic, salt lake',
      workingDays: const {
        'Monday': true,
        'Tuesday': true,
        'Wednesday': true,
        'Thursday': true,
        'Friday': true,
        'Saturday': true,
        'Sunday': false,
      },
      startTime: '10:00 AM',
      endTime: '07:00 PM',
      slotDuration: '30 Minutes',
    ),
    AdminDoctorModel(
      id: 'doc_3',
      name: 'Dr. Ananya Shah',
      specialty: 'Specialist Cardiologist',
      rating: 4.8,
      reviewsCount: 380,
      consultationFee: 28.0,
      isActive: true,
      imageUrl: ImageAssets.doctorCard2,
      clinicLocation: centralLocation,
      workingDays: const {
        'Monday': true,
        'Tuesday': true,
        'Wednesday': true,
        'Thursday': true,
        'Friday': true,
        'Saturday': false,
        'Sunday': false,
      },
      startTime: '09:00 AM',
      endTime: '04:00 PM',
      slotDuration: '30 Minutes',
    ),
    AdminDoctorModel(
      id: 'doc_4',
      name: 'Dr. Sarah Tranquilli',
      specialty: 'Specialist Medicine',
      rating: 4.9,
      reviewsCount: 289,
      consultationFee: 30.0,
      isActive: true,
      imageUrl: ImageAssets.doctorCard3,
      clinicLocation: centralLocation,
      workingDays: const {
        'Monday': true,
        'Tuesday': true,
        'Wednesday': true,
        'Thursday': true,
        'Friday': true,
        'Saturday': true,
        'Sunday': false,
      },
      startTime: '08:30 AM',
      endTime: '05:00 PM',
      slotDuration: '30 Minutes',
    ),
    AdminDoctorModel(
      id: 'doc_5',
      name: 'Dr. Luke Whitesell',
      specialty: 'Specialist Cardiology',
      rating: 4.7,
      reviewsCount: 275,
      consultationFee: 35.0,
      isActive: true,
      imageUrl: ImageAssets.doctorMaleScrubs,
      clinicLocation: centralLocation,
      workingDays: const {
        'Monday': true,
        'Tuesday': true,
        'Wednesday': false,
        'Thursday': true,
        'Friday': true,
        'Saturday': false,
        'Sunday': false,
      },
      startTime: '09:00 AM',
      endTime: '03:30 PM',
      slotDuration: '30 Minutes',
    ),
    AdminDoctorModel(
      id: 'doc_6',
      name: 'Dr. Emily Shoemaker',
      specialty: 'Specialist Pathology',
      rating: 4.6,
      reviewsCount: 282,
      consultationFee: 26.0,
      isActive: true,
      imageUrl: ImageAssets.doctorCard4,
      clinicLocation: centralLocation,
      workingDays: const {
        'Monday': true,
        'Tuesday': true,
        'Wednesday': true,
        'Thursday': true,
        'Friday': true,
        'Saturday': false,
        'Sunday': false,
      },
      startTime: '10:00 AM',
      endTime: '05:00 PM',
      slotDuration: '30 Minutes',
    ),
    AdminDoctorModel(
      id: 'doc_7',
      name: 'Dr. Michael Bonebreak',
      specialty: 'Specialist Dentist',
      rating: 4.8,
      reviewsCount: 195,
      consultationFee: 24.0,
      isActive: true,
      imageUrl: ImageAssets.doctorMaleCoat,
      clinicLocation: centralLocation,
      workingDays: const {
        'Monday': true,
        'Tuesday': true,
        'Wednesday': true,
        'Thursday': true,
        'Friday': false,
        'Saturday': true,
        'Sunday': false,
      },
      startTime: '09:00 AM',
      endTime: '04:30 PM',
      slotDuration: '30 Minutes',
    ),
    AdminDoctorModel(
      id: 'doc_8',
      name: 'Dr. Crick',
      specialty: 'Specialist Orthopedic',
      rating: 4.9,
      reviewsCount: 310,
      consultationFee: 25.0,
      isActive: true,
      imageUrl: ImageAssets.doctorFeature1,
      clinicLocation: centralLocation,
      workingDays: const {
        'Monday': true,
        'Tuesday': true,
        'Wednesday': true,
        'Thursday': true,
        'Friday': true,
        'Saturday': true,
        'Sunday': false,
      },
      startTime: '09:00 AM',
      endTime: '05:00 PM',
      slotDuration: '30 Minutes',
    ),
    AdminDoctorModel(
      id: 'doc_9',
      name: 'Dr. Strain',
      specialty: 'Specialist Eye',
      rating: 4.8,
      reviewsCount: 290,
      consultationFee: 22.0,
      isActive: true,
      imageUrl: ImageAssets.doctorFeature3,
      clinicLocation: centralLocation,
      workingDays: const {
        'Monday': true,
        'Tuesday': true,
        'Wednesday': true,
        'Thursday': true,
        'Friday': true,
        'Saturday': false,
        'Sunday': false,
      },
      startTime: '10:00 AM',
      endTime: '06:00 PM',
      slotDuration: '30 Minutes',
    ),
  ];

  late final List<AdminAppointmentModel> _appointments = [
    AdminAppointmentModel(
      id: 'apt_1',
      patientName: 'Maya Patel',
      patientEmail: 'maya.patel@example.com',
      doctorId: 'doc_3',
      doctorName: 'Dr. Ananya Shah',
      doctorSpecialty: 'Specialist Cardiologist',
      date: '02 Oct 2026',
      time: '10:30 AM',
      fee: 28.0,
      clinicLocation: centralLocation,
      status: AdminAppointmentStatus.upcoming,
    ),
    AdminAppointmentModel(
      id: 'apt_2',
      patientName: 'James Wilson',
      patientEmail: 'james.wilson@example.com',
      doctorId: 'doc_2',
      doctorName: 'Dr. Shruti Kedia',
      doctorSpecialty: 'Specialist Dentist',
      date: '08 Oct 2026',
      time: '02:00 PM',
      fee: 32.0,
      clinicLocation: 'Upasana Dental Clinic, salt lake',
      status: AdminAppointmentStatus.upcoming,
    ),
    AdminAppointmentModel(
      id: 'apt_3',
      patientName: 'Olivia Martin',
      patientEmail: 'olivia.martin@example.com',
      doctorId: 'doc_4',
      doctorName: 'Dr. Sarah Tranquilli',
      doctorSpecialty: 'Specialist Medicine',
      date: '21 Sep 2026',
      time: '09:00 AM',
      fee: 30.0,
      clinicLocation: centralLocation,
      status: AdminAppointmentStatus.completed,
    ),
    AdminAppointmentModel(
      id: 'apt_4',
      patientName: 'Daniel Kim',
      patientEmail: 'daniel.kim@example.com',
      doctorId: 'doc_7',
      doctorName: 'Dr. Michael Bonebreak',
      doctorSpecialty: 'Specialist Dentist',
      date: '12 Sep 2026',
      time: '04:30 PM',
      fee: 24.0,
      clinicLocation: centralLocation,
      status: AdminAppointmentStatus.completed,
    ),
    AdminAppointmentModel(
      id: 'apt_5',
      patientName: 'Sophia Clark',
      patientEmail: 'sophia.clark@example.com',
      doctorId: 'doc_5',
      doctorName: 'Dr. Luke Whitesell',
      doctorSpecialty: 'Specialist Cardiology',
      date: '30 Aug 2026',
      time: '11:00 AM',
      fee: 35.0,
      clinicLocation: centralLocation,
      status: AdminAppointmentStatus.cancelled,
    ),
    AdminAppointmentModel(
      id: 'apt_6',
      patientName: 'Ethan Brooks',
      patientEmail: 'ethan.brooks@example.com',
      doctorId: 'doc_6',
      doctorName: 'Dr. Emily Shoemaker',
      doctorSpecialty: 'Specialist Pathology',
      date: '18 Aug 2026',
      time: '03:30 PM',
      fee: 26.0,
      clinicLocation: centralLocation,
      status: AdminAppointmentStatus.cancelled,
    ),
  ];

  AdminDoctorModel? findDoctorById(String id) {
    try {
      return _doctors.firstWhere((d) => d.id == id);
    } catch (_) {
      return _doctors.isNotEmpty ? _doctors.first : null;
    }
  }

  AdminDoctorModel? findDoctorByName(String name) {
    try {
      final clean = name.toLowerCase().trim();
      return _doctors.firstWhere(
        (d) => d.name.toLowerCase().trim() == clean,
      );
    } catch (_) {
      return null;
    }
  }

  Future<List<AdminDoctorModel>> getDoctors() async {
    try {
      final response = await _client
          .from('doctors')
          .select()
          .order('name', ascending: true);

      final list = (response as List)
          .map((item) => AdminDoctorModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();

      if (list.isNotEmpty) {
        _doctors.clear();
        _doctors.addAll(list);
      } else {
        // Table is empty, seed defaults in the background
        _seedDefaultDoctors();
      }
    } catch (e) {
      debugPrint('Supabase getDoctors warning (using local fallback): $e');
    }
    return List.unmodifiable(_doctors);
  }

  Future<void> _seedDefaultDoctors() async {
    try {
      for (final doc in _doctors) {
        await _client.from('doctors').upsert(doc.toJson());
      }
    } catch (e) {
      debugPrint('Supabase seedDefaultDoctors warning: $e');
    }
  }

  Future<void> addDoctor(AdminDoctorModel doctor) async {
    final photo = (doctor.imageUrl != null && doctor.imageUrl!.isNotEmpty)
        ? doctor.imageUrl!
        : DoctorImageHelper.getDoctorPhoto(doctor.name);
    final docWithCentralLocation = doctor.copyWith(
      clinicLocation: centralLocation,
      imageUrl: photo,
    );
    _doctors.insert(0, docWithCentralLocation);
    try {
      await _client.from('doctors').insert(docWithCentralLocation.toJson());
    } catch (e) {
      debugPrint('Supabase addDoctor warning: $e');
    }
  }

  Future<void> updateDoctor(AdminDoctorModel updatedDoctor) async {
    final docWithCentralLocation = updatedDoctor.copyWith(clinicLocation: centralLocation);
    final index = _doctors.indexWhere((d) => d.id == updatedDoctor.id);
    if (index != -1) {
      _doctors[index] = docWithCentralLocation;
    }
    try {
      await _client
          .from('doctors')
          .update(docWithCentralLocation.toJson())
          .eq('id', updatedDoctor.id);
    } catch (e) {
      debugPrint('Supabase updateDoctor warning: $e');
    }
  }

  Future<void> toggleDoctorStatus(String id, bool isActive) async {
    final index = _doctors.indexWhere((d) => d.id == id);
    if (index != -1) {
      _doctors[index] = _doctors[index].copyWith(isActive: isActive);
    }
    try {
      await _client.from('doctors').update({'is_active': isActive}).eq('id', id);
    } catch (e) {
      debugPrint('Supabase toggleDoctorStatus warning: $e');
    }
  }

  Future<void> deleteDoctor(String id) async {
    _doctors.removeWhere((d) => d.id == id);
    _favoriteDoctorIds.remove(id);
    try {
      await _client.from('doctors').delete().eq('id', id);
    } catch (e) {
      debugPrint('Supabase deleteDoctor warning: $e');
    }
  }

  bool isFavorite(String doctorId) => _favoriteDoctorIds.contains(doctorId);

  void toggleFavorite(String doctorId) {
    if (_favoriteDoctorIds.contains(doctorId)) {
      _favoriteDoctorIds.remove(doctorId);
    } else {
      _favoriteDoctorIds.add(doctorId);
    }
  }

  Set<String> get favoriteDoctorIds => Set.unmodifiable(_favoriteDoctorIds);

  Future<List<AdminAppointmentModel>> getAppointments() async {
    try {
      final response = await _client
          .from('appointments')
          .select()
          .order('date', ascending: false);

      final list = (response as List)
          .map((item) => AdminAppointmentModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();

      if (list.isNotEmpty) {
        _appointments.clear();
        _appointments.addAll(list);
      }
    } catch (e) {
      debugPrint('Supabase getAppointments warning: $e');
    }
    return List.unmodifiable(_appointments);
  }

  Future<void> addAppointment(AdminAppointmentModel appointment) async {
    final aptWithCentralLocation = appointment.copyWith(clinicLocation: centralLocation);
    _appointments.insert(0, aptWithCentralLocation);
    try {
      await _client.from('appointments').insert(aptWithCentralLocation.toJson());
    } catch (e) {
      debugPrint('Supabase addAppointment warning: $e');
    }
  }

  Future<void> updateAppointmentStatus(
    String id,
    AdminAppointmentStatus newStatus,
  ) async {
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(status: newStatus);
    }
    try {
      await _client.from('appointments').update({'status': newStatus.name}).eq('id', id);
    } catch (e) {
      debugPrint('Supabase updateAppointmentStatus warning: $e');
    }
  }

  Future<List<DoctorReviewModel>> getDoctorReviews(String doctorId) async {
    try {
      final response = await _client
          .from('reviews')
          .select()
          .eq('doctor_id', doctorId)
          .order('created_at', ascending: false);

      final list = (response as List)
          .map((item) => DoctorReviewModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();

      if (list.isNotEmpty) {
        return list;
      }
    } catch (e) {
      debugPrint('Supabase getDoctorReviews warning: $e');
    }
    return _reviews.where((r) => r.doctorId == doctorId).toList();
  }

  Future<void> addDoctorReview(DoctorReviewModel review) async {
    _reviews.insert(0, review);

    final aptIndex = _appointments.indexWhere((a) => a.id == review.appointmentId);
    if (aptIndex != -1) {
      _appointments[aptIndex] = _appointments[aptIndex].copyWith(
        rating: review.rating,
        reviewText: review.comment,
      );
    }

    final docIndex = _doctors.indexWhere((d) => d.id == review.doctorId);
    if (docIndex != -1) {
      final docReviews = _reviews.where((r) => r.doctorId == review.doctorId).toList();
      final totalRating = docReviews.fold<double>(0.0, (sum, r) => sum + r.rating);
      final newAvg = double.parse((totalRating / docReviews.length).toStringAsFixed(1));

      _doctors[docIndex] = _doctors[docIndex].copyWith(
        rating: newAvg,
        reviewsCount: _doctors[docIndex].reviewsCount + 1,
      );
    }

    try {
      await _client.from('reviews').insert(review.toJson());
      if (aptIndex != -1) {
        await _client.from('appointments').update({
          'rating': review.rating,
          'review_text': review.comment,
        }).eq('id', review.appointmentId);
      }
      if (docIndex != -1) {
        await _client.from('doctors').update({
          'rating': _doctors[docIndex].rating,
          'reviews_count': _doctors[docIndex].reviewsCount,
        }).eq('id', review.doctorId);
      }
    } catch (e) {
      debugPrint('Supabase addDoctorReview warning: $e');
    }
  }

  Future<Map<String, String>> getAdminProfile() async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser != null) {
        final meta = currentUser.userMetadata;
        final fullName = (meta?['full_name'] as String?) ??
            (meta?['name'] as String?) ??
            _adminProfile['fullName']!;
        final email = currentUser.email ?? _adminProfile['email']!;
        final location = (meta?['clinic_location'] as String?) ?? _adminProfile['clinicLocation']!;
        final initials = fullName
            .trim()
            .split(' ')
            .take(2)
            .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
            .join();

        _adminProfile = {
          'fullName': fullName,
          'email': email,
          'clinicLocation': location,
          'initials': initials.isEmpty ? 'AK' : initials,
        };
      }
    } catch (e) {
      debugPrint('Supabase getAdminProfile warning: $e');
    }
    return Map.unmodifiable(_adminProfile);
  }

  Future<void> updateAdminProfile({
    required String fullName,
    required String email,
    required String clinicLocation,
  }) async {
    final initials = fullName
        .trim()
        .split(' ')
        .take(2)
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
        .join();

    _adminProfile = {
      'fullName': fullName,
      'email': email,
      'clinicLocation': clinicLocation,
      'initials': initials.isEmpty ? 'AK' : initials,
    };

    for (int i = 0; i < _doctors.length; i++) {
      _doctors[i] = _doctors[i].copyWith(clinicLocation: clinicLocation);
    }
    for (int i = 0; i < _appointments.length; i++) {
      _appointments[i] = _appointments[i].copyWith(clinicLocation: clinicLocation);
    }

    try {
      await _client.auth.updateUser(
        UserAttributes(
          data: {
            'full_name': fullName,
            'clinic_location': clinicLocation,
          },
        ),
      );
    } catch (e) {
      debugPrint('Supabase updateAdminProfile warning: $e');
    }
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/patient_appointment_model.dart';
import '../../../../admin/data/repo/admin_repository.dart';
import '../../../../admin/data/models/admin_appointment_model.dart';
import '../../../doctors/data/models/doctor_review_model.dart';

class PatientAppointmentsRepository {
  final AdminRepository adminRepository;

  PatientAppointmentsRepository({required this.adminRepository});

  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

  Future<List<PatientAppointmentModel>> getAppointments() async {
    final adminApts = await adminRepository.getAppointments();

    // Filter to only show appointments for the current patient
    final userId = _currentUserId;
    final filteredApts = userId != null
        ? adminApts.where((a) => a.patientId == userId || a.patientId == null).toList()
        : adminApts;

    return filteredApts.map((a) {
      PatientAppointmentStatus pStatus;
      switch (a.status) {
        case AdminAppointmentStatus.upcoming:
          pStatus = PatientAppointmentStatus.upcoming;
          break;
        case AdminAppointmentStatus.completed:
          pStatus = PatientAppointmentStatus.completed;
          break;
        case AdminAppointmentStatus.cancelled:
          pStatus = PatientAppointmentStatus.cancelled;
          break;
      }

      return PatientAppointmentModel(
        id: a.id,
        doctorId: a.doctorId ?? 'doc_1',
        doctorName: a.doctorName,
        doctorSpecialty: a.doctorSpecialty,
        doctorAvatar: a.doctorAvatar,
        date: a.date,
        time: a.time,
        fee: a.fee,
        clinicLocation: adminRepository.centralLocation,
        status: pStatus,
        rating: a.rating,
        userRating: a.rating,
        reviewComment: a.reviewText,
        isRated: a.rating != null,
      );
    }).toList();
  }

  Future<void> bookAppointment(PatientAppointmentModel appointment) async {
    final currentUser = Supabase.instance.client.auth.currentUser;
    final metadata = currentUser?.userMetadata;
    final patientName = (metadata?['full_name'] as String?) ??
        (metadata?['name'] as String?) ??
        'Patient';
    final patientEmail = currentUser?.email ?? 'patient@doctorhunt.com';
    final patientId = currentUser?.id;

    final adminApt = AdminAppointmentModel(
      id: appointment.id,
      patientId: patientId,
      patientName: patientName,
      patientEmail: patientEmail,
      doctorId: appointment.doctorId,
      doctorName: appointment.doctorName,
      doctorSpecialty: appointment.doctorSpecialty,
      date: appointment.date,
      time: appointment.time,
      fee: appointment.fee,
      clinicLocation: appointment.clinicLocation.isNotEmpty
          ? appointment.clinicLocation
          : adminRepository.centralLocation,
      status: AdminAppointmentStatus.upcoming,
    );
    await adminRepository.addAppointment(adminApt);
  }

  Future<void> cancelAppointment(String id) async {
    await adminRepository.updateAppointmentStatus(id, AdminAppointmentStatus.cancelled);
  }

  Future<void> rateDoctor(String id, double rating, {String? comment}) async {
    final apts = await adminRepository.getAppointments();
    final apt = apts.firstWhere((a) => a.id == id, orElse: () => apts.first);

    final doctors = await adminRepository.getDoctors();
    final doc = doctors.firstWhere(
      (d) => d.name == apt.doctorName,
      orElse: () => doctors.first,
    );

    final currentUser = Supabase.instance.client.auth.currentUser;
    final patientId = currentUser?.id ?? 'patient_me';

    final review = DoctorReviewModel(
      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
      appointmentId: id,
      patientId: patientId,
      doctorId: doc.id,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );

    await adminRepository.addDoctorReview(review);
  }
}

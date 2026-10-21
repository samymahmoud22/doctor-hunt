import 'package:equatable/equatable.dart';

enum AdminAppointmentStatus {
  upcoming,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case AdminAppointmentStatus.upcoming:
        return 'Upcoming';
      case AdminAppointmentStatus.completed:
        return 'Completed';
      case AdminAppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class AdminAppointmentModel extends Equatable {
  final String id;
  final String? patientId;
  final String patientName;
  final String patientEmail;
  final String? patientAvatar;
  final String? doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String? doctorAvatar;
  final String date;
  final String time;
  final double fee;
  final String clinicLocation;
  final AdminAppointmentStatus status;
  final double? rating;
  final String? reviewText;

  const AdminAppointmentModel({
    required this.id,
    this.patientId,
    required this.patientName,
    required this.patientEmail,
    this.patientAvatar,
    this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    this.doctorAvatar,
    required this.date,
    required this.time,
    required this.fee,
    this.clinicLocation = 'Central Clinic • 24 Garden Avenue',
    required this.status,
    this.rating,
    this.reviewText,
  });

  AdminAppointmentModel copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? patientEmail,
    String? patientAvatar,
    String? doctorId,
    String? doctorName,
    String? doctorSpecialty,
    String? doctorAvatar,
    String? date,
    String? time,
    double? fee,
    String? clinicLocation,
    AdminAppointmentStatus? status,
    double? rating,
    String? reviewText,
  }) {
    return AdminAppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientEmail: patientEmail ?? this.patientEmail,
      patientAvatar: patientAvatar ?? this.patientAvatar,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialty: doctorSpecialty ?? this.doctorSpecialty,
      doctorAvatar: doctorAvatar ?? this.doctorAvatar,
      date: date ?? this.date,
      time: time ?? this.time,
      fee: fee ?? this.fee,
      clinicLocation: clinicLocation ?? this.clinicLocation,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
    );
  }

  factory AdminAppointmentModel.fromJson(Map<String, dynamic> json) {
    final statusStr = (json['status'] ?? 'upcoming').toString().toLowerCase();
    AdminAppointmentStatus parsedStatus;
    if (statusStr.contains('completed')) {
      parsedStatus = AdminAppointmentStatus.completed;
    } else if (statusStr.contains('cancel')) {
      parsedStatus = AdminAppointmentStatus.cancelled;
    } else {
      parsedStatus = AdminAppointmentStatus.upcoming;
    }

    return AdminAppointmentModel(
      id: (json['id'] ?? '').toString(),
      patientId: json['patient_id']?.toString() ?? json['patientId']?.toString(),
      patientName: (json['patient_name'] ?? json['patientName'] ?? 'Patient').toString(),
      patientEmail: (json['patient_email'] ?? json['patientEmail'] ?? '').toString(),
      patientAvatar: json['patient_avatar'] ?? json['patientAvatar'],
      doctorId: json['doctor_id']?.toString() ?? json['doctorId']?.toString(),
      doctorName: (json['doctor_name'] ?? json['doctorName'] ?? 'Doctor').toString(),
      doctorSpecialty: (json['doctor_specialty'] ?? json['doctorSpecialty'] ?? 'Specialist').toString(),
      doctorAvatar: json['doctor_avatar'] ?? json['doctorAvatar'],
      date: (json['date'] ?? '').toString(),
      time: (json['time'] ?? '').toString(),
      fee: ((json['fee'] ?? 28.0) as num).toDouble(),
      clinicLocation: (json['clinic_location'] ?? json['clinicLocation'] ?? 'Central Clinic • 24 Garden Avenue').toString(),
      status: parsedStatus,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      reviewText: json['review_text'] ?? json['reviewText'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'patient_name': patientName,
      'patient_email': patientEmail,
      'patient_avatar': patientAvatar,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'doctor_specialty': doctorSpecialty,
      'doctor_avatar': doctorAvatar,
      'date': date,
      'time': time,
      'fee': fee,
      'clinic_location': clinicLocation,
      'status': status.name,
      'rating': rating,
      'review_text': reviewText,
    };
  }

  @override
  List<Object?> get props => [
        id,
        patientId,
        patientName,
        patientEmail,
        patientAvatar,
        doctorId,
        doctorName,
        doctorSpecialty,
        doctorAvatar,
        date,
        time,
        fee,
        clinicLocation,
        status,
        rating,
        reviewText,
      ];
}


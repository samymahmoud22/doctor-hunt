import 'package:equatable/equatable.dart';

enum PatientAppointmentStatus {
  upcoming,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case PatientAppointmentStatus.upcoming:
        return 'Upcoming';
      case PatientAppointmentStatus.completed:
        return 'Completed';
      case PatientAppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class PatientAppointmentModel extends Equatable {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String? doctorAvatar;
  final String date;
  final String time;
  final double fee;
  final String clinicLocation;
  final PatientAppointmentStatus status;
  final double? rating;
  final double? userRating;
  final String? reviewComment;
  final bool isRated;

  const PatientAppointmentModel({
    required this.id,
    this.doctorId = 'doc_1',
    required this.doctorName,
    required this.doctorSpecialty,
    this.doctorAvatar,
    required this.date,
    required this.time,
    required this.fee,
    this.clinicLocation = 'DoctorHunt HQ Clinic • 24 Garden Avenue',
    required this.status,
    this.rating,
    this.userRating,
    this.reviewComment,
    this.isRated = false,
  });

  PatientAppointmentModel copyWith({
    String? id,
    String? doctorId,
    String? doctorName,
    String? doctorSpecialty,
    String? doctorAvatar,
    String? date,
    String? time,
    double? fee,
    String? clinicLocation,
    PatientAppointmentStatus? status,
    double? rating,
    double? userRating,
    String? reviewComment,
    bool? isRated,
  }) {
    return PatientAppointmentModel(
      id: id ?? this.id,
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
      userRating: userRating ?? this.userRating,
      reviewComment: reviewComment ?? this.reviewComment,
      isRated: isRated ?? this.isRated,
    );
  }

  @override
  List<Object?> get props => [
        id,
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
        userRating,
        reviewComment,
        isRated,
      ];
}

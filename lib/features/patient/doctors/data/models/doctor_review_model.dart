import 'package:equatable/equatable.dart';

class DoctorReviewModel extends Equatable {
  final String id;
  final String appointmentId;
  final String patientId;
  final String doctorId;
  final double rating;
  final String? comment;
  final DateTime createdAt;

  const DoctorReviewModel({
    required this.id,
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory DoctorReviewModel.fromJson(Map<String, dynamic> json) {
    return DoctorReviewModel(
      id: (json['id'] ?? '').toString(),
      appointmentId: (json['appointment_id'] ?? json['appointmentId'] ?? '').toString(),
      patientId: (json['patient_id'] ?? json['patientId'] ?? '').toString(),
      doctorId: (json['doctor_id'] ?? json['doctorId'] ?? '').toString(),
      rating: ((json['rating'] ?? 5.0) as num).toDouble(),
      comment: json['comment'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : (json['createdAt'] is DateTime
              ? json['createdAt'] as DateTime
              : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointment_id': appointmentId,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        appointmentId,
        patientId,
        doctorId,
        rating,
        comment,
        createdAt,
      ];
}


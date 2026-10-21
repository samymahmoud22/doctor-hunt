import 'package:equatable/equatable.dart';

class AdminDoctorModel extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviewsCount;
  final double consultationFee;
  final bool isActive;
  final String? imageUrl;
  final String clinicLocation;
  final Map<String, bool> workingDays;
  final String startTime;
  final String endTime;
  final String slotDuration;

  const AdminDoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    this.rating = 4.8,
    this.reviewsCount = 120,
    this.consultationFee = 28.0,
    this.isActive = true,
    this.imageUrl,
    this.clinicLocation = 'Central Clinic • 24 Garden Avenue',
    this.workingDays = const {
      'Monday': true,
      'Tuesday': true,
      'Wednesday': true,
      'Thursday': true,
      'Friday': true,
      'Saturday': false,
      'Sunday': false,
    },
    this.startTime = '09:00 AM',
    this.endTime = '05:00 PM',
    this.slotDuration = '30 Minutes',
  });

  AdminDoctorModel copyWith({
    String? id,
    String? name,
    String? specialty,
    double? rating,
    int? reviewsCount,
    double? consultationFee,
    bool? isActive,
    String? imageUrl,
    String? clinicLocation,
    Map<String, bool>? workingDays,
    String? startTime,
    String? endTime,
    String? slotDuration,
  }) {
    return AdminDoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      consultationFee: consultationFee ?? this.consultationFee,
      isActive: isActive ?? this.isActive,
      imageUrl: imageUrl ?? this.imageUrl,
      clinicLocation: clinicLocation ?? this.clinicLocation,
      workingDays: workingDays ?? this.workingDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      slotDuration: slotDuration ?? this.slotDuration,
    );
  }

  factory AdminDoctorModel.fromJson(Map<String, dynamic> json) {
    Map<String, bool> parsedWorkingDays = const {
      'Monday': true,
      'Tuesday': true,
      'Wednesday': true,
      'Thursday': true,
      'Friday': true,
      'Saturday': false,
      'Sunday': false,
    };

    if (json['working_days'] != null) {
      if (json['working_days'] is Map) {
        parsedWorkingDays = (json['working_days'] as Map).map(
          (k, v) => MapEntry(k.toString(), v == true),
        );
      }
    } else if (json['workingDays'] != null && json['workingDays'] is Map) {
      parsedWorkingDays = (json['workingDays'] as Map).map(
        (k, v) => MapEntry(k.toString(), v == true),
      );
    }

    return AdminDoctorModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      specialty: (json['specialty'] ?? '').toString(),
      rating: ((json['rating'] ?? 4.8) as num).toDouble(),
      reviewsCount: ((json['reviews_count'] ?? json['reviewsCount'] ?? 0) as num).toInt(),
      consultationFee: ((json['consultation_fee'] ?? json['consultationFee'] ?? 28.0) as num).toDouble(),
      isActive: json['is_active'] ?? json['isActive'] ?? true,
      imageUrl: json['image_url'] ?? json['imageUrl'],
      clinicLocation: (json['clinic_location'] ?? json['clinicLocation'] ?? 'Central Clinic • 24 Garden Avenue').toString(),
      workingDays: parsedWorkingDays,
      startTime: (json['start_time'] ?? json['startTime'] ?? '09:00 AM').toString(),
      endTime: (json['end_time'] ?? json['endTime'] ?? '05:00 PM').toString(),
      slotDuration: (json['slot_duration'] ?? json['slotDuration'] ?? '30 Minutes').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'reviews_count': reviewsCount,
      'consultation_fee': consultationFee,
      'is_active': isActive,
      'image_url': imageUrl,
      'clinic_location': clinicLocation,
      'working_days': workingDays,
      'start_time': startTime,
      'end_time': endTime,
      'slot_duration': slotDuration,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        specialty,
        rating,
        reviewsCount,
        consultationFee,
        isActive,
        imageUrl,
        clinicLocation,
        workingDays,
        startTime,
        endTime,
        slotDuration,
      ];
}


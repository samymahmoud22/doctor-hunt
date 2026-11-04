import 'package:equatable/equatable.dart';
import '../../../../admin/data/models/admin_doctor_model.dart';
import '../../data/models/doctor_review_model.dart';

class DoctorDetailsState extends Equatable {
  final AdminDoctorModel? doctor;
  final List<DoctorReviewModel> reviews;
  final bool isFavorite;
  final bool isLoading;
  final String clinicLocation;
  final String? errorMessage;

  const DoctorDetailsState({
    this.doctor,
    this.reviews = const [],
    this.isFavorite = false,
    this.isLoading = false,
    this.clinicLocation = '',
    this.errorMessage,
  });

  DoctorDetailsState copyWith({
    AdminDoctorModel? doctor,
    List<DoctorReviewModel>? reviews,
    bool? isFavorite,
    bool? isLoading,
    String? clinicLocation,
    String? errorMessage,
  }) {
    return DoctorDetailsState(
      doctor: doctor ?? this.doctor,
      reviews: reviews ?? this.reviews,
      isFavorite: isFavorite ?? this.isFavorite,
      isLoading: isLoading ?? this.isLoading,
      clinicLocation: clinicLocation ?? this.clinicLocation,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [doctor, reviews, isFavorite, isLoading, clinicLocation, errorMessage];
}

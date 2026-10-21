import 'package:equatable/equatable.dart';

class AdminProfileState extends Equatable {
  final String fullName;
  final String email;
  final String clinicLocation;
  final String initials;
  final bool isLoading;
  final String? errorMessage;
  final bool isSaved;

  const AdminProfileState({
    this.fullName = 'Ahmed Khaled',
    this.email = 'admin@doctorhunt.com',
    this.clinicLocation = 'DoctorHunt HQ Clinic',
    this.initials = 'AK',
    this.isLoading = false,
    this.errorMessage,
    this.isSaved = false,
  });

  AdminProfileState copyWith({
    String? fullName,
    String? email,
    String? clinicLocation,
    String? initials,
    bool? isLoading,
    String? errorMessage,
    bool? isSaved,
  }) {
    return AdminProfileState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      clinicLocation: clinicLocation ?? this.clinicLocation,
      initials: initials ?? this.initials,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSaved: isSaved ?? false,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        email,
        clinicLocation,
        initials,
        isLoading,
        errorMessage,
        isSaved,
      ];
}

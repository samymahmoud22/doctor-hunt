import 'package:equatable/equatable.dart';

class PatientProfileState extends Equatable {
  final String fullName;
  final String phone;
  final String email;
  final String? avatarUrl;
  final bool isLoading;
  final bool isSaved;
  final String? errorMessage;

  const PatientProfileState({
    this.fullName = 'Sarah Johnson',
    this.phone = '+201000000000',
    this.email = 'patient@doctorhunt.com',
    this.avatarUrl,
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage,
  });

  PatientProfileState copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? avatarUrl,
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
  }) {
    return PatientProfileState(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [fullName, phone, email, avatarUrl, isLoading, isSaved, errorMessage];
}


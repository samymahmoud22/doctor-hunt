import 'package:equatable/equatable.dart';
import '../../../../admin/data/models/admin_doctor_model.dart';

class PatientDoctorsState extends Equatable {
  final List<AdminDoctorModel> allDoctors;
  final List<AdminDoctorModel> popularDoctors;
  final List<AdminDoctorModel> filteredDoctors;
  final Set<String> favoriteDoctorIds;
  final String searchQuery;
  final String selectedSpecialty;
  final bool onlyFavorites;
  final bool isLoading;
  final String? errorMessage;

  const PatientDoctorsState({
    this.allDoctors = const [],
    this.popularDoctors = const [],
    this.filteredDoctors = const [],
    this.favoriteDoctorIds = const {},
    this.searchQuery = '',
    this.selectedSpecialty = 'All',
    this.onlyFavorites = false,
    this.isLoading = false,
    this.errorMessage,
  });

  bool isFavorite(String doctorId) => favoriteDoctorIds.contains(doctorId);

  PatientDoctorsState copyWith({
    List<AdminDoctorModel>? allDoctors,
    List<AdminDoctorModel>? popularDoctors,
    List<AdminDoctorModel>? filteredDoctors,
    Set<String>? favoriteDoctorIds,
    String? searchQuery,
    String? selectedSpecialty,
    bool? onlyFavorites,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PatientDoctorsState(
      allDoctors: allDoctors ?? this.allDoctors,
      popularDoctors: popularDoctors ?? this.popularDoctors,
      filteredDoctors: filteredDoctors ?? this.filteredDoctors,
      favoriteDoctorIds: favoriteDoctorIds ?? this.favoriteDoctorIds,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedSpecialty: selectedSpecialty ?? this.selectedSpecialty,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        allDoctors,
        popularDoctors,
        filteredDoctors,
        favoriteDoctorIds,
        searchQuery,
        selectedSpecialty,
        onlyFavorites,
        isLoading,
        errorMessage,
      ];
}


import 'package:equatable/equatable.dart';
import '../../data/models/admin_doctor_model.dart';

class AdminDoctorsState extends Equatable {
  final List<AdminDoctorModel> allDoctors;
  final List<AdminDoctorModel> filteredDoctors;
  final String searchQuery;
  final String selectedSpecialty;
  final bool isLoading;
  final String? errorMessage;

  const AdminDoctorsState({
    this.allDoctors = const [],
    this.filteredDoctors = const [],
    this.searchQuery = '',
    this.selectedSpecialty = 'All',
    this.isLoading = false,
    this.errorMessage,
  });

  int get activeDoctorsCount =>
      allDoctors.where((d) => d.isActive).length;

  int get totalDoctorsCount => allDoctors.length;

  List<String> get specialties {
    final set = <String>{'All'};
    for (final doc in allDoctors) {
      set.add(doc.specialty);
    }
    return set.toList();
  }

  AdminDoctorsState copyWith({
    List<AdminDoctorModel>? allDoctors,
    List<AdminDoctorModel>? filteredDoctors,
    String? searchQuery,
    String? selectedSpecialty,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AdminDoctorsState(
      allDoctors: allDoctors ?? this.allDoctors,
      filteredDoctors: filteredDoctors ?? this.filteredDoctors,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedSpecialty: selectedSpecialty ?? this.selectedSpecialty,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        allDoctors,
        filteredDoctors,
        searchQuery,
        selectedSpecialty,
        isLoading,
        errorMessage,
      ];
}

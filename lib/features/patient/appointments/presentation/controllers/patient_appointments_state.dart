import 'package:equatable/equatable.dart';
import '../../data/models/patient_appointment_model.dart';

class PatientAppointmentsState extends Equatable {
  final List<PatientAppointmentModel> allAppointments;
  final PatientAppointmentStatus selectedTab;
  final bool isLoading;
  final String? errorMessage;

  const PatientAppointmentsState({
    this.allAppointments = const [],
    this.selectedTab = PatientAppointmentStatus.upcoming,
    this.isLoading = false,
    this.errorMessage,
  });

  List<PatientAppointmentModel> get upcomingAppointments =>
      allAppointments.where((a) => a.status == PatientAppointmentStatus.upcoming).toList();

  List<PatientAppointmentModel> get completedAppointments =>
      allAppointments.where((a) => a.status == PatientAppointmentStatus.completed).toList();

  List<PatientAppointmentModel> get cancelledAppointments =>
      allAppointments.where((a) => a.status == PatientAppointmentStatus.cancelled).toList();

  List<PatientAppointmentModel> get currentTabAppointments {
    switch (selectedTab) {
      case PatientAppointmentStatus.upcoming:
        return upcomingAppointments;
      case PatientAppointmentStatus.completed:
        return completedAppointments;
      case PatientAppointmentStatus.cancelled:
        return cancelledAppointments;
    }
  }

  PatientAppointmentsState copyWith({
    List<PatientAppointmentModel>? allAppointments,
    PatientAppointmentStatus? selectedTab,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PatientAppointmentsState(
      allAppointments: allAppointments ?? this.allAppointments,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [allAppointments, selectedTab, isLoading, errorMessage];
}

import 'package:equatable/equatable.dart';
import '../../data/models/admin_appointment_model.dart';

enum AdminAppointmentTab {
  all,
  upcoming,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case AdminAppointmentTab.all:
        return 'All';
      case AdminAppointmentTab.upcoming:
        return 'Upcoming';
      case AdminAppointmentTab.completed:
        return 'Completed';
      case AdminAppointmentTab.cancelled:
        return 'Cancelled';
    }
  }
}

class AdminAppointmentsState extends Equatable {
  final List<AdminAppointmentModel> allAppointments;
  final AdminAppointmentTab selectedTab;
  final bool isLoading;
  final String? errorMessage;

  const AdminAppointmentsState({
    this.allAppointments = const [],
    this.selectedTab = AdminAppointmentTab.all,
    this.isLoading = false,
    this.errorMessage,
  });

  List<AdminAppointmentModel> get upcomingAppointments =>
      allAppointments.where((a) => a.status == AdminAppointmentStatus.upcoming).toList();

  List<AdminAppointmentModel> get completedAppointments =>
      allAppointments.where((a) => a.status == AdminAppointmentStatus.completed).toList();

  List<AdminAppointmentModel> get cancelledAppointments =>
      allAppointments.where((a) => a.status == AdminAppointmentStatus.cancelled).toList();

  List<AdminAppointmentModel> get currentTabAppointments {
    switch (selectedTab) {
      case AdminAppointmentTab.all:
        return allAppointments;
      case AdminAppointmentTab.upcoming:
        return upcomingAppointments;
      case AdminAppointmentTab.completed:
        return completedAppointments;
      case AdminAppointmentTab.cancelled:
        return cancelledAppointments;
    }
  }

  AdminAppointmentsState copyWith({
    List<AdminAppointmentModel>? allAppointments,
    AdminAppointmentTab? selectedTab,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AdminAppointmentsState(
      allAppointments: allAppointments ?? this.allAppointments,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [allAppointments, selectedTab, isLoading, errorMessage];
}

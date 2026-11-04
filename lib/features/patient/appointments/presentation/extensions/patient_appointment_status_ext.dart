import 'package:doctor_hunt/features/patient/appointments/data/models/patient_appointment_model.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';

extension PatientAppointmentStatusPresentation on PatientAppointmentStatus {
  /// Localized display label for the presentation layer.
  String get displayLabel {
    switch (this) {
      case PatientAppointmentStatus.upcoming:
        return t.appointments.upcoming;
      case PatientAppointmentStatus.completed:
        return t.appointments.completed;
      case PatientAppointmentStatus.cancelled:
        return t.appointments.cancelled;
    }
  }
}


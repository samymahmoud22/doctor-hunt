import 'package:doctor_hunt/features/admin/data/models/admin_appointment_model.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';

extension AdminAppointmentStatusPresentation on AdminAppointmentStatus {
  /// Localized display label for the presentation layer.
  String get displayLabel {
    switch (this) {
      case AdminAppointmentStatus.upcoming:
        return t.appointments.upcoming;
      case AdminAppointmentStatus.completed:
        return t.appointments.completed;
      case AdminAppointmentStatus.cancelled:
        return t.appointments.cancelled;
    }
  }
}


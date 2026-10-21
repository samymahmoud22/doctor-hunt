enum UserRole {
  patient,
  admin;

  String get value => name;

  bool get isPatient => this == UserRole.patient;
  bool get isAdmin => this == UserRole.admin;

  static UserRole fromString(String? role) {
    if (role == null) return UserRole.patient;
    return UserRole.values.firstWhere(
      (e) => e.name.toLowerCase() == role.toLowerCase(),
      orElse: () => UserRole.patient,
    );
  }
}

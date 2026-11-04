import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:doctor_hunt/core/enums/user_role.dart';
import 'package:doctor_hunt/features/common/auth/data/models/user_model.dart';
import 'package:doctor_hunt/features/common/auth/data/service/auth_service.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  group('UserRole Enum - Edge Cases', () {
    test('fromString resolves correctly for standard values', () {
      expect(UserRole.fromString('patient'), UserRole.patient);
      expect(UserRole.fromString('admin'), UserRole.admin);
    });

    test('fromString handles case insensitivity and whitespace', () {
      expect(UserRole.fromString('ADMIN'), UserRole.admin);
      expect(UserRole.fromString('Patient'), UserRole.patient);
      expect(UserRole.fromString('Admin'), UserRole.admin);
    });

    test('fromString returns patient as fallback for null, empty, or unknown role', () {
      expect(UserRole.fromString(null), UserRole.patient);
      expect(UserRole.fromString(''), UserRole.patient);
      expect(UserRole.fromString('superadmin'), UserRole.patient);
      expect(UserRole.fromString('doctor'), UserRole.patient);
    });

    test('isPatient and isAdmin getters work accurately', () {
      expect(UserRole.patient.isPatient, isTrue);
      expect(UserRole.patient.isAdmin, isFalse);
      expect(UserRole.admin.isAdmin, isTrue);
      expect(UserRole.admin.isPatient, isFalse);
    });
  });

  group('UserModel - Serialization & Equality Edge Cases', () {
    test('fromJson deserializes complete JSON', () {
      final json = {
        'id': 'usr_99',
        'email': 'jane@example.com',
        'fullName': 'Jane Doe',
        'role': 'admin',
      };
      final user = UserModel.fromJson(json);

      expect(user.id, 'usr_99');
      expect(user.email, 'jane@example.com');
      expect(user.fullName, 'Jane Doe');
      expect(user.role, UserRole.admin);
    });

    test('fromJson handles null / missing fields with safe defaults', () {
      final json = <String, dynamic>{};
      final user = UserModel.fromJson(json);

      expect(user.id, '');
      expect(user.email, '');
      expect(user.fullName, '');
      expect(user.role, UserRole.patient);
    });

    test('toJson serializes correctly', () {
      const user = UserModel(
        id: 'usr_1',
        email: 'doc@hunt.com',
        fullName: 'Dr. Hunt',
        role: UserRole.admin,
      );
      final json = user.toJson();

      expect(json, {
        'id': 'usr_1',
        'email': 'doc@hunt.com',
        'fullName': 'Dr. Hunt',
        'role': 'admin',
      });
    });

    test('UserModel equatable value comparison', () {
      const u1 = UserModel(id: '1', email: 'a@b.com', fullName: 'A', role: UserRole.patient);
      const u2 = UserModel(id: '1', email: 'a@b.com', fullName: 'A', role: UserRole.patient);
      const u3 = UserModel(id: '2', email: 'a@b.com', fullName: 'A', role: UserRole.patient);

      expect(u1, equals(u2));
      expect(u1 == u3, isFalse);
    });
  });

  group('AuthService - Demo Accounts & Offline Resilience Edge Cases', () {
    test('admin demo emails bypass network and return admin user immediately', () async {
      final mockClient = MockSupabaseClient();
      final authService = AuthService(client: mockClient);

      final emailsToTest = [
        'admin@doctorhunt.com',
        'admin@demo.com',
        'admin@admin.com',
        '  ADMIN@DEMO.COM ', // case insensitive and trimmed
        'admin@doctorhunt.com  ',
      ];

      for (final email in emailsToTest) {
        final user = await authService.login(
          email: email,
          password: 'any_password',
          role: UserRole.admin,
        );

        expect(user.id, 'admin_demo_id');
        expect(user.role, UserRole.admin);
        expect(user.email, email.trim().toLowerCase());
        expect(user.fullName, 'Ahmed Khaled (Admin)');
      }
    });

    test('patient demo emails bypass network and return patient user immediately', () async {
      final mockClient = MockSupabaseClient();
      final authService = AuthService(client: mockClient);

      final emailsToTest = [
        'patient@doctorhunt.com',
        'patient@demo.com',
        'patient@patient.com',
        '  PATIENT@DOCTORHUNT.COM ', // case insensitive and trimmed
      ];

      for (final email in emailsToTest) {
        final user = await authService.login(
          email: email,
          password: 'any_password',
          role: UserRole.patient,
        );

        expect(user.id, 'patient_demo_id');
        expect(user.role, UserRole.patient);
        expect(user.email, email.trim().toLowerCase());
        expect(user.fullName, 'Sarah Johnson');
      }
    });
  });
}

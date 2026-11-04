import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/features/common/choose_role/presentation/widgets/role_card.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: child),
      ),
    );
  }

  group('RoleCard Widget Tests', () {
    testWidgets('renders title, description, and icon', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          RoleCard(
            title: 'Patient',
            description: 'Find doctors and book appointments',
            icon: Icons.person,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Patient'), findsOneWidget);
      expect(find.text('Find doctors and book appointments'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('shows checkmark indicator when isSelected is true', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          RoleCard(
            title: 'Admin',
            description: 'Manage clinics and doctors',
            icon: Icons.admin_panel_settings,
            isSelected: true,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Admin'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('triggers onTap callback when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        createTestWidget(
          RoleCard(
            title: 'Patient',
            description: 'Patient role',
            icon: Icons.person,
            isSelected: false,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('Patient'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}


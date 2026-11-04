import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/core/widgets/custom_text_field.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }

  group('CustomTextField Widget Tests', () {
    testWidgets('renders label and hint text', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const CustomTextField(
            label: 'Email Address',
            hint: 'Enter your email',
          ),
        ),
      );

      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('entering text updates controller and triggers onChanged', (tester) async {
      final controller = TextEditingController();
      String changedText = '';

      await tester.pumpWidget(
        createTestWidget(
          CustomTextField(
            hint: 'Full Name',
            controller: controller,
            onChanged: (val) {
              changedText = val;
            },
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Sarah Connor');
      await tester.pump();

      expect(controller.text, 'Sarah Connor');
      expect(changedText, 'Sarah Connor');
    });

    testWidgets('renders prefix icon when supplied', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const CustomTextField(
            hint: 'Search doctor',
            prefixIcon: Icons.search,
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('password field: toggles visibility on icon tap (Edge Case)', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const CustomTextField(
            hint: 'Password',
            isPassword: true,
          ),
        ),
      );

      // Initially obscureText should be true
      final initialEditable = tester.widget<EditableText>(find.byType(EditableText));
      expect(initialEditable.obscureText, isTrue);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      // Tap toggle button
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Now obscureText should be false
      final toggledEditable = tester.widget<EditableText>(find.byType(EditableText));
      expect(toggledEditable.obscureText, isFalse);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Tap toggle button again
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // ObscureText returns to true
      final revertedEditable = tester.widget<EditableText>(find.byType(EditableText));
      expect(revertedEditable.obscureText, isTrue);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('form validation: shows error when input is invalid (Edge Case)', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        createTestWidget(
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  hint: 'Email',
                  validator: (val) {
                    if (val == null || !val.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    formKey.currentState!.validate();
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      );

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField), 'invalidemail');
      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);

      // Enter valid email
      await tester.enterText(find.byType(TextFormField), 'valid@doctorhunt.com');
      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsNothing);
    });
  });
}


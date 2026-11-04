import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/core/utils/debouncer.dart';
import 'package:doctor_hunt/core/widgets/custom_text_field.dart';

void main() {
  group('Debouncer Unit Tests', () {
    test('executes action after specified delay', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 100));
      int callCount = 0;

      expect(debouncer.isRunning, isFalse);
      expect(debouncer.isActive, isFalse);

      debouncer.run(() {
        callCount++;
      });

      expect(debouncer.isRunning, isTrue);
      expect(debouncer.isActive, isTrue);
      expect(callCount, 0);

      await Future.delayed(const Duration(milliseconds: 120));

      expect(callCount, 1);
      expect(debouncer.isRunning, isFalse);
      expect(debouncer.isActive, isFalse);

      debouncer.dispose();
    });

    test('rapid successive calls only execute the last action once', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 100));
      final List<String> results = [];

      debouncer.run(() => results.add('first'));
      await Future.delayed(const Duration(milliseconds: 40));

      debouncer.run(() => results.add('second'));
      await Future.delayed(const Duration(milliseconds: 40));

      debouncer.run(() => results.add('third'));
      await Future.delayed(const Duration(milliseconds: 120));

      expect(results, ['third']);
      expect(results.length, 1);

      debouncer.dispose();
    });

    test('cancel() prevents execution', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 100));
      bool executed = false;

      debouncer.run(() {
        executed = true;
      });

      expect(debouncer.isRunning, isTrue);
      debouncer.cancel();
      expect(debouncer.isRunning, isFalse);

      await Future.delayed(const Duration(milliseconds: 120));
      expect(executed, isFalse);

      debouncer.dispose();
    });

    test('dispose() cancels any pending timer safely', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 100));
      bool executed = false;

      debouncer.run(() {
        executed = true;
      });

      debouncer.dispose();
      expect(debouncer.isRunning, isFalse);

      await Future.delayed(const Duration(milliseconds: 120));
      expect(executed, isFalse);

      // Calling dispose again is safe and idempotent
      expect(() => debouncer.dispose(), returnsNormally);
      expect(() => debouncer.cancel(), returnsNormally);
    });

    test('callable syntax invokes run()', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 80));
      int count = 0;

      debouncer(() {
        count++;
      });

      expect(debouncer.isRunning, isTrue);
      await Future.delayed(const Duration(milliseconds: 100));
      expect(count, 1);

      debouncer.dispose();
    });

    test('custom delay duration is respected', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 200));
      bool executed = false;

      debouncer.run(() {
        executed = true;
      });

      await Future.delayed(const Duration(milliseconds: 100));
      expect(executed, isFalse);
      expect(debouncer.isRunning, isTrue);

      await Future.delayed(const Duration(milliseconds: 120));
      expect(executed, isTrue);
      expect(debouncer.isRunning, isFalse);

      debouncer.dispose();
    });
  });

  group('CustomTextField Debounce Integration Tests', () {
    testWidgets('onDebouncedChanged delays callback and only fires for final input', (tester) async {
      final debouncedValues = <String>[];
      final rawValues = <String>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              hint: 'Search...',
              debounceDuration: const Duration(milliseconds: 150),
              onChanged: (val) => rawValues.add(val),
              onDebouncedChanged: (val) => debouncedValues.add(val),
            ),
          ),
        ),
      );

      final finder = find.byType(TextFormField);
      expect(finder, findsOneWidget);

      await tester.enterText(finder, 'c');
      await tester.pump(const Duration(milliseconds: 50));
      await tester.enterText(finder, 'ca');
      await tester.pump(const Duration(milliseconds: 50));
      await tester.enterText(finder, 'card');

      // Raw onChanged fired immediately for all 3 keystrokes
      expect(rawValues, ['c', 'ca', 'card']);
      // But debounced callback hasn't fired yet
      expect(debouncedValues, isEmpty);

      // Advance clock past the debounce duration (150ms)
      await tester.pump(const Duration(milliseconds: 160));

      // Debounced callback only fired once with the final text
      expect(debouncedValues, ['card']);
    });

    testWidgets('submitting text cancels pending debounce timer', (tester) async {
      final debouncedValues = <String>[];
      String? submittedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              hint: 'Search...',
              debounceDuration: const Duration(milliseconds: 200),
              onDebouncedChanged: (val) => debouncedValues.add(val),
              onSubmitted: (val) => submittedValue = val,
            ),
          ),
        ),
      );

      final finder = find.byType(TextFormField);
      await tester.enterText(finder, 'dr smith');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(submittedValue, 'dr smith');

      // Advance clock past debounce time; debounced callback was cancelled
      await tester.pump(const Duration(milliseconds: 250));
      expect(debouncedValues, isEmpty);
    });
  });
}


// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

void main() {
  final files = ['onboarding1.svg', 'onboarding2.svg', 'onboarding3.svg'];

  for (var i = 0; i < files.length; i++) {
    final fileName = files[i];
    final file = File('assets/images/$fileName');
    if (!file.existsSync()) {
      print('File not found: $fileName');
      continue;
    }

    final content = file.readAsStringSync();
    final match = RegExp(r'data:image/jpeg;base64,([^\"]+)').firstMatch(content);
    if (match != null) {
      final base64Str = match.group(1)!;
      final bytes = base64Decode(base64Str);
      final outFile = File('assets/images/onboarding${i + 1}.jpg');
      outFile.writeAsBytesSync(bytes);
      print('Extracted onboarding${i + 1}.jpg (${bytes.length} bytes)');
    } else {
      print('No base64 image found in $fileName');
    }
  }
}

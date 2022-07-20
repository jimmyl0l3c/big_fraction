import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  group("Testing the 'Console' class", () {
    test('Making sure that the console prints the welcome message', () async {
      final process = await Process.start(
        'dart',
        ['run', './bin/fraction_example.dart'],
      );

      // Converting into a stream
      final stream = process.stdout.transform(const Utf8Decoder());

      // Expected output
      final expectedOutput = StringBuffer()
        ..writeln('What do you want to analyze?\n')
        ..writeln(' 1) Fractions')
        ..writeln(' 2) Mixed fractions\n')
        ..write('Enter your choice (1 or 2): ');

      await expectLater(
        stream,
        emitsAnyOf([
          '$expectedOutput',
        ]),
      );
    });
  });
}

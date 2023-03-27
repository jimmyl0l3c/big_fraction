import 'package:big_fraction/big_fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the extension method on 'String'", () {
    test('Making sure that strings are properly converted into fractions', () {
      expect('1/3'.toBigFraction(), equals(BigFraction.from(1, 3)));
      expect('-4/5'.toBigFraction(), equals(BigFraction.from(-4, 5)));
      expect('5'.toBigFraction(), equals(BigFraction.from(5)));
      expect('-5'.toBigFraction(), equals(BigFraction.from(-5)));
      expect('0'.toBigFraction(), equals(BigFraction.zero()));
      expect('⅘'.toBigFraction(), equals(BigFraction.from(4, 5)));
    });

    test(
      'Making sure that invalid strings conversions throw and exception',
      () {
        expect('1/'.toBigFraction, throwsA(isA<FormatException>()));
        expect('1/0'.toBigFraction, throwsA(isA<FractionException>()));
        expect('x'.toBigFraction, throwsA(isA<FractionException>()));
        expect('3/-6'.toBigFraction, throwsA(isA<FractionException>()));
        expect(''.toBigFraction, throwsA(isA<FractionException>()));
      },
    );

    test(
      'Making sure that the boolean check is safe to be used before converting',
      () {
        expect('3/5'.isBigFraction, isTrue);
        expect('-3/5'.isBigFraction, isTrue);
        expect('6'.isBigFraction, isTrue);
        expect('-2'.isBigFraction, isTrue);
        expect('⅜'.isBigFraction, isTrue);
        expect(''.isBigFraction, isFalse);
        expect('/2'.isBigFraction, isFalse);
      },
    );
  });
}

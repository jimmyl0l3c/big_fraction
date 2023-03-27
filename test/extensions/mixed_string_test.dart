import 'package:big_fraction/big_fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the extension method on 'String'", () {
    test('Making sure that strings are properly converted into fractions', () {
      expect(
        '1 2/3'.toMixedBigFraction(),
        equals(
          MixedBigFraction(
            whole: BigInt.one,
            numerator: BigInt.two,
            denominator: BigInt.from(3),
          ),
        ),
      );
      expect(
        '3 -4/5'.toMixedBigFraction(),
        equals(
          MixedBigFraction(
            whole: BigInt.from(-3),
            numerator: BigInt.from(4),
            denominator: BigInt.from(5),
          ),
        ),
      );
      expect(
        '0 5/1'.toMixedBigFraction(),
        equals(
          MixedBigFraction(
            whole: BigInt.zero,
            numerator: BigInt.from(5),
            denominator: BigInt.one,
          ),
        ),
      );
      expect(
        '-5 3/3'.toMixedBigFraction(),
        equals(
          MixedBigFraction(
            whole: BigInt.from(-5),
            numerator: BigInt.one,
            denominator: BigInt.one,
          ),
        ),
      );
      expect(
        '2 ⅔'.toMixedBigFraction(),
        equals(
          MixedBigFraction(
            whole: BigInt.two,
            numerator: BigInt.two,
            denominator: BigInt.from(3),
          ),
        ),
      );
    });

    test(
      'Making sure that invalid strings conversions throw and exception',
      () {
        expect(
          '1/'.toMixedBigFraction,
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          '1/0'.toMixedBigFraction,
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          'x'.toMixedBigFraction,
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          '3/-6'.toMixedBigFraction,
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          ''.toMixedBigFraction,
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          '2 2/'.toMixedBigFraction,
          throwsA(isA<FormatException>()),
        );
        expect(
          '1  1/2'.toMixedBigFraction,
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          '-1 1/-2'.toMixedBigFraction,
          throwsA(isA<FractionException>()),
        );
      },
    );

    test(
      'Making sure that the boolean check is safe to be used before converting',
      () {
        expect('1 3/5'.isMixedBigFraction, isTrue);
        expect('3 ¾'.isMixedBigFraction, isTrue);
        expect('0 -3/5'.isMixedBigFraction, isTrue);
        expect(''.isMixedBigFraction, isFalse);
        expect('7/4'.isMixedBigFraction, isFalse);
      },
    );
  });
}

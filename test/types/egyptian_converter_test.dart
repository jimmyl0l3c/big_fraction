import 'package:big_fraction/big_fraction.dart';
import 'package:big_fraction/src/types/egyptian_converter.dart';
import 'package:test/test.dart';

void main() {
  group('Constructors', () {
    test('Making sure that the class can be instantiated', () {
      final egyptian =
          EgyptianBigFractionConverter(fraction: BigFraction.from(2, 5));
      expect(egyptian.fraction, equals(BigFraction.from(2, 5)));
    });

    test(
      'Making sure that the class can correctly be instantiated with the '
      'mixed fraction constructor',
      () {
        final mixed = MixedBigFraction(
          whole: BigInt.from(10),
          numerator: BigInt.from(7),
          denominator: BigInt.two,
        );
        final egyptian = EgyptianBigFractionConverter.fromMixedFraction(
          mixedFraction: mixed,
        );
        expect(egyptian.fraction, equals(BigFraction.from(27, 2)));
      },
    );

    test(
      'Making sure that the constructor throws in case of invalid fraction',
      () {
        expect(
          () => EgyptianBigFractionConverter(fraction: BigFraction.from(2, 0)),
          throwsA(isA<FractionException>()),
        );
      },
    );

    test('Making sure that caching properly works', () {
      final egyptian =
          EgyptianBigFractionConverter(fraction: BigFraction.from(2, 5));

      expect(
        egyptian.compute(),
        unorderedEquals([
          BigFraction.from(1, 3),
          BigFraction.from(1, 15),
        ]),
      );
      expect(
        egyptian.compute(),
        unorderedEquals([
          BigFraction.from(1, 3),
          BigFraction.from(1, 15),
        ]),
      );
    });
  });

  group('Testing objects equality', () {
    test('Making sure that comparison works properly', () {
      final egyptian1 =
          EgyptianBigFractionConverter(fraction: BigFraction.from(1, 3));
      final egyptian2 =
          EgyptianBigFractionConverter(fraction: BigFraction.from(4, 12));

      expect(
        egyptian1 ==
            EgyptianBigFractionConverter(fraction: BigFraction.from(1, 3)),
        isTrue,
      );
      expect(egyptian1 == egyptian2, isTrue);

      expect(egyptian1.hashCode != egyptian2.hashCode, isTrue);
      expect(
        egyptian1.hashCode ==
            EgyptianBigFractionConverter(
              fraction: BigFraction.from(1, 3),
            ).hashCode,
        isTrue,
      );
    });
  });

  group('Testing the API', () {
    test("Making sure that the 'compute()' method works properly'", () {
      final testMatrix = {
        BigFraction.from(5, 8): [
          BigFraction.from(1, 2),
          BigFraction.from(1, 8)
        ],
        BigFraction.from(2, 3): [
          BigFraction.from(1, 2),
          BigFraction.from(1, 6)
        ],
        BigFraction.from(2, 5): [
          BigFraction.from(1, 3),
          BigFraction.from(1, 15)
        ],
        BigFraction.from(3, 4): [
          BigFraction.from(1, 2),
          BigFraction.from(1, 4)
        ],
        BigFraction.from(3, 5): [
          BigFraction.from(1, 2),
          BigFraction.from(1, 10)
        ],
        BigFraction.from(4, 5): [
          BigFraction.from(1, 2),
          BigFraction.from(1, 4),
          BigFraction.from(1, 20)
        ],
        BigFraction.from(7, 15): [
          BigFraction.from(1, 3),
          BigFraction.from(1, 8),
          BigFraction.from(1, 120)
        ],
      };

      for (final entry in testMatrix.entries) {
        final egyptian = EgyptianBigFractionConverter(fraction: entry.key);
        expect(egyptian.compute(), unorderedEquals(entry.value));
      }
    });

    test(
      "Making sure that the 'compute()' throws is the fraction is negative'",
      () {
        final egyptian = EgyptianBigFractionConverter(
          fraction: BigFraction.from(-2, 5),
        );

        expect(egyptian.compute, throwsA(isA<FractionException>()));
      },
    );

    test("Making sure that 'toString' works properly", () {
      final egyptian = EgyptianBigFractionConverter(
        fraction: BigFraction.from(5, 8),
      );
      expect('$egyptian', equals('1/2 + 1/8'));

      // Calling 'toString' twice to make sure that CI coverage also covers the
      // case where the instance is cached
      final egyptian2 = EgyptianBigFractionConverter(
        fraction: BigFraction.from(5, 8),
      );
      expect('$egyptian2', equals('1/2 + 1/8'));

      final egyptian3 = EgyptianBigFractionConverter.fromMixedFraction(
        mixedFraction: MixedBigFraction(
          whole: BigInt.two,
          numerator: BigInt.from(4),
          denominator: BigInt.from(5),
        ),
      );
      expect('$egyptian3', equals('1 + 1 + 1/2 + 1/4 + 1/20'));
    });
  });
}

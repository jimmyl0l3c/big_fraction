import 'package:big_fraction/big_fraction.dart';
import 'package:test/test.dart';

void main() {
  group('Constructors', () {
    test('Making sure that numerator and denominator are correct', () {
      final fraction = BigFraction.from(5, 7);

      expect(fraction.numerator, equals(BigInt.from(5)));
      expect(fraction.denominator, equals(BigInt.from(7)));
      expect(fraction.toString(), '5/7');
    });

    test('Making sure that the sign on the numerator persists', () {
      final fraction = BigFraction.from(-5, 7);

      expect(fraction.numerator, equals(BigInt.from(-5)));
      expect(fraction.denominator, equals(BigInt.from(7)));
      expect(fraction.toString(), '-5/7');
    });

    test(
      'Making sure that the sign on the denominator is moved to the numerator',
      () {
        final fraction = BigFraction.from(5, -7);

        expect(fraction.numerator, equals(BigInt.from(-5)));
        expect(fraction.denominator, equals(BigInt.from(7)));
        expect(fraction.toString(), '-5/7');
      },
    );

    test('Making sure that whole fractions have the denominator = 1', () {
      final fraction = BigFraction.from(10);

      expect(fraction.numerator, equals(BigInt.from(10)));
      expect(fraction.denominator, equals(BigInt.one));
      expect(fraction.toString(), '10');

      final negativeFraction = BigFraction.from(-8);

      expect(negativeFraction.numerator, equals(BigInt.from(-8)));
      expect(negativeFraction.denominator, equals(BigInt.one));
      expect(negativeFraction.toString(), '-8');
    });

    test(
      'Making sure an exception is thrown ONLY when the denominator is zero',
      () {
        expect(() => BigFraction.from(1, 0), throwsA(isA<FractionException>()));
        expect(BigFraction.from(0), equals(BigFraction.from(0)));
      },
    );

    test(
      "Making sure that the 'fromString()' constructor handles strings"
      ' properly',
      () {
        // Valid conversions
        expect(BigFraction.fromString('3/5'), equals(BigFraction.from(3, 5)));
        expect(BigFraction.fromString('-3/5'), equals(BigFraction.from(-3, 5)));
        expect(BigFraction.fromString('7'), equals(BigFraction.from(7)));
        expect(BigFraction.fromString('-6'), equals(BigFraction.from(-6)));
        expect(
          () => BigFraction.fromString('½'),
          throwsA(isA<FractionException>()),
        );

        // Invalid conversions
        expect(
          () => BigFraction.fromString('2/-5'),
          throwsA(isA<FractionException>()),
        );
        expect(
          () => BigFraction.fromString('1/-0'),
          throwsA(isA<FractionException>()),
        );
        expect(
          () => BigFraction.fromString('2/0'),
          throwsA(isA<FractionException>()),
        );
        expect(
          () => BigFraction.fromString('0/0'),
          throwsA(isA<FractionException>()),
        );

        // Invalid formats
        expect(
          () => BigFraction.fromString('2/'),
          throwsA(isA<FormatException>()),
        );
        expect(
          () => BigFraction.fromString('3/a'),
          throwsA(isA<FormatException>()),
        );
        expect(
          () => BigFraction.fromString('1/-3'),
          throwsA(isA<FractionException>()),
        );
      },
    );

    test(
      "Making sure that the 'fromGlyph()' constructor handles strings properly",
      () {
        expect(BigFraction.fromGlyph('½'), equals(BigFraction.from(1, 2)));
        expect(BigFraction.fromGlyph('⅓'), equals(BigFraction.from(1, 3)));
        expect(BigFraction.fromGlyph('⅔'), equals(BigFraction.from(2, 3)));
        expect(BigFraction.fromGlyph('¼'), equals(BigFraction.from(1, 4)));
        expect(BigFraction.fromGlyph('¾'), equals(BigFraction.from(3, 4)));
        expect(BigFraction.fromGlyph('⅕'), equals(BigFraction.from(1, 5)));
        expect(BigFraction.fromGlyph('⅖'), equals(BigFraction.from(2, 5)));
        expect(BigFraction.fromGlyph('⅗'), equals(BigFraction.from(3, 5)));
        expect(BigFraction.fromGlyph('⅘'), equals(BigFraction.from(4, 5)));
        expect(BigFraction.fromGlyph('⅙'), equals(BigFraction.from(1, 6)));
        expect(BigFraction.fromGlyph('⅚'), equals(BigFraction.from(5, 6)));
        expect(BigFraction.fromGlyph('⅐'), equals(BigFraction.from(1, 7)));
        expect(BigFraction.fromGlyph('⅛'), equals(BigFraction.from(1, 8)));
        expect(BigFraction.fromGlyph('⅜'), equals(BigFraction.from(3, 8)));
        expect(BigFraction.fromGlyph('⅝'), equals(BigFraction.from(5, 8)));
        expect(BigFraction.fromGlyph('⅞'), equals(BigFraction.from(7, 8)));
        expect(BigFraction.fromGlyph('⅑'), equals(BigFraction.from(1, 9)));
        expect(BigFraction.fromGlyph('⅒'), equals(BigFraction.from(1, 10)));
      },
    );

    test(
      "Making sure that the 'fromDouble()' constructor handles strings "
      'properly',
      () {
        // Valid conversions
        expect(BigFraction.fromDouble(5.6), equals(BigFraction.from(28, 5)));
        expect(
          BigFraction.fromDouble(0.0025),
          equals(BigFraction.from(1, 400)),
        );
        expect(BigFraction.fromDouble(-3.8), equals(BigFraction.from(-19, 5)));
        expect(BigFraction.fromDouble(0), equals(BigFraction.from(0)));

        // Invalid conversions
        expect(
          () => BigFraction.fromDouble(double.nan),
          throwsA(isA<FractionException>()),
        );
        expect(
          () => BigFraction.fromDouble(double.infinity),
          throwsA(isA<FractionException>()),
        );
        expect(
          () => BigFraction.fromDouble(double.negativeInfinity),
          throwsA(isA<FractionException>()),
        );
      },
    );

    test(
      'Making sure that fractions are properly built from mixed fractions',
      () {
        final fraction = BigFraction.fromMixedFraction(
          MixedBigFraction(
            whole: BigInt.from(3),
            numerator: BigInt.from(5),
            denominator: BigInt.from(6),
          ),
        );

        expect(fraction, equals(BigFraction.from(23, 6)));
        expect(fraction.isNegative, isFalse);
      },
    );

    test(
      'Making sure that fractions are properly built from neg. mixed fractions',
      () {
        final fraction = BigFraction.fromMixedFraction(
          MixedBigFraction(
            whole: BigInt.from(-3),
            numerator: BigInt.from(5),
            denominator: BigInt.from(6),
          ),
        );

        expect(fraction, equals(BigFraction.from(-23, 6)));
        expect(fraction.isNegative, isTrue);
      },
    );
  });

  group('Testing objects equality', () {
    test('Making sure that fractions comparison is made via cross product', () {
      expect(BigFraction.from(3, 12) == BigFraction.from(1, 4), isTrue);
      expect(BigFraction.from(6, 13) == BigFraction.from(6, 13), isTrue);

      expect(
        BigFraction.from(3, 12).hashCode != BigFraction.from(1, 4).hashCode,
        isTrue,
      );
      expect(
        BigFraction.from(6, 13).hashCode == BigFraction.from(6, 13).hashCode,
        isTrue,
      );
    });

    test(
      "Making sure that 'compareTo' returns 1, -1 or 0 according with the "
      'natural sorting',
      () {
        expect(BigFraction.from(2).compareTo(BigFraction.from(8)), equals(-1));
        expect(BigFraction.from(2).compareTo(BigFraction.from(-4)), equals(1));
        expect(BigFraction.from(6).compareTo(BigFraction.from(6)), equals(0));
      },
    );
  });

  group('Testing the API of the Fraction class', () {
    test('Making sure conversions to double are correct', () {
      expect(BigFraction.from(10, 2).toDouble(), equals(5.0));
      expect(BigFraction.from(-6, 8).toDouble(), equals(-0.75));
    });

    test('Making sure conversions to egyptian fractions are correct', () {
      expect(
        BigFraction.from(2, 3).toEgyptianFraction(),
        unorderedEquals([BigFraction.from(1, 2), BigFraction.from(1, 6)]),
      );
      expect(
        BigFraction.from(3, 5).toEgyptianFraction(),
        unorderedEquals([BigFraction.from(1, 2), BigFraction.from(1, 10)]),
      );
    });

    test("Making sure that 'copyWith' works properly", () {
      final fraction1 = BigFraction.from(1, 3).copyWith();
      expect(fraction1, equals(BigFraction.from(1, 3)));

      final fraction2 = BigFraction.from(1, 3).copyWith(numerator: BigInt.two);
      expect(fraction2, equals(BigFraction.from(2, 3)));

      final fraction3 = BigFraction.from(1, 3).copyWith(
        denominator: BigInt.from(-3),
      );
      expect(fraction3, equals(BigFraction.from(1, -3)));

      final fraction4 = fraction3.copyWith(
        numerator: BigInt.from(5),
        denominator: BigInt.from(7),
      );
      expect(fraction4, equals(BigFraction.from(5, 7)));
    });

    test('Making sure conversions to double are correct', () {
      final fraction = BigFraction.from(3, 7);
      expect(fraction.isProper, equals(true));
      expect(fraction.isImproper, equals(false));

      final inverse = fraction.inverse();
      expect(inverse.isProper, equals(false));
      expect(inverse.isImproper, equals(true));
    });

    test('Making sure that the gliph conversion is correct', () {
      expect(BigFraction.from(1, 2).toStringAsGlyph(), equals('½'));
      expect(BigFraction.from(1, 3).toStringAsGlyph(), equals('⅓'));
      expect(BigFraction.from(2, 3).toStringAsGlyph(), equals('⅔'));
      expect(BigFraction.from(1, 4).toStringAsGlyph(), equals('¼'));
      expect(BigFraction.from(3, 4).toStringAsGlyph(), equals('¾'));
      expect(BigFraction.from(1, 5).toStringAsGlyph(), equals('⅕'));
      expect(BigFraction.from(2, 5).toStringAsGlyph(), equals('⅖'));
      expect(BigFraction.from(3, 5).toStringAsGlyph(), equals('⅗'));
      expect(BigFraction.from(4, 5).toStringAsGlyph(), equals('⅘'));
      expect(BigFraction.from(1, 6).toStringAsGlyph(), equals('⅙'));
      expect(BigFraction.from(5, 6).toStringAsGlyph(), equals('⅚'));
      expect(BigFraction.from(1, 7).toStringAsGlyph(), equals('⅐'));
      expect(BigFraction.from(1, 8).toStringAsGlyph(), equals('⅛'));
      expect(BigFraction.from(3, 8).toStringAsGlyph(), equals('⅜'));
      expect(BigFraction.from(5, 8).toStringAsGlyph(), equals('⅝'));
      expect(BigFraction.from(7, 8).toStringAsGlyph(), equals('⅞'));
      expect(BigFraction.from(1, 9).toStringAsGlyph(), equals('⅑'));
      expect(BigFraction.from(1, 10).toStringAsGlyph(), equals('⅒'));
    });

    test('Making sure that gliphs are recognized', () {
      expect(BigFraction.from(1, 2).isFractionGlyph, isTrue);
      expect(BigFraction.from(-1, 2).isFractionGlyph, isFalse);
      expect(BigFraction.from(-1, -2).isFractionGlyph, isTrue);
      expect(BigFraction.from(1, -2).isFractionGlyph, isFalse);
    });

    test(
      'Making sure that a non-gliph encodeable fraction throws when trying '
      'to convert it into a glyph',
      () {
        expect(
          () => BigFraction.from(10, 37).toStringAsGlyph(),
          throwsA(isA<FractionException>()),
        );
      },
    );

    test('Making sure conversions to mixed fractions are correct', () {
      final mixed = BigFraction.from(8, 7).toMixedFraction();

      expect(mixed.whole, equals(BigInt.one));
      expect(mixed.numerator, equals(BigInt.one));
      expect(mixed.denominator, equals(BigInt.from(7)));
    });

    test(
      'Making sure that the inverse is another fraction with swapped values',
      () {
        expect(
          BigFraction.from(10, 2).inverse(),
          equals(BigFraction.from(2, 10)),
        );
        expect(
          BigFraction.from(-10, 2).inverse(),
          equals(BigFraction.from(-2, 10)),
        );
      },
    );

    test('Making sure that negation changes the sign', () {
      expect(BigFraction.from(-2, 4).negate(), equals(BigFraction.from(2, 4)));
      expect(BigFraction.from(2, 4).negate(), equals(BigFraction.from(-1, 2)));
    });

    test('Making sure that negation is properly detected', () {
      expect(BigFraction.from(-1, 2).isNegative, isTrue);
      expect(BigFraction.from(1, 2).isNegative, isFalse);
    });

    test('Making sure that whole fraction detection works', () {
      expect(BigFraction.from(15).isWhole, isTrue);
      expect(BigFraction.from(16, 2).isWhole, isFalse);
      expect(BigFraction.from(1, 15).isWhole, isFalse);
    });

    test(
      'Making sure that reduction to the lowest terms works as expected',
      () {
        final positiveFraction = BigFraction.from(16, 46);
        expect(positiveFraction.reduce(), equals(BigFraction.from(8, 23)));

        final negativeFraction = BigFraction.from(-9, 3);
        expect(negativeFraction.reduce(), equals(BigFraction.from(-3)));
      },
    );
  });

  group('Testing operators overloads', () {
    test('Making sure that operators +, -, * and / do proper calculations', () {
      final fraction1 = BigFraction.from(7, 13);
      final fraction2 = BigFraction.from(-4, 3);

      expect(fraction1 + fraction2, equals(BigFraction.from(-31, 39)));
      expect(fraction1 - fraction2, equals(BigFraction.from(73, 39)));
      expect(fraction1 * fraction2, equals(BigFraction.from(-28, 39)));
      expect(fraction1 / fraction2, equals(BigFraction.from(-21, 52)));
    });

    test('Making sure that comparison operators compare values correctly', () {
      expect(BigFraction.from(10) > BigFraction.from(8), isTrue);
      expect(BigFraction.from(10) >= BigFraction.from(8), isTrue);
      expect(BigFraction.from(10) >= BigFraction.from(10), isTrue);
      expect(BigFraction.from(8) < BigFraction.from(10), isTrue);
      expect(BigFraction.from(8) <= BigFraction.from(10), isTrue);
      expect(BigFraction.from(8) <= BigFraction.from(8), isTrue);
    });

    test(
      'Making sure that the index operator returns value only when called with '
      '0 and 1',
      () {
        final fraction = BigFraction.from(9, 20);

        expect(fraction[0], equals(BigInt.from(9)));
        expect(fraction[1], equals(BigInt.from(20)));
        expect(() => fraction[2], throwsA(isA<FractionException>()));
      },
    );
  });
}

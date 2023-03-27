import 'package:big_fraction/big_fraction.dart';
import 'package:test/test.dart';

void main() {
  // Tests on constructors
  group('Testing the behaviors of the constructors', () {
    test('Making sure that whole, numerator and denominator are correct', () {
      final fraction = MixedBigFraction(
        whole: BigInt.one,
        numerator: BigInt.from(5),
        denominator: BigInt.from(7),
      );

      expect(fraction.whole, equals(BigInt.one));
      expect(fraction.numerator, equals(BigInt.from(5)));
      expect(fraction.denominator, equals(BigInt.from(7)));
      expect(fraction.isNegative, isFalse);
      expect(fraction.toString(), equals('1 5/7'));
    });

    test('Making sure that whole, numerator and denominator are correct', () {
      final fraction = MixedBigFraction(
        whole: BigInt.zero,
        numerator: -BigInt.one,
        denominator: -BigInt.two,
      );

      expect(fraction.whole, equals(BigInt.zero));
      expect(fraction.numerator, equals(BigInt.one));
      expect(fraction.denominator, equals(BigInt.two));
      expect(fraction.isNegative, isFalse);
      expect(fraction.toString(), equals('1/2'));
    });

    test(
      'Making sure that an exception is thrown when the denominator is zero',
      () {
        expect(
          () => MixedBigFraction(
            whole: BigInt.one,
            numerator: BigInt.from(5),
            denominator: BigInt.zero,
          ),
          throwsA(isA<MixedFractionException>()),
        );
      },
    );

    test(
      'Making sure that when numerator > denominator, the fraction is '
      "'normalized' so that the numerator <= denominator relation becomes true",
      () {
        final fraction1 = MixedBigFraction(
          whole: BigInt.one,
          numerator: BigInt.from(5),
          denominator: BigInt.from(3),
        );

        expect(fraction1.whole, equals(BigInt.two));
        expect(fraction1.numerator, equals(BigInt.two));
        expect(fraction1.denominator, equals(BigInt.from(3)));
        expect(fraction1.toString(), equals('2 2/3'));

        final fraction2 = MixedBigFraction(
          whole: BigInt.from(3),
          numerator: BigInt.from(18),
          denominator: BigInt.from(-7),
        );

        expect(fraction2.whole, equals(BigInt.from(-5)));
        expect(fraction2.numerator, equals(BigInt.from(4)));
        expect(fraction2.denominator, equals(BigInt.from(7)));
        expect(fraction2.toString(), equals('-5 4/7'));

        final fraction3 = MixedBigFraction(
          whole: BigInt.two,
          numerator: BigInt.from(-6),
          denominator: BigInt.from(5),
        );

        expect(fraction3.whole, equals(BigInt.from(-3)));
        expect(fraction3.numerator, equals(BigInt.one));
        expect(fraction3.denominator, equals(BigInt.from(5)));
        expect(fraction3.toString(), equals('-3 1/5'));

        final fraction4 = MixedBigFraction(
          whole: BigInt.from(-5),
          numerator: -BigInt.one,
          denominator: BigInt.from(3),
        );

        expect(fraction4.whole, equals(BigInt.from(5)));
        expect(fraction4.numerator, equals(BigInt.one));
        expect(fraction4.denominator, equals(BigInt.from(3)));
        expect(fraction4.toString(), equals('5 1/3'));
      },
    );

    test('Making sure that negative signs are properly handled', () {
      final fraction1 = MixedBigFraction(
        whole: -BigInt.one,
        numerator: BigInt.from(-4),
        denominator: BigInt.from(9),
      );

      expect(fraction1.whole, equals(BigInt.one));
      expect(fraction1.numerator, equals(BigInt.from(4)));
      expect(fraction1.denominator, equals(BigInt.from(9)));
      expect(fraction1.toString(), equals('1 4/9'));

      final fraction2 = MixedBigFraction(
        whole: -BigInt.two,
        numerator: BigInt.from(-4),
        denominator: BigInt.from(-11),
      );

      expect(fraction2.whole, equals(-BigInt.two));
      expect(fraction2.numerator, equals(BigInt.from(4)));
      expect(fraction2.denominator, equals(BigInt.from(11)));
      expect(fraction2.toString(), equals('-2 4/11'));

      final fraction3 = MixedBigFraction(
        whole: BigInt.from(6),
        numerator: BigInt.two,
        denominator: BigInt.from(-7),
      );

      expect(fraction3.whole, equals(BigInt.from(-6)));
      expect(fraction3.numerator, equals(BigInt.two));
      expect(fraction3.denominator, equals(BigInt.from(7)));
      expect(fraction3.toString(), equals('-6 2/7'));

      expect(
        MixedBigFraction(
          whole: BigInt.from(-3),
          numerator: BigInt.two,
          denominator: BigInt.from(5),
        ).toFraction(),
        equals(BigFraction.from(-17, 5)),
      );
      expect(
        MixedBigFraction(
          whole: BigInt.from(-4),
          numerator: BigInt.from(5),
          denominator: BigInt.from(6),
        ).toFraction(),
        equals(BigFraction.from(-29, 6)),
      );
    });

    test(
      'Making sure that mixed fractions are properly constructed from '
      'fractions',
      () {
        final fraction = MixedBigFraction.fromFraction(
          BigFraction.from(19, 3),
        );

        expect(fraction.whole, equals(BigInt.from(6)));
        expect(fraction.numerator, equals(BigInt.one));
        expect(fraction.denominator, equals(BigInt.from(3)));
      },
    );

    test(
      'Making sure that mixed fractions are properly constructed from strings',
      () {
        // Valid conversions
        expect(
          MixedBigFraction.fromString('-3 6/11'),
          equals(
            MixedBigFraction(
              whole: BigInt.from(-3),
              numerator: BigInt.from(6),
              denominator: BigInt.from(11),
            ),
          ),
        );

        expect(
          MixedBigFraction.fromString('1 5/3'),
          equals(
            MixedBigFraction(
              whole: BigInt.two,
              numerator: BigInt.two,
              denominator: BigInt.from(3),
            ),
          ),
        );

        expect(
          MixedBigFraction.fromString('2 5/1'),
          equals(
            MixedBigFraction(
              whole: BigInt.two,
              numerator: BigInt.from(5),
              denominator: BigInt.one,
            ),
          ),
        );

        expect(
          MixedBigFraction.fromString('2 5'),
          equals(
            MixedBigFraction(
              whole: BigInt.two,
              numerator: BigInt.from(5),
              denominator: BigInt.one,
            ),
          ),
        );

        expect(
          MixedBigFraction.fromString('3 ⅕'),
          equals(
            MixedBigFraction(
              whole: BigInt.from(3),
              numerator: BigInt.one,
              denominator: BigInt.from(5),
            ),
          ),
        );

        // Invalid conversions
        expect(
          () => MixedBigFraction.fromString('1/2'),
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          () => MixedBigFraction.fromString('1  3/2'),
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          () => MixedBigFraction.fromString('2  1/1'),
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          () => MixedBigFraction.fromString('2 c/0'),
          throwsA(isA<FractionException>()),
        );
      },
    );

    test(
      'Making sure that mixed fractions are properly constructed from '
      'decimal values',
      () {
        expect(
          MixedBigFraction.fromDouble(5.46),
          equals(
            MixedBigFraction(
              whole: BigInt.from(5),
              numerator: BigInt.from(23),
              denominator: BigInt.from(50),
            ),
          ),
        );
        expect(
          MixedBigFraction.fromDouble(1.06),
          equals(
            MixedBigFraction(
              whole: BigInt.one,
              numerator: BigInt.from(3),
              denominator: BigInt.from(50),
            ),
          ),
        );
        expect(
          MixedBigFraction.fromDouble(0),
          equals(
            MixedBigFraction(
              whole: BigInt.zero,
              numerator: BigInt.zero,
              denominator: BigInt.one,
            ),
          ),
        );
      },
    );
  });

  group('Testing objects equality', () {
    test('Making sure that fractions comparison is made via cross product', () {
      final mixed1 = MixedBigFraction(
        whole: BigInt.one,
        numerator: BigInt.from(4),
        denominator: BigInt.from(7),
      );
      final mixed2 = MixedBigFraction(
        whole: BigInt.one,
        numerator: BigInt.from(8),
        denominator: BigInt.from(14),
      );

      expect(
        mixed1 ==
            MixedBigFraction(
              whole: BigInt.one,
              numerator: BigInt.from(4),
              denominator: BigInt.from(7),
            ),
        isTrue,
      );
      expect(mixed1 == mixed2, isTrue);

      expect(mixed1.hashCode != mixed2.hashCode, isTrue);
      expect(
        mixed1.hashCode ==
            MixedBigFraction(
              whole: BigInt.one,
              numerator: BigInt.from(4),
              denominator: BigInt.from(7),
            ).hashCode,
        isTrue,
      );
    });

    test(
      "Making sure that 'compareTo' works according with the natural sorting",
      () {
        final mixed1 = MixedBigFraction(
          whole: BigInt.zero,
          numerator: -BigInt.two,
          denominator: BigInt.from(4),
        );
        final mixed2 = MixedBigFraction(
          whole: BigInt.one,
          numerator: BigInt.from(6),
          denominator: BigInt.from(4),
        );

        expect(mixed1.compareTo(mixed2), equals(-1));
        expect(mixed2.compareTo(mixed1), equals(1));
        expect(mixed1.compareTo(mixed1), equals(0));
      },
    );
  });

  group('Testing the API of the MixedFraction class', () {
    test(
      'Making sure conversions that, if the fraction is gliph-encodeable, '
      "the 'toStringAsGliph()' method works",
      () {
        final frac1 = MixedBigFraction(
          whole: -BigInt.two,
          numerator: BigInt.one,
          denominator: BigInt.two,
        ).toStringAsGlyph();
        final frac2 = MixedBigFraction(
          whole: BigInt.zero,
          numerator: BigInt.one,
          denominator: BigInt.two,
        ).toStringAsGlyph();
        final frac3 = BigFraction.from(12, 15).toMixedFraction();

        expect(frac1, equals('-2 ½'));
        expect(frac2, equals('½'));
        expect(
          frac3.toStringAsGlyph,
          throwsA(isA<FractionException>()),
        );
      },
    );

    test('Making sure conversions to egyptian fractions are correct', () {
      final mixedFraction1 = BigFraction.from(2, 3).toMixedFraction();
      final mixedFraction2 = BigFraction.from(3, 5).toMixedFraction();

      expect(
        mixedFraction1.toEgyptianFraction(),
        unorderedEquals([BigFraction.from(1, 2), BigFraction.from(1, 6)]),
      );
      expect(
        mixedFraction2.toEgyptianFraction(),
        unorderedEquals([BigFraction.from(1, 2), BigFraction.from(1, 10)]),
      );
    });

    test("Making sure that 'copyWith' works properly", () {
      final fraction = MixedBigFraction(
        whole: -BigInt.two,
        numerator: BigInt.one,
        denominator: BigInt.two,
      );

      final copy1 = fraction.copyWith();
      expect(
        copy1,
        equals(
          MixedBigFraction(
            whole: -BigInt.two,
            numerator: BigInt.one,
            denominator: BigInt.two,
          ),
        ),
      );

      final copy2 = fraction.copyWith(numerator: BigInt.from(4));
      expect(
        copy2,
        equals(
          MixedBigFraction(
            whole: -BigInt.two,
            numerator: BigInt.from(4),
            denominator: BigInt.two,
          ),
        ),
      );

      final copy3 = fraction.copyWith(denominator: BigInt.from(79));
      expect(
        copy3,
        equals(
          MixedBigFraction(
            whole: -BigInt.two,
            numerator: BigInt.one,
            denominator: BigInt.from(79),
          ),
        ),
      );

      final copy4 = fraction.copyWith(whole: BigInt.from(4));
      expect(
        copy4,
        equals(
          MixedBigFraction(
            whole: BigInt.from(4),
            numerator: BigInt.one,
            denominator: BigInt.two,
          ),
        ),
      );
    });

    test('Making sure conversions to double are correct', () {
      expect(
        MixedBigFraction(
          whole: BigInt.zero,
          numerator: BigInt.from(-4),
          denominator: BigInt.one,
        ).toDouble(),
        equals(-4.0),
      );
      expect(
        MixedBigFraction(
          whole: BigInt.two,
          numerator: BigInt.from(5),
          denominator: BigInt.from(4),
        ).toDouble(),
        equals(3.25),
      );
    });

    test('Making sure conversions to fractions are correct', () {
      final fraction = MixedBigFraction(
        whole: BigInt.from(10),
        numerator: BigInt.from(7),
        denominator: BigInt.two,
      ).toFraction();
      expect(
        fraction,
        equals(BigFraction.from(27, 2)),
      );
    });

    test('Making sure reduction on the fractional part properly works', () {
      final fraction1 = MixedBigFraction(
        whole: BigInt.one,
        numerator: BigInt.from(3),
        denominator: BigInt.from(6),
      ).reduce();

      expect(fraction1.whole, equals(BigInt.one));
      expect(fraction1.numerator, equals(BigInt.one));
      expect(fraction1.denominator, equals(BigInt.two));
    });

    test('Making sure negation properly works', () {
      final fraction = MixedBigFraction(
        whole: -BigInt.one,
        numerator: BigInt.from(5),
        denominator: BigInt.from(3),
      );

      expect(fraction.negate().toDouble(), isPositive);
      expect(fraction.negate().isNegative, isFalse);
    });

    test('Making sure that the fractional part is properly constructed', () {
      final fraction = MixedBigFraction(
        whole: BigInt.from(5),
        numerator: BigInt.from(4),
        denominator: BigInt.from(7),
      );

      expect(fraction.fractionalPart, equals(BigFraction.from(4, 7)));
    });

    test('Making sure that the "isWhole" method correctly works', () {
      expect(
        MixedBigFraction(
          whole: BigInt.from(5),
          numerator: BigInt.from(4),
          denominator: BigInt.from(7),
        ).isWhole,
        isFalse,
      );
      expect(
        MixedBigFraction(
          whole: BigInt.from(5),
          numerator: BigInt.one,
          denominator: BigInt.one,
        ).isWhole,
        isTrue,
      );
    });
  });

  group('Testing operators overloads', () {
    final mixed1 = MixedBigFraction(
      whole: BigInt.one,
      numerator: BigInt.from(7),
      denominator: BigInt.from(10),
    );
    final mixed2 = MixedBigFraction(
      whole: BigInt.two,
      numerator: BigInt.one,
      denominator: BigInt.from(4),
    );

    test('Making sure that operators +, -, * and / do proper calculations', () {
      expect(
        mixed1 + mixed2,
        equals(
          MixedBigFraction(
            whole: BigInt.from(3),
            numerator: BigInt.from(19),
            denominator: BigInt.from(20),
          ),
        ),
      );
      expect(
        mixed1 - mixed2,
        equals(
          MixedBigFraction(
            whole: BigInt.zero,
            numerator: BigInt.from(-11),
            denominator: BigInt.from(20),
          ),
        ),
      );
      expect(
        mixed1 * mixed2,
        equals(
          MixedBigFraction(
            whole: BigInt.from(3),
            numerator: BigInt.from(33),
            denominator: BigInt.from(40),
          ),
        ),
      );
      expect(
        mixed1 / mixed2,
        equals(
          MixedBigFraction(
            whole: BigInt.zero,
            numerator: BigInt.from(34),
            denominator: BigInt.from(45),
          ),
        ),
      );
    });

    test('Making sure that comparison operators compare values correctly', () {
      expect(mixed2 > mixed1, isTrue);
      expect(mixed2 >= mixed1, isTrue);
      expect(mixed2 >= mixed2, isTrue);
      expect(mixed1 < mixed2, isTrue);
      expect(mixed1 <= mixed2, isTrue);
      expect(mixed1 <= mixed2, isTrue);
    });

    test(
      'Making sure that the index operator returns value only when called '
      'with 0, 1 and 2',
      () {
        expect(mixed1[0], equals(BigInt.one));
        expect(mixed1[1], equals(BigInt.from(7)));
        expect(mixed1[2], equals(BigInt.from(10)));
        expect(() => mixed1[3], throwsA(isA<MixedFractionException>()));
      },
    );
  });
}

import 'package:big_fraction/big_fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the extension method on 'num'", () {
    test('Making sure that integers are properly converted into fractions', () {
      expect(13.toBigFraction(), equals(BigFraction.from(13)));
      expect((-3).toBigFraction(), equals(BigFraction.from(-3)));
      expect(0.toBigFraction(), equals(BigFraction.zero()));
    });

    test('Making sure that doubles are properly converted into fractions', () {
      expect(8.46.toBigFraction(), equals(BigFraction.from(423, 50)));
      expect((-3.9).toBigFraction(), equals(BigFraction.from(-39, 10)));
      expect(0.toBigFraction(), equals(BigFraction.zero()));
      expect(double.nan.toBigFraction, throwsA(isA<FractionException>()));
      expect(double.infinity.toBigFraction, throwsA(isA<FractionException>()));
      expect(
        double.negativeInfinity.toBigFraction,
        throwsA(isA<FractionException>()),
      );
    });
  });
}

import 'package:big_fraction/big_fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the extension method on 'num'", () {
    test(
      'Making sure that integers are properly converted into '
      'mixed fractions',
      () {
        final mixedVal = MixedBigFraction(
          whole: BigInt.zero,
          numerator: BigInt.from(16),
          denominator: BigInt.one,
        );

        expect(16.toMixedBigFraction(), equals(mixedVal));
      },
    );

    test(
      'Making sure that doubles are properly converted into '
      'mixed fractions',
      () {
        final mixedVal = MixedBigFraction(
          whole: BigInt.from(6),
          numerator: BigInt.from(37),
          denominator: BigInt.from(50),
        );

        expect(6.74.toMixedBigFraction(), equals(mixedVal));
      },
    );
  });
}

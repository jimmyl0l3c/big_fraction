import 'package:big_fraction/big_fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'Rational' class", () {
    test(
      'Making sure that Fraction conversions from string correctly work',
      () {
        // Valid
        expect(BigRational.tryParse('-1/2'), isA<BigFraction>());
        expect(BigRational.tryParse('1/2'), isA<BigFraction>());
        expect(BigRational.tryParse('1'), isA<BigFraction>());
        expect(BigRational.tryParse('-1'), isA<BigFraction>());
        expect(BigRational.tryParse('0/1'), isA<BigFraction>());
        expect(BigRational.tryParse('-0/1'), isA<BigFraction>());
        expect(BigRational.tryParse('0'), isA<BigFraction>());

        // Invalid
        expect(BigRational.tryParse(''), isNull);
        expect(BigRational.tryParse('1/'), isNull);
        expect(BigRational.tryParse('/2'), isNull);
        expect(BigRational.tryParse('1/-2'), isNull);
        expect(BigRational.tryParse('1/0'), isNull);
      },
    );

    test(
      'Making sure that MixedFraction conversions from string correctly work',
      () {
        // Valid
        expect(BigRational.tryParse('1 1/2'), isA<MixedBigFraction>());
        expect(BigRational.tryParse('1 2/2'), isA<MixedBigFraction>());
        expect(BigRational.tryParse('1 3/1'), isA<MixedBigFraction>());
        expect(BigRational.tryParse('1 3'), isA<MixedBigFraction>());
        expect(BigRational.tryParse('-1 2/5'), isA<MixedBigFraction>());
        expect(BigRational.tryParse('-1 -2/5'), isA<MixedBigFraction>());

        // Invalid
        expect(BigRational.tryParse(''), isNull);
        expect(BigRational.tryParse('1 2/-3'), isNull);
        expect(BigRational.tryParse('1 0/0'), isNull);
        expect(BigRational.tryParse('5 -1/-0'), isNull);
      },
    );
  });
}

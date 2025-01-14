import 'package:big_fraction/big_fraction.dart';

/// Dart representation of a rational number.
///
/// A **rational number** is a number that can be expressed as the quotient
/// `x/y` of two integers, a numerator `x` and a non-zero denominator `y`. Any
/// rational number is also a real number.
///
/// [BigRational] and all of its sub-types are **immutable**.
///
/// See also:
///
///  - [BigFraction], to work with fractions in the form `a/b`
///  - [MixedBigFraction], to work with mixed fractions in the form `a b/c`
abstract class BigRational implements Comparable<BigRational> {
  /// Creates a [BigRational] object.
  const BigRational();

  @override
  int compareTo(BigRational other) {
    final thisDouble = toDouble();
    final otherDouble = other.toDouble();

    // Using operator== on floating point values isn't reliable due to potential
    // machine precision losses. Comparisons with operator> and operator< are
    // safer.
    if (thisDouble < otherDouble) {
      return -1;
    }

    if (thisDouble > otherDouble) {
      return 1;
    }

    return 0;
  }

  /// Checks whether this rational number is greater or equal than the other.
  bool operator >=(BigRational other) => toDouble() >= other.toDouble();

  /// Checks whether this rational number is greater than the other.
  bool operator >(BigRational other) => toDouble() > other.toDouble();

  /// Checks whether this rational number is smaller or equal than the other.
  bool operator <=(BigRational other) => toDouble() <= other.toDouble();

  /// Checks whether this rational number is smaller than the other.
  bool operator <(BigRational other) => toDouble() < other.toDouble();

  /// The dividend `a` of the `a/b` division, which also is the numerator of the
  /// associated fraction.
  BigInt get numerator;

  /// The divisor `b` of the `a/b` division, which also is the denominator of
  /// the associated fraction.
  BigInt get denominator;

  /// True or false whether this rational number is positive or negative.
  bool get isNegative;

  /// True or false whether this rational number is whole or not.
  bool get isWhole;

  /// A floating point representation of this rational number.
  double toDouble();

  /// The sign is changed and the result is returned in new instance.
  BigRational negate();

  /// Reduces this rational number to the lowest terms and returns the result in
  /// a new instance.
  BigRational reduce();

  /// Represents this rational number as an egyptian fraction.
  List<BigFraction> toEgyptianFraction();

  /// Parses a string containing a fraction or a mixed fraction into a number.
  ///
  /// If the parsing fails, this method returns `null`. For example:
  ///
  /// ```dart
  /// Rational.tryParse('1/2') // Fraction(1, 2);
  /// Rational.tryParse('2 5/3') // MixedFraction(2, 5, 3);
  /// Rational.tryParse('') // null
  /// ```
  static BigRational? tryParse(String value) {
    if (value.isBigFraction) {
      return BigFraction.fromString(value);
    }

    if (value.isMixedBigFraction) {
      return MixedBigFraction.fromString(value);
    }

    return null;
  }
}

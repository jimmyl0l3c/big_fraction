import 'package:big_fraction/big_fraction.dart';
import 'package:big_fraction/src/types/egyptian_converter.dart';

/// Dart representation of a 'mixed fraction', which is made up by the whole
/// part and a proper fraction. A proper fraction is a fraction in which the
/// relation `numerator <= denominator` is true.
///
/// There's the possibility to create an instance of [MixedBigFraction] either
/// by using one of the constructors or the extension methods on [num] and
/// [String].
///
/// ```dart
/// MixedFraction(
///   whole: 5,
///   numerator: 2,
///   denominator: 3,
/// );
/// MixedFraction.fromDouble(1.5);
/// MixedFraction.fromString("1 1/2");
/// ```
///
/// There also are extension methods to quickly build [BigFraction] objects from
/// primitive types:
///
/// ```dart
/// 1.5.toMixedFraction();
/// "1 1/2".toMixedFraction();
/// ```
///
/// If the string doesn't represent a valid fraction, a [MixedFractionException]
/// is thrown.
class MixedBigFraction extends BigRational {
  /// Whole part of the mixed fraction.
  final BigInt whole;

  /// The numerator of the fractional part.
  final BigInt _numerator;

  /// The denominator of the fractional part.
  final BigInt _denominator;

  /// Creates an instance of a mixed fraction.
  ///
  /// If the numerator isn't greater than the denominator, values are
  /// transformed so that a valid mixed fraction is created. For example, in...
  ///
  /// ```dart
  /// MixedFraction(1, 7, 3);
  /// ```
  ///
  /// ... the object is built as '3 1/3' since '1 7/3' would be invalid.
  factory MixedBigFraction({
    required BigInt whole,
    required BigInt numerator,
    required BigInt denominator,
  }) {
    // Denominator cannot be zero
    if (denominator == BigInt.zero) {
      throw const MixedFractionException('The denominator cannot be zero');
    }

    // The sign of the fractional part doesn't persist on the fraction itself;
    // the negative sign only applies (by convention) to the whole part
    final sign = BigFraction(numerator, denominator).isNegative
        ? BigInt.from(-1)
        : BigInt.one;
    final absNumerator = numerator.abs();
    final absDenominator = denominator.abs();

    // In case the numerator was greater than the denominator, there'd the need
    // to transform the fraction and make it proper. The sign of the whole part
    // may change depending on the sign of the fractional part.
    if (absNumerator > absDenominator) {
      return MixedBigFraction._(
        (absNumerator ~/ absDenominator + whole) * sign,
        absNumerator % absDenominator,
        absDenominator,
      );
    } else {
      return MixedBigFraction._(
        whole * sign,
        absNumerator,
        absDenominator,
      );
    }
  }

  /// The default constructor.
  const MixedBigFraction._(this.whole, this._numerator, this._denominator);

  /// Creates an instance of a mixed fraction.
  factory MixedBigFraction.fromFraction(BigFraction fraction) =>
      fraction.toMixedFraction();

  /// Creates an instance of a mixed fraction. The input string must be in the
  /// form 'a b/c' with exactly one space between the whole part and the
  /// fraction.
  ///
  /// The fraction can also be a glyph.
  ///
  /// The negative sign can only stay in front of 'a' or 'b'. Some valid
  /// examples are:
  ///
  /// ```dart
  /// MixedFraction.fromString('-2 2/5');
  /// MixedFraction.fromString('1 1/3');
  /// MixedFraction.fromString('3 ⅐');
  /// ```
  factory MixedBigFraction.fromString(String value) {
    const errorObj = MixedFractionException(
      "The string must be in the form 'a b/c' with exactly one space between "
      'the whole part and the fraction',
    );

    // Check for the space
    if (!value.contains(' ')) {
      throw errorObj;
    }

    /*
     * The 'parts' array must contain exactly 2 pieces:
     *  - parts[0]: the whole part (an integer)
     *  - parts[1]: the fraction (a string)
     * */
    final parts = value.split(' ');

    // Throw because this is not in the form 'a b/c'
    if (parts.length != 2) {
      throw errorObj;
    }

    /*
     * At this point the string is made up of 2 "parts" separated by a space. An
     * exception can occur only if the second part is a malformed string (not a
     * fraction)
     * */
    BigFraction fraction;

    // The string must be either a fraction with numbers and a slash or a glyph.
    // If that's not the case, then a 'FractionException' is thrown.
    try {
      fraction = BigFraction.fromString(parts[1]);
    } on FractionException {
      fraction = BigFraction.fromGlyph(parts[1]);
    }

    // Fixing the potential negative signs
    return MixedBigFraction(
      whole: BigInt.parse(parts.first),
      numerator: fraction.numerator,
      denominator: fraction.denominator,
    );
  }

  /// Tries to give a fractional representation of a double according with the
  /// given precision. This implementation takes inspiration from the continued
  /// fraction algorithm.
  ///
  /// ```dart
  /// MixedFraction.fromDouble(5.46) // represented as 5 + 23/50
  /// ```
  ///
  /// Note that irrational numbers can **not** be represented as fractions, so
  /// if you try to use this method on π (3.1415...) you won't get a valid
  /// result.
  ///
  /// ```dart
  /// MixedFraction.fromDouble(math.pi)
  /// ```
  ///
  /// The above returns a mixed fraction because the algorithm considers only
  /// the first 10 decimal digits (since `precision` is set to 1.0e-10).
  ///
  /// ```dart
  /// MixedFraction.fromDouble(math.pi, precision: 1.0e-20)
  /// ```
  ///
  /// This example will return another different value because it considers the
  /// first 20 digits. It's still not a fractional representation of pi because
  /// irrational numbers cannot be expressed as fractions.
  ///
  /// This method is good with rational numbers.
  factory MixedBigFraction.fromDouble(
    double value, {
    double precision = 1.0e-12,
  }) {
    // Use 'Fraction' to reuse the continued fraction algorithm.
    final fraction = BigFraction.fromDouble(value, precision: precision);

    return fraction.toMixedFraction();
  }

  @override
  BigInt get numerator => _numerator;

  @override
  BigInt get denominator => _denominator;

  @override
  bool get isNegative => whole < BigInt.zero;

  @override
  bool get isWhole => fractionalPart == BigFraction.one();

  @override
  bool operator ==(Object other) {
    // Two mixed fractions are equal if the whole part and the "cross product"
    // of the fractional part is equal.
    //
    // ```dart
    // final one = MixedFraction(whole: 1, numerator: 3, denominator: 4);
    // final two = MixedFraction(whole: 1, numerator: 6, denominator: 8);
    //
    // print(one == two); //true
    // ```
    //
    // The above example returns true because the whole part is equal (1 = 1)
    // and the "cross product" of `one` and two` is equal (3 * 8 = 6 * 4).
    if (identical(this, other)) {
      return true;
    }

    if (other is MixedBigFraction) {
      return toFraction() == other.toFraction();
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 17;

    result = result * 37 + whole.hashCode;
    result = result * 37 + _numerator.hashCode;
    result = result * 37 + _denominator.hashCode;

    return result;
  }

  @override
  String toString() {
    if (whole == BigInt.zero) {
      return '$numerator/$denominator';
    }

    return '$whole $numerator/$denominator';
  }

  @override
  double toDouble() => whole.toDouble() + (numerator / denominator);

  @override
  MixedBigFraction negate() => MixedBigFraction(
        whole: whole * BigInt.from(-1),
        numerator: numerator,
        denominator: denominator,
      );

  @override
  MixedBigFraction reduce() {
    final fractionalPart = BigFraction(numerator, denominator).reduce();

    return MixedBigFraction(
      whole: whole,
      numerator: fractionalPart.numerator,
      denominator: fractionalPart.denominator,
    );
  }

  @override
  List<BigFraction> toEgyptianFraction() =>
      EgyptianBigFractionConverter.fromMixedFraction(
        mixedFraction: this,
      ).compute();

  /// If possible, this method converts this [MixedBigFraction] instance into an
  /// unicode glyph string. For example:
  ///
  /// ```dart
  /// MixedFraction(
  ///   whole: 3,
  ///   numerator: 1,
  ///   denominator: 7,
  /// ).toStringAsGlyph() // "⅐"
  /// ```
  ///
  /// If the conversion is not possible, a [FractionException] object is thrown.
  String toStringAsGlyph() {
    final glyph = BigFraction(numerator, denominator).toStringAsGlyph();

    if (whole == BigInt.zero) {
      return glyph;
    } else {
      return '$whole $glyph';
    }
  }

  /// Converts this mixed fraction into a fraction.
  BigFraction toFraction() => BigFraction.fromMixedFraction(this);

  /// Creates a **deep** copy of this object with the given fields replaced
  /// with the new values.
  MixedBigFraction copyWith({
    BigInt? whole,
    BigInt? numerator,
    BigInt? denominator,
  }) =>
      MixedBigFraction(
        whole: whole ?? this.whole,
        numerator: numerator ?? this.numerator,
        denominator: denominator ?? this.denominator,
      );

  /// Returns the fractional part of the mixed fraction as [BigFraction] object.
  BigFraction get fractionalPart => BigFraction(numerator, denominator);

  /// The sum between two mixed fractions.
  MixedBigFraction operator +(MixedBigFraction other) {
    final result = toFraction() + other.toFraction();

    return result.toMixedFraction();
  }

  /// The difference between two mixed fractions.
  MixedBigFraction operator -(MixedBigFraction other) {
    final result = other.toFraction() - toFraction();

    return result.toMixedFraction();
  }

  /// The product of two mixed fractions.
  MixedBigFraction operator *(MixedBigFraction other) {
    final result = toFraction() * other.toFraction();

    return result.toMixedFraction();
  }

  /// The division of two mixed fractions.
  MixedBigFraction operator /(MixedBigFraction other) {
    final result = toFraction() / other.toFraction();

    return result.toMixedFraction();
  }

  /// Access the whole part, the numerator or the denominator of the fraction
  /// via index. In particular:
  ///
  ///  - `0` refers to the whole part;
  ///  - `1` refers to the numerator;
  ///  - `2` refers to the denominator.
  ///
  /// Any other value which is not `0`, `1` or `2` will throw an exception of
  /// type [MixedFractionException].
  BigInt operator [](int index) {
    switch (index) {
      case 0:
        return whole;
      case 1:
        return numerator;
      case 2:
        return denominator;
      default:
        throw MixedFractionException(
          'The index ($index) is not valid: it must either be 0, 1 or 2.',
        );
    }
  }
}

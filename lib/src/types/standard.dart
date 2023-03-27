import 'package:big_fraction/big_fraction.dart';
import 'package:big_fraction/src/types/egyptian_converter.dart';

/// Dart representation of a fraction having both the numerator and the
/// denominator as integers.
///
/// ```dart
/// BigFraction(-2, 5);
/// BigFraction.fromDouble(1.5);
/// BigFraction.fromString("4/5");
/// ```
///
/// There also are extension methods to quickly build [BigFraction] objects from
/// primitive types:
///
/// ```dart
/// 1.5.toFraction();
/// "4/5".toFraction();
/// ```
///
/// If the string doesn't represent a valid fraction, a [FractionException]
/// object is thrown.
class BigFraction extends BigRational {
  /// This regular expression matches the structure of fraction in the `a/b`
  /// format with the optional minus (-) sign at the front.
  static final _fractionRegex = RegExp(
    r'(^-?|^\+?)(?:[1-9]\d*|0)(?:/[1-9]\d*)?',
  );

  /// Maps fraction glyphs to fraction values.
  static final _glyphsToValues = {
    '½': BigFraction.from(1, 2),
    '⅓': BigFraction.from(1, 3),
    '⅔': BigFraction.from(2, 3),
    '¼': BigFraction.from(1, 4),
    '¾': BigFraction.from(3, 4),
    '⅕': BigFraction.from(1, 5),
    '⅖': BigFraction.from(2, 5),
    '⅗': BigFraction.from(3, 5),
    '⅘': BigFraction.from(4, 5),
    '⅙': BigFraction.from(1, 6),
    '⅚': BigFraction.from(5, 6),
    '⅐': BigFraction.from(1, 7),
    '⅛': BigFraction.from(1, 8),
    '⅜': BigFraction.from(3, 8),
    '⅝': BigFraction.from(5, 8),
    '⅞': BigFraction.from(7, 8),
    '⅑': BigFraction.from(1, 9),
    '⅒': BigFraction.from(1, 10),
  };

  /// Maps fraction values to fraction glyphs.
  static final _valuesToGlyphs = {
    BigFraction.from(1, 2): '½',
    BigFraction.from(1, 3): '⅓',
    BigFraction.from(2, 3): '⅔',
    BigFraction.from(1, 4): '¼',
    BigFraction.from(3, 4): '¾',
    BigFraction.from(1, 5): '⅕',
    BigFraction.from(2, 5): '⅖',
    BigFraction.from(3, 5): '⅗',
    BigFraction.from(4, 5): '⅘',
    BigFraction.from(1, 6): '⅙',
    BigFraction.from(5, 6): '⅚',
    BigFraction.from(1, 7): '⅐',
    BigFraction.from(1, 8): '⅛',
    BigFraction.from(3, 8): '⅜',
    BigFraction.from(5, 8): '⅝',
    BigFraction.from(7, 8): '⅞',
    BigFraction.from(1, 9): '⅑',
    BigFraction.from(1, 10): '⅒',
  };

  /// The numerator of the fraction.
  final BigInt _numerator;

  /// The denominator of the fraction.
  final BigInt _denominator;

  /// Creates a new representation of a fraction. If the denominator is
  /// negative, the fraction is 'normalized' so that the minus sign only appears
  /// in front of the denominator.
  ///
  /// ```dart
  /// Fraction(BigInt.from(3), BigInt.from(4))  // is interpreted as 3/4
  /// Fraction(BigInt.from(-3), BigInt.from(4)) // is interpreted as -3/4
  /// Fraction(BigInt.from(3), BigInt.from(-4)) // is interpreted as -3/4
  /// Fraction(BigInt.from(3))     // is interpreted as 3/1
  /// ```
  ///
  /// A [FractionException] object is thrown when [denominator] is zero.
  factory BigFraction(BigInt numerator, [BigInt? denominator]) {
    denominator ??= BigInt.one;

    if (denominator == BigInt.zero) {
      throw const FractionException('Denominator cannot be zero.');
    }

    // Fixing the sign of numerator and denominator
    if (denominator < BigInt.zero) {
      return BigFraction._(
        numerator * BigInt.from(-1),
        denominator * BigInt.from(-1),
      );
    } else {
      return BigFraction._(numerator, denominator);
    }
  }

  /// BigFraction with the value 0 (0/1).
  BigFraction.zero()
      : _numerator = BigInt.zero,
        _denominator = BigInt.one;

  /// BigFraction with the value 1 (1/1).
  BigFraction.one()
      : _numerator = BigInt.one,
        _denominator = BigInt.one;

  /// BigFraction with the value -1 (-1/1).
  BigFraction.minusOne()
      : _numerator = BigInt.from(-1),
        _denominator = BigInt.one;

  /// Creates a new representation of a fraction. If the denominator is
  /// negative, the fraction is 'normalized' so that the minus sign only appears
  /// in front of the denominator.
  ///
  /// ```dart
  /// Fraction(3, 4)  // is interpreted as 3/4
  /// Fraction(-3, 4) // is interpreted as -3/4
  /// Fraction(3, -4) // is interpreted as -3/4
  /// Fraction(3)     // is interpreted as 3/1
  /// ```
  ///
  /// A [FractionException] object is thrown when [denominator] is zero.
  factory BigFraction.from(int numerator, [int denominator = 1]) =>
      BigFraction(BigInt.from(numerator), BigInt.from(denominator));

  /// The default constructor.
  const BigFraction._(this._numerator, this._denominator);

  /// Returns an instance of [BigFraction] if the source string is a valid
  /// representation of a fraction. Some valid examples are:
  ///
  /// ```dart
  /// Fraction.fromString("5/2")
  /// Fraction.fromString("-5/2")
  /// Fraction.fromString("5")
  /// ```
  ///
  /// The denominator cannot be negative.
  ///
  /// ```dart
  /// Fraction.fromString("5/-2") // throws FractionException
  /// ```
  ///
  /// If the given string [value] doesn't represent a fraction, then a
  /// [FractionException] object is thrown.
  factory BigFraction.fromString(String value) {
    // Check the format of the string
    if ((!_fractionRegex.hasMatch(value)) || (value.contains('/-'))) {
      throw FractionException('The string $value is not a valid fraction');
    }

    // Remove the leading + (if any)
    final fraction = value.replaceAll('+', '');

    // Look for the '/' separator
    final barPos = fraction.indexOf('/');

    if (barPos == -1) {
      return BigFraction(BigInt.parse(fraction));
    } else {
      final den = BigInt.parse(fraction.substring(barPos + 1));

      if (den == BigInt.zero) {
        throw const FractionException('Denominator cannot be zero');
      }

      // Fixing the sign of numerator and denominator
      return BigFraction(BigInt.parse(fraction.substring(0, barPos)), den);
    }
  }

  /// Returns an instance of [BigFraction] if the source string is a glyph
  /// representing a fraction.
  ///
  /// A 'glyph' (or 'number form') is an unicode character that represents a
  /// fraction. For example, the glyph for "1/7" is ⅐. Only a very small subset
  /// of fractions have a glyph representation.
  ///
  /// ```dart
  /// Fraction.fromString("⅐") // 1/7
  /// Fraction.fromString("⅔") // 2/3
  /// Fraction.fromString("⅞") // 7/8
  /// ```
  ///
  /// If the given string [value] doesn't represent a fraction glyph, then a
  /// [FractionException] object is thrown.
  factory BigFraction.fromGlyph(String value) {
    if (_glyphsToValues.containsKey(value)) {
      return _glyphsToValues[value]!;
    }

    throw FractionException(
      'The given string ($value) does not represent a valid fraction glyph!',
    );
  }

  /// Tries to give a fractional representation of a [double] according with the
  /// given precision. This implementation takes inspiration from the continued
  /// fraction algorithm.
  ///
  /// ```dart
  /// Fraction.fromDouble(3.8) // represented as 19/5
  /// ```
  ///
  /// Note that irrational numbers can **not** be represented as fractions, so
  /// if you try to use this method on π (3.1415...) you won't get a valid
  /// result.
  ///
  /// ```dart
  /// Fraction.fromDouble(math.pi)
  /// ```
  ///
  /// The above returns a fraction because the algorithm considers only the
  /// first 10 decimal digits (since `precision` is set to 1.0e-10).
  ///
  /// ```dart
  /// Fraction.fromDouble(math.pi, precision: 1.0e-20)
  /// ```
  ///
  /// This example will return another different value because it considers the
  /// first 20 digits. It's still not a fractional representation of pi because
  /// irrational numbers cannot be expressed as fractions.
  ///
  /// This method is good with rational numbers.
  factory BigFraction.fromDouble(double value, {double precision = 1.0e-12}) {
    _checkValue(value);
    _checkValue(precision);

    // Storing the sign
    final abs = value.abs();
    final mul = (value >= 0) ? 1 : -1;
    final x = abs;

    // How many digits is the algorithm going to consider
    final limit = precision;
    var h1 = 1;
    var h2 = 0;
    var k1 = 0;
    var k2 = 1;
    var y = abs;

    do {
      final a = y.floor();
      var aux = h1;
      h1 = a * h1 + h2;
      h2 = aux;
      aux = k1;
      k1 = a * k1 + k2;
      k2 = aux;
      y = 1 / (y - a);
    } while ((x - h1 / k1).abs() > x * limit);

    // Assigning the computed values
    return BigFraction(BigInt.from(mul * h1), BigInt.from(k1));
  }

  /// Converts a [MixedBigFraction] into a [BigFraction].
  factory BigFraction.fromMixedFraction(MixedBigFraction mixed) {
    var num = mixed.whole * mixed.denominator + mixed.numerator;

    if (mixed.isNegative) {
      num =
          mixed.whole * mixed.denominator + (mixed.numerator * BigInt.from(-1));
    }

    return BigFraction(num, mixed.denominator);
  }

  @override
  BigInt get numerator => _numerator;

  @override
  BigInt get denominator => _denominator;

  @override
  bool get isNegative => numerator < BigInt.zero;

  @override
  bool get isWhole => denominator == BigInt.one;

  @override
  bool operator ==(Object other) {
    // Two fractions are equal if their "cross product" is equal.
    //
    // ```dart
    // final one = Fraction(1, 2);
    // final two = Fraction(2, 4);
    //
    // final areEqual = (one == two); //true
    // ```
    //
    // The above example returns true because the "cross product" of `one` and
    // two` is equal (1*4 = 2*2).
    if (identical(this, other)) {
      return true;
    }

    if (other is BigFraction) {
      final fraction = other;

      return runtimeType == fraction.runtimeType &&
          (numerator * fraction.denominator ==
              denominator * fraction.numerator);
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 17;

    result = result * 37 + numerator.hashCode;
    result = result * 37 + denominator.hashCode;

    return result;
  }

  @override
  String toString() {
    if (denominator == BigInt.one) {
      return '$numerator';
    }

    return '$numerator/$denominator';
  }

  @override
  double toDouble() => numerator / denominator;

  @override
  BigFraction negate() => BigFraction(numerator * BigInt.from(-1), denominator);

  @override
  BigFraction reduce() {
    // Storing the sign for later use.
    final sign = (numerator < BigInt.zero) ? BigInt.from(-1) : BigInt.one;

    // Calculating the gcd for reduction.
    final lgcd = numerator.gcd(denominator);

    final num = (numerator * sign) ~/ lgcd;
    final den = (denominator * sign) ~/ lgcd;

    return BigFraction(num, den);
  }

  @override
  List<BigFraction> toEgyptianFraction() =>
      EgyptianBigFractionConverter(fraction: this).compute();

  /// If possible, this method converts this [BigFraction] instance into an
  /// unicode glyph string.
  ///
  /// A 'glyph' (or 'number form') is an unicode character that represents a
  /// fraction. For example, the glyph for "1/7" is ⅐. Only a very small subset
  /// of fractions have a glyph representation.
  ///
  /// ```dart
  /// final fraction = Fraction(1, 7);
  /// final str = fraction.toStringAsGlyph() // "⅐"
  /// ```
  ///
  /// If the conversion is not possible, a [FractionException] object is thrown.
  /// You can use the [isFractionGlyph] getter to determine whether this
  /// fraction can be converted into an unicode glyph or not.
  String toStringAsGlyph() {
    if (_valuesToGlyphs.containsKey(this)) {
      return _valuesToGlyphs[this]!;
    }

    throw FractionException(
      'This fraction ($this) does not have an unicode fraction glyph!',
    );
  }

  /// Converts this object into a [MixedBigFraction].
  MixedBigFraction toMixedFraction() => MixedBigFraction(
        whole: numerator ~/ denominator,
        numerator: numerator % denominator,
        denominator: denominator,
      );

  /// Creates a **deep** copy of this object with the given fields replaced
  /// with the new values.
  BigFraction copyWith({
    BigInt? numerator,
    BigInt? denominator,
  }) =>
      BigFraction(
        numerator ?? this.numerator,
        denominator ?? this.denominator,
      );

  /// Throws a [FractionException] whether [value] is infinite or [double.nan].
  static void _checkValue(num value) {
    if ((value.isNaN) || (value.isInfinite)) {
      throw const FractionException('NaN and Infinite are not allowed.');
    }
  }

  /// The numerator and the denominator of this object are swapped and returned
  /// in a new [BigFraction] object.
  BigFraction inverse() => BigFraction(denominator, numerator);

  /// Returns `true` if the numerator is smaller than the denominator.
  bool get isProper => numerator < denominator;

  /// Returns `true` if the numerator is equal or greater than the denominator.
  bool get isImproper => numerator >= denominator;

  /// Returns `true` if this [BigFraction] object has an associated unicode
  /// glyph.
  /// For example:
  ///
  /// ```dart
  /// Fraction(1, 2).hasUnicodeGlyph; // true
  /// ```
  ///
  /// The above returns `true` because "1/2" can be represented as ½, which is
  /// a valid 'unicode glyph'.
  bool get isFractionGlyph => _valuesToGlyphs.containsKey(this);

  /// The sum between two fractions.
  BigFraction operator +(BigFraction other) => BigFraction(
        numerator * other.denominator + denominator * other.numerator,
        denominator * other.denominator,
      );

  /// The difference between two fractions.
  BigFraction operator -(BigFraction other) => BigFraction(
        numerator * other.denominator - denominator * other.numerator,
        denominator * other.denominator,
      );

  /// The product of two fractions.
  BigFraction operator *(BigFraction other) => BigFraction(
        numerator * other.numerator,
        denominator * other.denominator,
      );

  /// The division of two fractions.
  BigFraction operator /(BigFraction other) => BigFraction(
        numerator * other.denominator,
        denominator * other.numerator,
      );

  /// Allows retrieving numerator or denominator by index. In particular, ´0´
  /// refers to the numerator and ´1´ to the denominator.
  ///
  /// Throws a [FractionException] object if [index] is not `0` or `1`.
  BigInt operator [](int index) {
    if (index == 0) {
      return numerator;
    }

    if (index == 1) {
      return denominator;
    }

    throw FractionException(
      'The index you gave ($index) is not valid: it must be either 0 or 1.',
    );
  }
}

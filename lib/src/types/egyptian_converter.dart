import 'package:big_fraction/big_fraction.dart';

/// This class converts a [BigFraction] or a [MixedBigFraction] type into its
/// egyptian fraction representation. Only positive number are allowed.
///
/// An Egyptian fraction is a finite sum of distinct fractions where the
/// numerator is always 1, the denominator is a positive number and all the
/// denominators differ from each other. For example:
///
///  - 5/8 = 1/2 + 1/8 (where "1/2 + 1/8" is the egyptian fraction)
///
/// Basically, egyptian fractions are a sum of fractions in the form 1/x that
/// represent a proper or an improper fraction. Here we have other examples of
/// fractions and their egyptian fraction equivalent:
///
///  - 4/7 = 1/2 + 1/14
///  - 43/48 = 1/2 + 1/3 + 1/16
///  - 2014/59 = 34 + 1/8 + 1/95 + 1/14947 + 1/670223480
///
/// In various cases, the value of the denominator can be so big that an
/// overflow error happens.
class EgyptianBigFractionConverter {
  /// This variable caches the result of the `compute()` method.
  static final _cache = <BigFraction, List<BigFraction>>{};

  /// The fraction to be converted into an egyptian fraction.
  final BigFraction fraction;

  /// Creates an [EgyptianBigFractionConverter] instance from a [BigFraction]
  /// object.
  const EgyptianBigFractionConverter({
    required this.fraction,
  });

  /// Creates an [EgyptianBigFractionConverter] instance from
  /// a [MixedBigFraction]
  /// object.
  EgyptianBigFractionConverter.fromMixedFraction({
    required MixedBigFraction mixedFraction,
  }) : this(fraction: mixedFraction.toFraction());

  /// Returns a series of [BigFraction]s representing the egyptian fraction of
  /// the current [fraction] object.
  ///
  /// Throws a [FractionException] if [fraction] is negative.
  List<BigFraction> compute() {
    if (fraction.isNegative) {
      throw const FractionException('The fraction must be positive!');
    }

    // If the result is in the cache, then return it immediately.
    if (_cache.containsKey(fraction)) {
      return _cache[fraction]!;
    }

    // Computing the fraction series
    final results = <BigFraction>[];

    var numerator = fraction.numerator;
    var denominator = fraction.denominator;

    while (numerator > BigInt.zero) {
      final egyptianDen = (denominator + numerator - BigInt.one) ~/ numerator;
      results.add(BigFraction(BigInt.one, egyptianDen));

      numerator = _modulo(-denominator, numerator);
      denominator *= egyptianDen;
    }

    // The value isn't in the cache at this point to we must add it
    _cache[fraction] = List<BigFraction>.from(results);

    return results;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is EgyptianBigFractionConverter) {
      return fraction == other.fraction;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => fraction.hashCode;

  @override
  String toString() {
    List<BigFraction> results;

    // Trying to not compute the fraction (if possible).
    if (_cache.containsKey(fraction)) {
      results = _cache[fraction]!;
    } else {
      results = compute();

      // We can cache it if caching is enabled.
      _cache[fraction] = List<BigFraction>.from(results);
    }

    final buffer = StringBuffer()..writeAll(results, ' + ');

    return buffer.toString();
  }

  BigInt _modulo(BigInt a, BigInt b) => ((a % b) + b) % b;
}

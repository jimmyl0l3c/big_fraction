import 'package:big_fraction/big_fraction.dart';

/// Extension method that adds [BigFraction] functionalities to [num].
extension BigFractionNum on num {
  /// Builds a [BigFraction] from an [int] or a [double].
  BigFraction toBigFraction() {
    if (this is int) {
      return BigFraction(BigInt.from(this));
    }

    return BigFraction.fromDouble(toDouble());
  }
}

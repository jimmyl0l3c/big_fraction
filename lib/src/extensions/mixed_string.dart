import 'package:big_fraction/big_fraction.dart';

/// Extension method that adds [MixedBigFraction] functionalities to [String].
extension MixedBigFractionString on String {
  /// Checks whether a string contains a valid representation of a mixed
  /// fraction in the 'a b/c' format:
  ///
  ///  * 'a', 'b' and 'c' must be integers;
  ///  * there can be the minus sign only in front of a;
  ///  * there must be exactly one space between the whole part and the
  ///  fraction.
  bool get isMixedBigFraction {
    try {
      MixedBigFraction.fromString(this);

      return true;
    } on Exception {
      return false;
    }
  }

  /// Converts the string into a [BigFraction].
  ///
  /// If you want to be sure that this method doesn't throw a
  /// [MixedFractionException] object, use `isFraction` before.
  MixedBigFraction toMixedBigFraction() => MixedBigFraction.fromString(this);
}

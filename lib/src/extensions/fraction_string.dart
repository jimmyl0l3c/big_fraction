import 'package:big_fraction/big_fraction.dart';

/// Extension method that adds [BigFraction] functionalities to [String].
extension BigFractionString on String {
  /// Checks whether the string contains a valid representation of a fraction in
  /// the 'a/b' format.
  ///
  /// Note that 'a' and 'b' must be integers.
  bool get isBigFraction {
    try {
      BigFraction.fromString(this);

      return true;
    } on Exception {
      try {
        BigFraction.fromGlyph(this);

        return true;
      } on Exception {
        return false;
      }
    }
  }

  /// Converts the string into a [BigFraction].
  ///
  /// If you want to be sure that this method doesn't throw a
  /// [FractionException], use `isFraction` before.
  BigFraction toBigFraction() {
    try {
      return BigFraction.fromString(this);
    } on FractionException {
      return BigFraction.fromGlyph(this);
    }
  }
}

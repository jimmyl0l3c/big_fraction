import 'package:big_fraction/big_fraction.dart';

/// Extension method that adds [MixedBigFraction] functionalities to [num].
extension MixedBigFractionNum on num {
  /// Builds a [MixedBigFraction] from an [int] or a [double].
  ///
  /// If the value cannot be expressed as a mixed fraction, a
  /// [MixedFractionException] exception is thrown.
  MixedBigFraction toMixedBigFraction() =>
      MixedBigFraction.fromFraction(toBigFraction());
}

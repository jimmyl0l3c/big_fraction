import 'package:big_fraction/big_fraction.dart';

/// Exception object thrown by a [BigFraction] object.
class FractionException implements Exception {
  /// The error message.
  final String message;

  /// Represents an error raised from the [BigFraction] class.
  const FractionException(this.message);

  @override
  String toString() => 'FractionException: $message';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is FractionException) {
      final exception = other;

      return runtimeType == exception.runtimeType &&
          message == exception.message;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => message.hashCode;
}

/// Exception object thrown by a [MixedBigFraction] object.
class MixedFractionException implements Exception {
  /// Error message.
  final String message;

  /// Represents an error raised from the [MixedBigFraction] class.
  const MixedFractionException(this.message);

  @override
  String toString() => 'MixedFractionException: $message';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is MixedFractionException) {
      final exception = other;

      return runtimeType == exception.runtimeType &&
          message == exception.message;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => message.hashCode;
}

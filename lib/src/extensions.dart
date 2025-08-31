
import 'package:flutter_form_validators/src/enums/card_type.dart';

/// Extension to provide validLengths and prefixes for CreditCardType.
extension CreditCardTypeUtils on CreditCardType {
  /// Returns the typical length for this card type.
  List<int> get validLengths {
    switch (this) {
      case CreditCardType.visa:
        return [13, 16, 19];
      case CreditCardType.mastercard:
        return [16];
      case CreditCardType.amex:
        return [15];
      case CreditCardType.discover:
        return [16];
    }
  }

  /// Returns the prefix patterns for this card type.
  List<String> get prefixes {
    switch (this) {
      case CreditCardType.visa:
        return ['4'];
      case CreditCardType.mastercard:
        return ['5', '2221-2720'];
      case CreditCardType.amex:
        return ['34', '37'];
      case CreditCardType.discover:
        return ['6011', '622126-622925', '644-649', '65'];
    }
  }

}



/// Extension methods for CreditCardType enum.
extension CreditCardTypeExtension on CreditCardType {
  /// Returns the display name of the credit card type.
  String get displayName {
    switch (this) {
      case CreditCardType.visa:
        return 'Visa';
      case CreditCardType.mastercard:
        return 'Mastercard';
      case CreditCardType.amex:
        return 'American Express';
      case CreditCardType.discover:
        return 'Discover';
    }
  }
}
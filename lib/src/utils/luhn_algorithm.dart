import 'package:form_validators_plus/form_validators_plus.dart';

/// Implementation of the Luhn algorithm for credit card validation.
///
/// The Luhn algorithm is a simple checksum formula used to validate
/// various identification numbers, including credit card numbers,
/// IMEI numbers, and Canadian social insurance numbers.
class LuhnAlgorithm {
  LuhnAlgorithm._();

  /// Validates a credit card number using the Luhn algorithm.
  ///
  /// The algorithm works by:
  /// 1. Starting from the rightmost digit, double every second digit
  /// 2. If doubling results in a two-digit number, add the digits together
  /// 3. Sum all the digits
  /// 4. If the sum is divisible by 10, the number is valid
  ///
  /// Example:
  /// ```dart
  /// bool isValid = LuhnAlgorithm.validate('4532015112830366');
  /// print(isValid); // true
  /// ``
  static bool validate(String cardNumber) {
    if (cardNumber.isEmpty) return false;

    // remove all non-digit characters
    final String cleaned = _cleanedNumber(cardNumber);

    // must be at least 2 digits and all digits
    if (cleaned.length < 2 || !_isAllDigits(cleaned)) {
      return false;
    }

    return _luhnCheck(cleaned);
  }

  /// Validates a credit card number with additional length constraints.
  ///
  /// Credit cards typically have 13-19 digits:
  /// - American Express: 15 digits
  /// - Visa: 13, 16, or 19 digits
  /// - Mastercard: 16 digits
  /// - Discover: 16 digits
  static bool validateCreditCard(String number) {
    final cleaned = _cleanedNumber(number);

    // checks the constraints of the card number
    if (cleaned.length < 13 || cleaned.length > 19) {
      return false;
    }

    return validate(number);
  }

  /// Generates a valid Luhn check digit for a partial number.
  ///
  /// Given a partial number, this method calculates what the
  /// final digit should be to make the entire number valid
  /// according to the Luhn algorithm.
  ///
  /// Example:
  /// ```dart
  /// int checkDigit = LuhnAlgorithm.generateCheckDigit('453201511283036');
  /// print(checkDigit); // 6 (making the full number 4532015112830366)
  /// ```
  ///
  static int generateCheckDigit(String partialNumber) {
    if (partialNumber.isEmpty) {
      throw ArgumentError('partial number cannot be empty');
    }

    final cleaned = _cleanedNumber(partialNumber);

    if (!_isAllDigits(cleaned)) {
      throw ArgumentError("partial digits must contain only digits");
    }

    /// calculate sum for partial numbers (treating it as if check digit is 0)
    final int sum = _calculateLuhnSum('${cleaned}0');

    // The check digit is what we need to add to make sum divisible by 10
    return (10 - (sum % 10)) % 10;
  }

  /// replaces all non-digit characters from the card number string with an empty string
  static String _cleanedNumber(String cardNumber) {
    return cardNumber.replaceAll(RegExp(r'[^\d]'), '');
  }

  /// checks if the cleaned string contains only digits
  static bool _isAllDigits(String cleaned) {
    return RegExp(r'^\d+$').hasMatch(cleaned);
  }

  /// performs the Luhn algorithm check on the cleaned string
  static bool _luhnCheck(String cleaned) {
    final int sum = _calculateLuhnSum(cleaned);
    return sum % 10 == 0;
  }

  /// calculates the Luhn sum for the cleaned string
  static int _calculateLuhnSum(String number) {
    int sum = 0;
    bool alternate = false;

    // Process digits from right to left
    for (int i = number.length - 1; i >= 0; i--) {
      int digit = int.parse(number[i]);

      if (alternate) {
        digit *= 2;
        // If doubling results in two digits, add them together
        if (digit > 9) {
          digit = (digit % 10) + (digit ~/ 10);
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum;
  }

  /// Generates a random valid credit card number for testing purposes.
  ///
  /// **WARNING**: This is for testing only. Never use for actual transactions.
  ///
  /// Supported prefixes:
  /// - Visa: 4
  /// - Mastercard: 5
  /// - American Express: 34, 37
  ///
  /// Example:
  /// ```dart
  /// String testCard = LuhnAlgorithm.generateTestNumber(CreditCardType.visa);
  /// print(LuhnAlgorithm.validate(testCard)); // true
  /// ```
  ///
  static String generateTestNumber(CreditCardType type) {
    String prefix;
    int length;

    switch (type) {
      case CreditCardType.visa:
        prefix = '4';
        length = 16;
        break;
      case CreditCardType.mastercard:
        prefix = '5';
        length = 16;
        break;
      case CreditCardType.amex:
        prefix = (34 + (3 * (DateTime.now().millisecondsSinceEpoch % 2)))
            .toString(); // 34 or 37
        length = 15;
        break;
      case CreditCardType.discover:
        prefix = '6011';
        length = 16;
        break;
    }

    // Generate random digits to fill the length minus the prefix and check digit
    final random = DateTime.now().millisecondsSinceEpoch;
    String middle = '';
    final int remainingLength =
        length - prefix.length - 1; // -1 for check digit

    for (int i = 0; i < remainingLength; i++) {
      middle += ((random + i) % 10).toString();
    }

    final partialNumber = prefix + middle;
    final checkDigit = generateCheckDigit(partialNumber);
    return partialNumber + checkDigit.toString();
  }

  /// Detects the credit card type based on the number pattern.
  ///
  /// Uses standard industry prefixes to identify card types:
  /// - Visa: starts with 4
  /// - Mastercard: starts with 5
  /// - American Express: starts with 34 or 37
  /// - Discover: starts with 6011, 622126-622925, 644-649, or 65
  static CreditCardType? detectCardType(String cardNumber) {
    final cleaned = _cleanedNumber(cardNumber);

    if (cleaned.isEmpty) return null;

    // Visa starts with 4
    if (cleaned.startsWith('4')) {
      return CreditCardType.visa;
    }

    // Mastercard starts with 5 or 2221-2720
    if (cleaned.startsWith('5') ||
        (cleaned.length >= 4 &&
            int.tryParse(cleaned.substring(0, 4)) != null &&
            int.parse(cleaned.substring(0, 4)) >= 2221 &&
            int.parse(cleaned.substring(0, 4)) <= 2720)) {
      return CreditCardType.mastercard;
    }

    //American Express: starts with 34 or 37
    if (cleaned.startsWith("34") || cleaned.startsWith("37")) {
      return CreditCardType.amex;
    }

    // Discover : multiple patterns
    if (cleaned.startsWith('6011') ||
        cleaned.startsWith('65') ||
        (cleaned.length >= 6 &&
            int.tryParse(cleaned.substring(0, 6)) != null &&
            int.parse(cleaned.substring(0, 6)) >= 622126 &&
            int.parse(cleaned.substring(0, 6)) <= 622925) ||
        (cleaned.length >= 3 &&
            int.tryParse(cleaned.substring(0, 3)) != null &&
            int.parse(cleaned.substring(0, 3)) >= 644 &&
            int.parse(cleaned.substring(0, 3)) <= 649)) {
      return CreditCardType.discover;
    }

    return null;
  }
}

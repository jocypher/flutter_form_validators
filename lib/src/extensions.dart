import 'package:flutter_form_validators/flutter_form_validators.dart';

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

///Extension methods on Strings for convenient validations and manipulations.
///
///These extensions provide easy access to common validation checks and formatting
///operations directly on String instances.
///without needing to call separate utility functions.
extension StringValidationExtension on String? {
  /// BASIC CHECKS

  // returns true if the string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  // returns true if the string is null or empty or contains an empty whiteSpace
  bool get isNullOrWhiteSpace => this == null || this!.trim().isEmpty;

  // returns true if the string has content
  bool get hasContent => !isNullOrWhiteSpace;

  //returns the length of the string or 0 if null
  int get safeLength => this?.length ?? 0;

  ///
  ///  EMAIL VALIDATIONS
  ///

  // return true if the email is valid
  // Uses a comprehensive regex pattern supporting email formats
  bool get isValidEmail {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this!, RegexPatterns.email);
  }

  // returns true if the email is valid using simple pattern
  // more permissive than [isValidEmail] but faster
  bool get isSimpleEmail {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this!, RegexPatterns.emailSimple);
  }

  ///.
  /// NUMERIC VALIDATION
  ///

  // returns true if the string are only numeric characters
  bool get isNumeric {
    if (isNullOrEmpty) return false;
    return double.tryParse(this!) != null;
  }

  // returns true if the string is a valid integer
  bool get isInteger {
    if (isNullOrEmpty) return false;
    return int.tryParse(this!) != null;
  }

  // returns true if the string is a positive number
  bool get isPositive {
    if (!isNumeric) return false;
    final double number = double.parse(this!);
    return number >= 0;
  }

  // returns true if the string is a negative number
  bool get isNegative {
    if (!isNumeric) return false;
    final double number = double.parse(this!);
    return number < 0;
  }

  // returns true if the string matches the currency format
  bool get isCurrency {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this!, RegexPatterns.currency);
  }

  /// URL VALIDATION
  ///

  // returns true if the url is a valid one
  bool get isValidUrl {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this!, RegexPatterns.url);
  }

  // returns true if the domain is valid
  bool get isValidDomain {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this!, RegexPatterns.domain);
  }

  /// PHONE NUMBER VALIDATION
  ///

  // returns true if the string is a valid phone number depending on the country
  bool get isValidPhoneNumberGH {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this, RegexPatterns.phoneGH);
  }

  // returns true if the string is a valid GHANA number
  bool get isValidPhoneNumberUS {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this, RegexPatterns.phoneUS);
  }

  bool get isValidPhoneNumberUK {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this, RegexPatterns.phoneUK);
  }

  bool get isValidInternationalNumber {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this, RegexPatterns.phoneInternational);
  }

  /// PASSWORD VALIDATION
  ///

  // returns true if the string contains at least one uppercase letter
  bool get hasUpperCase =>
      RegexPatterns.matches(this!, RegexPatterns.upperCase);

  // returns true if the string contains at least one lowercase letter
  bool get hasLowerCase =>
      RegexPatterns.matches(this!, RegexPatterns.lowerCase);

  // returns true if the string contains atleast one digit
  bool get hasDigit => RegexPatterns.matches(this!, RegexPatterns.digit);

  // returns true if the string has a special character
  bool get hasSpecialChar =>
      RegexPatterns.matches(this!, RegexPatterns.specialCharacter);

  // returns true if the String has an extended special character
  bool get hasExtendedSpecialChar =>
      RegexPatterns.matches(this!, RegexPatterns.extendedSpecialCharacters);

  /// returns true if the string is a strong password.
  ///
  /// A strong password must:
  /// - Be at least 8 characters long
  /// - Contain uppercase and lowercase letters
  /// - Contain at least one digit
  /// - Contain at least one special character

  bool get isStrongPassword {
    if (isNullOrEmpty || this!.length < 8) return false;
    return hasUpperCase && hasLowerCase && hasDigit && hasSpecialChar;
  }

  /// Returns the password strength score (0-5).
  ///
  /// Scoring criteria:
  /// - Length >= 8: +1 point
  /// - Contains uppercase: +1 point
  /// - Contains lowercase: +1 point
  /// - Contains digit: +1 point
  /// - Contains special character: +1 point
  ///
  int get passwordScoreStrength {
    if (isNullOrEmpty) return 0;

    int score = 0;

    if (this!.length > 8) score++;
    if (hasUpperCase) score++;
    if (hasLowerCase) score++;
    if (hasDigit) score++;
    if (hasSpecialChar) score++;

    return score;
  }

  /// Returns the password strength level as a string.
  String get passwordStrengthLevel {
    switch (passwordScoreStrength) {
      case 0:
      case 1:
        return 'Very Weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Fair';
      case 4:
        return 'Strong';
      case 5:
        return 'Very Strong';
      default:
        return 'Unknown';
    }
  }

  /// USERNAME VALIDATION
  ///

  // returns true if the string contains only alphanumeric characters
  bool get isAlphaNumeric {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this!, RegexPatterns.alphanumeric);
  }

  // returns true if the string contains only alphabetic characters
  bool get isAlphabetic {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this!, RegexPatterns.alphabetic);
  }

  /// returns true if the string is a valid username
  /// (alphanumeric, underscores, hyphenes, 3-20 characters)
  bool get isValidUsername {
    if (isNullOrEmpty) return false;
    if (this!.length < 3 || this!.length > 20) return false;
    return RegexPatterns.matches(this!, RegexPatterns.username);
  }

  /// returns true if the string is a valid name format.
  /// (letters, spaces, apostrophes, hyphens)
  bool get isValidName {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this!, RegexPatterns.name);
  }

  /// CREDIT CARD VALIDATION
  ///

  // returns true if string is a valid credit card number (using Luhn check)
  bool get isValidCreditCard {
    if (isNullOrEmpty) return false;
    return LuhnAlgorithm.validateCreditCard(this!);
  }

  // returns the detected credit card type, or null if invalid
  CreditCardType? get creditCardType {
    if (isNullOrEmpty) return null;
    return LuhnAlgorithm.detectCardType(this!);
  }

  // returns true if the string is a valid Visa card number.
  bool get isValidVisa {
    if (!isValidCreditCard) return false;
    return creditCardType == CreditCardType.visa;
  }

  // returns true if the string is a valid Mastercard number.
  bool get isValidMastercard {
    if (!isValidCreditCard) return false;
    return creditCardType == CreditCardType.mastercard;
  }

  // DATE AND TIME MANIPULATION
  ///
  ///

  /// returns true if the string is a valid date in YYYY-MM-DD
  bool get isValidDateYMD {
    if (isNullOrEmpty) return false;
    if (!RegexPatterns.matches(this, RegexPatterns.dateYMD)) return false;

    try {
      DateTime.tryParse(this!);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// returns true if the string is a valid date in MM/DD/YYYY format.
  bool get isValidDateMDY {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this!, RegexPatterns.dateMDY);
  }

  /// returns true if the string is a valid date in DD/MM/YYYY format.
  bool get isValidDateDMY {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this!, RegexPatterns.dateDMY);
  }

  /// returns true if the string is a valid time in 24-hour format (HH:MM).
  bool get isValidTime24 {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this!, RegexPatterns.time24Hour);
  }

  /// returns true if the string is a valid time in 12-hour format (HH:MM AM/PM).
  bool get isValidTime12 {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this!, RegexPatterns.time12Hour);
  }

//
//  GEOGRAPHIC LOCATION
//

  /// returns true if the string is a valid US Zip code
  bool get isValidZipCode {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this!, RegexPatterns.zipCodeUS);
  }

  /// returns true if the string is a valid Canadian postal code.
  bool get isValidCanadianPostalCode {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(
        this!.toUpperCase(), RegexPatterns.postalCodeCA);
  }

  /// returns true if the string is a valid UK postal code.
  bool get isValidUKPostalCode {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(
        this!.toUpperCase(), RegexPatterns.postalCodeUK);
  }

  /// returns true if the string is a valid US Social Security Number.
  bool get isValidSSN {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this!, RegexPatterns.ssn);
  }

  // NETWORK VALIDATION
  //
  //

  /// returns true if the string is a valid IPv4 address.
  bool get isValidIPv4 {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this!, RegexPatterns.ipv4);
  }

  /// returns true if the string is a valid IPv6 address.
  ///
  /// Supports all IPv6 formats including:
  /// - Full: 2001:0db8:85a3:0000:0000:8a2e:0370:7334
  /// - Compressed: 2001:db8:85a3::8a2e:370:7334
  /// - Loopback: ::1
  /// - All zeros: ::
  /// - IPv4-mapped: ::ffff:192.0.2.1
  bool get isValidIPv6 {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this!, RegexPatterns.ipv6);
  }

  /// Returns true if the string is a valid IP address (IPv4 or IPv6).
  bool get isValidIPAddress {
    return isValidIPv4 || isValidIPv6;
  }

  /// Returns true if the string is a valid MAC address.
  bool get isValidMacAddress {
    if (isNullOrEmpty) return false;
    return RegexPatterns.matches(this!, RegexPatterns.macAddress);
  }

  // VALUE CONVERSION

  /// returns the numeric value if string is numeric, otherwise null.
  double? get numericValue => double.tryParse(this ?? '');

  /// returns the integer value if string is integer, otherwise null.
  int? get intValue => int.tryParse(this ?? '');

  /// returns the datetime value if string is a valid date, otherwise null.
  DateTime? get dateTime {
    if (isNullOrEmpty) return null;
    try {
      return DateTime.parse(this!);
    } catch (e) {
      return null;
    }
  }

  /// returns the uri value if string is a valid url, otherwise null
  Uri? get uriValue {
    if (isNullOrEmpty) return null;
    try {
      return Uri.parse(this!);
    } catch (e) {
      return null;
    }
  }

  // STRING MANIPULATION
  //

  /// Capitalizes first letter
  String get capitalized {
    if (isNullOrEmpty) return this!;
    if (this!.length == 1) return this!.toUpperCase();
    return this![0].toUpperCase() + this!.substring(1).toLowerCase();
  }

  /// Converts the string to title case (first letter of each word capitalized)
  String? get titleCase {
    if (isNullOrEmpty) return this;
    return this!.split(" ").map((word) => word.capitalized).join(" ");
  }

  /// removes all whitespaces
  String? get removeWhiteSpace {
    if (isNullOrEmpty) return this;
    return this!.replaceAll(RegExp(r'\s+'), '');
  }

  /// removes all non-alphabetic characters from the string.
  String? get alphabeticOnly {
    if (isNullOrEmpty) return this;
    return this!.replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }

  /// removes all non-numeric characters from the string.
  String? get numericOnly {
    if (isNullOrEmpty) return this;
    return this!.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// removes all non-alphanumeric characters from the string.
  String? get alphanumericOnly {
    if (isNullOrEmpty) return this;
    return this!.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  /// Masks the string, showing only the first and last n characters.
  ///
  /// Example:
  /// ```dart
  /// '1234567890'.masked(2) // '12****7890'
  /// ```
  String? masked(int visibleChars, {String maskChar = '*'}) {
    if (isNullOrEmpty || this!.length <= visibleChars * 2) return this;

    final start = this!.substring(0, visibleChars);
    final end = this!.substring(this!.length - visibleChars);
    final middle = maskChar * (this!.length - visibleChars * 2);

    return start + middle + end;
  }

  /// Truncates the string to the specified length with ellipsis.
  String? truncate(int maxLength, {String ellipsis = '...'}) {
    if (isNullOrEmpty || this!.length <= maxLength) return this;
    return this!.substring(0, maxLength - ellipsis.length) + ellipsis;
  }

  // UTILITY METHODS

  /// returns true if the string contains only ASCII characters.
  bool get isAscii {
    if (isNullOrEmpty) return true;
    return this!.codeUnits.every((unit) => unit <= 127);
  }

  /// returns the number of words in the string.
  int get wordCount {
    if (isNullOrWhiteSpace) return 0;
    return this!.trim().split(RegExp(r'\s+')).length;
  }

  /// returns true if the string is a palindrome (reads same forwards and backwards).
  bool get isPalindrome {
    if (isNullOrEmpty) return true;
    final cleaned = this!.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return cleaned == cleaned.split('').reversed.join('');
  }

  /// returns the reverse of the string.
  String? get reversed {
    if (isNullOrEmpty) return this;
    return this!.split('').reversed.join('');
  }

  /// returns true if the string contains the specified substring (case-insensitive).
  bool containsIgnoreCase(String substring) {
    if (isNullOrEmpty) return false;
    return this!.toLowerCase().contains(substring.toLowerCase());
  }

  /// returns true if the string matches any of the provided patterns.
  bool matchesAny(List<String> patterns) {
    if (isNullOrEmpty) return false;
    return patterns.any((pattern) => RegExp(pattern).hasMatch(this!));
  }

  /// returns true if the string is within the specified length range.
  bool isLengthBetween(int min, int max) {
    final length = safeLength;
    return length >= min && length <= max;
  }

  /// Returns a formatted string for displaying sensitive data.
  ///
  /// Examples:
  /// - Credit card: '1234 5678 9012 3456'
  /// - Phone: '(123) 456-7890'
  /// - SSN: '123-45-6789'
  String? formatSensitiveData(SensitiveDataType type) {
    if (isNullOrEmpty) return this;

    final cleaned = numericOnly!;

    switch (type) {
      case SensitiveDataType.creditCard:
        if (cleaned.length >= 13) {
          return cleaned
              .replaceAllMapped(
                RegExp(r'(\d{4})(?=\d)'),
                (match) => '${match.group(1)} ',
              )
              .trim();
        }
        break;
      case SensitiveDataType.phone:
        if (cleaned.length == 10) {
          return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
        }
        break;
      case SensitiveDataType.ssn:
        if (cleaned.length == 9) {
          return '${cleaned.substring(0, 3)}-${cleaned.substring(3, 5)}-${cleaned.substring(5)}';
        }
        break;
    }

    return this;
  }
}

/// Enum for different types of sensitive data formatting.
enum SensitiveDataType {
  creditCard,
  phone,
  ssn,
}

/// Extension methods on List ``String`` for validation.
extension StringListValidationExtensions on List<String> {
  /// Returns true if all strings in the list are valid emails.
  bool get allValidEmails => every((email) => email.isValidEmail);

  /// Returns true if all strings in the list have content.
  bool get allHaveContent => every((str) => str.hasContent);

  /// Returns only the valid email addresses from the list.
  List<String> get validEmails => where((email) => email.isValidEmail).toList();

  /// Returns only the strings that have content.
  List<String> get withContent => where((str) => str.hasContent).toList();

  /// Returns the strings that match the given pattern.
  List<String> matching(String pattern) {
    return where((str) => RegExp(pattern).hasMatch(str)).toList();
  }
}

/// Extension for DateFormat enum.
extension DateFormatExtension on DateFormat {
  String get pattern {
    switch (this) {
      case DateFormat.ymd:
        return 'YYYY-MM-DD';
      case DateFormat.mdy:
        return 'MM/DD/YYYY';
      case DateFormat.dmy:
        return 'DD/MM/YYYY';
    }
  }

  String get regexPattern {
    switch (this) {
      case DateFormat.ymd:
        return RegexPatterns.dateYMD;
      case DateFormat.mdy:
        return RegexPatterns.dateMDY;
      case DateFormat.dmy:
        return RegexPatterns.dateDMY;
    }
  }
}

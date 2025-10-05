import 'package:flutter_form_validators/flutter_form_validators.dart';
import 'package:flutter_form_validators/src/enums/countries.dart';
import 'package:flutter_form_validators/src/enums/date_format.dart';
import 'package:flutter_form_validators/src/enums/phone_regions.dart';
import 'package:flutter_form_validators/src/utils/validator_utilities.dart';

/// A function that represents a form field validator.
/// It takes in a string value and returns a string error message if validation fails,
/// or null if validation passes.
/// For example:
typedef Validator = String? Function(String? value);

/// A comprehensive collection of form field validators for Flutter applications.
///
/// This class provides a wide range of validation functions that can be used
/// with Flutter's TextFormField and other form widgets.
///
/// Example usage:
/// ```dart
/// TextFormField(
///   validator: Validators.combine([
///     Validators.required(),
///     Validators.email(),
///     Validators.minLength(5),
///   ]),
/// )
/// ```
///
class Validators {
  Validators._();

  // CORE VALIDATORS

  /// validates that a field is not empty or null
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.required(message: 'This field is required')
  ///
  /// ```
  static Validator required({
    String message = "This field is required",
    String? locale,
  }) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) {
        return locale != null
            ? ValidatorUtilities.getLocalizedMessage("required", locale)
            : message;
      }
      return null;
    };
  }

  /// Validates email format using a comprehensive regex pattern
  ///
  /// Supports most common email formats including internationalized domains
  ///
  /// Example:
  ///
  /// ``` dart
  /// TextFormField(
  /// validator: Validators.email(message:"Invalid email")
  /// )
  static Validator email(
      {String message = "Please enter a valid email",
      bool useSimplePattern = false,
      String? locale}) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      final pattern =
          useSimplePattern ? RegexPatterns.emailSimple : RegexPatterns.email;

      final isValid = RegexPatterns.matches(value, pattern);

      if (!isValid) {
        return locale != null
            ? ValidatorUtilities.getLocalizedMessage("email", locale)
            : message;
      }
      return null;
    };
  }

  /// Validates the minimum length requirement
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  /// validator: Validators.minLength(8, message:'Too short')
  /// )
  /// ```
  ///
  static Validator minLength(
    int length, {
    String? message,
    String? locale,
  }) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      final result = ValidatorUtilities.validateLength(value, length, null);
      if (!result.isValid) {
        return locale != null
            ? ValidatorUtilities.getLocalizedMessage('minLength', locale,
                params: {'min': length})
            : (message ?? result.errorMessage);
      }

      return null;
    };
  }

  /// Validates the maximum length
  /// Example:
  /// ``` dart
  /// TextFormField(
  /// validator: Validator.maxLength(50, message:"Too Long")
  /// )
  /// ```
  ///
  static Validator maxLength(int maxLength, {String? message, String? locale}) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      final results = ValidatorUtilities.validateLength(value, null, maxLength);
      if (!results.isValid) {
        return locale != null
            ? ValidatorUtilities.getLocalizedMessage("maxLength", locale,
                params: {'max': maxLength})
            : (message ?? results.errorMessage);
      }
      return null;
    };
  }

  /// Validates that input contains only numeric characters.
  /// Supports both integers and decimal numbers.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.numeric(allowDecimal: false),
  /// )
  /// ```
  static Validator numeric(
      {String message = 'Please enter a valid number',
      bool allowDecimal = true,
      bool allowNegative = true}) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      String pattern;

      if (allowDecimal && allowNegative) {
        pattern = RegexPatterns.decimal;
      } else if (allowDecimal && !allowNegative) {
        pattern = RegexPatterns.positiveDecimal;
      } else if (!allowDecimal && allowNegative) {
        pattern = RegexPatterns.integer;
      } else {
        pattern = RegexPatterns.positiveInteger;
      }

      return RegexPatterns.matches(value!, pattern) ? null : message;
    };
  }

  /// Validates URL format with support for various protocols.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.url(requireHttps: true),
  /// )
  /// ```
  static Validator url(
      {String message = "Please enter a valid url",
      bool allowHttps = false,
      bool allowLocalhost = true}) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      if (allowHttps && !value!.startsWith("https://")) {
        return 'URL must use HTTPS';
      }
      if (!allowLocalhost && value!.contains("localhost")) {
        return 'Localhost URLs are not allowed';
      }

      return RegexPatterns.matches(value, RegexPatterns.url) ? null : message;
    };
  }

  /// ADVANCED VALIDATORS

  /// Validates password strength with comprehensive customizable requirements.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.password(
  ///     minLength: 12,
  ///     requireSpecialChars: false,
  ///   ),
  /// )
  /// ```
  static Validator password(
      {int minLength = 8,
      int? maxLength,
      bool requireUpperCase = true,
      bool requireLowerCase = true,
      bool requireNumbers = true,
      bool requireSpecialChars = true,
      List<String>? forbiddenPasswords,
      String? username,
      String? message}) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      final result = ValidatorUtilities.validatePasswordComplexity(
          value: value,
          minLength: minLength,
          maxLength: maxLength,
          requireLowercase: requireLowerCase,
          requireUppercase: requireUpperCase,
          requireNumbers: requireNumbers,
          requireSpecialChars: requireSpecialChars,
          forbiddenPasswords: forbiddenPasswords,
          username: username);

      return result.isValid ? null : (message ?? result.errorMessage);
    };
  }

  /// Validates phone number format with support for multiple regions.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.phoneNumber(region: PhoneRegion.international),
  /// )
  /// ```
  static Validator phoneNumber(
      {PhoneRegion phoneRegion = PhoneRegion.gh,
      String? customPattern,
      String message = "Please enter a valid number"}) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;
      String pattern;

      switch (phoneRegion) {
        case PhoneRegion.gh:
          final cleaned = ValidatorUtilities.extractDigits(value);
          pattern = RegexPatterns.phoneGH;
          value = cleaned;
          break;
        case PhoneRegion.us:
          final cleaned = ValidatorUtilities.extractDigits(value);
          pattern = RegexPatterns.phoneUS;
          value = cleaned;
          break;
        case PhoneRegion.uk:
          pattern = RegexPatterns.phoneUK;
          break;
        case PhoneRegion.international:
          pattern = RegexPatterns.phoneInternational;
          break;
        case PhoneRegion.custom:
          if (customPattern == null) {
            throw ArgumentError(
                "Custom pattern must be provided for custom region");
          }
          pattern = customPattern;
          break;
      }
      return RegexPatterns.matches(value!, pattern) ? null : message;
    };
  }

  /// Validates credit card number using the Luhn algorithm with enhanced features.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.creditCard(
  ///     acceptedTypes: [CreditCardType.visa, CreditCardType.mastercard],
  ///   ),
  /// )
  /// ```
  static Validator creditCard(
      {String message = "please enter a valid card number",
      List<CreditCardType>? acceptedTypes,
      bool formatInput = false}) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      if (!LuhnAlgorithm.validateCreditCard(value!)) {
        return message;
      }

      if (acceptedTypes != null) {
        final cardType = LuhnAlgorithm.detectCardType(value);
        if (cardType == null || !acceptedTypes.contains(cardType)) {
          final acceptedNames =
              acceptedTypes.map((t) => t.displayName).join(',');
          return 'Only $acceptedNames cards are accepted';
        }
      }
      return null;
    };
  }

  /// Validates that two fields match (useful for password confirmation).
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.match(
  ///     passwordController.text,
  ///     message: 'Passwords must match',
  ///   ),
  /// )
  /// ```
  static Validator match(
    String matchValue, {
    String message = 'Values do not match',
    bool caseSensitive = true,
    bool trimWhitespace = true,
  }) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      String processedValue = value!;
      String processedMatch = matchValue;

      if (trimWhitespace) {
        processedValue = processedValue.trim();
        processedMatch = processedMatch.trim();
      }

      if (!caseSensitive) {
        processedValue = processedValue.toLowerCase();
        processedMatch = processedMatch.toLowerCase();
      }

      return processedValue == processedMatch ? null : message;
    };
  }

  /// Validates username format with comprehensive rules.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.username(
  ///     allowNumbers: false,
  ///     mustStartWithLetter: true,
  ///   ),
  /// )
  /// ```
  static Validator username({
    int minLength = 3,
    int maxLength = 20,
    bool allowNumbers = true,
    bool allowUnderscore = true,
    bool allowHyphen = true,
    bool mustStartWithLetter = false,
    String? message,
  }) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      final lengthResult =
          ValidatorUtilities.validateLength(value, minLength, maxLength);
      if (!lengthResult.isValid) {
        return message ?? lengthResult.errorMessage;
      }

      // Build pattern based on options
      String pattern = r'^';

      if (mustStartWithLetter) {
        pattern += r'[a-zA-Z]';
        pattern += r'[a-zA-Z';
        if (allowNumbers) pattern += r'0-9';
        if (allowUnderscore) pattern += r'_';
        if (allowHyphen) pattern += r'-';
        pattern += r']*';
      } else {
        pattern += r'[a-zA-Z';
        if (allowNumbers) pattern += r'0-9';
        if (allowUnderscore) pattern += r'_';
        if (allowHyphen) pattern += r'-';
        pattern += r']+';
      }

      pattern += r'$';

      if (!RegExp(pattern).hasMatch(value!)) {
        return message ?? 'Username contains invalid characters';
      }
      return null;
    };
  }

  /// Validates date format with enhanced parsing and range checking.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.date(
  ///     format: DateFormat.mdy,
  ///     minDate: DateTime(1900, 1, 1),
  ///     maxDate: DateTime.now(),
  ///   ),
  /// )
  /// ```
  static Validator date({
    DateFormat format = DateFormat.ymd,
    DateTime? minDate,
    DateTime? maxDate,
    String? message,
  }) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      final dateResult =
          ValidatorUtilities.validateDate(value, format: format.pattern);
      if (!dateResult.isValid) {
        return message ?? dateResult.errorMessage;
      }

      if (minDate != null || maxDate != null) {
        final rangeResult =
            ValidatorUtilities.validateDateRange(value, minDate, maxDate);
        if (!rangeResult.isValid) {
          return message ?? rangeResult.errorMessage;
        }
      }

      return null;
    };
  }

  /// Validates that value is within a numeric range with enhanced features.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.range(
  ///     18, 65,
  ///     message: 'Age must be between 18 and 65',
  ///   ),
  /// )
  /// ```
  static Validator range(
    double min,
    double max, {
    String? message,
    bool inclusive = true,
  }) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      final number = double.tryParse(value!);
      if (number == null) {
        return 'Please enter a valid number';
      }

      bool isValid;
      if (inclusive) {
        isValid = number >= min && number <= max;
      } else {
        isValid = number > min && number < max;
      }

      if (!isValid) {
        final operator = inclusive ? 'between' : 'strictly between';
        return message ?? 'Value must be $operator $min and $max';
      }

      return null;
    };
  }

  /// Validates postal codes for different countries.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.postalCode(country: Country.canada),
  /// )
  /// ```
  static Validator postalCode({
    Countries country = Countries.us,
    String? message,
  }) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      String pattern;
      String countryName;

      switch (country) {
        case Countries.us:
          pattern = RegexPatterns.zipCodeUS;
          countryName = 'US';
          break;
        case Countries.canada:
          pattern = RegexPatterns.postalCodeCA;
          countryName = 'Canadian';
          value = value!.toUpperCase();
          break;
        case Countries.uk:
          pattern = RegexPatterns.postalCodeUK;
          countryName = 'UK';
          value = value!.toUpperCase();
          break;
      }
      final isValid = RegexPatterns.matches(value!, pattern);
      return isValid
          ? null
          : (message ?? 'Please enter a valid $countryName postal code');
    };
  }

  /// Validates Social Security Numbers.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.ssn(),
  /// )
  /// ```
  static Validator ssn(
      {String message = "Please enter a valid Social Security Number",
      bool requiresHyphen = true}) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      if (requiresHyphen) {
        return RegexPatterns.matches(value!, RegexPatterns.ssn)
            ? null
            : message;
      } else {
        final digits = ValidatorUtilities.extractDigits(value);
        return digits.length == 9 ? null : message;
      }
    };
  }

  /// Validates IPv4 addresses.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.ipv4(),
  /// )
  /// ```
  static Validator ipv4(
      {String message = "Please enter a valid IPV4 address"}) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      return RegexPatterns.matches(value!, RegexPatterns.ipv4) ? null : message;
    };
  }

  /// Validates IPv6 addresses with comprehensive format support.
  ///
  /// Supports all IPv6 formats including compressed notation,
  /// loopback, IPv4-mapped, and more.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.ipv6(),
  /// )
  /// ```
  ///
  static Validator ipv6({
    String message = "Please enter a valid IPV6 address",
  }) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      return RegexPatterns.matches(value, RegexPatterns.ipv6) ? null : message;
    };
  }

  /// Validates IP addresses (both IPv4 and IPv6).
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.ipAddress(),
  /// )
  /// ```
  static Validator ipAddress(
      {String message = "Please enter a valid ip Address",
      bool allowIPV4 = false,
      bool allowIPV6 = false}) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      if (!allowIPV4 && !allowIPV6) {
        throw ArgumentError("At least one IP version must be allowed");
      }

      bool isValid = false;

      if (allowIPV4 && RegexPatterns.matches(value!, RegexPatterns.ipv4)) {
        isValid = true;
      }

      if (!isValid &&
          allowIPV6 &&
          RegexPatterns.matches(value!, RegexPatterns.ipv6)) {
        isValid = true;
      }

      return isValid ? null : message;
    };
  }

  /// Validates MAC addresses.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.macAddress(),
  /// )
  /// ```
  static Validator macAddress({
    String message = "Please enter a valid MAC address",
  }) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      return RegexPatterns.matches(value, RegexPatterns.macAddress)
          ? null
          : message;
    };
  }

  /// Validates input for security concerns (XSS, injection, etc.).
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.secure(),
  /// )
  /// ```
  static Validator secure({
    String message = 'Input contains potentially harmful content',
  }) {
    return (String? value) {
      if (ValidatorUtilities.isEmpty(value)) return null;

      final result = ValidatorUtilities.validateSecureInput(value);
      return result.isValid ? null : (message);
    };
  }
}

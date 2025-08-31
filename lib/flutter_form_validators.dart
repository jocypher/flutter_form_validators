// lib/flutter_form_validators.dart

/// A comprehensive collection of form field validators for Flutter applications.
///
/// This library provides an extensive set of validation functions that work
/// seamlessly with Flutter's TextFormField and other form widgets.
///
/// ## Features
///
/// - **15+ Built-in Validators**: Email, phone, credit card, password strength, etc.
/// - **Chainable API**: Combine multiple validators with ease
/// - **String Extensions**: Convenient validation methods on strings
/// - **Localization Support**: Multi-language error messages
/// - **Security Features**: XSS and injection protection
/// - **Advanced Credit Card**: Luhn algorithm with card type detection
/// - **Customizable**: Custom error messages and validation logic
///
/// ## Quick Start
///
/// ```dart
/// import 'package:flutter_form_validators/flutter_form_validators.dart';
///
/// // Simple usage
/// TextFormField(
///   validator: Validators.email(),
/// )
///
/// // Combined validators
/// TextFormField(
///   validator: Validators.combine([
///     Validators.required(),
///     Validators.minLength(8),
///     Validators.password(),
///   ]),
/// )
///
/// // String extensions
/// if ('test@example.com'.isValidEmail) {
///   print('Valid email!');
/// }
/// ```
///
/// ## Available Validators
///
/// ### Core Validators
/// - `required()` - Field must not be empty
/// - `email()` - Valid email format
/// - `minLength()` / `maxLength()` - Length constraints
/// - `numeric()` - Numbers only
/// - `url()` - Valid URL format
///
/// ### Advanced Validators
/// - `password()` - Password strength validation
/// - `phoneNumber()` - Phone number formats (US, UK, International)
/// - `creditCard()` - Credit card with Luhn algorithm
/// - `username()` - Username format validation
/// - `date()` - Date format validation
/// - `range()` - Numeric range validation
///
/// ### Geographic Validators
/// - `postalCode()` - US ZIP, Canadian, UK postal codes
/// - `ssn()` - US Social Security Numbers
///
/// ### Security Validators
/// - `secure()` - XSS and injection protection
///
/// ### Utility Validators
/// - `combine()` - Chain multiple validators
/// - `conditional()` - Conditional validation
/// - `custom()` - Create custom validators
/// - `match()` - Field matching (password confirmation)
///
/// ## String Extensions
///
/// The library includes powerful string extensions for quick validation:
///
/// ```dart
/// // Email validation
/// 'user@domain.com'.isValidEmail // true
///
/// // Password strength
/// 'MyPassword123!'.isStrongPassword // true
/// 'MyPassword123!'.passwordStrengthScore // 5
/// 'MyPassword123!'.passwordStrengthLevel // 'Very Strong'
///
/// // Credit card validation
/// '4532015112830366'.isValidCreditCard // true
/// '4532015112830366'.creditCardType // CreditCardType.visa
///
/// // Numeric checks
/// '123.45'.isNumeric // true
/// '123'.intValue // 123
/// '123.45'.numericValue // 123.45
///
/// // Text manipulation
/// 'hello world'.titleCase // 'Hello World'
/// 'sensitive data'.masked(2) // 'se*********ta'
/// '4532015112830366'.formatSensitiveData(SensitiveDataType.creditCard) // '4532 0151 1283 0366'
/// ```
///
/// ## Advanced Features
///
/// ### Localization Support
/// ```dart
/// TextFormField(
///   validator: Validators.email(locale: 'es'), // Spanish error messages
/// )
/// ```
///
/// ### Security Validation
/// ```dart
/// TextFormField(
///   validator: Validators.secure(), // Prevents XSS and injection
/// )
/// ```
///
/// ### Credit Card Type Detection
/// ```dart
/// final cardType = '4532015112830366'.creditCardType; // CreditCardType.visa
/// final isVisa = '4532015112830366'.isValidVisa; // true
/// ```
///
/// ### Password Strength Analysis
/// ```dart
/// final score = 'MyPassword123!'.passwordStrengthScore; // 0-5
/// final level = 'MyPassword123!'.passwordStrengthLevel; // 'Very Strong'
/// ```
///
/// ## Testing Utilities
///
/// The library includes utilities for generating test data:
///
/// ```dart
/// // Generate valid test credit card numbers
/// final testVisa = LuhnAlgorithm.generateTestNumber(CreditCardType.visa);
/// print(LuhnAlgorithm.validate(testVisa)); // true
/// ```
///
/// ## Examples
///
/// For complete examples, see the `/example` directory in the package repository.
library;

//library flutter_form_validators;

export 'src/validators.dart';
export 'src/extensions.dart';

export 'src/utils/luhn_algorithm.dart';

export 'src/enums/card_type.dart' show CreditCardType;
export 'src/regex_patterns.dart';
export 'src/extensions.dart' show CreditCardTypeExtension;

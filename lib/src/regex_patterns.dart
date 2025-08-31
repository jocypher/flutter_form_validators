/// A collection of common regex patterns used for validation.
/// You can use these patterns in your custom validators.
/// used throughout the validation library, making them easily maintainable
/// and testable.
/// For example, to validate an email, you can use [RegexPatterns.email].
/// See [Validators] for built-in validators that utilize these patterns.
class RegexPatterns {
  RegexPatterns._();

  // =============================================================================
  // EMAIL PATTERNS
  // =============================================================================

  /// Comprehensive email regex pattern following RFC 5322 standards.
  ///
  /// Supports:
  /// - Standard email formats (user@domain.com)
  /// - Plus addressing (user+tag@domain.com)
  /// - Dots in local part (first.last@domain.com)
  /// - Numbers and special characters
  /// - International domains
  static const String email =
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$';

  /// Simplified email regex pattern for basic validation.
  static const String emailSimple = r'^[^@]+@[^@]+\.[^@]+$';

  // =============================================================================
  // NUMERIC PATTERNS
  // =============================================================================

  // patern to validating integers (both positive and negative)
  static const String integer = r'^-?[0-9]+$';

  // pattern to validate decimal numbers (both positive and negative)
  static const String decimal = r'^-?[0-9]+(\.[0-9]+)?$';

  // pattern to validate positive integers only
  static const String positiveInteger = r'^[0-9]+$';

  // pattern to validate postive decimal numbers only
  static const String positiveDecimal = r'^[0-9]+(\.[0-9]+)?$';

  // pattern for currency validation (supports $ and decimal places)
  static const String currency = r'^\$?[0-9]{1,3}(,[0-9]{3})*(\.[0-9]{2})?$';

  // =============================================================================
  // URL PATTERNS
  // =============================================================================

  /// Comprehensive URL pattern supporting HTTP and HTTPS.
  static const String url =
      r'^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&=]*)$';

  /// Simplified URL pattern for basic validation.
  static const String urlSimple = r'^https?:\/\/.+\..+';

  ///Pattern to validate domain names (e.g., example.com, sub.domain.co.uk).
  static const String domain =
      r'^(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)*[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?$';

  // =============================================================================
  // PASSWORD PATTERNS
  // =============================================================================

  /// patern for detecting upperCase
  static const String upperCase = r'[A-Z]';

  // pattern for detecting lowerCase
  static const String lowerCase = r'[a-z]';

  /// pattern for detecting digits
  static const String digit = r'[0-9]';

  /// pattern for detecting common special characters
  static const String specialCharacter = r'[!@#$%^&*(),.?":{}|<>]';

  /// pattern for detecting extended special characters
  static const String extendedSpecialCharacters =
      r'[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?~`]';

  // pattern for strong passwords
  static const String strongPassword =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$';

  // =============================================================================
  // PHONE NUMBER PATTERNS
  // =============================================================================

  ///Ghana phone number pattern (10 digits starting with 0).
  static const String phoneGH = r'^0\d{9}$';

  /// Ghana phone number with country code (+233).
  static const String phoneGHWithCountryCode = r'^\+233\d{9}$';

  /// US phone number pattern (10 digits).
  static const String phoneUS = r'^\d{10}$';

  /// US phone number with formatting.
  static const String phoneUSFormatted = r'^\(\d{3}\) \d{3}-\d{4}$';

  /// International phone pattern (7-15 digits with optional +).
  static const String phoneInternational = r'^\+?[1-9]\d{1,14}$';

  /// UK phone number pattern.
  static const String phoneUK = r'^(\+44|0)[1-9]\d{8,9}$';

  // =============================================================================
  // USERNAME PATTERNS
  // =============================================================================

  /// Standard username pattern (alphanumeric,underscore,hyphen).
  static const String username = r'^[a-zA-Z0-9_-]+$';

  /// Extended username pattern (allows dots, 3-30 characters).
  static const String usernameExtended = r'^[a-zA-Z0-9._-]{3,30}$';

  ///Username with minimum / maximum length (3-20 characters).
  static const String usernameWithLength = r'^[a-zA-Z0-9_-]{3,20}$';

  /// Stric username (must start with letter)
  static const String usernameStrict = r'^[a-zA-Z][a-zA-Z0-9_-]*$';

  // =============================================================================
  // TEXT PATTERNS
  // =============================================================================

  /// pattern for alphabetic characters only
  static const String alphabetic = r'^[a-zA-Z]+$';

  /// patternn for alphanumeric characters only
  static const String alphanumeric = r'^[a-zA-Z0-9]+$';

  /// pattern for alphabetic with spaces
  static const String alphabeticWithSpaces = r'^[a-zA-Z\s]+$';

  /// pattern for names (letters, spaces, hyphens, apostrophes)
  static const String name = r"^[a-zA-Z\s'-]+$";

  // =============================================================================
  // DATE PATTERNS
  // =============================================================================

  /// pattern for date in YYYY-MM-DD format
  static const String dateYMD = r'^\d{4}-\d{2}-\d{2}$';

  /// pattern for date in MM/DD/YYYY format
  static const String dateMDY = r'^\d{2}/\d{2}/\d{4}$';

  /// pattern for date in DD/MM/YYYY format
  static const String dateDMY = r'^\d{2}/\d{2}/\d{4}$';

  /// pattern for time in HH:MM 24-hour format
  static const String time24Hour = r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$';

  // pattern for time in HH:MM AM/PM 12-hour format
  static const String time12Hour = r'^(1[0-2]|0?[1-9]):[0-5][0-9] (AM|PM)$';

  // =============================================================================
  // CREDIT CARD PATTERNS
  // =============================================================================

  /// visa card pattern (Starts with 4, 13-19 digits)
  static const String visa = r'^4[0-9]{12}(?:[0-9]{3})?$';

  /// MasterCard pattern (Starts with 5, 16 digits)
  static const String masterCard = r'^5[1-5][0-9]{14}$';

  /// American Express pattern (starts with 34 or 37, 15 digits).
  static const String amex = r'^3[47][0-9]{13}$';

  /// Discover card pattern (starts with 6, 16 digits).
  static const String discover = r'^6(?:011|5[0-9]{2})[0-9]{12}$';

  /// Generic credit card pattern (13-19 digits).
  static const String creditCard = r'^[0-9]{13,19}$';

  // =============================================================================
  // SOCIAL SECURITY & ID PATTERNS
  // =============================================================================

  /// US social security number pattern (XXX-XX-XXXX)
  /// where X is a digit. The first three digits cannot be 000, 666, or 900-999.
  static const String ssn = r'^\d{3}-\d{2}-\d{4}$';

  /// US Zip code pattern (5 digits or 5+4 format).
  static const String zipCodeUS = r'^\d{5}(-\d{4})?$';

  /// Ghana Zip code pattern (5 digits).
  /// Ghana does not have a formal postal code system, but this pattern can be used for local codes.
  static const String zipCodeGH = r'^\d{5}$';

  /// Canadian postal code pattern
  static const String postalCodeCA =
      r'^[ABCEGHJ-NPRSTVXY]\d[ABCEGHJ-NPRSTV-Z] ?\d[ABCEGHJ-NPRSTV-Z]\d$';

  /// UK postal code pattern.
  static const String postalCodeUK =
      r'^[A-Z]{1,2}[0-9R][0-9A-Z]? [0-9][ABD-HJLNP-UW-Z]{2}$';

  // =============================================================================
  // IP ADDRESS PATTERNS
  // =============================================================================

  /// IPv4 address pattern.
  static const String ipv4 =
      r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$';

  /// IPv6 address pattern.
  /// IPv6 address pattern (comprehensive - supports all valid formats).
  ///
  /// Supports:
  /// - Full format: 2001:0db8:85a3:0000:0000:8a2e:0370:7334
  /// - Compressed: 2001:db8:85a3::8a2e:370:7334
  /// - Loopback: ::1
  /// - All zeros: ::
  /// - IPv4-mapped: ::ffff:192.0.2.1
  /// - IPv4-compatible: ::192.0.2.1
  static const String ipv6 = r'^(?:'
      r'(?:[a-fA-F0-9]{1,4}:){7}[a-fA-F0-9]{1,4}|' // Full format
      r'(?:[a-fA-F0-9]{1,4}:){1,7}:|' // Ending with ::
      r'(?:[a-fA-F0-9]{1,4}:){1,6}:[a-fA-F0-9]{1,4}|' // One compression
      r'(?:[a-fA-F0-9]{1,4}:){1,5}(?::[a-fA-F0-9]{1,4}){1,2}|' // Two compressions
      r'(?:[a-fA-F0-9]{1,4}:){1,4}(?::[a-fA-F0-9]{1,4}){1,3}|' // Three compressions
      r'(?:[a-fA-F0-9]{1,4}:){1,3}(?::[a-fA-F0-9]{1,4}){1,4}|' // Four compressions
      r'(?:[a-fA-F0-9]{1,4}:){1,2}(?::[a-fA-F0-9]{1,4}){1,5}|' // Five compressions
      r'[a-fA-F0-9]{1,4}:(?::[a-fA-F0-9]{1,4}){1,6}|' // Six compressions
      r':(?::[a-fA-F0-9]{1,4}){1,7}|' // Seven compressions
      r'::(?:[a-fA-F0-9]{1,4}:){0,6}[a-fA-F0-9]{1,4}|' // Starting with ::
      r'::|' // All zeros
      r'(?:[a-fA-F0-9]{1,4}:){6}(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)|' // IPv4-mapped
      r'::(?:[a-fA-F0-9]{1,4}:){5}(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)|' // IPv4-mapped compressed
      r'(?:[a-fA-F0-9]{1,4}:){5}:(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)|' // IPv4-mapped
      r'(?:[a-fA-F0-9]{1,4}:){4}:(?:[a-fA-F0-9]{1,4}:)?(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)|' // More IPv4-mapped variations
      r'(?:[a-fA-F0-9]{1,4}:){3}:(?:[a-fA-F0-9]{1,4}:){0,2}(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)|'
      r'(?:[a-fA-F0-9]{1,4}:){2}:(?:[a-fA-F0-9]{1,4}:){0,3}(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)|'
      r'[a-fA-F0-9]{1,4}:(?::[a-fA-F0-9]{1,4}:){0,4}(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)|'
      r'::(?:[a-fA-F0-9]{1,4}:){0,5}(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' // IPv4-compatible
      r')$';

  /// MAC address pattern.
  static const String macAddress = r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$';

  // =============================================================================
  // UTILITY METHODS
  // =============================================================================

  /// Creates a RegExp object from a pattern string.
  static RegExp getRegExp(String pattern, {bool caseSensitive = true}) {
    return RegExp(pattern, caseSensitive: caseSensitive);
  }

  /// Validates if a string matches the given pattern.
  static bool matches(String? value, String pattern) {
    if (value == null) return false;
    return RegExp(pattern).hasMatch(value);
  }

  /// Extracts all matches of a pattern from a string.
  static List<String> extractMatches(String value, String pattern) {
    return RegExp(pattern).allMatches(value).map((m) => m.group(0)!).toList();
  }

  /// Replaces all matches of a pattern in a string.
  static String replaceMatches(
      String value, String pattern, String replacement) {
    return value.replaceAll(RegExp(pattern), replacement);
  }
}

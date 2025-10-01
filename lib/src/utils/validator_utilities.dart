/// Utility class providing helper methods for validation operations.
///
/// This class contains common validation logic that can be reused
/// across different validators, improving code organization and
/// reducing duplication.
///
class ValidatorUtilities {
  ValidatorUtilities._();

  // COMMON VALIDATION HELPERS

  /// checks if a value should be considered "empty" for validation purposes.
  ///
  /// A value is considered empty if it's null, an empty string, or only whitespaces
  static bool isEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// normalizes string for consistent validation
  ///
  /// Operations performed:
  /// - Trims whitespaces
  /// - Converts to lowercase(if specified)
  /// - Removes extra spaces between words
  ///
  static String normalized(String? value, {bool toLowerCase = false}) {
    if (value == null) return '';

    String normalized = value.trim().replaceAll(RegExp(r'\s+'), ' ');
    return toLowerCase ? normalized.toLowerCase() : normalized;
  }

  /// cleans a string by removing specified characters
  static String clean(String? value, {String pattern = r'[^\w\s]'}) {
    if (value == null) return '';
    return value.replaceAll(RegExp(pattern), " ");
  }

  /// extracts only digits from string
  static String extractDigits(String? value) {
    if (value == null) return '';
    return value.replaceAll(RegExp(r'[^\d]'), " ");
  }

  /// extracts only letters from a string.
  static String extractLetters(String? value, {bool preserveSpaces = false}) {
    if (value == null) return '';
    final pattern = preserveSpaces ? r'[^a-zA-Z\s]' : r'[^a-zA-Z]';
    return value.replaceAll(RegExp(pattern), '');
  }

  /// checks if a string contains only the allowed characters.
  static bool containsOnly(String? value, String allowedPattern) {
    if (value == null || value.isEmpty) return true;
    return RegExp('^[$allowedPattern]+\$').hasMatch(value);
  }

  /// validates string length against min/max constraints
  static ValidationResult validateLength(
      String? value, int? minLength, int? maxLength) {
    if (value == null) {
      return ValidationResult.valid();
    }
    final length = value.length;
    if (minLength != null && length < minLength) {
      return ValidationResult.invalid(
          'Must be at least $minLength characters long');
    }
    if (maxLength != null && length > maxLength) {
      return ValidationResult.invalid(
          'Must be no more than $maxLength characters long');
    }
    return ValidationResult.valid();
  }

  /// validates that a numeric string falls within a specified range.
  static ValidationResult validateNumericRange(
    String? value,
    double? min,
    double? max,
  ) {
    if (value == null || value.isEmpty) {
      return ValidationResult.valid();
    }

    final number = double.tryParse(value);
    if (number == null) {
      return ValidationResult.invalid('Please enter a valid number');
    }

    if (min != null && number < min) {
      return ValidationResult.invalid('Value must be at least $min');
    }

    if (max != null && number > max) {
      return ValidationResult.invalid('Value must be no more than $max');
    }

    return ValidationResult.valid();
  }

  /// DATE VALIDATION HELPERS

  /// Validates a date string and ensures it represents a valid date.
  ///
  static ValidationResult validateDate(String? value, {String? format}) {
    if (value == null || value.isEmpty) {
      return ValidationResult.valid();
    }

    try {
      final date = DateTime.parse(value);

      // additionally we want to ensure date passed makes sense
      if (date.year < 1900 || date.year > 2100) {
        return ValidationResult.invalid("Year must be between 1900 and 2100");
      }

      return ValidationResult.valid();
    } catch (e) {
      final formatMsg = format != null ? ' ($format)' : '';
      return ValidationResult.invalid('Please enter a valid date$formatMsg');
    }
  }

  /// validates that a date falls within a specified range.
  static ValidationResult validateDateRange(
    String? value,
    DateTime? minDate,
    DateTime? maxDate,
  ) {
    if (value == null || value.isEmpty) {
      return ValidationResult.valid();
    }

    try {
      final date = DateTime.parse(value);

      if (minDate != null && date.isBefore(minDate)) {
        return ValidationResult.invalid(
            'Date must be after ${_formatDate(minDate)}');
      }

      if (maxDate != null && date.isAfter(maxDate)) {
        return ValidationResult.invalid(
            'Date must be before ${_formatDate(maxDate)}');
      }

      return ValidationResult.valid();
    } catch (e) {
      return ValidationResult.invalid('Please enter a valid date');
    }
  }

  /// formats a datetime for user display
  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // ADVANCED VALIDATION HELPERS

  /// Validates password complexity based on configurable rules.
  static ValidationResult validatePasswordComplexity({
    required String? value,
    int minLength = 8,
    int? maxLength,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumbers = true,
    bool requireSpecialChars = true,
    List<String>? forbiddenPasswords,
    String? username, // To prevent password == username
  }) {
    if (value == null || value.isEmpty) {
      return ValidationResult.valid();
    }

    List<String> errors = [];

    // length check
    final lengthResult = validateLength(value, minLength, maxLength);
    if (!lengthResult.isValid) {
      errors.add(lengthResult.errorMessage!);
    }

    // character requirements
    if (requireUppercase && !RegExp(r'[A-Z]').hasMatch(value)) {
      errors.add('one uppercase letter');
    }

    if (requireLowercase && !RegExp(r'[a-z]').hasMatch(value)) {
      errors.add('one lowercase letter');
    }

    if (requireNumbers && !RegExp(r'[0-9]').hasMatch(value)) {
      errors.add('one number');
    }

    if (requireSpecialChars &&
        !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      errors.add('one special character');
    }

    // forbidden passwords check
    if (forbiddenPasswords != null &&
        forbiddenPasswords.any(
            (forbidden) => value.toLowerCase() == forbidden.toLowerCase())) {
      return ValidationResult.invalid('This password is too common');
    }

    // username similarity check
    if (username != null && value.toLowerCase() == username.toLowerCase()) {
      return ValidationResult.invalid(
          'Password cannot be the same as username');
    }

    // sequential characters check
    if (_hasSequentialChars(value)) {
      errors.add('avoid sequential characters (123, abc)');
    }

    // repeated characters check
    if (_hasRepeatedChars(value)) {
      errors.add('avoid repeated characters (aaa, 111)');
    }

    if (errors.isNotEmpty) {
      return ValidationResult.invalid(
          'Password must contain ${errors.join(', ')}');
    }

    return ValidationResult.valid();
  }

  /// checks for sequential characters in a password.
  static bool _hasSequentialChars(String password, {int sequenceLength = 3}) {
    for (int i = 0; i <= password.length - sequenceLength; i++) {
      final substring = password.substring(i, i + sequenceLength);
      if (_isSequential(substring)) {
        return true;
      }
    }
    return false;
  }

  /// checks if a string contains sequential characters.
  static bool _isSequential(String str) {
    if (str.length < 3) return false;

    bool ascending = true;
    bool descending = true;

    for (int i = 1; i < str.length; i++) {
      int current = str.codeUnitAt(i);
      int previous = str.codeUnitAt(i - 1);

      if (current != previous + 1) ascending = false;
      if (current != previous - 1) descending = false;
    }

    return ascending || descending;
  }

  /// checks for repeated characters in a password.
  static bool _hasRepeatedChars(String password, {int repeatLength = 3}) {
    for (int i = 0; i <= password.length - repeatLength; i++) {
      final char = password[i];
      bool isRepeated = true;

      for (int j = i + 1; j < i + repeatLength; j++) {
        if (password[j] != char) {
          isRepeated = false;
          break;
        }
      }

      if (isRepeated) return true;
    }
    return false;
  }

  // LOCALIZATION HELPERS

  /// Gets a localized error message based on the validation type and locale.
  static String getLocalizedMessage(
    String messageKey,
    String locale, {
    Map<String, dynamic>? params,
  }) {
    // This is a simple implementation - in a real app, you'd use
    // a proper localization system like intl
    final messages = _getMessagesForLocale(locale);
    String message = messages[messageKey] ?? messageKey;

    // Simple parameter substitution
    if (params != null) {
      params.forEach((key, value) {
        message = message.replaceAll('{$key}', value.toString());
      });
    }

    return message;
  }

  /// Returns a map of localized messages for a given locale.
  static Map<String, String> _getMessagesForLocale(String locale) {
    switch (locale.toLowerCase()) {
      case 'es':
        return {
          'required': 'Este campo es requerido',
          'email': 'Por favor ingrese un email válido',
          'minLength': 'Debe tener al menos {min} caracteres',
          'maxLength': 'No puede tener más de {max} caracteres',
        };
      case 'fr':
        return {
          'required': 'Ce champ est requis',
          'email': 'Veuillez saisir une adresse e-mail valide',
          'minLength': 'Doit contenir au moins {min} caractères',
          'maxLength': 'Ne peut pas dépasser {max} caractères',
        };
      case 'de':
        return {
          'required': 'Dieses Feld ist erforderlich',
          'email': 'Bitte geben Sie eine gültige E-Mail-Adresse ein',
          'minLength': 'Muss mindestens {min} Zeichen lang sein',
          'maxLength': 'Darf nicht mehr als {max} Zeichen haben',
        };
      default: // English
        return {
          'required': 'This field is required',
          'email': 'Please enter a valid email address',
          'minLength': 'Must be at least {min} characters long',
          'maxLength': 'Must be no more than {max} characters long',
        };
    }
  }

  // SECURITY HELPERS

  /// Checks if a string contains potentially malicious content.
  static ValidationResult validateSecureInput(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationResult.valid();
    }

    // Check for common injection patterns
    final maliciousPatterns = [
      r'<script[^>]*>.*?</script>', // XSS
      r'javascript:', // JavaScript protocol
      r'on\w+\s*=', // Event handlers
      r'SELECT.*FROM', // SQL injection (basic)
      r'UNION.*SELECT', // SQL injection
      r'DROP.*TABLE', // SQL injection
      r'INSERT.*INTO', // SQL injection
      r'DELETE.*FROM', // SQL injection
    ];

    for (final pattern in maliciousPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(value)) {
        return ValidationResult.invalid(
            'Input contains potentially harmful content');
      }
    }

    return ValidationResult.valid();
  }

  /// Sanitizes input by escaping HTML characters.
  static String sanitizeHtml(String? value) {
    if (value == null || value.isEmpty) return '';

    return value
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;');
  }
}

/// represents the result of a validation operation.
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final ValidationSeverity severity;
  final Map<String, dynamic>? metadata;

  const ValidationResult._({
    required this.isValid,
    this.errorMessage,
    this.severity = ValidationSeverity.error,
    this.metadata,
  });

  /// creates a successful validation result.
  factory ValidationResult.valid({Map<String, dynamic>? metadata}) {
    return ValidationResult._(
      isValid: true,
      metadata: metadata,
    );
  }

  /// Creates a failed validation result with an error message.
  factory ValidationResult.invalid(
    String message, {
    ValidationSeverity severity = ValidationSeverity.error,
    Map<String, dynamic>? metadata,
  }) {
    return ValidationResult._(
      isValid: false,
      errorMessage: message,
      severity: severity,
      metadata: metadata,
    );
  }

  /// creates a warning validation result.
  factory ValidationResult.warning(
    String message, {
    Map<String, dynamic>? metadata,
  }) {
    return ValidationResult._(
      isValid: true, // warnings don't fail validation
      errorMessage: message,
      severity: ValidationSeverity.warning,
      metadata: metadata,
    );
  }

  @override
  String toString() {
    return 'ValidationResult(isValid: $isValid, message: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValidationResult &&
        other.isValid == isValid &&
        other.errorMessage == errorMessage &&
        other.severity == severity;
  }

  @override
  int get hashCode {
    return isValid.hashCode ^ errorMessage.hashCode ^ severity.hashCode;
  }
}

enum ValidationSeverity {
  info,
  warning,
  error,
}

/// Extension methods for ValidationSeverity enum.
extension ValidationSeverityExtension on ValidationSeverity {
  /// Returns the display name of the severity level.
  String get displayName {
    switch (this) {
      case ValidationSeverity.info:
        return 'Info';
      case ValidationSeverity.warning:
        return 'Warning';
      case ValidationSeverity.error:
        return 'Error';
    }
  }

  /// Returns true if this severity level blocks form submission.
  bool get blocksSubmission {
    return this == ValidationSeverity.error;
  }
}

# Flutter Form Validators

[![pub package](https://img.shields.io/pub/v/flutter_form_validators.svg)](https://pub.dev/packages/flutter_form_validators)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive, production-ready form validation library for Flutter with 20+ validators, security features, and 40+ string extensions.

## ✨ Features

- 🎯 **20+ Built-in Validators** - Email, phone, credit card, password strength, URL, and more
- 🔗 **Chainable API** - Combine multiple validators effortlessly
- 🛡️ **Security First** - XSS and SQL injection prevention
- 💳 **Advanced Credit Card** - Luhn algorithm with automatic type detection
- 🌍 **Internationalization** - Multi-language error messages
- 🚀 **40+ String Extensions** - Quick validation checks
- ✅ **100% Test Coverage** - Production-ready reliability

## 🚀 Installation

Add to your `pubspec.yaml`:
```yaml
dependencies:
  flutter_form_validators: ^1.0.0
```

Then run:
```bash
flutter pub get
```

## 📖 Usage

### Basic Example
```dart
import 'package:flutter_form_validators/flutter_form_validators.dart';

TextFormField(
  validator: Validators.email(),
  decoration: InputDecoration(labelText: 'Email'),
)
```

### Combining Validators
```dart
TextFormField(
  validator: Validators.combine([
    Validators.required(),
    Validators.email(),
    Validators.minLength(5),
  ]),
)
```

### String Extensions
```dart
if ('test@example.com'.isValidEmail) {
  print('Valid email!');
}

if ('Password123!'.isStrongPassword) {
  print('Strong password!');
}

final score = 'MyPass123!'.passwordStrengthScore; // 0-5
```

### Available Validators

#### Core Validators
- `required()` - Field must not be empty
- `email()` - Valid email format
- `minLength(int)` / `maxLength(int)` - Length constraints
- `numeric()` - Numbers only
- `url()` - Valid URL format

#### Advanced Validators
- `password()` - Password strength with customizable requirements
- `phoneNumber()` - Phone validation (US, UK, International)
- `creditCard()` - Credit card with Luhn algorithm & type detection
- `match(String)` - Field matching (password confirmation)
- `username()` - Username format validation
- `date()` - Date format validation
- `range(min, max)` - Numeric range validation

#### Security & Geographic
- `secure()` - XSS and injection prevention
- `postalCode()` - ZIP codes (US, Canada, UK)
- `ssn()` - Social Security Numbers
- `ipAddress()` - IPv4 and IPv6
- `macAddress()` - MAC address validation

### Password Validation Example
```dart
TextFormField(
  validator: Validators.password(
    minLength: 12,
    requireUppercase: true,
    requireLowercase: true,
    requireNumbers: true,
    requireSpecialChars: true,
  ),
)
```

### Credit Card Example
```dart
TextFormField(
  validator: Validators.creditCard(
    acceptedTypes: [CreditCardType.visa, CreditCardType.mastercard],
  ),
)

// Or use extensions
if ('4532015112830366'.isValidCreditCard) {
  final type = '4532015112830366'.creditCardType; // CreditCardType.visa
}
```

## 🔥 String Extensions
```dart
// Validation
'test@email.com'.isValidEmail // true
'https://example.com'.isValidUrl // true
'123'.isNumeric // true

// Password Analysis  
'Password123!'.isStrongPassword // true
'Password123!'.passwordStrengthScore // 5 (out of 5)
'Password123!'.passwordStrengthLevel // 'Very Strong'

// Credit Cards
'4532015112830366'.isValidCreditCard // true
'4532015112830366'.creditCardType // CreditCardType.visa

// Text Manipulation
'hello world'.titleCase // 'Hello World'
'sensitive data'.masked(2) // 'se**********ta'
'long text here'.truncate(10) // 'long te...'

// Conversions
'123'.intValue // 123
'123.45'.numericValue // 123.45
'2024-01-01'.dateValue // DateTime object
```

## 📱 Complete Example
```dart
class RegistrationForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: Validators.combine([
              Validators.required(),
              Validators.email(),
            ]),
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            controller: _passwordController,
            validator: Validators.password(),
            decoration: InputDecoration(labelText: 'Password'),
          ),
          TextFormField(
            validator: Validators.match(_passwordController.text),
            decoration: InputDecoration(labelText: 'Confirm Password'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Form is valid
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

## 🧪 Testing

Run tests:
```bash
flutter test
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Support

If you find this package helpful, please ⭐ star the repo and share it with other Flutter developers!

---

Made with ❤️ for the Flutter community
// example/lib/main.dart

import 'package:flutter/material.dart';
import 'package:form_validators_plus/form_validators_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form Validators Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ValidatorsDemoPage(),
    );
  }
}

class ValidatorsDemoPage extends StatelessWidget {
  const ValidatorsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Validators Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Flutter Form Validators',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Comprehensive validation examples',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildDemoCard(
            context,
            'Registration Form',
            'Complete signup form with all validators',
            Icons.app_registration,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegistrationFormPage()),
            ),
          ),
          _buildDemoCard(
            context,
            'String Extensions Demo',
            'See 40+ extension methods in action',
            Icons.extension,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExtensionsDemoPage()),
            ),
          ),
          _buildDemoCard(
            context,
            'Credit Card Validator',
            'Luhn algorithm with type detection',
            Icons.credit_card,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreditCardDemoPage()),
            ),
          ),
          _buildDemoCard(
            context,
            'Password Strength',
            'Real-time password analysis',
            Icons.lock,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PasswordStrengthPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// =============================================================================
// REGISTRATION FORM PAGE
// =============================================================================

class RegistrationFormPage extends StatefulWidget {
  const RegistrationFormPage({super.key});

  @override
  State<RegistrationFormPage> createState() => _RegistrationFormPageState();
}

class _RegistrationFormPageState extends State<RegistrationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create Account',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // First Name
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: Validators.combine([
                  Validators.required(message: 'First name is required'),
                  Validators.minLength(2, message: 'Name too short'),
                ]),
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: Validators.combine([
                  Validators.required(message: 'Email is required'),
                  Validators.email(),
                ]),
              ),
              const SizedBox(height: 16),

              // Username
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.alternate_email),
                  border: OutlineInputBorder(),
                  helperText: '3-20 chars, letters, numbers, _ and -',
                ),
                validator: Validators.combine([
                  Validators.required(),
                  Validators.username(),
                ]),
              ),
              const SizedBox(height: 16),

              // Phone
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(),
                  helperText: 'US format: (123) 456-7890',
                ),
                validator: Validators.combine([
                  Validators.required(),
                  Validators.phoneNumber(),
                ]),
              ),
              const SizedBox(height: 16),

              // Age
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.cake_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: Validators.combine([
                  Validators.required(),
                  Validators.numeric(allowDecimal: false),
                  Validators.range(18, 120, message: 'Age must be 18-120'),
                ]),
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: const OutlineInputBorder(),
                  helperText: '8+ chars, upper, lower, number, special',
                  helperMaxLines: 2,
                ),
                validator: Validators.combine([
                  Validators.required(),
                  Validators.password(),
                ]),
              ),
              const SizedBox(height: 16),

              // Confirm Password
              TextFormField(
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: Validators.combine([
                  Validators.required(),
                  Validators.match(_passwordController.text,
                      message: 'Passwords must match'),
                ]),
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Create Account',
                    style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// STRING EXTENSIONS DEMO PAGE
// =============================================================================

class ExtensionsDemoPage extends StatelessWidget {
  const ExtensionsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('String Extensions Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Email Validation', [
            _buildTest('test@example.com', 'test@example.com'.isValidEmail),
            _buildTest('invalid-email', 'invalid-email'.isValidEmail),
          ]),
          _buildSection('Password Strength', [
            _buildTest('password', 'password'.isStrongPassword),
            _buildTest('Password123!', 'Password123!'.isStrongPassword),
            _buildInfo('Password123!',
                'Score: ${'Password123!'.passwordScoreStrength}/5'),
            _buildInfo('Password123!',
                'Level: ${'Password123!'.passwordStrengthLevel}'),
          ]),
          _buildSection('Credit Card Validation', [
            _buildTest(
                '4532015112830366', '4532015112830366'.isValidCreditCard),
            _buildInfo('4532015112830366',
                'Type: ${'4532015112830366'.creditCardType?.displayName ?? 'Unknown'}'),
            _buildTest(
                '1234567890123456', '1234567890123456'.isValidCreditCard),
          ]),
          _buildSection('Numeric Checks', [
            _buildTest('123', '123'.isNumeric),
            _buildTest('123.45', '123.45'.isNumeric),
            _buildTest('abc', 'abc'.isNumeric),
            _buildInfo('123', 'intValue: ${'123'.intValue}'),
            _buildInfo('123.45', 'numericValue: ${'123.45'.numericValue}'),
          ]),
          _buildSection('Text Manipulation', [
            _buildInfo('hello world', 'titleCase: ${'hello world'.titleCase}'),
            _buildInfo('HELLO', 'capitalized: ${'HELLO'.capitalized}'),
            _buildInfo('secret1234', 'masked: ${'secret1234'.masked(2)}'),
            _buildInfo(
                'long text here', 'truncate: ${'long text here'.truncate(10)}'),
          ]),
          _buildSection('URL & IP Validation', [
            _buildTest('https://example.com', 'https://example.com'.isValidUrl),
            _buildTest('192.168.1.1', '192.168.1.1'.isValidIPv4),
            _buildTest('::1', '::1'.isValidIPv6),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTest(String input, bool result) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            result ? Icons.check_circle : Icons.cancel,
            color: result ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '"$input"',
              style: TextStyle(
                fontFamily: 'monospace',
                color: result ? Colors.green : Colors.red,
              ),
            ),
          ),
          Text(
            result ? 'Valid' : 'Invalid',
            style: TextStyle(
              color: result ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(String input, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 20, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '"$input" → $info',
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CREDIT CARD DEMO PAGE
// =============================================================================

class CreditCardDemoPage extends StatefulWidget {
  const CreditCardDemoPage({super.key});

  @override
  State<CreditCardDemoPage> createState() => _CreditCardDemoPageState();
}

class _CreditCardDemoPageState extends State<CreditCardDemoPage> {
  final _controller = TextEditingController();
  String? _cardType;
  bool? _isValid;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateCard(String value) {
    setState(() {
      _isValid = value.isValidCreditCard;
      _cardType = value.creditCardType?.displayName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Credit Card Validator')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Credit Card Validation',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  prefixIcon: Icon(Icons.credit_card),
                  border: OutlineInputBorder(),
                  hintText: '4532 0151 1283 0366',
                ),
                onChanged: _validateCard,
              ),
              const SizedBox(height: 24),
              if (_isValid != null) ...[
                Card(
                  color: _isValid! ? Colors.green.shade50 : Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          _isValid! ? Icons.check_circle : Icons.cancel,
                          color: _isValid! ? Colors.green : Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isValid! ? 'Valid Card' : 'Invalid Card',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _isValid! ? Colors.green : Colors.red,
                          ),
                        ),
                        if (_cardType != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Card Type: $_cardType',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Try these test cards:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildTestCard('Visa', '4532015112830366'),
              _buildTestCard('Mastercard', '5555555555554444'),
              _buildTestCard('Amex', '378282246310005'),
              _buildTestCard('Invalid', '1234567890123456'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestCard(String type, String number) {
    return Card(
      child: ListTile(
        title: Text(type),
        subtitle: Text(number, style: const TextStyle(fontFamily: 'monospace')),
        trailing: IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            _controller.text = number;
            _validateCard(number);
          },
        ),
      ),
    );
  }
}

// =============================================================================
// PASSWORD STRENGTH PAGE
// =============================================================================

class PasswordStrengthPage extends StatefulWidget {
  const PasswordStrengthPage({super.key});

  @override
  State<PasswordStrengthPage> createState() => _PasswordStrengthPageState();
}

class _PasswordStrengthPageState extends State<PasswordStrengthPage> {
  final _controller = TextEditingController();
  int _score = 0;
  String _level = 'None';
  bool _obscure = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _analyzePassword(String value) {
    setState(() {
      _score = value.passwordScoreStrength;
      _level = value.passwordStrengthLevel;
    });
  }

  Color _getStrengthColor() {
    switch (_score) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow.shade700;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Password Strength')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Password Strength Analyzer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            TextField(
              controller: _controller,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon:
                      Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: _analyzePassword,
            ),
            const SizedBox(height: 24),

            // Strength Bar
            Row(
              children: List.generate(5, (index) {
                return Expanded(
                  child: Container(
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index < _score
                          ? _getStrengthColor()
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            Text(
              'Strength: $_level',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getStrengthColor(),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Requirements
            _buildRequirement('8+ characters', _controller.text.length >= 8),
            _buildRequirement(
                'Uppercase letter', _controller.text.hasUpperCase),
            _buildRequirement(
                'Lowercase letter', _controller.text.hasLowerCase),
            _buildRequirement('Number', _controller.text.hasDigit),
            _buildRequirement(
                'Special character', _controller.text.hasSpecialChar),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirement(String text, bool met) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.radio_button_unchecked,
            color: met ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: met ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

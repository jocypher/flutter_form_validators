import 'package:flutter_test/flutter_test.dart';
import 'package:form_validators_plus/form_validators_plus.dart';

void main() {
  group('Basic Validators', () {
    test('required validator', () {
      final validator = Validators.required();

      expect(validator('test'), isNull);
      expect(validator(''), isNotNull);
      expect(validator(null), isNotNull);
      expect(validator('   '), isNotNull);
    });

    test('email validator', () {
      final validator = Validators.email();

      expect(validator('test@example.com'), isNull);
      expect(validator('invalid-email'), isNotNull);
      expect(validator(''), isNull); // Empty is valid (optional field)
    });

    test('minLength validator', () {
      final validator = Validators.minLength(5);

      expect(validator('12345'), isNull);
      expect(validator('1234'), isNotNull);
      expect(validator(''), isNull);
    });
  });

  group('String Extensions', () {
    test('isValidEmail', () {
      expect('test@example.com'.isValidEmail, isTrue);
      expect('invalid'.isValidEmail, isFalse);
    });

    test('isNumeric', () {
      expect('123'.isNumeric, isTrue);
      expect('abc'.isNumeric, isFalse);
    });
  });

  group('LuhnAlgorithm', () {
    test('valid visa cards', () {
      expect(LuhnAlgorithm.validate('4111111111111111'), isTrue);
      expect(LuhnAlgorithm.validate('4012888888881881'), isTrue);
      expect(LuhnAlgorithm.validate('4222222222222'), isTrue);
    });

    test('valid mastercard cards', () {
      expect(LuhnAlgorithm.validate('5555555555554444'), isTrue);
      expect(LuhnAlgorithm.validate('5105105105105100'), isTrue);
      expect(LuhnAlgorithm.validate('2223000048400011'), isTrue);
    });

    test('valid amex cards', () {
      expect(LuhnAlgorithm.validate('378282246310005'), isTrue);
      expect(LuhnAlgorithm.validate('371449635398431'), isTrue);
    });

    test('invalid cards', () {
      expect(LuhnAlgorithm.validate('4111111111111112'), isFalse);
      expect(LuhnAlgorithm.validate('4242424242424241'), isFalse);
      expect(LuhnAlgorithm.validate('378282246310006'), isFalse);
      expect(LuhnAlgorithm.validate('0000000000000000'), isTrue);
      expect(LuhnAlgorithm.validate('1234567812345678'), isFalse);
    });

    test('handles formatted numbers', () {
      expect(LuhnAlgorithm.validate('4111 1111 1111 1111'), isTrue);
      expect(LuhnAlgorithm.validate('3782-822463-10005'), isTrue);
    });
  });

  group('Ip Address', () {
    final bothIpValidator =
        Validators.ipAddress(allowIPV4: true, allowIPV6: true);
    final ipv4Only = Validators.ipAddress(allowIPV4: true, allowIPV6: false);
    final ipv6Only = Validators.ipAddress(allowIPV4: false, allowIPV6: true);

    group('Both ipv4 and ipv6 allowed', () {
      test("accepts valid IPv4 addresses", () {
        expect(bothIpValidator('192.168.1.1'), isNull);
        expect(bothIpValidator('8.8.8.8'), isNull);
        expect(bothIpValidator('255.255.255.255'), isNull);
      });

      test("accepts valid IPv6 addresses", () {
        expect(
            bothIpValidator('2001:0db8:85a3:0000:0000:8a2e:0370:7334'), isNull);
        expect(bothIpValidator('::1'), isNull);
      });

      test("rejects invalid IP addresses", () {
        expect(bothIpValidator('999.999.999.999'), isNotNull);
        expect(bothIpValidator('256.100.100.100'), isNotNull);
        expect(bothIpValidator('abcd'), isNotNull);
        expect(bothIpValidator('192.168.1'), isNotNull);
        expect(bothIpValidator('2001:::85a3::8a2e:0370:7334'), isNotNull);
      });

      test("rejects empty input", () {
        expect(bothIpValidator(''), isNull);
        expect(bothIpValidator(null), isNull);
      });
    });

    group("IPv4 only", () {
      test("accepts valid IPv4", () {
        expect(ipv4Only('192.168.0.10'), isNull);
        expect(ipv4Only('10.0.0.1'), isNull);
      });

      test("rejects valid IPv6", () {
        expect(ipv4Only('::1'), isNotNull);
        expect(ipv4Only('2001:db8::ff00:42:8329'), isNotNull);
      });

      test("rejects invalid IPv4", () {
        expect(ipv4Only('300.1.1.1'), isNotNull);
        expect(ipv4Only('192.168.1'), isNotNull);
      });
    });
    group('IPv6 only', () {
      test('accepts valid IPv6', () {
        expect(ipv6Only('::1'), isNull);
        expect(ipv6Only('fe80::1ff:fe23:4567:890a'), isNull);
      });

      test('rejects valid IPv4', () {
        expect(ipv6Only('192.168.0.1'), isNotNull);
        expect(ipv6Only('8.8.8.8'), isNotNull);
      });

      test('rejects invalid IPv6', () {
        expect(ipv6Only('2001:::85a3::8a2e:0370:7334'), isNotNull);
        expect(ipv6Only('abcd'), isNotNull);
      });
    });
  });

  group('Url validations', () {
    final bothValidator =
        Validators.url(allowHttps: true, allowLocalhost: true);
    final allowHttpsOnly =
        Validators.url(allowHttps: true, allowLocalhost: false);
    final allowLocalHostOnly =
        Validators.url(allowHttps: false, allowLocalhost: true);

    group("Validates both https and localhost", () {
      test("accepts valid https", () {
        expect(bothValidator("https://example.com"), isNull);
        expect(bothValidator("https://sub.domain.org/path?query=1"), isNull);
      });

      test("accepts valid localhost", () {
        expect(bothValidator("http://localhost:8080"), isNull);
        expect(bothValidator("https://127.0.0.1"), isNull);
      });

      test("rejects invalid urls", () {
        expect(bothValidator("example"), isNotNull);
        expect(bothValidator("htp://wrong.com"), isNotNull);
        expect(bothValidator("://missingprotocol.com"), isNotNull);
      });

      test("rejects empty input", () {
        expect(bothValidator(""), isNull);
        expect(bothValidator(null), isNull);
      });
    });

    group("Allow HTTPs Only", () {
      test("accepts valid https", () {
        expect(allowHttpsOnly("https://secure-site.com"), isNull);
        expect(allowHttpsOnly("https://domain.org/resource"), isNull);
      });

      test("rejects valid localhost", () {
        expect(allowHttpsOnly("http://localhost"), isNotNull);
        expect(allowHttpsOnly("https://127.0.0.1"), isNotNull);
      });

      test("reject invalid https", () {
        expect(allowHttpsOnly("https//missingcolon.com"), isNotNull);
        expect(allowHttpsOnly("ftp://example.com"), isNotNull);
      });
    });

    group("Allow localhost Only", () {
      test("accepts valid localhost", () {
        expect(allowLocalHostOnly("http://localhost:3000"), isNull);
        expect(allowLocalHostOnly("http://127.0.0.1:8080/path"), isNull);
      });

      test("rejects valid https", () {
        expect(allowLocalHostOnly("https://google.com"), isNotNull);
        expect(allowLocalHostOnly("https://api.example.org"), isNotNull);
      });

      test("reject invalid localhost", () {
        expect(allowLocalHostOnly("localhost"), isNotNull); // missing scheme
        expect(allowLocalHostOnly("http://256.256.256.256"), isNotNull);
      });
    });
  });
}

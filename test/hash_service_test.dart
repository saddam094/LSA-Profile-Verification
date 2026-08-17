import 'package:flutter_test/flutter_test.dart';
import 'package:lsa_profile_verification/core/security/hash_service.dart';

void main() {
  test('generates deterministic SHA-256 for the same payload', () {
    final service = HashService();

    final first = service.sha256FromMap({
      'b': 'two',
      'a': 'one',
    });

    final second = service.sha256FromMap({
      'a': 'one',
      'b': 'two',
    });

    expect(first, second);
    expect(first.length, 64);
  });
}

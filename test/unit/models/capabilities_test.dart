import 'package:nyxx/src/models/capabilities.dart';
import 'package:test/test.dart';

void main() {
  group('Client capabilities', () {
    test('all value', () {
      final capabilities = Capabilities.all;

      expect(capabilities, equals(Capabilities.all));
    });

    test('value', () {
      final capabilities = Capabilities.clientStateV2 | Capabilities.prioritizedReadyPayload;

      expect(capabilities.value, equals((Capabilities.clientStateV2 | Capabilities.prioritizedReadyPayload).value));
    });
  });
}
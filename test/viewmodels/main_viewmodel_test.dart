import 'package:flutter_test/flutter_test.dart';
import 'package:mail_processor/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('MainViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}

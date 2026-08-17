import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import 'package:lsa_profile_verification/main.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('LSA Profile Verification app renders', (tester) async {
    await tester.pumpWidget(const LsaVerificationApp());
    await tester.pumpAndSettle();

    expect(find.text('LSA Profile Verification'), findsOneWidget);
    expect(find.text('Submit for verification'), findsOneWidget);
    expect(find.text('Security test harness'), findsOneWidget);
  });
}
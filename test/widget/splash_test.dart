import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numero/core/theme/theme_provider.dart';
import 'package:numero/features/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Splash renders without crashing', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(home: SplashScreen()),
      ),
    );

    // Just one frame — we don't want the post-frame routing logic to fire,
    // which would call `context.go` in the absence of a router.
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}

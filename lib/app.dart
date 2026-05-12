/// Application root. Wires [MaterialApp.router] to the theme preset and
/// system dynamic colour (Spec §12.1, §12.2).
library;

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme_builder.dart';
import 'core/theme/theme_provider.dart';

class NumeroApp extends ConsumerWidget {
  const NumeroApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeControllerProvider);
    final router = ref.watch(routerProvider);

    return DynamicColorBuilder(builder: (lightDyn, darkDyn) {
      return MaterialApp.router(
        title: 'Numero',
        debugShowCheckedModeBanner: false,
        theme: AppThemeBuilder.build(
          preset: themeState.preset,
          brightness: Brightness.light,
          systemScheme: lightDyn,
        ),
        darkTheme: AppThemeBuilder.build(
          preset: themeState.preset,
          brightness: Brightness.dark,
          systemScheme: darkDyn,
        ),
        themeMode: themeState.brightness,
        routerConfig: router,
      );
    });
  }
}

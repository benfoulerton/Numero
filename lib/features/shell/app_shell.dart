/// App shell — wraps the Home / Practice / Profile screens with a bottom
/// navigation bar (Spec §3.2). The bar hides when a lesson is active —
/// achieved by rendering the lesson as a top-level route outside this shell.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import 'widgets/numero_bottom_nav.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  int _indexFor(String location) {
    if (location.startsWith(Routes.practice)) return 1;
    if (location.startsWith(Routes.profile)) return 2;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(Routes.home);
      case 1:
        context.go(Routes.practice);
      case 2:
        context.go(Routes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final current = _indexFor(location);
    return Scaffold(
      body: child,
      bottomNavigationBar: NumeroBottomNav(
        currentIndex: current,
        onChanged: (i) => _onTap(context, i),
      ),
    );
  }
}

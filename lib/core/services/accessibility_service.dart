/// Accessibility helpers (Spec §11.2 + §12.4).
///
/// Reduced-motion combines the user's in-app toggle with the platform's
/// MediaQuery `disableAnimations` flag. Either one triggers the reduced
/// motion path.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'storage_service.dart';

class AccessibilityService {
  AccessibilityService(this._storage);

  final StorageService _storage;

  /// True if the user (or the system) has requested reduced motion.
  /// [context] is required because we need to read the latest MediaQuery.
  bool reducedMotion(BuildContext context) {
    final systemFlag = MediaQuery.disableAnimationsOf(context);
    return systemFlag || _storage.reducedMotion;
  }

  bool get highContrast => _storage.highContrast;
}

final accessibilityServiceProvider = Provider<AccessibilityService>((ref) {
  return AccessibilityService(ref.watch(storageServiceProvider));
});

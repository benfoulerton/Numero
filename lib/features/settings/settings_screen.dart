// ============================================================================
//                    DEVELOPER CONTACT — CHANGE THIS
// ============================================================================
//
// This constant is the destination address for the "Contact developer"
// button in Settings (Spec §14.2). It is intentionally hoisted to the very
// top of this file so it is easy to find.
//
// To change it: replace the string below. Recompile. Done.
//
// Do NOT scatter copies of this email through the rest of the codebase —
// keep it here, and import it from this file if anything else ever needs
// it.
// ============================================================================

/// Settings screen (Spec §14.2).
///
/// Sound, haptics, reduced motion, notifications, theme, reset progress,
/// version info, contact developer, privacy policy.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/services/storage_service.dart';
import '../../core/services/storage_service_aliases.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/utils/platform_email.dart';
import 'widgets/notification_settings.dart';
import 'widgets/reset_progress_dialog.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_toggle_tile.dart';

const kDeveloperEmail = 'benfoulerton@gmail.com';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(storageServiceProvider);
    final themeState = ref.watch(themeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          SettingsSection(
            title: 'Feedback',
            children: [
              SettingsToggleTile(
                icon: Icons.volume_up_rounded,
                title: 'Sounds',
                subtitle: 'Play sound effects on correct / incorrect answers',
                value: storage.soundEnabled,
                onChanged: (v) async {
                  await storage.setSoundEnabled(v);
                  (context as Element).markNeedsBuild();
                },
              ),
              SettingsToggleTile(
                icon: Icons.vibration_rounded,
                title: 'Haptics',
                subtitle: 'Gentle vibrations during interactions',
                value: storage.hapticEnabled,
                onChanged: (v) async {
                  await storage.setHapticEnabled(v);
                  (context as Element).markNeedsBuild();
                },
              ),
              SettingsToggleTile(
                icon: Icons.accessibility_new_rounded,
                title: 'Reduced motion',
                subtitle: 'Replace springs and slides with quick fades',
                value: storage.reducedMotion,
                onChanged: (v) async {
                  await storage.setReducedMotion(v);
                  (context as Element).markNeedsBuild();
                },
              ),
            ],
          ),
          const SettingsSection(
            title: 'Notifications',
            children: [NotificationSettings()],
          ),
          SettingsSection(
            title: 'Appearance',
            children: [
              ListTile(
                leading: const Icon(Icons.brightness_6_rounded),
                title: const Text('Brightness'),
                trailing: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      icon: Icon(Icons.brightness_auto_rounded),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: Icon(Icons.light_mode_rounded),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.dark_mode_rounded),
                    ),
                  ],
                  selected: {themeState.brightness},
                  onSelectionChanged: (s) {
                    ref
                        .read(themeControllerProvider.notifier)
                        .setBrightness(s.first);
                  },
                  showSelectedIcon: false,
                ),
              ),
            ],
          ),
          SettingsSection(
            title: 'About & support',
            children: [
              ListTile(
                leading: const Icon(Icons.mail_outline_rounded),
                title: const Text('Contact developer'),
                subtitle: const Text(kDeveloperEmail),
                onTap: () => PlatformEmail.compose(
                  to: kDeveloperEmail,
                  subject: 'Numero feedback',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.policy_outlined),
                title: const Text('Privacy policy'),
                onTap: () => _showPrivacy(context),
              ),
              const _VersionTile(),
            ],
          ),
          SettingsSection(
            title: 'Danger zone',
            children: [
              ListTile(
                leading: Icon(Icons.delete_forever_outlined,
                    color: Theme.of(context).colorScheme.error),
                title: Text(
                  'Reset all progress',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error),
                ),
                subtitle: const Text(
                    "Clears XP, streak, hearts, and everything stored on this device. This cannot be undone."),
                onTap: () => ResetProgressDialog.show(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showPrivacy(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Privacy'),
        content: const SingleChildScrollView(
          child: Text(
            "Numero stores all of your data locally on this device. No "
            "account is required, and nothing you do in the app is "
            "transmitted to a server unless you explicitly choose to share "
            "feedback or use a future cloud-sync feature.\n\n"
            "If you reset progress in Settings, that data is permanently "
            "deleted from this device.",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _VersionTile extends StatefulWidget {
  const _VersionTile();

  @override
  State<_VersionTile> createState() => _VersionTileState();
}

class _VersionTileState extends State<_VersionTile> {
  String _version = '—';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() => _version = '${info.version} (${info.buildNumber})');
      }
    } catch (_) {
      // Some test environments don't have package info; ignore.
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline_rounded),
      title: const Text('Version'),
      subtitle: Text(_version),
    );
  }
}

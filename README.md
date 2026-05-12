# Numero

A Duolingo-style mathematics learning app, built in Flutter. This repository
contains the **app shell only** — every screen, animation, interaction, and
system described in Part One of the spec is implemented. No real curriculum
content lives here yet; the placeholder lesson exercises every micro-screen
template and every interaction type so the shell can be navigated end-to-end.

## Getting started

```sh
flutter pub get
flutter pub run flutter_launcher_icons  # generates Android launcher icons
flutter run                              # builds and installs on a connected device
```

Target: **Android 8.0 (API 26) and up**. iOS is not configured in v1 per
the spec (Google Play Store distribution only).

## Project layout

```
lib/
├── main.dart                 # entry point — bootstraps services and runs ProviderScope
├── app.dart                  # MaterialApp.router root with dynamic colour
├── core/
│   ├── constants/            # tap target, spring presets, layout fractions
│   ├── router/               # go_router config + Routes
│   ├── services/             # storage, audio, haptic, notifications, db, accessibility
│   ├── theme/                # 6 presets + M3 Expressive builder + typography
│   ├── utils/                # extensions, email/url launchers
│   └── widgets/              # NumeroLogo, NumeroButton, SpringScale, etc.
├── data/
│   ├── models/               # DailyGoal, UserProfile, LessonProgress
│   ├── placeholder/          # PlaceholderPath, PlaceholderLesson
│   └── repositories/         # User, Progress, Settings (thin wrappers)
├── diagrams/                 # 5 priority-1 diagrams (number line, function plotter, ...)
├── features/
│   ├── splash/
│   ├── onboarding/           # 4-step flow: theme, name, goal, gestures
│   ├── shell/                # bottom-nav scaffold
│   ├── home/                 # streak header, daily quest bar, path map
│   ├── lesson/               # the heart of the app
│   │   ├── interactions/     # 11 interaction widgets + their config types
│   │   ├── micro_screens/    # renderer + visual hook + summary
│   │   └── widgets/          # top bar, feedback panel, reward screen
│   ├── practice/             # review queue
│   ├── profile/              # avatar, stats, achievements
│   └── settings/             # sound, haptic, notifications, reset, kDeveloperEmail
├── gamification/
│   ├── xp/                   # XP awards, today / total tracking
│   ├── streak/               # daily streak with freezes
│   ├── hearts/               # 5 hearts, disabled for first 10 lessons
│   ├── gems/                 # soft currency
│   ├── chests/               # variable-ratio rewards every 5 lessons
│   ├── crowns/               # 5 crown levels per unit (stub)
│   ├── quests/               # 3 daily quests, midnight reset
│   └── leagues/              # opt-in weekly leaderboard (stub)
├── spaced_repetition/
│   ├── leitner/              # 5-box scheduler — v1 default
│   ├── fsrs/                 # FSRS v2 placeholder
│   ├── mix_policy.dart       # 70/30 → 30/70 at 200+ items
│   └── review_queue.dart
├── notifications/            # NotificationScheduler bridges service + storage
├── widgets_home_screen/      # Android home-screen widget data bridge
└── l10n/                     # localisations (English only in v1)

android/
└── app/src/main/kotlin/com/numero/app/widget/
    ├── NumeroWidgetSmall.kt  # 1×1 widget showing streak + XP
    └── NumeroWidgetMedium.kt # 2×2 widget showing streak + XP + next lesson

assets/
├── icon/numero_icon.svg      # used by both splash logo and launcher icon
└── sounds/                   # five placeholder paths — drop MP3s in to enable audio
```

## Where to change things

| Want to change…                | Look in                                                                   |
| ------------------------------ | ------------------------------------------------------------------------- |
| Developer contact email        | `lib/features/settings/settings_screen.dart` — `kDeveloperEmail` constant |
| Theme colours                  | `lib/core/theme/theme_presets.dart`                                       |
| XP, hearts, streak rules       | `lib/core/constants/app_constants.dart`                                   |
| Splash dwell time              | `AppConstants.splashDuration`                                             |
| Add a new interaction type     | Implement in `lib/features/lesson/interactions/`, then wire into `micro_screen_renderer.dart` |
| Add a new diagram              | Add a folder under `lib/diagrams/`, wrap with `DiagramContainer`          |

## Where to add curriculum content (Part Two)

The shell is curriculum-agnostic. To start filling in real lessons:

1. Author `MicroScreenSpec` lists in `lib/data/curriculum/...` organised by
   world / section / unit / lesson (mirroring the spec's Part Two outline).
2. Replace `PlaceholderPath.entries` and `PlaceholderLesson.build()` with
   real curriculum data.
3. Author the priority-1 diagrams' content-specific subclasses (e.g.
   `RiemannSumSlider` extending `FunctionPlotter`).

Every lesson follows the 14-screen template defined in `MicroScreenSpec`.
The renderer (`micro_screen_renderer.dart`) dispatches to the right
interaction widget by `MicroScreenKind`.

## Design decisions

- **State management:** Riverpod throughout (Spec §2 leaves the choice to
  the developer; consistency is the rule).
- **Routing:** `go_router` with a `ShellRoute` for the bottom-nav tabs;
  lesson and settings are top-level routes so the bottom nav hides during
  a lesson (Spec §3.2).
- **Theming:** M3 Expressive (`useMaterial3: true`,
  `DynamicSchemeVariant.expressive`). Spring physics replace easing curves.
  Six presets plus a System preset that uses `dynamic_color` on Android 12+.
- **Spaced repetition:** Leitner box (5 boxes, intervals `[1, 2, 4, 8, 16]`
  days) in v1. FSRS v2 is stubbed for the v2 milestone (Spec §10.1).
- **Hearts:** Disabled for the first 10 lessons of all time
  (Spec §8.2). No punishment during onboarding learning.
- **Accessibility:** Reduced motion is read from both the in-app toggle
  *and* the platform's `MediaQuery.disableAnimations` flag — either one
  triggers the reduced-motion path.

## Running the tests

```sh
flutter test
```

Tests live under `test/` and cover splash, onboarding, home, the lesson
controller, gamification controllers, the Leitner scheduler, and the
theme builder. They are smoke-level — they exist to catch regressions
in the wiring, not to verify pedagogy. Verification of pedagogy is a
content-team responsibility (Spec Implementation Notes).

## Known v1 limitations

- **Sound assets are placeholders.** The audio service silently fails when
  files are missing — see `assets/sounds/README.md`.
- **No account system.** All data is stored locally on the device. Cloud
  sync is deferred.
- **No iOS build.** Spec targets Google Play Store first.
- **STIX Two Math font is not bundled** — uncomment the `fonts:` block in
  `pubspec.yaml` and drop the `.otf` files in `assets/fonts/stix/` before
  shipping content that uses equations.
- **FSRS is stubbed.** Leitner ships in v1; FSRS port is the v2 milestone.

## Licence

Proprietary — Numero v1.0.

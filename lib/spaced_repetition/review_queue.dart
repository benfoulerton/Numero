/// Pulls due items from the Leitner scheduler for the Practice tab.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'leitner/leitner_scheduler.dart';

final reviewQueueProvider = FutureProvider<List<ReviewItem>>((ref) async {
  return ref.watch(leitnerSchedulerProvider).dueItems();
});

final reviewQueueCountProvider = FutureProvider<int>((ref) async {
  return ref.watch(leitnerSchedulerProvider).totalItemCount();
});

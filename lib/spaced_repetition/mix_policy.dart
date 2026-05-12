/// New-vs-review item ratio (Spec §10.3).
///
/// Default split: 70/30 new vs review.
/// Once item count > 200, shift to 30/70 new vs review.
library;

import '../core/constants/app_constants.dart';

class MixPolicy {
  const MixPolicy._();

  static double newRatio(int totalItems) =>
      totalItems > AppConstants.reviewMixThreshold
          ? AppConstants.newRatioAfter
          : AppConstants.newRatioBefore;

  static double reviewRatio(int totalItems) => 1.0 - newRatio(totalItems);
}

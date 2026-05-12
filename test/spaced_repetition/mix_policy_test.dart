import 'package:flutter_test/flutter_test.dart';
import 'package:numero/core/constants/app_constants.dart';
import 'package:numero/spaced_repetition/mix_policy.dart';

void main() {
  group('MixPolicy', () {
    test('starts at 70/30 new/review', () {
      expect(MixPolicy.newRatio(0), AppConstants.newRatioBefore);
      expect(MixPolicy.reviewRatio(0),
          1.0 - AppConstants.newRatioBefore);
    });

    test('flips to 30/70 above the threshold (Spec §10.3)', () {
      final above = AppConstants.reviewMixThreshold + 1;
      expect(MixPolicy.newRatio(above), AppConstants.newRatioAfter);
      expect(MixPolicy.reviewRatio(above),
          1.0 - AppConstants.newRatioAfter);
    });

    test('exactly at the threshold uses the BEFORE ratio', () {
      expect(MixPolicy.newRatio(AppConstants.reviewMixThreshold),
          AppConstants.newRatioBefore);
    });
  });
}

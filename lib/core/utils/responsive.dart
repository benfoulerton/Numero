/// Responsive width helpers. The app is phone-first and tested at
/// 360 / 393 / 412 dp (Spec §15). On larger viewports, content is centred.
library;

import 'package:flutter/widgets.dart';

import '../constants/layout_constants.dart';

extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get safeContentWidth {
    final w = screenSize.width;
    return w > LayoutConstants.maxContentWidth
        ? LayoutConstants.maxContentWidth
        : w;
  }
}

class CenteredContent extends StatelessWidget {
  const CenteredContent({super.key, required this.child, this.maxWidth});

  final Widget child;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? LayoutConstants.maxContentWidth,
        ),
        child: child,
      ),
    );
  }
}

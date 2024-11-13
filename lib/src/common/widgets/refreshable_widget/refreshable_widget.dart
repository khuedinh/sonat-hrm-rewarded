import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RefreshableWidget extends StatelessWidget {
  final List<Widget> slivers;
  final Future Function() onRefresh;
  final ScrollController? controller;

  const RefreshableWidget({
    super.key,
    this.slivers = const <Widget>[],
    required this.onRefresh,
    this.controller,
  });

  buildAndroidWidget() {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(
          parent: ClampingScrollPhysics(),
        ),
        slivers: slivers,
      ),
    );
  }

  buildIOSWidget() {
    return CustomScrollView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: onRefresh,
          builder: buildRefreshIndicator,
          refreshTriggerPullDistance: 120,
        ),
        ...slivers
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid ? buildAndroidWidget() : buildIOSWidget();
  }
}

Widget buildRefreshIndicator(
  BuildContext context,
  RefreshIndicatorMode refreshState,
  double pulledExtent,
  double refreshTriggerPullDistance,
  double refreshIndicatorExtent,
) {
  final double percentageComplete =
      clampDouble(pulledExtent / refreshTriggerPullDistance, 0.0, 1.0);

  // Place the indicator at the top of the sliver that opens up. We're using a
  // Stack/Positioned widget because the CupertinoActivityIndicator does some
  // internal translations based on the current size (which grows as the user drags)
  // that makes Padding calculations difficult. Rather than be reliant on the
  // internal implementation of the activity indicator, the Positioned widget allows
  // us to be explicit where the widget gets placed. The indicator should appear
  // over the top of the dragged widget, hence the use of Clip.none.
  return Center(
    child: Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Positioned(
          top: 16,
          left: 0.0,
          right: 0.0,
          child: _buildIndicatorForRefreshState(
              refreshState, 10, percentageComplete),
        ),
      ],
    ),
  );
}

Widget _buildIndicatorForRefreshState(RefreshIndicatorMode refreshState,
    double radius, double percentageComplete) {
  switch (refreshState) {
    case RefreshIndicatorMode.drag:
      // While we're dragging, we draw individual ticks of the spinner while simultaneously
      // easing the opacity in. The opacity curve values here were derived using
      // Xcode through inspecting a native app running on iOS 13.5.
      const Curve opacityCurve = Interval(0.0, 0.35, curve: Curves.easeInOut);
      return Opacity(
        opacity: opacityCurve.transform(percentageComplete),
        child: CupertinoActivityIndicator.partiallyRevealed(
            radius: radius, progress: percentageComplete),
      );
    case RefreshIndicatorMode.armed:
    case RefreshIndicatorMode.refresh:
      // Once we're armed or performing the refresh, we just show the normal spinner.
      return CupertinoActivityIndicator(radius: radius);
    case RefreshIndicatorMode.done:
      // When the user lets go, the standard transition is to shrink the spinner.
      return CupertinoActivityIndicator(radius: radius * percentageComplete);
    case RefreshIndicatorMode.inactive:
      // Anything else doesn't show anything.
      return const SizedBox.shrink();
  }
}

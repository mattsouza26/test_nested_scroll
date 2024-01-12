import 'package:flutter/material.dart';

class NestedScrollPhysics extends ClampingScrollPhysics {
  final BuildContext context;
  final ScrollController? parentController;

  NestedScrollPhysics({
    required this.context,
    ScrollController? parentController,
    super.parent,
  }) : parentController =
            parentController ?? PrimaryScrollController.maybeOf(context);
  @override
  NestedScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return NestedScrollPhysics(
        context: context,
        parent: _buildParent(ancestor),
        parentController: parentController);
  }

  ScrollPhysics? _buildParent(ScrollPhysics? ancestor) {
    return ancestor is BouncingScrollPhysics
        ? const ClampingScrollPhysics()
        : ancestor;
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    if (parentController == null ||
        !parentController!.hasClients ||
        !parentController!.position.hasContentDimensions ||
        !parentController!.positions.isNotEmpty) {
      return super.shouldAcceptUserOffset(position);
    }
    final ScrollPosition parentControllerPosition = parentController!.position;
    final double parentControllerPixels = parentControllerPosition.pixels;

    final bool parentControllerStartScrolling =
        parentControllerPixels != parentControllerPosition.minScrollExtent &&
            parentControllerPixels < parentControllerPosition.maxScrollExtent;
    final bool viewportAtParentViewport = position.viewportDimension ==
        parentControllerPosition.viewportDimension;

    return super.shouldAcceptUserOffset(position) ||
        parentControllerStartScrolling ||
        viewportAtParentViewport;
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (parentController == null ||
        !parentController!.hasClients ||
        !parentController!.position.hasContentDimensions ||
        !parentController!.positions.isNotEmpty) {
      return super.applyPhysicsToUserOffset(position, offset);
    }
    final double scrollPixels = position.pixels;
    final double minScrollExtent = position.minScrollExtent;

    final double parentScrollPixels = parentController!.position.pixels;
    final double parentScrollOffset = parentController!.offset;
    final double parentMaxScrollExtent =
        parentController!.position.maxScrollExtent;
    final double parentMinScrollExtent =
        parentController!.position.minScrollExtent;
    final bool parentAtMaxScrollExtent = !parentScrollPixels.isNegative &&
        parentScrollPixels >= parentMaxScrollExtent;

    final bool isScrollingDown = !offset.isNegative;
    final bool isScrollingUp = offset.isNegative;
    final bool isOverScrolling =
        !parentAtMaxScrollExtent && parentScrollPixels <= parentMinScrollExtent;

    if (isScrollingUp && !parentAtMaxScrollExtent ||
        isScrollingDown &&
            scrollPixels == minScrollExtent &&
            !isOverScrolling) {
      parentController!.jumpTo(parentScrollOffset - offset);
      offset = minScrollExtent;
    } else if (isScrollingDown &&
        scrollPixels == minScrollExtent &&
        isOverScrolling) {
      parentController!.jumpTo(parentMinScrollExtent);
      offset = minScrollExtent;
    }
    return super.applyPhysicsToUserOffset(position, offset);
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (parentController == null ||
        !parentController!.hasClients ||
        !parentController!.position.hasContentDimensions ||
        !parentController!.positions.isNotEmpty) {
      return super.applyBoundaryConditions(position, value);
    }

    final double offset = value - position.pixels;
    final double parentScrollOffset = parentController!.offset;
    final double parentScrollPixels = parentController!.position.pixels;
    final double parentMinScrollExtent =
        parentController!.position.minScrollExtent;
    final double parentMaxScrollExtent =
        parentController!.position.maxScrollExtent;
    final bool parentAtMaxScrollExtent = !parentScrollPixels.isNegative &&
        parentScrollPixels >= parentMaxScrollExtent;

    final bool isScrollingUp = !offset.isNegative;

    if (isScrollingUp && parentScrollOffset < parentMaxScrollExtent) {
      parentController!.jumpTo(parentScrollPixels + offset);
    } else if (!isScrollingUp && value.isNegative && parentAtMaxScrollExtent) {
      parentController!.animateTo(parentMinScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.decelerate);
    }
    return super.applyBoundaryConditions(position, value);
  }
}

import 'dart:math';
import 'package:flutter/material.dart';

/// The axis around which the flip occurs.
enum FlipAxis { horizontal, vertical }

/// A widget that flips between two children with a 3D rotation effect.
/// Supports drag-to-flip with threshold and optional tap-to-flip.
class DoubleSidedFlipWidget extends StatefulWidget {
  /// The front widget when not flipped.
  final Widget front;

  /// The back widget when flipped.
  final Widget back;

  /// The axis to flip: horizontal (around Y) or vertical (around X).
  final FlipAxis axis;

  /// Duration of the flip animation.
  final Duration duration;

  /// Whether the user can drag to flip.
  final bool enableDrag;

  /// Whether the user can tap to flip.
  final bool enableTap;

  /// Fraction of full flip (0‒1) required on drag release to trigger flip.
  /// E.g. 0.5 means halfway.
  final double flipThreshold;

  /// Sensitivity of drag: fraction of flip per pixel.
  final double dragSensitivity;

  /// Perspective depth for 3D effect; small positive value like 0.001.
  final double perspective;

  const DoubleSidedFlipWidget({
    super.key,
    required this.front,
    required this.back,
    this.axis = FlipAxis.horizontal,
    this.duration = const Duration(milliseconds: 400),
    this.enableDrag = true,
    this.enableTap = false,
    this.flipThreshold = 0.5,
    this.dragSensitivity = 0.005,
    this.perspective = 0.001,
  })  : assert(flipThreshold >= 0 && flipThreshold <= 1),
        assert(dragSensitivity > 0),
        assert(perspective > 0 && perspective < 1);

  @override
  State<DoubleSidedFlipWidget> createState() => _DoubleSidedFlipWidgetState();
}

class _DoubleSidedFlipWidgetState extends State<DoubleSidedFlipWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: _showFront ? 0.0 : 1.0,
    )..addStatusListener(_onStatus);
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _showFront = false;
    } else if (status == AnimationStatus.dismissed) {
      _showFront = true;
    }
  }

  @override
  void didUpdateWidget(covariant DoubleSidedFlipWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller
        ..duration = widget.duration
        ..reset();
      _controller.value = _showFront ? 0.0 : 1.0;
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onStatus);
    _controller.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final angle = _controller.value * pi;
        // Choose which side to show
        final isFront = _controller.value <= 0.5;
        // Apply perspective
        final transform = Matrix4.identity()
          ..setEntry(3, 2, widget.perspective);
        // Rotate around chosen axis
        if (widget.axis == FlipAxis.horizontal) {
          transform.rotateY(angle);
        } else {
          transform.rotateX(angle);
        }
        // Select front/back child
        Widget display = isFront ? widget.front : widget.back;
        // For back, correct orientation by flipping an extra 180°
        if (!isFront) {
          final correction = Matrix4.identity();
          if (widget.axis == FlipAxis.horizontal) {
            correction.rotateY(pi);
          } else {
            correction.rotateX(pi);
          }
          display = Transform(
            transform: correction,
            alignment: Alignment.center,
            child: widget.back,
          );
        }
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: display,
        );
      },
    );

    // Wrap with gestures if needed
    if (widget.enableDrag || widget.enableTap) {
      child = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.enableTap ? _toggleFlip : null,
        onHorizontalDragUpdate:
            widget.enableDrag && widget.axis == FlipAxis.horizontal
                ? (details) {
                    _controller.value = (_controller.value +
                            details.delta.dx * widget.dragSensitivity)
                        .clamp(0.0, 1.0);
                  }
                : null,
        onVerticalDragUpdate:
            widget.enableDrag && widget.axis == FlipAxis.vertical
                ? (details) {
                    _controller.value = (_controller.value -
                            details.delta.dy * widget.dragSensitivity)
                        .clamp(0.0, 1.0);
                  }
                : null,
        onHorizontalDragEnd:
            widget.enableDrag && widget.axis == FlipAxis.horizontal
                ? (details) {
                    if (_controller.value >= widget.flipThreshold) {
                      _controller.animateTo(1.0);
                    } else {
                      _controller.animateBack(0.0);
                    }
                  }
                : null,
        onVerticalDragEnd: widget.enableDrag && widget.axis == FlipAxis.vertical
            ? (details) {
                if (_controller.value >= widget.flipThreshold) {
                  _controller.animateTo(1.0);
                } else {
                  _controller.animateBack(0.0);
                }
              }
            : null,
        child: child,
      );
    }

    return child;
  }
}

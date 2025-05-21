import 'dart:math';
import 'package:flutter/material.dart';

/// A widget that applies 3D rotation to its [child], supporting both
/// gesture-driven and continuous or finite auto-rotation on the X axis, Y axis, or both.
class IndefiniteRotation3DEffect extends StatefulWidget {
  /// The widget to be rotated.
  final Widget child;

  /// If true and [rotationCount] is null, auto-rotation runs continuously.
  final bool autoRotate;

  /// If non-null, runs a finite number of full rotations, overriding [autoRotate].
  final int? rotationCount;

  /// Whether to rotate around the X axis.
  final bool rotateX;

  /// Whether to rotate around the Y axis.
  final bool rotateY;

  /// Duration for one full 360° rotation cycle.
  final Duration rotationDuration;

  /// If true, user can pan to rotate the widget.
  final bool allowUserRotation;

  /// If true, it will stop rotating when the user interacts.
  final bool stopRotationOnUserInteraction;

  /// Multiplier controlling how sensitive user drag is (radians per pixel).
  final double gestureSensitivity;

  const IndefiniteRotation3DEffect({
    super.key,
    required this.child,
    this.autoRotate = true,
    this.rotationCount,
    this.rotateX = true,
    this.rotateY = false,
    this.rotationDuration = const Duration(seconds: 5),
    this.allowUserRotation = true,
    this.stopRotationOnUserInteraction = false,
    this.gestureSensitivity = 0.01,
  })  : assert(rotateX || rotateY, 'At least one axis must be true.'),
        assert(rotationCount == null || rotationCount > 0,
            'rotationCount must be greater than zero.');

  @override
  State<IndefiniteRotation3DEffect> createState() =>
      _IndefiniteRotation3DEffectState();
}

class _IndefiniteRotation3DEffectState extends State<IndefiniteRotation3DEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // User-controlled rotation angles (in radians).
  double _userAngleX = 0;
  double _userAngleY = 0;

  // Count of completed full rotations (for finite rotation).
  int _completedRotations = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.rotationDuration,
    );
    _controller.addStatusListener(_onAnimationStatus);

    // Start auto or finite rotation if requested
    if (widget.rotationCount != null) {
      _startFiniteRotation();
    } else if (widget.autoRotate) {
      _controller.repeat();
    }
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && widget.rotationCount != null) {
      _completedRotations++;
      if (_completedRotations < widget.rotationCount!) {
        _controller.forward(from: 0.0);
      }
      // else: reached desired count, stop animating
    }
  }

  void _startFiniteRotation() {
    _completedRotations = 0;
    _controller.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(covariant IndefiniteRotation3DEffect oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle duration changes
    if (widget.rotationDuration != oldWidget.rotationDuration) {
      _controller
        ..duration = widget.rotationDuration
        ..reset();
      if (widget.rotationCount != null) {
        _startFiniteRotation();
      } else if (widget.autoRotate) {
        _controller.repeat();
      }
    }

    // Handle changes between finite and infinite rotation
    final oldAuto = oldWidget.autoRotate || oldWidget.rotationCount != null;
    final newAuto = widget.autoRotate || widget.rotationCount != null;

    if (newAuto && !oldAuto) {
      if (widget.rotationCount != null) {
        _startFiniteRotation();
      } else {
        _controller.repeat();
      }
    } else if (!newAuto && oldAuto) {
      _controller.stop();
    } else if (oldWidget.rotationCount == null &&
        widget.rotationCount != null) {
      // switched infinite->finite
      _controller.reset();
      _startFiniteRotation();
    } else if (oldWidget.rotationCount != null &&
        widget.rotationCount == null &&
        widget.autoRotate) {
      // switched finite->infinite
      _controller.reset();
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onAnimationStatus);
    _controller.dispose();
    super.dispose();
  }

  Matrix4 _buildTransform(double autoAngle) {
    final matrix = Matrix4.identity()..setEntry(3, 2, 0.003);
    // Compute the auto-rotate contribution (finite or infinite)
    final autoContribution = widget.rotationCount != null
        ? (_completedRotations + _controller.value) * 2 * pi
        : autoAngle;

    final totalX =
        widget.rotateX ? _userAngleX + autoContribution : _userAngleX;
    final totalY =
        widget.rotateY ? _userAngleY + autoContribution : _userAngleY;

    if (widget.rotateX) matrix.rotateX(totalX);
    if (widget.rotateY) matrix.rotateY(totalY);
    return matrix;
  }

  @override
  Widget build(BuildContext context) {
    Widget rotated = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final autoAngle = _controller.value * 2 * pi;
        return Transform(
          transform: _buildTransform(autoAngle),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: widget.child,
    );

    if (widget.allowUserRotation) {
      rotated = GestureDetector(
        onPanDown: (_) {
          // Always stop controller to allow manual rotation
          if (widget.autoRotate || widget.rotationCount != null) {
            _controller.stop();
          }
        },
        onPanUpdate: (details) {
          setState(() {
            _userAngleY += details.delta.dx * widget.gestureSensitivity;
            _userAngleX -= details.delta.dy * widget.gestureSensitivity;
          });
        },
        onPanEnd: (_) {
          // Resume only if stopRotationOnUserInteraction is false
          if (!widget.stopRotationOnUserInteraction) {
            if (widget.rotationCount != null) {
              final remaining = widget.rotationCount! - _completedRotations;
              if (remaining > 0) {
                _controller.forward(from: _controller.value);
              }
            } else if (widget.autoRotate) {
              _controller.repeat();
            }
          }
        },
        child: rotated,
      );
    }

    return rotated;
  }
}

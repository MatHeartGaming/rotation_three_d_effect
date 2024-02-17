import 'package:flutter/material.dart';

/// This Widget allows to simply rotate other widgets.
/// [child] is the Widget to which the rotation will be applied to.
/// [maximumPan] is the maximum rotation on all axes (x, y, z).
/// [returnsInPlace] indicates whether the widget will return the original position (0, 0, 0).
/// [returnInPlaceDuration] is the duration of the returnsInPlace animation.
/// [initalPosition] is the inital postion in x and y the [child] Widget will assume.
/// [endPosition] is the postion in x and y the [child] Widget will assume when returning to its original position. This only has effect when [returnsInPlace] is set to true.
/// THIS IS STILL EXPERIMENTAL! [rotateIndefinitely] makes the Widget roate on itself indefinetely. This is under development and I don't recomend using it yet.
class Rotation3DEffect extends StatefulWidget {
  final Widget child;
  final double? maximumPan;
  final Offset initalPosition;
  final Offset endPosition;
  final bool returnsInPlace;
  final Duration returnInPlaceDuration;
  final bool rotateIndefinitely;

  /// This applies a limited rotation indicated by [maximumPan] and always retruns in place.
  /// [returnInPlaceDuration] the duration of the returnsInPlace animation.
  /// [initalPosition] is the inital postion in x and y the [child] Widget will assume.
  /// [endPosition] is the postion in x and y the [child] Widget will assume when returning to its original position.
  Rotation3DEffect.limitedReturnsInPlace({
    super.key,
    required this.child,
    this.maximumPan = 50,
    this.initalPosition = Offset.zero,
    this.endPosition = Offset.zero,
    this.returnInPlaceDuration = const Duration(milliseconds: 400),
  })  : returnsInPlace = true,
        rotateIndefinitely = false,
        assert(
            initalPosition.dx.abs() <= (maximumPan ?? double.infinity) &&
                initalPosition.dy.abs() <= (maximumPan ?? double.infinity),
            "The absoulte value of initialPosition in x and y axis cannot exceed the maximumSpan"),
        assert(
            endPosition.dx.abs() <= (maximumPan ?? double.infinity) &&
                endPosition.dy.abs() <= (maximumPan ?? double.infinity),
            "The absoulte value of endPosition in x and y axis cannot exceed the maximumSpan");

  /// This applies a limited rotation indicated by [maximumPan] and never retruns in place
  /// [initalPosition] is the inital postion in x and y the [child] Widget will assume.
  /// Takes in a [child] Widget
  Rotation3DEffect.limited({
    super.key,
    required this.child,
    this.maximumPan = 50,
    this.initalPosition = Offset.zero,
  })  : returnsInPlace = false,
        returnInPlaceDuration = const Duration(milliseconds: 0),
        endPosition = Offset.zero,
        rotateIndefinitely = false,
        assert(
            initalPosition.dx.abs() <= (maximumPan ?? double.infinity) &&
                initalPosition.dy.abs() <= (maximumPan ?? double.infinity),
            "The absoulte value of Initial position in x and y axis cannot exceed the maximumSpan");

  /// This applies a limited rotation indicated by [maximumPan]
  /// Takes in a [child] Widget
  /// [returnsInPlace] tells whether the widget should return to its original position when the user lift their finger.
  /// [returnInPlaceDuration] the duration of the returnsInPlace animation
  /// [initalPosition] is the inital postion in x and y the [child] Widget will assume.
  /// [endPosition] is the postion in x and y the [child] Widget will assume when returning to its original position. [returnsInPlace] must be true for this to have effect.
  Rotation3DEffect({
    super.key,
    required this.child,
    this.maximumPan,
    this.returnsInPlace = false,
    this.initalPosition = Offset.zero,
    this.endPosition = Offset.zero,
    this.rotateIndefinitely = false,
    this.returnInPlaceDuration = const Duration(milliseconds: 0),
  })  : assert(
            initalPosition.dx.abs() <= (maximumPan ?? double.infinity) &&
                initalPosition.dy.abs() <= (maximumPan ?? double.infinity),
            "The absoulte value of initialPosition in x and y axis cannot exceed the maximumSpan"),
        assert(
            endPosition.dx.abs() <=
                    (rotateIndefinitely
                        ? double.infinity
                        : (maximumPan ?? double.infinity)) &&
                endPosition.dy.abs() <=
                    (rotateIndefinitely
                        ? double.infinity
                        : (maximumPan ?? double.infinity)),
            "The absoulte value of endPosition in x and y axis cannot exceed the maximumSpan");

  @override
  State<Rotation3DEffect> createState() => _Rotation3DEffectState();
}

class _Rotation3DEffectState extends State<Rotation3DEffect>
    with SingleTickerProviderStateMixin {
  Offset _offset = Offset.zero;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _offset = widget.initalPosition;
    _controller = AnimationController(
      vsync: this,
      duration: widget.returnInPlaceDuration,
    );
    _animation = Tween<Offset>(
      begin: _offset,
      end: widget.endPosition,
    ).animate(_controller)
      ..addListener(() {
        setState(() {
          _offset = _animation.value;
        });
      });

    if (widget.rotateIndefinitely) {
      _initLoopRotation();
    }
  }

  void _initLoopRotation() {
    _controller.addListener(() {
      if (_controller.isCompleted) {
        _controller.repeat();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // perspective
        ..rotateX(0.01 * _offset.dy) // changed
        ..rotateY(-0.01 * _offset.dx), // changed
      alignment: FractionalOffset.center,
      child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _offset += details.delta;
              if (widget.maximumPan == null) return;
              final maximumPan = widget.maximumPan ?? 0;
              if (_offset.dy < -maximumPan) {
                _offset = Offset(_offset.dx, -50);
              }
              if (_offset.dy > maximumPan) {
                _offset = Offset(_offset.dx, maximumPan);
              }
              if (_offset.dx < -maximumPan) {
                _offset = Offset(-maximumPan, _offset.dy);
              }
              if (_offset.dx > maximumPan) {
                _offset = Offset(maximumPan, _offset.dy);
              }
            });
          },
          onPanEnd: (details) {
            _animation = Tween<Offset>(
              begin: _offset,
              end: widget.endPosition,
            ).animate(_controller);
            if (!widget.returnsInPlace) return;
            _controller.reset();
            _controller.forward();
          },
          child: widget.child),
    );
  }
}

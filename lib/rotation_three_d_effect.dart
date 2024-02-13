import 'package:flutter/material.dart';

/// This Widget allows to simply rotate other widgets.
/// [child] is the Widget to which the rotation will be applied to.
/// [maximumPan] is the maximum rotation on all axes (x, y, z)
/// [returnsInPlace] indicates whether the widget will return the original position (0, 0, 0)
/// [returnInPlaceDuration] is the duration of the returnsInPlace animation
class Rotation3DEffect extends StatefulWidget {
  final Widget child;
  final double? maximumPan;
  final bool returnsInPlace;
  final Duration returnInPlaceDuration;

  /// This applies a limited rotation indicated by [maximumPan] and always retruns in place
  /// [returnInPlaceDuration] the duration of the returnsInPlace animation
  const Rotation3DEffect.limitedReturnsInPlace({
    super.key,
    required this.child,
    this.maximumPan = 50,
    this.returnInPlaceDuration = const Duration(milliseconds: 400),
  }) : returnsInPlace = true;

  /// This applies a limited rotation indicated by [maximumPan] and never retruns in place
  /// Takes in a [child] Widget
  const Rotation3DEffect.limited({
    super.key,
    required this.child,
    this.maximumPan = 50,
  })  : returnsInPlace = false,
        returnInPlaceDuration = const Duration(milliseconds: 0);

  /// This applies a limited rotation indicated by [maximumPan]
  /// Takes in a [child] Widget
  /// [returnsInPlace] tells whether the widget should return to its original position when the user lift their finger.
  /// [returnInPlaceDuration] the duration of the returnsInPlace animation
  const Rotation3DEffect({
    super.key,
    required this.child,
    this.maximumPan,
    this.returnsInPlace = false,
    this.returnInPlaceDuration = const Duration(milliseconds: 0),
  });

  @override
  State<Rotation3DEffect> createState() => _Rotation3DEffectState();
}

class _Rotation3DEffectState extends State<Rotation3DEffect>
    with SingleTickerProviderStateMixin {
  Offset _offset = Offset.zero;
  final Offset _originalOffset = Offset.zero;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.returnInPlaceDuration,
    );
    _animation = Tween<Offset>(
      begin: _offset,
      end: _originalOffset,
    ).animate(_controller)
      ..addListener(() {
        setState(() {
          _offset = _animation.value;
        });
      });
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
              end: _originalOffset,
            ).animate(_controller);
            if (!widget.returnsInPlace) return;
            _controller.reset();
            _controller.forward();
          },
          child: widget.child),
    );
  }
}

import 'package:flutter/material.dart';

class ThreeDimensionalWidget extends StatefulWidget {
  final Widget child;
  final double? maximumPan;
  final bool returnsInPlace;
  final Duration? returnInPlaceDuration;

  const ThreeDimensionalWidget.limitedReturnsInPlace(
      {super.key,
      required this.child,
      this.maximumPan = 50,
      this.returnsInPlace = true,
      this.returnInPlaceDuration = const Duration(milliseconds: 400),
    });

  const ThreeDimensionalWidget.limited(
      {super.key,
      required this.child,
      this.maximumPan = 50,
      this.returnsInPlace = false,
      this.returnInPlaceDuration,
    });

  const ThreeDimensionalWidget(
      {super.key,
      required this.child,
      this.maximumPan,
      this.returnsInPlace = false,
      this.returnInPlaceDuration,
    });

  @override
  State<ThreeDimensionalWidget> createState() => _ThreeDimensionalWidgetState();
}

class _ThreeDimensionalWidgetState extends State<ThreeDimensionalWidget>
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

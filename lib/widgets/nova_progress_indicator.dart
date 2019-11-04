import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class NovaProgressIndicator extends ProgressIndicator {
  final double strokeWidth;

  const NovaProgressIndicator({
    Key key,
    double value,
    Color backgroundColor,
    this.strokeWidth = 20.0,
  });

  @override
  _NovaProgressIndicatorState createState() => _NovaProgressIndicatorState();
}

class _NovaProgressIndicatorState extends State<NovaProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    );
    if (widget.value == null) _controller.repeat();
  }

  @override
  void didUpdateWidget(NovaProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating)
      _controller.repeat();
    else if (widget.value != null && _controller.isAnimating)
      _controller.stop();
  }

  Widget _buildIndicator(BuildContext context, double headValue,
      double tailValue, int stepValue, double rotationValue) {
    return ClipPath(
      clipper: _NovaProgressIndicatorClipper(),
      child: CustomPaint(
        child: Container(
          child: Image.asset(
            'assets/loading.png',
            color: const Color(0xFFEDEAF9),
          ),
          constraints: BoxConstraints(
            maxHeight: 80.0,
            maxWidth: 80.0,
          ),
        ),
        foregroundPainter: _NovaProgressBarPainter(
          backgroundColor: widget.backgroundColor,
          valueColor: Color(0xFFC4BDDB),
          value: widget.value,
          headValue: headValue,
          tailValue: tailValue,
          stepValue: stepValue,
          rotationValue: rotationValue,
          strokeWidth: widget.strokeWidth,
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return _buildIndicator(
          context,
          _kStrokeHeadTween.evaluate(_controller),
          _kStrokeTailTween.evaluate(_controller),
          _kStepTween.evaluate(_controller),
          _kRotationTween.evaluate(_controller),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) return _buildIndicator(context, 0.0, 0.0, 0, 0.0);
    return _buildAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

final Animatable<double> _kStrokeHeadTween = CurveTween(
  curve: const Interval(0.0, 0.5, curve: Curves.fastOutSlowIn),
).chain(CurveTween(
  curve: const SawTooth(5),
));

final Animatable<double> _kStrokeTailTween = CurveTween(
  curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
).chain(CurveTween(
  curve: const SawTooth(5),
));

final Animatable<int> _kStepTween = StepTween(begin: 0, end: 5);

final Animatable<double> _kRotationTween = CurveTween(curve: const SawTooth(5));

class _NovaProgressBarPainter extends CustomPainter {
  _NovaProgressBarPainter({
    this.backgroundColor,
    this.valueColor,
    this.value,
    this.headValue,
    this.tailValue,
    this.stepValue,
    this.rotationValue,
    this.strokeWidth,
  })  : arcStart = value != null
            ? _startAngle
            : _startAngle +
                tailValue * 3 / 2 * math.pi +
                rotationValue * math.pi * 1.7 -
                stepValue * 0.8 * math.pi,
        arcSweep = value != null
            ? value.clamp(0.0, 1.0) * _sweep
            : math.max(
                headValue * 3 / 2 * math.pi - tailValue * 3 / 2 * math.pi,
                _epsilon);

  final Color backgroundColor;
  final Color valueColor;
  final double value;
  final double headValue;
  final double tailValue;
  final int stepValue;
  final double rotationValue;
  final double strokeWidth;
  final double arcStart;
  final double arcSweep;

  static const double _twoPi = math.pi * 2.0;
  static const double _epsilon = .001;
  static const double _sweep = _twoPi - _epsilon;
  static const double _startAngle = -math.pi / 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final Size constrainedSize =
        size - Offset(this.strokeWidth, this.strokeWidth);
    final shortestSide =
        math.min(constrainedSize.width, constrainedSize.height);
    final radius = (shortestSide / 2);
    final Paint paint = Paint()
      ..color = valueColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    if (value == null) paint.strokeCap = StrokeCap.butt;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      arcStart,
      arcSweep,
      false,
      paint,
    );
  }

  double radToDeg(num deg) => deg * (180.0 * math.pi);

  @override
  bool shouldRepaint(_NovaProgressBarPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value ||
        oldPainter.headValue != headValue ||
        oldPainter.tailValue != tailValue ||
        oldPainter.stepValue != stepValue ||
        oldPainter.rotationValue != rotationValue ||
        oldPainter.strokeWidth != strokeWidth;
  }
}

class _NovaProgressIndicatorClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final x = size.width / 2.0;
    final y = size.height / 2.0;
    final path = Path()
      ..moveTo(size.width * 0.12, size.height * 0.17)
      ..lineTo(x, y)
      ..lineTo(0.0, size.height * 0.17)
      ..lineTo(-1.0, size.height * 0.63)
      ..lineTo(x, y)
      ..lineTo(-1.0, size.height * 0.66)
      ..lineTo(size.width * 0.07, size.height * 0.77)
      ..lineTo(x, y)
      ..lineTo(size.width * 0.07, size.height * 0.8)
      ..lineTo(size.width * 0.1, size.height * 0.89)
      ..lineTo(x, y)
      ..lineTo(size.width * 0.07, size.height)
      ..lineTo(size.width * 0.53, size.height)
      ..lineTo(x, y)
      ..lineTo(size.width * 0.61, size.height)
      ..lineTo(size.width * 0.77, size.height)
      ..lineTo(x, y)
      ..lineTo(size.width * 0.8, size.height)
      ..lineTo(size.width * 0.94, size.height * 0.77)
      ..lineTo(x, y)
      ..lineTo(size.width, size.height * 0.77)
      ..lineTo(size.width, size.height * 0.61)
      ..lineTo(x, y)
      ..lineTo(size.width * 1.1, size.height * 0.6)
      ..lineTo(size.width * 1.1, size.height * 0.49)
      ..lineTo(x, y)
      ..lineTo(size.width * 1.1, size.height * 0.43)
      ..lineTo(size.width * 0.95, size.height * 0.22)
      ..lineTo(x, y)
      ..lineTo(size.width * 0.95, size.height * 0.18)
      ..lineTo(size.width * 0.9, size.height * 0.09)
      ..lineTo(x, y)
      ..lineTo(size.width * 0.9, size.height * 0.06)
      ..lineTo(size.width * 0.82, size.height * 0.06)
      ..lineTo(x, y)
      ..lineTo(size.width * 0.79, 0.0)
      ..lineTo(size.width * 0.38, -1.5)
      ..lineTo(x, y)
      ..lineTo(size.width * 0.35, 0.0)
      ..lineTo(size.width * 0.23, 0.0)
      ..lineTo(x, y)
      ..lineTo(size.width * 0.2, 0.0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

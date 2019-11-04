import 'package:flutter/material.dart';

/// виджет градиентного фона
class GradientBackground extends StatelessWidget {
  const GradientBackground({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xFF533781),
                const Color(0xFF89519D),
                const Color(0xFFFF8D8C),
              ],
              stops: [
                0.0,
                0.3226,
                1.0,
              ],
            ),
          ),
        ),
        Container(color: const Color(0x661F1431)),
      ],
    );
  }
}

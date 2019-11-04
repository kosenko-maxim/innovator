import 'package:flutter/material.dart';

/// виджет для отображения изображения с круглой рамкой
class NovaCircleAvatar extends StatelessWidget {
  final double radius;
  final ImageProvider image;

  const NovaCircleAvatar({
    Key key,
    this.radius: 53.0,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: radius,
        minWidth: radius,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
        color: Colors.deepPurple[300],
        shape: BoxShape.circle,
      ),
    );
  }
}

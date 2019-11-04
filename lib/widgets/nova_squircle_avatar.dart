import 'package:flutter/material.dart';

/// виджет для отображения отображения с прямоугольной рамкой со скругленными краями
class NovaSquircleAvatar extends StatelessWidget {
  final double size;
  final ImageProvider image;

  NovaSquircleAvatar({Key key, this.size: 80.0, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: size,
        minWidth: size,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
        color: Colors.deepPurple[300],
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}

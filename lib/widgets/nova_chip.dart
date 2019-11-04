import 'package:flutter/material.dart';

/// виджет для отображения различных тегов
class NovaChip extends StatelessWidget {
  final String label;
  final Color color;

  NovaChip({
    Key key,
    this.label,
    this.color: const Color(0xFFEDEAF9),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        constraints: BoxConstraints(
          minHeight: 21.0,
        ),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Center(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.body2,
          ),
        ),
      ),
    );
  }
}

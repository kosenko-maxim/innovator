import 'package:flutter/material.dart';

/// виджет кнопки с контуром
class NovaButton extends StatelessWidget {
  final Color color;
  final Color disabledColor;
  final Color highlightColor;
  final Color splashColor;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback onPressed;

  const NovaButton({
    Key key,
    this.color: const Color(0xFFFFFFFF),
    this.disabledColor,
    this.highlightColor,
    this.splashColor,
    this.child,
    this.padding,
    this.margin,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          margin: margin,
          padding: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: const Color(0xFF80469B),
          ),
          child: FlatButton(
            color: color,
            disabledColor: disabledColor,
            highlightColor: highlightColor,
            splashColor: splashColor,
            child: child,
            padding: padding,
            onPressed: onPressed,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

/// виджет отображающий дополнительную информацию в деталях проекта
class ExtraInfoCard extends StatelessWidget {
  final bool showUpperDivider;
  final bool showLowerDivider;
  final Widget leading;
  final Widget content;

  const ExtraInfoCard({
    Key key,
    this.leading,
    this.content,
    this.showUpperDivider: true,
    this.showLowerDivider: false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          showUpperDivider
              ? Divider(
                  height: 0.0,
                  color: const Color(0xFFC4BDDB),
                )
              : Container(),
          const SizedBox(height: 9.0),
          Row(
            children: <Widget>[
              leading,
              SizedBox(width: 8.0),
              content,
            ],
          ),
          const SizedBox(height: 13.0),
          showLowerDivider
              ? Divider(
                  height: 0.0,
                  color: const Color(0xFFC4BDDB),
                )
              : Container(),
        ],
      ),
    );
  }
}

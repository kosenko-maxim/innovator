import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/chapter.dart';

/// виджет дорожной карты
class RoadmapWidget extends StatelessWidget {
  final List<Chapter> chapters;

  const RoadmapWidget({
    Key key,
    @required this.chapters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: chapters.map((goal) => _buildGoal(goal, context)).toList(),
    );
  }

  Widget _buildGoal(Chapter chapter, BuildContext context) {
    final format = DateFormat('d MMMM yyyy').format;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                _buildIcon(),
                _buildLine(chapter != chapters.last),
              ],
            ),
            SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20.0),
                Text(
                  '${chapter.title} — ${chapter.isActive ? 'текущий' : 'реализован'}',
                  style: Theme.of(context)
                      .textTheme
                      .display1
                      .copyWith(color: const Color(0xFF533781)),
                ),
                SizedBox(height: 4.0),
                Text(
                  '${format(DateTime.parse(chapter.dateFrom))} - ${format(DateTime.parse(chapter.dateTo))}',
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: const Color(0xFFC4BDDB)),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.only(left: 45.5),
          child: Text(
            chapter.description,
            style: Theme.of(context).textTheme.body1,
          ),
        ),
        SizedBox(height: 15.0),
      ],
    );
  }

  Widget _buildLine(bool showLine) {
    return Container(
      width: showLine ? 1.0 : 0.0,
      color: const Color(0xFFEDEAF9),
    );
  }

  Widget _buildIcon() {
    return Container(
      height: 37.0,
      width: 37.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0x0D7E4599),
      ),
      child: Center(
        child: Container(
          height: 21.0,
          width: 21.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0x0D7E4599),
          ),
          child: Center(
            child: Icon(
              Icons.check,
              size: 16.0,
              color: const Color(0xFF533781),
            ),
          ),
        ),
      ),
    );
  }
}

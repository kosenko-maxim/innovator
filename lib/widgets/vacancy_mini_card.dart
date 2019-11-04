import 'package:flutter/material.dart';

import '../models/models.dart';
import 'nova_circle_avatar.dart';

/// мини карточка вакансии для отображения в других виджетах
class VacancyMiniCard extends StatelessWidget {
  final Vacancy _vacancy;
  final bool showUpperDivider;
  final bool showLowerDivider;
  final VoidCallback onTap;

  VacancyMiniCard(
    this._vacancy, {
    Key key,
    this.showUpperDivider: true,
    this.showLowerDivider: false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFFFFF),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            showUpperDivider
                ? Divider(
                    height: 0.0,
                    color: const Color(0xFFC4BDDB),
                  )
                : Container(),
            const SizedBox(height: 15.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                NovaCircleAvatar(
                  image: _vacancy.project.projectPic.isEmpty ||
                          !_vacancy.project.projectPic.startsWith('http')
                      ? AssetImage('assets/project.png')
                      : NetworkImage(_vacancy.project.projectPic),
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _vacancy.title,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(color: const Color(0xFF533781)),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      _vacancy.project.title,
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(color: const Color(0xFF533781)),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      _vacancy.description,
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(color: const Color(0xFF9786BC)),
                    ),
                    // Text(
                    //   '50 000 рублей',
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .body1
                    //       .copyWith(color: const Color(0xFF9786BC)),
                    // ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            showLowerDivider
                ? Divider(
                    height: 0.0,
                    color: const Color(0xFFC4BDDB),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/models.dart';
import 'nova_squircle_avatar.dart';

/// мини карточка проекта для отображения в других виджетах
class ProjectMiniCard extends StatelessWidget {
  final Project _project;
  final bool showUpperDivider;
  final bool showLowerDivider;
  final VoidCallback onTap;

  ProjectMiniCard(
    this._project, {
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
            const SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                NovaSquircleAvatar(
                  size: 80.0,
                  image: _project.projectPic.isEmpty ||
                          !_project.projectPic.startsWith('http')
                      ? AssetImage('assets/project.png')
                      : NetworkImage(_project.projectPic),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _project.title,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: const Color(0xFF533781)),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        _project.description,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(color: const Color(0xFF9786BC)),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.favorite,
                            color: const Color(0xFFFF9595),
                            size: 16.0,
                          ),
                          Text(
                            _project.likes.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(color: const Color(0xFFFF9595)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
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

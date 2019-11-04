import 'package:flutter/material.dart';

import '../models/models.dart';
import 'nova_chip.dart';
import 'nova_squircle_avatar.dart';

/// карточка проекта
class ProjectCard extends StatelessWidget {
  final Project _project;
  final VoidCallback onTap;

  ProjectCard(
    this._project, {
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Material(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                NovaSquircleAvatar(
                  image: _project.projectPic.isEmpty ||
                          !_project.projectPic.startsWith('http')
                      ? AssetImage('assets/project.png')
                      : NetworkImage(_project.projectPic),
                ),
                const SizedBox(width: 16.0),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _project.title,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle
                                  .copyWith(color: const Color(0xFF533781)),
                            ),
                          ),
                          // Spacer(),
                          Text(
                            _project.likes.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(color: const Color(0xFF9786BC)),
                          ),
                          SizedBox(width: 5.5),
                          Icon(
                            Icons.favorite_border,
                            color: const Color(0xFF9786BC),
                            size: 14.0,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _project.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(color: const Color(0xFF533781)),
                      ),
                      const SizedBox(height: 10.0),
                      Wrap(
                        spacing: 4.0,
                        runSpacing: 4.0,
                        children: _project.tags
                            .split(',')
                            .map((tag) => NovaChip(label: tag))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

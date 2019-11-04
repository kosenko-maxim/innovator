import 'package:flutter/material.dart';

import '../models/models.dart';
import 'nova_chip.dart';
import 'nova_squircle_avatar.dart';

/// карточка вакансии
class VacancyCard extends StatelessWidget {
  final Vacancy _vacancy;
  final VoidCallback onTap;

  VacancyCard(
    this._vacancy, {
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Material(
        color: const Color(0xFFFFFFFF),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                NovaSquircleAvatar(
                  size: 40.0,
                  image: _vacancy.project.projectPic.isEmpty ||
                          !_vacancy.project.projectPic.startsWith('http')
                      ? AssetImage('assets/project.png')
                      : NetworkImage(_vacancy.project.projectPic),
                ),
                const SizedBox(width: 16.0),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _vacancy.title,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: const Color(0xFF533781)),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        _vacancy.project.title,
                        style: Theme.of(context).textTheme.body1,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        _vacancy.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(color: const Color(0xFF533781)),
                      ),
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 4.0,
                        runSpacing: 4.0,
                        children: _vacancy.skills
                            .replaceAll(RegExp(r"[\'\[\]]"), '')
                            .split(',')
                            .map((skill) => NovaChip(label: skill))
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

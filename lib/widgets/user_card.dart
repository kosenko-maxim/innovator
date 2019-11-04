import 'package:flutter/material.dart';

import '../models/models.dart';
import 'nova_chip.dart';
import 'nova_circle_avatar.dart';
import '../misc/misc.dart';

/// карточка пользователя
class UserCard extends StatelessWidget {
  final User _user;
  final VoidCallback onTap;

  UserCard(
    this._user, {
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
                Column(
                  children: <Widget>[
                    NovaCircleAvatar(
                      radius: 80.0,
                      image: _user.profilePic == null
                          ? AssetImage('assets/user.png')
                          : NetworkImage(_user.profilePic),
                    ),
                    if (_user.isExpert) ...[
                      const SizedBox(height: 8.0),
                      IntrinsicWidth(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          constraints: BoxConstraints(
                            minHeight: 21.0,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF513577),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Center(
                            child: Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.star,
                                  size: 16.0,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  'Эксперт',
                                  style: Theme.of(context)
                                      .textTheme
                                      .body2
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
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
                              '${_user.firstname} ${_user.lastname}',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle
                                  .copyWith(color: const Color(0xFF533781)),
                            ),
                          ),
                          // Spacer(),
                          Text(
                            _user.likes.toString(),
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
                        'Новый пользователь',
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
                        children: _user.skills
                            // .replaceAll(RegExp(r"[\'\[\]\s]"), '')
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

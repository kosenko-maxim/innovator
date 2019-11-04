import 'package:flutter/material.dart';

import '../models/models.dart';
import 'nova_circle_avatar.dart';

/// мини карточка пользователя для отображения в других виджетах
class UserMiniCard extends StatelessWidget {
  final User _user;
  final bool showUpperDivider;
  final bool showLowerDivider;
  final VoidCallback onTap;

  const UserMiniCard(
    this._user, {
    Key key,
    this.showUpperDivider: true,
    this.showLowerDivider: false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(25.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25.0),
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
              children: <Widget>[
                NovaCircleAvatar(
                  image: _user.profilePic == null ||
                          _user.profilePic.isEmpty ||
                          !_user.profilePic.startsWith('http')
                      ? AssetImage('assets/user.png')
                      : NetworkImage(_user.profilePic),
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${_user.firstname} ${_user.lastname}',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(color: const Color(0xFF533781)),
                    ),
                    const SizedBox(height: 7.0),
                    Text(
                      'технический специалист',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(color: const Color(0xFF9786BC)),
                    ),
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

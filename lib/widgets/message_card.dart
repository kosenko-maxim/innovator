import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'nova_circle_avatar.dart';
import '../models/message.dart';

/// карточка сообщения на экране Сообщения
class MessageCard extends StatelessWidget {
  final Message message;
  final VoidCallback onTap;

  MessageCard({
    Key key,
    this.onTap,
    this.message,
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
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 13.0,
              bottom: 17.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    DateFormat('d MMMM').format(
                      DateTime.parse(message.timestamp),
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(color: const Color(0xFF9786BC))),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    NovaCircleAvatar(
                      radius: 60.0,
                      image: message.sender.profilePic==null||message.sender.profilePic.isEmpty
                          ? AssetImage('assets/user.png')
                          : NetworkImage(message.sender.profilePic),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              '${message.sender.firstname} ${message.sender.lastname}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle
                                  .copyWith(color: const Color(0xFF533781))),
                          const SizedBox(height: 4.0),
                          const SizedBox(height: 4.0),
                          Text(message.message,
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(color: const Color(0xFF533781))),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                            DateFormat('H:mm').format(
                              DateTime.parse(message.timestamp),
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(color: const Color(0xFF9786BC))),
                        const SizedBox(height: 22.0),
                        // Container(
                        //   width: 24.0,
                        //   height: 21.0,
                        //   decoration: BoxDecoration(
                        //     color: const Color(0xFF80469B),
                        //     borderRadius: BorderRadius.circular(120.0),
                        //   ),
                        //   child: Center(
                        //     child: Text(
                        //       '1',
                        //       style: TextStyle(
                        //         fontFamily: 'Ubuntu',
                        //         fontSize: 14.0,
                        //         fontWeight: FontWeight.w700,
                        //         color: const Color(0xFFFFFFFF),
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

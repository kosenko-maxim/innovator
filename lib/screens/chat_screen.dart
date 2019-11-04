import 'package:flutter/material.dart';

import '../blocs/blocs.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import '../misc/misc.dart';

/// экран Сообщения
class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key key,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _bloc = MessagesBloc();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 32.0),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 21.0, right: 24.0),
          child: Row(
            children: <Widget>[
              SizedBox(width: 8.0),
              Text(
                'Сообщения',
                style: Theme.of(context)
                    .textTheme
                    .display4
                    .copyWith(color: const Color(0xFFFFFFFF)),
              ),
              Spacer(),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        Flexible(
          child: StreamBuilder<List<Message>>(
            stream: _bloc.messagesObservable,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.isNotEmpty) {
                  final messages = snapshot.data;
                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (!(notification is ScrollEndNotification))
                        return false;
                      final metrics = notification.metrics;
                      if (metrics.pixels > metrics.maxScrollExtent - 220.0) {
                        // _bloc.loadMore();
                      }
                      return true;
                    },
                    child: RefreshIndicator(
                      onRefresh: _bloc.refresh,
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder<User>(
                            stream: _bloc.userObservable,
                            builder: (context, snapshot) {
                              return MessageCard(
                                message: messages[index],
                                onTap: () => _openDialogue(
                                  context,
                                  messages[index].receiver == snapshot.data
                                      ? messages[index].sender
                                      : messages[index].receiver,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: _bloc.refresh,
                    child: ListView(
                      physics: AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${snapshot.error}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              }
              return Center(
                child: NovaProgressIndicator(),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openDialogue(BuildContext context, User receiver) {
    showDialogueBottomSheet(
      context: context,
//      initialHeight: 0.85,
      builder: (context) {
        return Dialogue(
          receiver: receiver,
        );
      },
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

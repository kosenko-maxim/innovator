import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../blocs/blocs.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

/// виджет диалога с другим пользователем
class Dialogue extends StatefulWidget {
  final TabController tabController;
  final User receiver;
  final String projectName;

  const Dialogue({this.tabController, this.receiver, this.projectName});

  @override
  _DialogueState createState() => _DialogueState(receiver);
}

class _DialogueState extends State<Dialogue> {
  final DialogueBloc _bloc;
  final _controller = TextEditingController();

  _DialogueState(User receiver) : _bloc = DialogueBloc(receiver: receiver);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 300),
      child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.8,
          builder: (context, controller) {
            return Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 24.0,
                right: 24.0,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              child: Material(
                color: const Color(0xFFFFFFFF),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(bottom: 7.0),
                      child: Center(
                        child: widget.tabController == null
                            ? Container(
                                height: 3.0,
                                width: 54.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF9786BC),
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                              )
                            : NovaPageSelector(
                                controller: widget.tabController,
                                selectedColor: const Color(0xFF533781),
                                color: const Color(0x66533781),
                                indicatorSize: 7.0,
                              ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        NovaCircleAvatar(
                          radius: 42.0,
                          image: widget.receiver.profilePic == null ||
                                  widget.receiver.profilePic.isEmpty
                              ? AssetImage('assets/user.png')
                              : NetworkImage(widget.receiver.profilePic),
                        ),
                        const SizedBox(width: 13.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${widget.receiver.firstname} ${widget.receiver.lastname}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle
                                  .copyWith(color: const Color(0xFF533781)),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              widget.projectName ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(color: const Color(0xFF9786BC)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Divider(height: 0.0),
                    const SizedBox(height: 8.0),
                    StreamBuilder<List<Message>>(
                      stream: _bloc.messageObservable,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              reverse: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (_, index) {
                                final msg = snapshot.data[index];
                                if (msg == snapshot.data.last) {
                                  return Column(
                                    children: <Widget>[
                                      Text(
                                        DateFormat('d MMMM').format(
                                          DateTime.parse(msg.timestamp),
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .body1
                                            .copyWith(
                                              color: const Color(0xFF9786BC),
                                            ),
                                      ),
                                      msg.receiver != widget.receiver
                                          ? _AnswerBubble(message: msg)
                                          : _MessageBubble(message: msg),
                                    ],
                                  );
                                }
                                return msg.sender == widget.receiver &&
                                        msg.receiver != widget.receiver
                                    ? _AnswerBubble(message: msg)
                                    : _MessageBubble(message: msg);
                              },
                            ),
                          );
                        } else if (snapshot.hasError) {
                          print(snapshot.error);
                          // WidgetsBinding.instance.addPostFrameCallback((_) {
                          //   Scaffold.of(context).showSnackBar(
                          //     SnackBar(
                          //       content: Text('${snapshot.error}'),
                          //       backgroundColor: Colors.red,
                          //     ),
                          //   );
                          // });
                        }
                        return Spacer();
                      },
                    ),
                    Divider(height: 0.0),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            minLines: 3,
                            maxLines: 5,
                            controller: _controller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            if (_controller.text.isEmpty) return;
                            _bloc.add(_controller.text);
                            _controller.clear();
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class _AnswerBubble extends StatelessWidget {
  final Message message;

  const _AnswerBubble({Key key, this.message});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(message.timestamp);
    final format = DateFormat('H:mm').format;
    return Align(
      alignment: Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Container(
          constraints: BoxConstraints(
            minWidth: 0.0,
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color(0x26FF9595),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  message.message,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: const Color(0xFF533781)),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  format(date),
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(color: const Color(0xFF9786BC)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;

  const _MessageBubble({Key key, this.message});
  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(message.timestamp);
    final format = DateFormat('HH:mm').format;
    return Align(
      alignment: Alignment.centerRight,
      child: IntrinsicWidth(
        child: Container(
          constraints: BoxConstraints(
            minWidth: 0.0,
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color(0x26C4BDDB),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
              bottomLeft: Radius.circular(16.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  message.message,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: const Color(0xFF533781)),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  format(date),
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(color: const Color(0xFF9786BC)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

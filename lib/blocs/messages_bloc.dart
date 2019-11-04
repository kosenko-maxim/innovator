import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import 'bloc_base.dart';
import '../data_layer/data_layer.dart';
import '../models/models.dart';

class MessagesBloc implements BlocBase {
  final _client = http.Client();
  final _messagesRepository = MessageRepository();
  final _usersRepository = UsersRepository();

//ignore: close_sinks
  final _messagesSubject = BehaviorSubject<List<String>>();

  List<StreamSubscription> _subscriptions;
  List<Subject> _subjects;

  User _currentUser;

  Observable<User> get userObservable => Observable.just(_currentUser);

  Observable<List<Message>> get messagesObservable =>
      _messagesSubject.transform(
        StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            sink.add(
              Map.fromEntries(
                (data
                        .map((msg) => utf8.decode(base64.decode(msg)))
                        .map((msg) => Message.fromJson(msg))
                        .toList()
                          ..sort((a, b) => DateTime.parse(a.timestamp)
                              .compareTo(DateTime.parse(b.timestamp))))
                    .map(
                  (msg) {
                    return MapEntry(
                      ([msg.receiver.id, msg.sender.id]..sort()).toString(),
                      msg,
                    );
                  },
                ),
              ).values.toList(),
            );
          },
        ),
      );

  MessagesBloc() {
    _subjects = [_messagesSubject];
    _subscriptions = [];
    _init();
  }

  void _init() async {
    _currentUser = await _usersRepository.getCurrent(client: _client);
    await _fetch();
  }

  Future<void> refresh() => _fetch();

  void loadMore() {}

  Future<void> _fetch() async {
    final messages = await _messagesRepository.get(
      client: _client,
      participants: [_currentUser.id],
    );
    _messagesSubject.add(messages);
  }

  @override
  void dispose() async {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    for (var subject in _subjects) {
      await subject.drain();
      subject.close();
    }
    _client.close();
  }
}

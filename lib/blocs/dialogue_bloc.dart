import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:web_socket_channel/io.dart';

import '../data_layer/data_layer.dart';
import '../models/models.dart';
import 'bloc_base.dart';

/// BloC для экрана чата
class DialogueBloc implements BlocBase {
  final _client = http.Client();
  final _messageRepository = MessageRepository();
  final _usersRepository = UsersRepository();
//ignore: close_sinks
  final _messagesSubject = BehaviorSubject<List<String>>();

  final User receiver;
  User _currentUser;

  static const String _address = 'ws://82.146.46.168/ws';

  IOWebSocketChannel _websocket;

  List<StreamSubscription> _subscriptions;
  List<Subject> _subjects;

  /// [Sink] добавляющий в [IOWebSocketChannel]
  Sink get message => _websocket.sink;

  /// [Stream] выводящий информацию из [IOWebSocketChannel]
  Observable<List<Message>> get messageObservable =>
      _messagesSubject.stream.transform(
        StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            sink.add(data
                .map((message) => Message.fromJson(message))
                .where((message) =>
                    (message.receiver == receiver &&
                        message.sender == _currentUser) ||
                    (message.receiver == _currentUser &&
                        message.sender == receiver))
                .toList()
                .reversed
                .toList());
          },
        ),
      );

  DialogueBloc({this.receiver}) {
    _websocket = IOWebSocketChannel.connect(_address);
    _init().then(
      (_) {
        _subjects = [
          _messagesSubject,
        ];
        _subscriptions = [
          _websocket.stream.listen(
            (message) {
              final messages = _messagesSubject.value ?? <String>[];
              messages?.add(message);
              _messagesSubject.add(messages);
              _messageRepository.save(
                client: _client,
                participants: [receiver.id, _currentUser.id],
                message: message,
              );
            },
          ),
        ];
      },
    );
  }

  Future<void> _init() async {
    _currentUser = await _usersRepository.getCurrent(client: _client);
    final messages = await _messageRepository.get(
      client: _client,
      participants: [_currentUser.id, receiver.id]..sort(),
    );
    _messagesSubject.add(
      messages.map((msg) => utf8.decode(base64.decode(msg))).toList(),
    );
  }

  void add(String message) {
    final msg = Message(
      (b) => b
        ..sender = _currentUser.toBuilder()
        ..receiver = receiver.toBuilder()
        ..timestamp = DateTime.now().toIso8601String()
        ..message = message,
    );
    _websocket.sink.add(msg.toJson());
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
    _websocket.sink.close();
  }
}

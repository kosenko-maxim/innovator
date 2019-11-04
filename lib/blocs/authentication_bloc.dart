import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import './bloc_base.dart';
import '../data_layer/data_layer.dart';

/// BloC для [AuthenticationScreen]
///
/// реализует методы авторизации и сброса пароля
class AuthenticationBloc implements BlocBase {
  final _authService = AuthenticationService();
  final _client = http.Client();

//ignore: close_sinks
  final _emailSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _passwordSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _credentialsSubject = BehaviorSubject<Map<String, String>>();

  /// [Sink] для поля электронной почты
  Sink<String> get email => _emailSubject.sink;

  /// [Sink] для поля пароля
  Sink<String> get password => _passwordSubject.sink;

  /// [Observable] для поля электронной почты
  Observable<String> get emailObservable => _emailSubject.stream;

  /// [Observable] для поля пароля
  Observable<String> get passwordObservable => _passwordSubject.stream;

  /// [Observable] объединяющий поля пароля и электронной почты.
  /// Слушается кнопкой для валидации заполнености полей
  Observable<Map<String, String>> get credentialsObservable =>
      _credentialsSubject.stream;

  Observable<Map<String, String>> get _credentials => Observable.combineLatest2(
        emailObservable,
        passwordObservable,
        (String email, String password) {
          return {
            'email': email,
            'password': password,
          };
        },
      );

  List<StreamSubscription> _subscriptions;
  List<Subject> _subjects;

  AuthenticationBloc() {
    _subscriptions = [
      _credentials.listen(_credentialsSubject.add),
    ];
    _subjects = [
      _emailSubject,
      _passwordSubject,
      _credentialsSubject,
    ];
  }

  /// метод авторизующий пользователя
  Future<void> login({Map<String, String> credentials}) async {
    try {
      await _authService.login(
        client: _client,
        email: credentials['email'],
        password: credentials['password'],
      );
    } catch (error) {
      _credentialsSubject.addError(error);
      return Future.error(error);
    }
  }

  /// метод сброса пароля
  Future<void> reset({String email}) async {
    try {
      await _authService.reset(client: _client, email: email);
    } catch (error) {
      return Future.error(error);
    }
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

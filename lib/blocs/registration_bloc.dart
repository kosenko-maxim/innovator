import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../data_layer/data_layer.dart';
import 'bloc_base.dart';

/// BloC для экрана Регистрации
class RegistrationBloc with FieldsValidators implements BlocBase {
  final _authService = AuthenticationService();
  final _imageService = ImageService();
  final _client = http.Client();

//ignore: close_sinks
  final _firstnameSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _lastnameSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _citySubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _skillsSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _emailSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _passwordSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _educationSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _jobsSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _dataSubject = BehaviorSubject<Map<String, String>>();
//ignore: close_sinks
  final _avatarSubject = BehaviorSubject<File>();

  /// [Observable] для поля Имя
  Observable<String> get firstnameObservable => _firstnameSubject.stream;

  /// [Observable] для поля Фамилия
  Observable<String> get lastnameObservable => _lastnameSubject.stream;

  /// [Observable] для полей Город и Страна
  Observable<String> get cityObservable => _citySubject.stream;

  /// [Observable] для поля Навыки
  Observable<String> get skillsObservable => _skillsSubject.stream;

  /// [Observable] для поля электронная почта с валидацией
  Observable<String> get emailObservable => _emailSubject.transform(
        _validateEmail,
      );

  /// [Observable] для поля Пароль
  Observable<String> get passwordObservable => _passwordSubject.stream;

  /// [Observable] для поля Образование
  Observable<String> get educationObservable => _educationSubject.stream;

  /// [Observable] для поля Работа
  Observable<String> get jobsObservable => _jobsSubject.stream;

  /// [Observable] для поля Аватар
  Observable<File> get avatarObservable => _avatarSubject.stream;

  /// [Observable] объединяющий поля в [Map] для отправки в запрос
  Observable<Map<String, String>> get dataObservable => _dataSubject.stream;

  Observable<Map<String, String>> get _data => Observable.combineLatest8(
        firstnameObservable,
        lastnameObservable,
        cityObservable,
        skillsObservable,
        emailObservable,
        passwordObservable,
        educationObservable,
        jobsObservable,
        (
          String firstname,
          String lastname,
          String city,
          String skills,
          String email,
          String password,
          String education,
          String jobs,
        ) {
          final location = city.split(',');
          return <String, String>{
            'first_name': firstname,
            'last_name': lastname,
            'city': location[0],
            'country': location[1],
            'skills': skills,
            'email': email,
            'password': password,
            'jobs': jobs,
            'education': education,
            // 'profile_pic': _avatarSubject.value ?? '',
          };
        },
      );

  /// [Sink] для поля Имя
  Sink<String> get firstname => _firstnameSubject.sink;

  /// [Sink] для поля Фамилия
  Sink<String> get lastname => _lastnameSubject.sink;

  /// [Sink] для поля Город
  Sink<String> get city => _citySubject.sink;

  /// [Sink] для поля Навыки
  Sink<String> get skills => _skillsSubject.sink;

  /// [Sink] для поля электронная почта
  Sink<String> get email => _emailSubject.sink;

  /// [Sink] для поля Пароль
  Sink<String> get password => _passwordSubject.sink;

  /// [Sink] для поля Работа
  Sink<String> get jobs => _jobsSubject.sink;

  /// [Sink] для поля Образование
  Sink<String> get education => _educationSubject.sink;

  /// [Sink] для поля Аватар
  Sink<File> get avatar => _avatarSubject.sink;

  List<StreamSubscription> _subscriptions;
  List<Subject> _subjects;

  RegistrationBloc() {
    _subscriptions = [
      _data.listen(_dataSubject.add),
    ];
    _subjects = [
      _firstnameSubject,
      _lastnameSubject,
      _citySubject,
      _skillsSubject,
      _emailSubject,
      _passwordSubject,
      _educationSubject,
      _jobsSubject,
      _dataSubject,
      _avatarSubject,
    ];
  }

  /// метод регистрации
  Future<void> submit(Map<String, String> data, File image) async {
    try {
      await _authService.register(
        client: _client,
        data: data,
        image: image,
      );
    } catch (error) {
      _dataSubject.addError(error);
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

mixin FieldsValidators {
  final _validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      const _emailRegex = r'(^[a-z0-9_.+-]+@[a-z0-9-]+\.[a-z0-9-.]+$)';
      final regex = RegExp(_emailRegex, caseSensitive: false);
      if (regex.hasMatch(email)) {
        sink.add(email);
      } else {
        sink.addError('Введите корректный e-mail');
      }
    },
  );
}

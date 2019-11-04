import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../data_layer/data_layer.dart';
import 'bloc_base.dart';

/// BloC для сплешскрина
class SplashBloc implements BlocBase {
  final _authService = AuthenticationService();

  /// [Observable] выводящий информацию о состоянии аутентификации пользователя
  Observable<bool> get isAuthenticated =>
      Observable.fromFuture(_authService.isAuthenticated());

  List<StreamSubscription> _subscriptions;

  SplashBloc() {
    _subscriptions = [];
  }

  @override
  void dispose() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
  }
}

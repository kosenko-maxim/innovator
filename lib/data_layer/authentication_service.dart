import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../data_layer/api_provider.dart';

/// сервис аутентификации
class AuthenticationService {
  final _api = ApiProvider();

  /// метод входа
  Future<void> login({
    http.Client client,
    String email,
    String password,
  }) async {
    return await _api.authenticate(
      client: client,
      email: email,
      password: password,
    );
  }

  /// метод регистрации
  Future<void> register({
    http.Client client,
    Map<String, String> data,
    File image,
  }) async {
    return _api.addUser(client: client, data: data, image: image);
  }

  /// метод сброса пароля
  Future<void> reset({
    http.Client client,
    String email,
  }) {
    return _api.resetPassword(client: client, email: email);
  }

  /// метода выхода
  Future<void> logout() async {
    return _api.logout();
  }

  /// метод возвращающий состояние аутентификации
  Future<bool> isAuthenticated() async {
    return _api.isAuthenticated();
  }
}

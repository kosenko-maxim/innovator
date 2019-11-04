import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import 'api_provider.dart';

/// репозиторий для работы с пользователями
class UsersRepository {
  final _api = ApiProvider();

  /// метод добавляющий [User]'а
  void add({http.Client client, Map<String, String> data}) {
    _api.addUser(client: client, data: data);
  }

  /// метод возвращающий лист [User]'ов
  Future<BuiltList<User>> get({
    http.Client client,
    int page,
  }) {
    return _api.getUsers(client: client, page: page);
  }

  /// метод возвращающий [User]'а с id равным [id]
  Future<User> getById({http.Client client, int id}) {
    return _api.getUser(client: client, id: id);
  }

  /// метод возвращающий текущего залогиненого пользователя
  Future<User> getCurrent({http.Client client}) {
    return _api.getCurrentUser(client: client);
  }
}

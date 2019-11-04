import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import 'api_provider.dart';

/// репозиторий для работы с проектами
class ProjectsRepository {
  final _api = ApiProvider();

  /// метод добавления проекта
  Future<void> add({
    http.Client client,
    Map<String, String> data,
  }) {
    return _api.addProject(client: client, data: data);
  }

  /// метод редактирования проекта
  void update({
    http.Client client,
    int id,
    Map<String, String> data,
  }) {
    _api.updateProject(client: client, id: id, data: data);
  }

  /// метод возвращающий лист [Project]'ов созданных [User]'ом с id равным [id]
  Future<BuiltList<Project>> getUsersProjects({http.Client client, int id}) {
    return _api.getUsersProjects(client: client, id: id);
  }

  /// метод увеличивающий колличество лайков у проекта с id равным [projectId]
  Future<void> like({http.Client client, int id}) {
    return _api.likeProject(client: client, projectId: id);
  }

  /// метод возвразающий лист [Project]'ов
  Future<BuiltList<Project>> get({
    http.Client client,
    int offset,
    int quantity,
  }) async {
    return _api.getProjects(
      client: client,
      offset: offset,
      quantity: quantity,
    );
  }

  /// метод возвращающий [Project] с id равным [id]
  Future<Project> getById({http.Client client, int id}) {
    return _api.getProject(client: client, id: id);
  }

  /// метод возвращающий колличество лайков [Project]'а с id равным [id]
  Future<int> getLikes({http.Client client, int id}) {
    return _api.getProjectLikes(client: client, id: id);
  }
}

import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import 'api_provider.dart';

/// репозиторий для работы с дорожной картой
class RoadmapRepository {
  final _api = ApiProvider();

  /// метод возвращающий лист [Chapter]'ов [Roadmap]'а с id равным [id]
  Future<BuiltList<Chapter>> getChapters({http.Client client, int id}) {
    return _api.getChapters(client: client, id: id);
  }

  /// метод добавляющий дорожную карту с названием [title], возвращает id созданной дорожной карты
  Future<int> addRoadmap({http.Client client, String title}) {
    return _api.addRoadmap(client: client, title: title);
  }

  /// метод добавляющий [Chapter] в [Roadmap] с id равным [id]
  Future<void> addChapter({
    http.Client client,
    int id,
    Map<String, String> data,
  }) {
    return _api.addChapter(client: client, id: id, data: data);
  }
}

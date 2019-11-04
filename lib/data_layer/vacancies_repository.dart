import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import 'api_provider.dart';

/// репозиторий для работы с вакансиями
class VacanciesRepository {
  final _api = ApiProvider();

  /// метод добавления вакансии
  void add({
    http.Client client,
    Map<String, String> data,
  }) {
    _api.addVacancy(
      client: client,
      data: data,
    );
  }

  /// метод обновления вакансии с id равным [id]
  void update({
    http.Client client,
    int id,
    String title,
    String description,
    String skills,
  }) {
    _api.updateVacancy(
      client: client,
      id: id,
      title: title,
      description: description,
      skills: skills,
    );
  }

  /// метод возвращающий лист [Vacancy] созданных [User]'ом с id равным [id]
  Future<BuiltList<Vacancy>> getUsersVacancies({http.Client client, int id}) {
    return _api.getUsersVacancies(client: client, id: id);
  }

  /// метод возвращающий лист [Vacancy] относящихся к [Project]'у с id равным [id]
  Future<BuiltList<Vacancy>> getProjectVacancies({http.Client client, int id}) {
    return _api.getProjectVacancies(client: client, id: id);
  }

  /// метод возвращающий лист [Vacancy]
  Future<BuiltList<Vacancy>> get({
    http.Client client,
    int offset,
    int quantity,
  }) {
    return _api.getVacancies(
      client: client,
      offset: offset,
      quantity: quantity,
    );
  }

  /// метод возвращающий [Vacancy] с id равным [id]
  Future<Vacancy> getById({http.Client client, int id}) {
    return _api.getVacancy(client: client, id: id);
  }
}

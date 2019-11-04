import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../data_layer/data_layer.dart';
import '../models/models.dart';
import 'bloc_base.dart';

/// BloC для экрана управления
class ManagementBloc implements BlocBase {
  final _authService = AuthenticationService();
  final _projectsRepository = ProjectsRepository();
  final _vacancyRepository = VacanciesRepository();
  final _userRepository = UsersRepository();
  final _client = http.Client();

//ignore: close_sinks
  final _projectsSubject = BehaviorSubject<BuiltList<Project>>();
//ignore: close_sinks
  final _userSubject = BehaviorSubject<User>();
//ignore: close_sinks
  final _vacancyAdditionSubject = PublishSubject<Vacancy>();
//ignore: close_sinks
  final _vacanciesSubject = BehaviorSubject<BuiltList<Vacancy>>();

  /// [Observable] выводящий проекты текущего пользователя
  Observable<BuiltList<Project>> get projects => _projectsSubject.stream;

  /// [Observable] выводящий вакансии текущего пользователя
  Observable<BuiltList<Vacancy>> get vacancies => _vacanciesSubject.stream;

  /// [Observable] выводящий текущего пользователя
  ValueObservable<User> get user => _userSubject.stream;

  List<StreamSubscription> _subscriptions;
  List<Subject> _subjects;

  ManagementBloc() {
    getUser();
    getVacancies();
    getProjects();
    _subscriptions = [];
    _subjects = [
      _projectsSubject,
      _userSubject,
      _vacancyAdditionSubject,
      _vacanciesSubject,
    ];
  }

  /// метод выхода для текущего пользователя
  void logout() async {
    await _authService.logout();
  }

  /// метод обновляющий текущего пользователя
  void getUser() async {
    try {
      final user = await _userRepository.getCurrent(client: _client);
      _userSubject.add(user);
    } catch (error) {
      _userSubject.addError(error);
    }
  }

  /// метод обновляющий вакансии текущего пользователя
  void getVacancies() async {
    try {
      final user = await _userRepository.getCurrent(client: _client);
      final vacancies = await _vacancyRepository.getUsersVacancies(
        client: _client,
        id: user.id,
      );
      _vacanciesSubject.add(vacancies);
    } catch (error) {
      _vacanciesSubject.addError(error);
    }
  }

  /// метод обновляющий проекты текущего пользователя
  void getProjects() async {
    try {
      final user = await _userRepository.getCurrent(client: _client);
      final projects = await _projectsRepository.getUsersProjects(
        client: _client,
        id: user.id,
      );
      _projectsSubject.add(projects);
    } catch (error) {
      _projectsSubject.addError(error);
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

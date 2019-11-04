import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import '../data_layer/data_layer.dart';
import '../models/models.dart';
import 'bloc_base.dart';

/// BloC для экрана деталей проекта
class ProjectDetailsBloc implements BlocBase {
  final _vacanciesRepository = VacanciesRepository();
  final _projectRepository = ProjectsRepository();
  final _roadmapRepository = RoadmapRepository();
  final _usersRepository = UsersRepository();
  final _client = http.Client();

//ignore: close_sinks
  final _vacanciesSubject = BehaviorSubject<BuiltList<Vacancy>>();
//ignore: close_sinks
  final _likeSubject = BehaviorSubject<int>();
//ignore: close_sinks
  final _likesSubject = BehaviorSubject<int>();
//ignore: close_sinks
  final _roadmapSubject = BehaviorSubject<BuiltList<Chapter>>();
//ignore: close_sinks
  final _canEditSubject = BehaviorSubject<bool>();
//ignore: close_sinks
  final _teamSubject = BehaviorSubject<List<User>>();

  /// [Observable] выводящий лист [User]'ов, которые являются участниками проекта
  ValueObservable<List<User>> get team => _teamSubject.stream;

  /// [Observable] выводящий лист [Vacancy] проекта
  ValueObservable<BuiltList<Vacancy>> get vacancies => _vacanciesSubject.stream;

  /// [Observable] выводящий колличество лайков
  ValueObservable<int> get likes => _likesSubject.stream;

  /// [Observable] выводящий дорожную карту
  ValueObservable<BuiltList<Chapter>> get roadmap => _roadmapSubject.stream;

  /// [Observable] выводящий информацию о возможности редактирования проекта
  Observable<bool> get canEdit => _canEditSubject.stream;
  Observable<List<User>> get teamObservable => _teamSubject.stream;
  Observable<User> userObservable;

  Sink<int> get like => _likeSubject.sink;

  List<StreamSubscription> _subscriptions;
  List<Subject> _subjects;

  ProjectDetailsBloc(Project project) {
    userObservable = Observable.fromFuture(
      _usersRepository.getById(
        id: project.creatorId,
        client: _client,
      ),
    );
    getVacanvies(project.id);
    getRoadmap(project.roadmap.id);
    if (project.projectTeam.isNotEmpty) {
      _getTeam(
          project.projectTeam.split(',').map((id) => int.parse(id)).toList());
    }
    _usersRepository
        .getCurrent(client: _client)
        .then((user) => _canEditSubject.add(user.id == project.creatorId));
    _subscriptions = [
      _likeSubject.listen(_handleLike),
      // _usersRepository
      //     .getByIds(project.team?.toList())
      //     .listen(_teamSubject.add),
      // _investmentsRepository
      //     .getByIds(project.investments?.toList())
      //     .listen(_investmentsSubject.add),
      // _goalsRepository
      //     .getByIds(project.roadmap?.toList())
      //     .listen(_roadmapSubject.add),
      // _vacanciesRepository
      //     .getByIds(project.vacancy?.toList())
      //     .listen(_vacanciesSubject.add),
    ];
    _subjects = [
      _teamSubject,
      _vacanciesSubject,
      _likesSubject,
      _likeSubject,
      _roadmapSubject,
      _canEditSubject,
      _teamSubject,
    ];
  }

  void _getTeam(List<int> ids) async {
    final futures = ids.map(
      (id) => _usersRepository.getById(
        id: id,
        client: _client,
      ),
    );
    final users = await Future.wait(futures);
    _teamSubject.add(users);
  }

  /// метод обновляющий дорожную карту
  void getRoadmap(int id) async {
    final chapters = await _roadmapRepository.getChapters(
      client: _client,
      id: id,
    );
    _roadmapSubject.add(chapters);
  }

  /// метод обновляющий вакансии
  void getVacanvies(int id) async {
    final vacancies = await _vacanciesRepository.getProjectVacancies(
      client: _client,
      id: id,
    );
    _vacanciesSubject.add(vacancies);
  }

  void _handleLike(int id) async {
    await _projectRepository.like(client: _client, id: id);
    final likes = await _projectRepository.getLikes(client: _client, id: id);
    _likesSubject.add(likes);
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

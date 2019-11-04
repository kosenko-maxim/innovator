import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import './blocs.dart';
import '../data_layer/data_layer.dart';
import '../models/models.dart';

/// BloC для экрана деталей пользователя
class UserDetailsBloc implements BlocBase {
  final _projectsRepository = ProjectsRepository();
  final _usersRepository = UsersRepository();
  final _client = http.Client();

//ignore: close_sinks
  final _createdProjectsSubject = BehaviorSubject<BuiltList<Project>>();
//ignore: close_sinks
  final _projectsMemberSubject = BehaviorSubject<BuiltList<Project>>();
//ignore: close_sinks
  final _teamSubject = BehaviorSubject<List<User>>();

  /// [Observable] выводящий лист [Project]'ов созданных пользователем
  Observable<BuiltList<Project>> get createdProjects =>
      _createdProjectsSubject.stream;

  /// [Observable] выводящий лист [Project]'ов в которых пользователь является участником
  Observable<BuiltList<Project>> get projectsMember =>
      _projectsMemberSubject.stream;
  Observable<User> get userObservable =>
      Observable.fromFuture(_usersRepository.getCurrent(client: _client));
  Observable<List<User>> get teamObservable => _teamSubject.stream;

  List<StreamSubscription> _subscriptions;
  List<Subject> _subjects;

  UserDetailsBloc(User user) {
    getCreatedProjects(user.id);
    _subscriptions = [];
    _subjects = [
      _createdProjectsSubject,
      _projectsMemberSubject,
      _teamSubject,
    ];
  }

  /// метод обновления проектов созданных пользователем
  void getCreatedProjects(int id) async {
    final projects = await _projectsRepository.getUsersProjects(
      client: _client,
      id: id,
    );
    _createdProjectsSubject.add(projects);
  }

  void _getTeam(List<int> ids) async {
    final futures = ids.map(
      (id) => _usersRepository.getById(
        id: id,
        client: _client,
      ),
    );
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

import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../data_layer/data_layer.dart';
import '../models/models.dart';
import 'bloc_base.dart';

class VacancyCreationBloc implements BlocBase {
  final _projectsRepository = ProjectsRepository();
  final _vacanciesRepository = VacanciesRepository();
  final _usersRepository = UsersRepository();
  final _client = http.Client();

//ignore: close_sinks
  final _titleSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _descriptionSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _skillsSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _dataSubject = BehaviorSubject<Map<String, String>>();
//ignore: close_sinks
  final _usersProjectsSubject = BehaviorSubject<BuiltList<Project>>();
//ignore: close_sinks
  final _projectIdSubject = BehaviorSubject<int>();

  Observable<String> get titleObservable => _titleSubject.stream;
  Observable<String> get descriptionObservable => _descriptionSubject.stream;
  Observable<String> get skillsObservable => _skillsSubject.stream;
  Observable<Map<String, String>> get dataObservable => _dataSubject.stream;
  Observable<BuiltList<Project>> get usersProjectsObservable =>
      _usersProjectsSubject.stream;

  Sink<String> get title => _titleSubject.sink;
  Sink<String> get description => _descriptionSubject.sink;
  Sink<String> get skills => _skillsSubject.sink;
  Sink<int> get projectId => _projectIdSubject.sink;

  Observable<Map<String, String>> get _data => Observable.combineLatest4(
        _projectIdSubject,
        _titleSubject,
        _descriptionSubject,
        _skillsSubject,
        (
          int id,
          String title,
          String description,
          String skills,
        ) {
          return <String, String>{
            'id': id.toString(),
            'title': title,
            'description': description,
            'skills': skills,
          };
        },
      );

  List<StreamSubscription> _subscriptions;
  List<Subject> _subjects;

  VacancyCreationBloc() {
    _subscriptions = [
      _data.listen(_dataSubject.add),
    ];
    _subjects = [
      _titleSubject,
      _descriptionSubject,
      _skillsSubject,
      _dataSubject,
      _usersProjectsSubject,
      _projectIdSubject,
    ];
    int userId;
    _usersRepository.getCurrent(client: _client).then((user) {
      userId = user.id;
      _projectsRepository
          .getUsersProjects(client: _client, id: userId)
          .then(_usersProjectsSubject.add);
    });
  }

  Future<void> create({Map<String, String> data}) async {
    try {
      return _vacanciesRepository.add(client: _client, data: data);
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

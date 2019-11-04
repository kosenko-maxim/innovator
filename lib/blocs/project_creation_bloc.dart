import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../data_layer/data_layer.dart';
import '../models/models.dart';
import 'bloc_base.dart';

/// BloC для экрана создания проекта
class ProjectCreationBloc implements BlocBase {
  final _roadmapRepository = RoadmapRepository();
  final _projectsRepository = ProjectsRepository();
  final _imageService = ImageService();
  final _usersRepository = UsersRepository();
  final _client = http.Client();

//ignore: close_sinks
  final _titleSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _descriptionSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _audienceSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _infoSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _investorsSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _roadmapSubject = BehaviorSubject<List<Map<String, String>>>();
//ignore: close_sinks
  final _dataSubject = BehaviorSubject<Map<String, String>>();
//ignore: close_sinks
  final _roadmapAdditionSubject = BehaviorSubject<Map<String, String>>();
//ignore: close_sinks
  final _avatarSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _tagsSubject = BehaviorSubject<String>();
//ignore: close_sinks
  final _avatarAdditionSubject = PublishSubject<File>();
//ignore: close_sinks
  final _participantsSubject = BehaviorSubject<List<int>>.seeded([]);
//ignore: close_sinks
  final _participantAdditionSubject = BehaviorSubject<int>();
//ignore: close_sinks
  final _searchSubject = BehaviorSubject<String>.seeded('');

  /// [Observable] для поля названия
  Observable<String> get titleObservable => _titleSubject.stream;

  /// [Observable] для поля описания
  Observable<String> get descriptionObservable => _descriptionSubject.stream;

  /// [Observable] для поля целевой аудитории
  Observable<String> get audienceObservable => _audienceSubject.stream;

  /// [Observable] для поля дополнительной информации
  Observable<String> get infoObservable => _infoSubject.stream;

  /// [Observable] для поля инвесторов
  Observable<String> get investorsObservable => _investorsSubject.stream;

  /// [Observable] для поля дорожной карты
  ValueObservable<List<Map<String, String>>> get roadmapObservable =>
      _roadmapSubject.stream;

  /// [Observable] объединяющий поля в [Map] для отправки в запрос
  Observable<Map<String, String>> get dataObservable => _dataSubject.stream;

  /// [Observable] для поля аватара
  Observable<String> get avatarObservable => _avatarSubject.stream;
  Observable<String> get tagsObservable => _tagsSubject.stream;
  Observable<List<User>> get _users =>
      Observable.fromFuture(_usersRepository.get(client: _client))
          .map((users) => users.toList());
  Observable<List<User>> get searchObservable => _searchSubject.transform(
        FlatMapStreamTransformer(
          (query) {
            if (query.isEmpty || query == null) return _users;
            return _users.map(
              (users) {
                return users
                    .where((user) =>
                        '${user.firstname} ${user.lastname}'.contains(query))
                    .toList();
              },
            );
          },
        ),
      );
  Observable<List<User>> get participantsObservable =>
      _participantsSubject.asyncMap(
        (ids) async {
          final futures = ids.map(
            (id) => _usersRepository.getById(
              id: id,
              client: _client,
            ),
          );
          final users = await Future.wait(futures);
          return users;
        },
      )..listen(print);

  Sink<String> get search => _searchSubject.sink;

  /// [Sink] для поля названия
  Sink<String> get title => _titleSubject.sink;

  /// [Sink] для поля описания
  Sink<String> get description => _descriptionSubject.sink;

  /// [Sink] для поля целевой аудитории
  Sink<String> get audience => _audienceSubject.sink;

  /// [Sink] для поля дополнительной информации
  Sink<String> get info => _infoSubject.sink;

  /// [Sink] для поля инвесторов
  Sink<String> get investors => _investorsSubject.sink;

  /// [Sink] для поля дорожной карты
  Sink<List<Map<String, String>>> get roadmap => _roadmapSubject.sink;

  /// [Sink] для добавления этапов в дорожную карту
  Sink<Map<String, String>> get roadmapAddition => _roadmapAdditionSubject.sink;

  /// [Sink] для поля аватара
  Sink<File> get avatar => _avatarAdditionSubject.sink;
  Sink<String> get tags => _tagsSubject.sink;
  Sink<int> get participant => _participantAdditionSubject.sink;

  Observable<Map<String, String>> get _data => Observable.combineLatest7(
        _titleSubject,
        _descriptionSubject,
        _audienceSubject,
        _infoSubject,
        _investorsSubject,
        _tagsSubject,
        _participantsSubject,
        (
          String title,
          String description,
          String audience,
          String info,
          String investors,
          String tags,
          List<int> participants,
        ) {
          return <String, String>{
            'title': title,
            'description': description,
            'target_audience': audience,
            'additional_info': info,
            'investors': investors,
            'project_pic': _avatarSubject.value ?? '',
            'is_published': 'False',
            'tags': tags,
            'project_team': participants.join(','),
          };
        },
      );

  List<StreamSubscription> _subscriptions;
  List<Subject> _subjects;

  ProjectCreationBloc() {
    _subscriptions = [
      _data.listen(_dataSubject.add),
      _roadmapAdditionSubject.listen(_handleRoadmapAddition),
      _avatarAdditionSubject.listen(_handleAvatarAddition),
      _participantAdditionSubject.listen(_handleParticipantAddition),
    ];
    _subjects = [
      _titleSubject,
      _descriptionSubject,
      _audienceSubject,
      _infoSubject,
      _investorsSubject,
      _roadmapSubject,
      _dataSubject,
      _roadmapAdditionSubject,
      _avatarSubject,
      _avatarAdditionSubject,
      _searchSubject,
      _participantsSubject,
      _participantAdditionSubject,
      _tagsSubject,
    ];
  }

  void _handleParticipantAddition(int participant) {
    final participants = _participantsSubject.value;
    participants.contains(participant)
        ? participants.remove(participant)
        : participants.add(participant);
    _participantsSubject.add(participants);
  }

  void _handleAvatarAddition(File image) async {
    final url = await _imageService.addImage(client: _client, image: image);
    _avatarSubject.add(url);
  }

  void _handleRoadmapAddition(Map<String, String> data) {
    final roadmap = roadmapObservable.value;
    if (roadmap == null) {
      _roadmapSubject.add([data]);
    } else {
      roadmap.add(data);
      _roadmapSubject.add(roadmap);
    }
  }

  /// метод создания проекта
  Future<void> create({Map<String, String> data}) async {
    try {
      final roadmapId = await _roadmapRepository.addRoadmap(
        client: _client,
        title: data['title'],
      );
      final futures = _roadmapSubject.value.map((data) {
        return _roadmapRepository.addChapter(
          id: roadmapId,
          data: data,
          client: _client,
        );
      });
      await Future.wait(futures);
      data.addAll({'roadmap': roadmapId.toString()});
      return _projectsRepository.add(client: _client, data: data);
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

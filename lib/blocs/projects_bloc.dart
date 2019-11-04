import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/transformers.dart';

import '../data_layer/data_layer.dart';
import '../misc/misc.dart';
import '../models/models.dart';
import 'bloc_base.dart';

/// BloC для экрана Проекты
class ProjectsBloc implements BlocBase {
  final _repository = ProjectsRepository();
  final _client = http.Client();

//ignore: close_sinks
  final _projectsSubject = BehaviorSubject<BuiltList<Project>>();
//ignore: close_sinks
  final _filterSubject = BehaviorSubject<Filter>();
//ignore: close_sinks
  final _searchSubject = BehaviorSubject<String>.seeded('');
//ignore: close_sinks
  final _tagsSubject = BehaviorSubject<List<String>>.seeded([]);

  Observable<List<Project>> get _tagSearch => _tagsSubject.transform(
        FlatMapStreamTransformer(
          (tags) {
            if (tags.isEmpty || tags == null)
              return projects.map((projects) => projects.toList());
            return projects.map(
              (projects) {
                return projects
                    .where((project) => project.tags
                        .split(',')
                        .any((tag) => tags.contains(tag)))
                    .toList();
              },
            );
          },
        ),
      );

  /// [Observable] выводящий лист [Project]'ов удовлетворяющих поисковому запросу
  Observable<List<Project>> get searchObservable => _searchSubject.transform(
        FlatMapStreamTransformer(
          (query) {
            if (query.isEmpty || query == null) return _tagSearch;
            return _tagSearch.map(
              (projects) {
                return projects
                    .where((project) => project.title.contains(query))
                    .toList();
              },
            );
          },
        ),
      );

  /// [Observable] выводящий лист [Project]'ов отсортированных текущим фильтром
  Observable<BuiltList<Project>> get projects =>
      _filterSubject.shareValueSeeded(Filter.name).transform(
        FlatMapStreamTransformer(
          (value) {
            switch (value) {
              case Filter.date:
                break;
              case Filter.name:
                return _projectsSubject.transform(_nameSort);
                break;
              case Filter.rating:
                return _projectsSubject.transform(_ratingSort);
                break;
            }
            return _projectsSubject.transform(_nameSort);
          },
        ),
      );

  /// [Sink] для добавления поискового запроса
  Sink<String> get search => _searchSubject.sink;

  /// [Sink] для добавления текущего фильтра
  Sink<Filter> get filter => _filterSubject.sink;
  Sink<List<String>> get tags => _tagsSubject.sink;

  List<StreamSubscription> _subscriptions;
  List<Subject> _subjects;

  int _offset = 0;
  int _quantity = 10;

  ProjectsBloc() {
    _fetch();
    _subscriptions = [];
    _subjects = [
      _projectsSubject,
      _filterSubject,
      _searchSubject,
      _tagsSubject,
    ];
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

  /// метод обновляющий лист текущих [Project]'ов
  Future<void> refresh() {
    return _fetch();
  }

  /// метод догружающий [Project]'ов
  void loadMore() async {
    if (!_projectsSubject.hasValue || _offset == null) return;
    print(_offset);
    final peoples = _projectsSubject.value;
    final fetched = await _repository.get(
      client: _client,
      offset: _offset,
      quantity: _quantity,
    );
    final p = peoples.rebuild((users) => users.addAll(fetched));
    _offset = fetched.length < _quantity ? null : p.length;
    _projectsSubject.add(p);
  }

  Future<void> _fetch() async {
    final peoples = await _repository.get(
      client: _client,
      offset: 0,
      quantity: _quantity,
    );
    _offset = peoples.length;
    _projectsSubject.add(peoples);
  }

  static final _nameSort =
      StreamTransformer<BuiltList<Project>, BuiltList<Project>>.fromHandlers(
    handleData: (projects, sink) {
      sink.add(
        projects.rebuild((p) => p.sort((a, b) => a.title.compareTo(b.title))),
      );
    },
  );

  static final _ratingSort =
      StreamTransformer<BuiltList<Project>, BuiltList<Project>>.fromHandlers(
    handleData: (projects, sink) {
      sink.add(
        projects.rebuild((p) => p.sort((a, b) => b.likes.compareTo(a.likes))),
      );
    },
  );
}

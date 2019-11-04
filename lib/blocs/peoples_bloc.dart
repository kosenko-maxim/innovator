import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../data_layer/data_layer.dart';
import '../misc/misc.dart';
import '../models/models.dart';
import 'bloc_base.dart';

/// BloC для экрана Люди
class PeoplesBloc implements BlocBase {
  final _repository = UsersRepository();
  final _client = http.Client();

//ignore: close_sinks
  final _usersSubject = BehaviorSubject<BuiltList<User>>();
//ignore: close_sinks
  final _searchSubject = BehaviorSubject<String>.seeded('');
//ignore: close_sinks
  final _tagsSubject = BehaviorSubject<List<String>>.seeded([]);
//ignore: close_sinks
  final _filterSubject = PublishSubject<Filter>();

  int _currentPage = 0;
  Observable<List<User>> get _tagSearch => _tagsSubject.transform(
        FlatMapStreamTransformer(
          (tags) {
            if (tags.isEmpty || tags == null)
              return users.map((users) => users.toList());
            return users.map(
              (users) {
                return users
                    .where((user) =>
                        user.skills.split(',').any((tag) => tags.contains(tag)))
                    .toList();
              },
            );
          },
        ),
      );

  /// [Observable] выводящий лист [User]'ов удовлетворяющих поисковому запросу
  Observable<List<User>> get searchObservable => _searchSubject.transform(
        FlatMapStreamTransformer(
          (query) {
            if (query.isEmpty || query == null) return _tagSearch;
            return _tagSearch.map(
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

  /// [Observable] выводящий лист [User]'ов отсортированных текущим фильтром
  Observable<BuiltList<User>> get users =>
      _filterSubject.shareValueSeeded(Filter.name).transform(
        FlatMapStreamTransformer(
          (value) {
            switch (value) {
              case Filter.date:
                break;
              case Filter.name:
                return _usersSubject.transform(_nameSort);
                break;
              case Filter.rating:
                return _usersSubject.transform(_ratingSort);
                break;
            }
            return _usersSubject.transform(_nameSort);
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

  PeoplesBloc() {
    _fetch();
    _subscriptions = [];
    _subjects = [
      _usersSubject,
      _searchSubject,
      _filterSubject,
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

  /// метод обновляющий лист текущих [User]'ов
  Future<void> refresh() {
    return _fetch();
  }

  /// метод догружающий [User]'ов
  void loadMore() async {
    if (!_usersSubject.hasValue || _currentPage == null) return;
    final peoples = _usersSubject.value;
    final fetched = await _repository.get(
      client: _client,
      page: ++_currentPage,
    );
    if (_currentPage > 1 && peoples.contains(fetched.first)) {
      _currentPage = null;
      return;
    }
    final p = peoples.rebuild((users) => users.addAll(fetched));
    _usersSubject.add(p);
  }

  Future<void> _fetch() async {
    _currentPage = 1;
    final peoples = await _repository.get(
      client: _client,
      page: _currentPage,
    );
    _usersSubject.add(peoples);
  }

  final _nameSort =
      StreamTransformer<BuiltList<User>, BuiltList<User>>.fromHandlers(
    handleData: (users, sink) {
      sink.add(
        users.rebuild(
          (p) {
            p.sort(
              (a, b) => '${a.firstname} ${a.lastname}'
                  .compareTo('${b.firstname} ${b.lastname}'),
            );
          },
        ),
      );
    },
  );

  final _ratingSort =
      StreamTransformer<BuiltList<User>, BuiltList<User>>.fromHandlers(
    handleData: (users, sink) {
      sink.add(
        users.rebuild(
          (p) {
            p.sort((a, b) => b.likes.compareTo(a.likes));
          },
        ),
      );
    },
  );
}

import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../data_layer/data_layer.dart';
import '../misc/misc.dart';
import '../models/models.dart';
import 'bloc_base.dart';

/// BloC для экрана Вакансии
class VacanciesBloc implements BlocBase {
  final _repository = VacanciesRepository();
  final _client = http.Client();

//ignore: close_sinks
  final _vacanciesSubject = BehaviorSubject<BuiltList<Vacancy>>();
//ignore: close_sinks
  final _searchSubject = PublishSubject<String>();
//ignore: close_sinks
  final _filterSubject = PublishSubject<Filter>();

  int _offset = 0;
  int _quantity = 10;

  /// [Observable] выводящий лист [Vacancy] удовлетворяющих поисковому запросу
  Observable<List<Vacancy>> get searchObservable => _searchSubject.transform(
        FlatMapStreamTransformer(
          (query) {
            return vacancies.map(
              (vacancies) {
                return vacancies
                    .where((vacancy) => vacancy.title.contains(query))
                    .toList();
              },
            );
          },
        ),
      );

  /// [Observable] выводящий лист [Vacancy] отсортированных текущим фильтром
  Observable<BuiltList<Vacancy>> get vacancies =>
      _filterSubject.shareValueSeeded(Filter.name).transform(
        FlatMapStreamTransformer(
          (value) {
            switch (value) {
              case Filter.date:
                break;
              case Filter.name:
                return _vacanciesSubject.transform(_nameSort);
                break;
              case Filter.rating:
                break;
            }
            return _vacanciesSubject.transform(_nameSort);
          },
        ),
      );

  /// [Sink] для добавления поискового запроса
  Sink<String> get search => _searchSubject.sink;

  /// [Sink] для добавления текущего фильтра
  Sink<Filter> get filter => _filterSubject.sink;

  List<StreamSubscription> _subscriptions;
  List<Subject> _subjects;

  VacanciesBloc() {
    _fetch();
    _subscriptions = [];
    _subjects = [
      _vacanciesSubject,
      _searchSubject,
      _filterSubject,
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

  /// метод обновляющий лист текущих [Vacancy]
  Future<void> refresh() {
    return _fetch();
  }

  /// метод догружающий [Vacancy]
  void loadMore() async {
    if (!_vacanciesSubject.hasValue || _offset == null) return;
    final peoples = _vacanciesSubject.value;
    final fetched = await _repository.get(
      client: _client,
      offset: _offset,
      quantity: _quantity,
    );
    final p = peoples.rebuild((users) => users.addAll(fetched));
    _offset = fetched.length < _quantity ? null : p.length;
    _vacanciesSubject.add(p);
  }

  Future<void> _fetch() async {
    final peoples = await _repository.get(
      client: _client,
      offset: 0,
      quantity: _quantity,
    );
    _offset = peoples.length;
    _vacanciesSubject.add(peoples);
  }

  final _nameSort =
      StreamTransformer<BuiltList<Vacancy>, BuiltList<Vacancy>>.fromHandlers(
    handleData: (vacancies, sink) {
      sink.add(
        vacancies.rebuild((p) => p.sort((a, b) => a.title.compareTo(b.title))),
      );
    },
  );
}

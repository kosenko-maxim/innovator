import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'bloc_base.dart';
import '../data_layer/data_layer.dart';
import '../models/models.dart';

class VacancyDetailsBloc implements BlocBase {
  final _usersRepository = UsersRepository();
  final _client = http.Client();

  VacancyDetailsBloc(Vacancy vacancy) {
    userObservable = Observable.fromFuture(
      _usersRepository.getById(
        id: vacancy.project.creatorId,
        client: _client,
      ),
    );
  }

  Observable<User> userObservable;
  @override
  void dispose() async {
    _client.close();
  }
}

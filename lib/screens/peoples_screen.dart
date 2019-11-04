import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import '../blocs/blocs.dart';
import '../misc/misc.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

/// экран Люди
class PeoplesScreen extends StatefulWidget {
  const PeoplesScreen({
    Key key,
  }) : super(key: key);

  @override
  _PeoplesScreenState createState() => _PeoplesScreenState();
}

class _PeoplesScreenState extends State<PeoplesScreen> {
  final _bloc = PeoplesBloc();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 12.0,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 32.0),
          Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 8.0),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 8.0),
                  Text(
                    'Люди',
                    style: Theme.of(context)
                        .textTheme
                        .display4
                        .copyWith(color: const Color(0xFFFFFFFF)),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      NovaIcons.filter,
                      color: const Color(0xFFFFFFFF),
                    ),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: _openFilter,
                  ),
                  const SizedBox(width: 10.0),
                  IconButton(
                    icon: Icon(
                      NovaIcons.search,
                      color: const Color(0xFFFFFFFF),
                    ),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: _openSearch,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Flexible(
            child: StreamBuilder<BuiltList<User>>(
              stream: _bloc.users,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.isNotEmpty) {
                    return NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (!(notification is ScrollEndNotification))
                          return false;
                        final metrics = notification.metrics;
                        if (metrics.pixels > metrics.maxScrollExtent - 220.0) {
                          _bloc.loadMore();
                        }
                        return true;
                      },
                      child: RefreshIndicator(
                        onRefresh: _bloc.refresh,
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return UserCard(
                              snapshot.data[index],
                              onTap: () => _openDetails(snapshot.data[index]),
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: _bloc.refresh,
                      child: ListView(
                        physics: AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${snapshot.error}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                }
                return Center(
                  child: NovaProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openDetails(User user) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialogueBottomSheet(
          context: context,
          builder: (context) => UserDetails(user),
        );
      },
    );
  }

  void _openFilter() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialogueBottomSheet(
        context: context,
        builder: (context) {
          return Material(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 48.0, left: 70.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Сортировать:',
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(color: const Color(0xFFC4BDDB)),
                  ),
                  const SizedBox(height: 24.0),
                  GestureDetector(
                    onTap: () {
                      _bloc.filter.add(Filter.name);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'По имени',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(color: const Color(0xFF533781)),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  GestureDetector(
                    onTap: () {
                      _bloc.filter.add(Filter.rating);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'По рейтингу',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(color: const Color(0xFF533781)),
                    ),
                  ),
                  const SizedBox(height: 60.0),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  void _openSearch() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialogueBottomSheet(
          context: context,
          builder: (context) {
            return SearchWidget<User>(
              querySink: _bloc.search,
              searchStream: _bloc.searchObservable,
              tagsSink: _bloc.tags,
              tags: [
                'Креативность',
                'Убедительность',
                'Сотрудничество',
                'Адаптивность',
                'Организованность',
                'Ответственность',
                'Управление временем',
                'Целеустремленность',
                'Амбициозность',
                'Терпеливость',
                'Быстрая реакция',
                'Обучаемость',
                'Саморазвитие',
                'Cloud computing',
                'Искусственный интеллект',
                'Analitical Reasoning',
                'Управление людьми',
                'UX-дизайн',
                'SMM (Social Media Marketing) - привлечение внимания к бренду через социальные сети',
                'Разработка мобильных приложений',
                'Облачные вычисления для прогнозирования роста облачных сервисов',
                'Знание языков программирования Perl, Python и Ruby',
                'Анализ статистики и Data Mining (интеллектуальный анализ данных)',
                'Дизайн пользовательских интерфейсов',
                'Диджитал и Онлайн-маркетинг',
                'Подбор персонала',
                'Развитие бизнеса',
                'Системы электронных платежей',
                'Бизнес-аналитика',
                'Создание баз данных',
                'Веб-программирование',
                'Разработка алгоритмов',
                'Управление базами данных',
                'Компьютерная графика и анимация',
                'Языки программирования C и C++',
                'Разработка связующего программного обеспечения',
                'Развитие Java-приложений',
                'Обеспечение качества и юзабилити программного обеспечения',
                'Пиар',
                'Управление проектами по созданию программного обеспечения',
                'Обеспечение информационной безопасности',
                'Стратегическое планирование',
                'Создание и управление системами хранения данных',
              ],
              builder: (users) {
                return Column(
                  children: users
                      .map(
                        (user) => UserCard(user),
                      )
                      .toList(),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

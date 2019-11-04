import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../blocs/blocs.dart';
import '../misc/misc.dart';
import '../models/models.dart';
import '../widgets/search_widget.dart';
import '../widgets/widgets.dart';

/// экран Проекты
class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({
    Key key,
  }) : super(key: key);

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with TickerProviderStateMixin {
  final _bloc = ProjectsBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectsBloc>(
      bloc: _bloc,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 12.0,
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 32.0),
            Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 8.0),
                child: Row(
                  children: <Widget>[
                    const SizedBox(width: 8.0),
                    Text(
                      'Проекты',
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
            const SizedBox(height: 20.0),
            Flexible(
              child: StreamBuilder<BuiltList<Project>>(
                stream: _bloc.projects,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.isNotEmpty) {
                      return NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (!(notification is ScrollEndNotification))
                            return false;
                          final metrics = notification.metrics;
                          if (metrics.pixels >
                              metrics.maxScrollExtent - 220.0) {
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
                              return ProjectCard(
                                snapshot.data[index],
                                onTap: () {
                                  _openDetails(
                                    projects: snapshot.data.toList(),
                                    currentProject: snapshot.data
                                        .indexOf(snapshot.data[index]),
                                  );
                                },
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
      ),
    );
  }

  void _openSearch() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialogueBottomSheet(
          context: context,
          builder: (context) {
            return SearchWidget<Project>(
              querySink: _bloc.search,
              searchStream: _bloc.searchObservable,
              tagsSink: _bloc.tags,
              tags: [
                'Наука',
                'Энергетическая промышленность',
                'Искусственный интеллект',
                'Робототехника',
                'Биотехнологии и генная инженерия',
                'Здравоохранение',
                'Фармацевтика',
                'Продовольствие и вода',
                'Образование',
                'ИТ-инфраструктура',
                'Правительство',
                'Улучшение демографии и качества жизни',
                'Виртуальная и дополненная реальность',
                'Наука',
                'Транспорт',
                'недвижимость',
                'Трудоустройство',
                'Средства программирования',
                'Корпоративное программное обеспечение',
                'HR',
                'Финансовые операции',
                'Big Data',
                'Интернет вещей',
                'Информационная безопасность',
                'Автоматизированная аналитика',
                'Некоммерческое взаимодействие',
                'рекламные технологии',
                'маркетинг',
                'интернет-продвижение',
                'государственная инициатива',
                'корпоративная культура',
                'проект внутри корпорации',
                'Питание',
                'Голливуд 2.0',
                'Развлечение',
                'Организация мероприятий',
                'Путешествие',
                'Услуги для бизнеса',
                'Консалтинг',
                'Психология',
                'Педагогика',
              ],
              builder: (projects) {
                return Column(
                  children: projects
                      .map(
                        (project) => ProjectCard(project),
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

  void _openDetails({
    List<Project> projects,
    int currentProject,
  }) {
    final controller = TabController(
      length: projects.length,
      initialIndex: currentProject,
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialogueBottomSheet(
//          controller: controller,
          context: context,
          builder: (context) => TabBarView(
            controller: controller,
            children: projects.map(
              (project) {
                return ProjectDetails(
                  project,
                  tabController: controller,
                  onEdit: () async => await _bloc.refresh(),
                );
              },
            ).toList(),
          ),
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

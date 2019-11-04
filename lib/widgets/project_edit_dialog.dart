import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../blocs/blocs.dart';
import '../misc/misc.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'nova_button.dart';
import 'skills_selector.dart';

/// диалог редактирования проекта
class ProjectEditDialogue extends StatefulWidget {
  final Project project;
  final VoidCallback editCallback;

  ProjectEditDialogue(
    this.project, {
    Key key,
    this.editCallback,
  }) : super(key: key);

  @override
  _ProjectEditDialogueState createState() => _ProjectEditDialogueState(project);
}

class _ProjectEditDialogueState extends State<ProjectEditDialogue>
    with TickerProviderStateMixin {
  final ProjectEditBloc _bloc;
  final _tabs = <Widget>[
    Tab(text: 'Информация'),
    Tab(text: 'Дорожная карта'),
  ];

  int _currentChapter = 1;
  TabController _controller;
  Key _infoKey = PageStorageKey<String>('info');
  Key _roadmapKey = PageStorageKey<String>('roadmap');
  List<String> tags = [];

  _ProjectEditDialogueState(Project project)
      : _bloc = ProjectEditBloc(project) {
    tags.addAll(project.tags.split(','));
  }

  @override
  void initState() {
    _controller = TabController(length: _tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 300),
      child: Material(
        color: const Color(0xFFFFFFFF),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 22.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Редактирование проекта',
                            style: Theme.of(context)
                                .textTheme
                                .display2
                                .copyWith(color: const Color(0xFF533781)),
                          ),
                          Spacer(),
                          Expanded(
                            child: IconButton(
                              icon: Icon(NovaIcons.close),
                              onPressed: Navigator.of(context).pop,
                              color: const Color(0xFF533781),
                              iconSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      NovaTabBar(
                        controller: _controller,
                        tabs: _tabs,
                      ),
                      const SizedBox(height: 30.0),
                      Flexible(
                        child: TabBarView(
                          physics: BouncingScrollPhysics(),
                          controller: _controller,
                          children: <Widget>[
                            _buildInfo(context, _controller),
                            _buildRoadmap(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRoadmap(BuildContext context) {
    return LayoutBuilder(
      key: _roadmapKey,
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Text(
                    'Дорожная карта проекта описывает этапы или шаги, которые вы уже сделали и сделаете в будущем для реализации проекта',
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(color: const Color(0xFF9786BC)),
                  ),
                  const SizedBox(height: 24.0),
                  StreamBuilder<List<Map<String, String>>>(
                    stream: _bloc.roadmapObservable,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final format = DateFormat('d MMMM yyyy').format;
                        final first = snapshot.data.first;
                        final last = snapshot.data.last;
                        return Material(
                          color: const Color(0xFFFFFFFF),
                          child: Column(
                            children: snapshot.data.map((data) {
                              return Material(
                                color: const Color(0xFFFFFFFF),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    data == first
                                        ? Divider(height: 0.0)
                                        : Container(),
                                    const SizedBox(height: 16.0),
                                    Text(
                                      data['title'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .display1
                                          .copyWith(
                                              color: const Color(0xFF533781)),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      '${format(DateTime.parse(data['date-from']))} - ${format(DateTime.parse(data['date-to']))}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .body1
                                          .copyWith(
                                              color: const Color(0xFFC4BDDB)),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      data['description'],
                                      style: Theme.of(context).textTheme.body1,
                                    ),
                                    const SizedBox(height: 16.0),
                                    data == last
                                        ? Divider(height: 0.0)
                                        : Container(),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      } else if (snapshot.hasError) {}
                      return Container();
                    },
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _openChapterCreation(context),
                      child: Row(
                        children: <Widget>[
                          const SizedBox(width: 7.0),
                          const Icon(
                            Icons.add,
                            color: const Color(0xFF80469B),
                          ),
                          const SizedBox(width: 14.0),
                          Text(
                            'Добавить этап',
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(color: const Color(0xFF80469B)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  StreamBuilder<Map<String, String>>(
                    stream: _bloc.dataObservable,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${snapshot.error}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        });
                      }
                      return NovaButton(
                        color: const Color(0xFF80469B),
                        disabledColor: const Color(0xFFEDEAF9),
                        child: Text('Сохранить'),
                        onPressed: snapshot.hasData
                            ? () {
                                _bloc.update(data: snapshot.data).then(
                                  (_) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      widget.editCallback();
                                    });
                                  },
                                );
                              }
                            : null,
                      );
                    },
                  ),
                  Spacer(),
//                  const SizedBox(height: 70.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openChapterCreation(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final data = await showDialogueBottomSheet<Map<String, String>>(
          context: context,
          builder: (context) {
            return StreamBuilder<List<Map<String, String>>>(
                stream: _bloc.roadmapObservable,
                builder: (context, snapshot) {
                  return ChapterCreationDialog(
                    chapterIndex: snapshot.hasData
                        ? snapshot.data.length + 1
                        : _currentChapter,
                  );
                });
          },
        );
        if (data != null) {
          _currentChapter = int.parse(data['index']);
          _bloc.roadmapAddition.add(data);
        }
      },
    );
  }

  Widget _buildInfo(BuildContext context, TabController controller) {
    return LayoutBuilder(
      key: _infoKey,
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: Row(
                      children: <Widget>[
                        StreamBuilder<String>(
                          stream: _bloc.avatarObservable,
                          builder: (context, snapshot) {
                            return GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 50.0,
                                child: snapshot.hasData
                                    ? Container()
                                    : Icon(NovaIcons.add),
                                backgroundImage: snapshot.hasData
                                    ? NetworkImage(snapshot.data)
                                    : null,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 24.0),
                        Flexible(
                          child: Column(
                            children: <Widget>[
                              StreamBuilder<String>(
                                stream: _bloc.titleObservable,
                                builder: (context, snapshot) {
                                  final controller = snapshot.hasData
                                      ? TextEditingController(
                                          text: snapshot.data)
                                      : TextEditingController();
                                  if (snapshot.hasData)
                                    controller
                                      ..selection = TextSelection.fromPosition(
                                        TextPosition(
                                            offset: snapshot.data.length),
                                      );
                                  return TextField(
                                    controller: controller,
                                    onChanged: _bloc.title.add,
                                    decoration: InputDecoration(
                                      labelText: 'Название',
                                      errorText: snapshot.error,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 22.0),
                              StreamBuilder<String>(
                                stream: _bloc.descriptionObservable,
                                builder: (context, snapshot) {
                                  final controller = snapshot.hasData
                                      ? TextEditingController(
                                          text: snapshot.data)
                                      : TextEditingController();
                                  if (snapshot.hasData)
                                    controller
                                      ..selection = TextSelection.fromPosition(
                                        TextPosition(
                                            offset: snapshot.data.length),
                                      );
                                  return TextField(
                                    controller: controller,
                                    onChanged: _bloc.description.add,
                                    decoration: InputDecoration(
                                      labelText: 'Описание',
                                      errorText: snapshot.error,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22.0),
                  StreamBuilder<String>(
                    stream: _bloc.audienceObservable,
                    builder: (context, snapshot) {
                      final controller = snapshot.hasData
                          ? TextEditingController(text: snapshot.data)
                          : TextEditingController();
                      if (snapshot.hasData)
                        controller
                          ..selection = TextSelection.fromPosition(
                            TextPosition(offset: snapshot.data.length),
                          );
                      return TextField(
                        controller: controller,
                        onChanged: _bloc.audience.add,
                        decoration: InputDecoration(
                          labelText: 'Целевая аудитория',
                          errorText: snapshot.error,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 22.0),
                  StreamBuilder<String>(
                    stream: _bloc.infoObservable,
                    builder: (context, snapshot) {
                      final controller = snapshot.hasData
                          ? TextEditingController(text: snapshot.data)
                          : TextEditingController();
                      if (snapshot.hasData)
                        controller
                          ..selection = TextSelection.fromPosition(
                            TextPosition(offset: snapshot.data.length),
                          );
                      return TextField(
                        controller: controller,
                        onChanged: _bloc.info.add,
                        decoration: InputDecoration(
                          labelText: 'Дополнительная информация',
                          errorText: snapshot.error,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 22.0),
                  StreamBuilder<String>(
                    stream: _bloc.investorsObservable,
                    builder: (context, snapshot) {
                      final controller = snapshot.hasData
                          ? TextEditingController(text: snapshot.data)
                          : TextEditingController();
                      if (snapshot.hasData)
                        controller
                          ..selection = TextSelection.fromPosition(
                            TextPosition(offset: snapshot.data.length),
                          );
                      return TextField(
                        controller: controller,
                        onChanged: _bloc.investors.add,
                        decoration: InputDecoration(
                          labelText: 'Инвесторы',
                          errorText: snapshot.error,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 22.0),
                  Flexible(
                    child: SkillsSelector(
                      crossAxisCount: 3,
                      onSelected: (skill) {
                        if (tags.length >= 6) return false;
                        tags.add(skill);
                        print(tags);
                        _bloc.tags.add(tags.join(','));
                        return true;
                      },
                      onDeselected: (skill) {
                        if (tags.length <= 0) return false;
                        tags.remove(skill);
                        print(tags);
                        _bloc.tags.add(tags.join(','));
                        return true;
                      },
                      selectedPredicate: (skill) => tags.contains(skill),
                      skills: [
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
                    ),
                  ),
                  const SizedBox(height: 22.0),
                  StreamBuilder<List<User>>(
                    stream: _bloc.participantsObservable,
                    builder: (_, snapshot) {
                      return Column(
                        children: snapshot.hasData
                            ? snapshot.data
                                .map((user) => UserMiniCard(user))
                                .toList()
                            : [],
                      );
                    },
                  ),
                  const SizedBox(height: 22.0),
                  Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: _openParticipantsAddition,
                      child: Row(
                        children: <Widget>[
                          const SizedBox(width: 7.0),
                          const Icon(
                            Icons.add,
                            color: const Color(0xFF80469B),
                          ),
                          const SizedBox(width: 14.0),
                          Text(
                            'Добавить участников',
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(color: const Color(0xFF80469B)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  NovaButton(
                    onPressed: () => controller.animateTo(1),
                    child: Text('Далее'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openParticipantsAddition() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialogueBottomSheet(
          context: context,
          builder: (context) {
            return SearchWidget<User>(
              querySink: _bloc.search,
              searchStream: _bloc.searchObservable,
              builder: (users) {
                final first = users.first;
                final last = users.last;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: users
                      .map(
                        (user) => Row(
                          children: [
                            UserMiniCard(
                              user,
                              showUpperDivider: user != first,
                              showLowerDivider: user != last,
                              onTap: () {
                                WidgetsBinding.instance.addPostFrameCallback(
                                  (_) {
                                    showDialogueBottomSheet(
                                      context: context,
                                      builder: (context) => UserDetails(user),
                                    );
                                  },
                                );
                              },
                            ),
                            Spacer(),
                            StreamBuilder<List<User>>(
                              stream: _bloc.participantsObservable,
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  return IconButton(
                                    icon: Icon(snapshot.data.contains(user)
                                        ? Icons.remove
                                        : Icons.add),
                                    onPressed: () =>
                                        _bloc.participant.add(user.id),
                                  );
                                } else {
                                  return IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () =>
                                        _bloc.participant.add(user.id),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
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

  void _pickImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    _bloc.avatar.add(image);
  }

  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class ChapterCreationDialog extends StatefulWidget {
  final int chapterIndex;
  const ChapterCreationDialog({
    Key key,
    this.chapterIndex,
  }) : super(key: key);

  @override
  _ChapterCreationDialogState createState() => _ChapterCreationDialogState();
}

class _ChapterCreationDialogState extends State<ChapterCreationDialog>
    with TickerProviderStateMixin {
  final _descriptionController = TextEditingController();
  final _dateFromController = TextEditingController();
  final _dateToController = TextEditingController();

  TabController _statusController;

  @override
  void initState() {
    _statusController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('yyyy-MM-dd').format;
    return AnimatedContainer(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 300),
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.79999,
        builder: (context, controller) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                controller: controller,
                physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Material(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 32.0,
                              child: Center(
                                child: Container(
                                  height: 3.0,
                                  width: 54.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF9786BC),
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Этап ${widget.chapterIndex}',
                              style: Theme.of(context).textTheme.display2,
                            ),
                            const SizedBox(height: 24.0),
                            NovaTabBar(
                              controller: _statusController,
                              tabs: <Widget>[
                                Tab(text: 'Прошедший'),
                                Tab(text: 'Текущий'),
                              ],
                            ),
                            const SizedBox(height: 22.0),
                            GestureDetector(
                              onTap: () async {
                                final now = DateTime.now();
                                final date = await showDatePicker(
                                  initialDate: now,
                                  firstDate: DateTime(2000),
                                  lastDate: now.add(const Duration(days: 3650)),
                                  context: context,
                                );
                                if (date != null) {
                                  _dateFromController.text = format(date);
                                }
                              },
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: _dateFromController,
                                  decoration:
                                      InputDecoration(labelText: 'Дата начала'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 22.0),
                            GestureDetector(
                              onTap: () async {
                                final now = DateTime.now();
                                final date = await showDatePicker(
                                  initialDate: now,
                                  firstDate: DateTime(now.year),
                                  lastDate: now.add(const Duration(days: 3650)),
                                  context: context,
                                );
                                if (date != null) {
                                  _dateToController.text = format(date);
                                }
                              },
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: _dateToController,
                                  decoration: InputDecoration(
                                      labelText: 'Дата окончания'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 22.0),
                            TextField(
                              controller: _descriptionController,
                              decoration:
                                  InputDecoration(labelText: 'Описание'),
                            ),
                            const SizedBox(height: 10.0),
                            Spacer(),
                            NovaButton(
                              onPressed: () {
                                Navigator.of(context).pop(
                                  <String, String>{
                                    'index':
                                        (widget.chapterIndex + 1).toString(),
                                    'title': 'Этап ${widget.chapterIndex}',
                                    'description': _descriptionController.text,
                                    'date-to': _dateToController.text,
                                    'date-from': _dateFromController.text,
                                    'is-active': _statusController.index == 0
                                        ? 'False'
                                        : 'True',
                                  },
                                );
                              },
                              child: Text('Готово'),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void dispose() {
    _descriptionController.dispose();
    _dateFromController.dispose();
    _dateToController.dispose();
    super.dispose();
  }
}

class NovaTabBar extends StatefulWidget {
  final List<Widget> tabs;
  final TabController controller;

  const NovaTabBar({
    Key key,
    this.tabs,
    this.controller,
  }) : super(key: key);

  @override
  _NovaTabBarState createState() => _NovaTabBarState();
}

class _NovaTabBarState extends State<NovaTabBar> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        height: 40.0,
        child: Material(
          color: const Color(0xFFEDEAF9),
          borderRadius: BorderRadius.all(
            Radius.circular(100.0),
          ),
          child: TabBar(
            controller: widget.controller,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BubbleTabIndicator(
              insets: EdgeInsets.zero,
              indicatorColor: const Color(0xFF9786BC),
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
              indicatorHeight: 40.0,
            ),
            tabs: widget.tabs,
          ),
        ),
      ),
    );
  }
}

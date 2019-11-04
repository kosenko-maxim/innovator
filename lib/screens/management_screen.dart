import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import '../blocs/blocs.dart';
import '../misc/misc.dart';
import '../models/models.dart';
import '../widgets/widgets.dart' as widgets;
import '../widgets/widgets.dart';

/// экран управления
class ManagementScreen extends StatefulWidget {
  const ManagementScreen({
    Key key,
  }) : super(key: key);

  @override
  _ManagementScreenState createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  final ManagementBloc _bloc = ManagementBloc();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(height: 32.0),
                    Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 21.0, right: 24.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 8.0),
                            Text(
                              'Управление',
                              style: Theme.of(context)
                                  .textTheme
                                  .display4
                                  .copyWith(color: const Color(0xFFFFFFFF)),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                NovaIcons.menu,
                                color: const Color(0xFFFFFFFF),
                              ),
                              iconSize: 18.0,
                              onPressed: _openMenu,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Expanded(
                      child: Container(
                        color: const Color(0xFFFFFFFF),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 19.0),
                                child: StreamBuilder<User>(
                                  stream: _bloc.user,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return InkWell(
                                        onTap: () =>
                                            _openUserDetails(snapshot.data),
                                        child: Row(
                                          children: <Widget>[
                                            NovaCircleAvatar(
                                              radius: 80.0,
                                              image: snapshot.data.profilePic ==
                                                          null ||
                                                      snapshot.data.profilePic
                                                          .isEmpty
                                                  ? AssetImage(
                                                      'assets/user.png',
                                                    )
                                                  : NetworkImage(
                                                      snapshot.data.profilePic,
                                                    ),
                                            ),
                                            const SizedBox(width: 14.0),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    '${snapshot.data.firstname} ${snapshot.data.lastname}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .display2
                                                        .copyWith(
                                                            color: const Color(
                                                                0xFF533781)),
                                                  ),
                                                  SizedBox(height: 7.0),
                                                  Text(
                                                    'Открыть профиль',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .body1
                                                        .copyWith(
                                                            color: const Color(
                                                                0xFFC4BDDB)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${snapshot.error}'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      });
                                    }
                                    return Column(
                                      children: <Widget>[
                                        const SizedBox(height: 15.0),
                                        Row(
                                          children: <Widget>[
                                            NovaCircleAvatar(
                                              image:
                                                  AssetImage('assets/user.png'),
                                            ),
                                            const SizedBox(width: 16.0),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Ваш аккаунт не активирован',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle
                                                      .copyWith(
                                                          color: Colors.red),
                                                ),
                                                const SizedBox(height: 7.0),
                                                Text(
                                                  'проверьте свой email',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .body1
                                                      .copyWith(
                                                          color: const Color(
                                                              0xFF9786BC)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15.0),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Divider(height: 0.0),
                              const SizedBox(height: 17.0),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Личные проекты',
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .copyWith(
                                            color: const Color(0xFF533781)),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () =>
                                        _showProjectAdditionDialog(context),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              StreamBuilder<BuiltList<Project>>(
                                stream: _bloc.projects,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data.isNotEmpty) {
                                    final first = snapshot.data.first;
                                    final last = snapshot.data.last;
                                    return Column(
                                      children: snapshot.data
                                          .map((project) => ProjectMiniCard(
                                                project,
                                                showUpperDivider:
                                                    project != first,
                                                showLowerDivider:
                                                    project == last,
                                                onTap: () =>
                                                    _openProjectDetails(
                                                        project),
                                              ))
                                          .toList(),
                                    );
                                  } else if (snapshot.hasError) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${snapshot.error}'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    });
                                  } else {
                                    return Divider(height: 0.0);
                                  }
                                  return Container();
                                },
                              ),
                              const SizedBox(height: 17.0),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Размещенные вакансии',
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .copyWith(
                                            color: const Color(0xFF533781)),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () =>
                                        _showVacancyAdditionDialog(context),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              StreamBuilder<BuiltList<Vacancy>>(
                                stream: _bloc.vacancies,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data.isNotEmpty) {
                                    final first = snapshot.data.first;
                                    final last = snapshot.data.last;
                                    return Column(
                                      children: snapshot.data
                                          .map((vacancy) => VacancyMiniCard(
                                                vacancy,
                                                showUpperDivider:
                                                    vacancy != first,
                                                showLowerDivider:
                                                    vacancy == last,
                                                onTap: () =>
                                                    _openVacancyDetails(
                                                        vacancy),
                                              ))
                                          .toList(),
                                    );
                                  } else if (snapshot.hasError) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${snapshot.error}'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    });
                                  } else {
                                    return Divider(height: 0.0);
                                  }
                                  return Container();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _openMenu() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialogueBottomSheet(
//        initialHeight: 0.3,
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
                  GestureDetector(
                    onTap: () => _showAboutDialog(context),
                    child: Text(
                      'О приложении',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(color: const Color(0xFF533781)),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  GestureDetector(
                    onTap: () {
                      _bloc.logout();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/splash',
                        (route) => false,
                      );
                    },
                    child: Text(
                      'Выйти из аккаунта',
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

  void _showAboutDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => widgets.AboutDialog(),
    );
  }

  void _showProjectAdditionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => ProjectCreationDialogue(),
    );
    _bloc.getProjects();
  }

  void _showVacancyAdditionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => VacancyCreationDialogue(),
    );
    _bloc.getVacancies();
  }

  void _openUserDetails(User user) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialogueBottomSheet(
          context: context,
          builder: (context) => UserDetails(user),
        );
      },
    );
  }

  void _openVacancyDetails(Vacancy vacancy) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialogueBottomSheet(
          context: context,
          builder: (context) => VacancyDetails(vacancy),
        );
      },
    );
  }

  void _openProjectDetails(Project project) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialogueBottomSheet(
          context: context,
          builder: (context) => ProjectDetails(
            project,
            onEdit: () async => _bloc.getProjects(),
          ),
        );
      },
    );
  }
}

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import '../blocs/blocs.dart';
import '../misc/misc.dart';
import '../models/models.dart';
import '../widgets/project_edit_dialog.dart';
import '../widgets/widgets.dart';

/// детали проекта
class ProjectDetails extends StatefulWidget {
  final Project _project;
  final TabController tabController;
  final VoidCallback onEdit;

  ProjectDetails(
    this._project, {
    this.tabController,
    this.onEdit,
  });

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState(_project);
}

class _ProjectDetailsState extends State<ProjectDetails> {
  final ProjectDetailsBloc _bloc;

  _ProjectDetailsState(Project project) : _bloc = ProjectDetailsBloc(project);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1.0,
      minChildSize: 0.99999,
      builder: (context, controller) {
        return Scaffold(
          floatingActionButton: StreamBuilder<bool>(
            stream: _bloc.canEdit,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data) {
                return FloatingActionButton(
                  onPressed: () => _showEditingDialog(context),
                  child: Icon(Icons.edit),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                );
              }
              return Container();
            },
          ),
          body: SingleChildScrollView(
            controller: controller,
            physics: AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 375.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: widget._project.projectPic.isEmpty ||
                              !widget._project.projectPic.startsWith('http')
                          ? AssetImage('assets/project.png')
                          : NetworkImage(widget._project.projectPic),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 280.0),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(right: 32.0),
                        height: 32.0,
                        child: Center(
                          child: widget.tabController == null
                              ? Container(
                                  height: 3.0,
                                  width: 54.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF9786BC),
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                )
                              : NovaPageSelector(
                                  controller: widget.tabController,
                                  selectedColor: const Color(0xFF533781),
                                  color: const Color(0x66533781),
                                  indicatorSize: 7.0,
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget._project.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .display2
                                  .copyWith(color: const Color(0xFF533781)),
                            ),
                            // const SizedBox(height: 8.0),
                            // Text(
                            //   widget._project.isPublished.toString(),
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .body1
                            //       .copyWith(color: const Color(0xFF9786BC)),
                            // ),
                            const SizedBox(height: 12.0),
                            Text(
                              widget._project.description,
                              style: Theme.of(context).textTheme.body1,
                            ),
                            const SizedBox(height: 18.0),
                            _buildButtons(context),
                            SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        'Команда проекта',
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(color: const Color(0xFF533781)),
                      ),
                      const SizedBox(height: 17.0),
                      _buildTeam(),
                      const SizedBox(height: 24.0),
                      Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Целевая аудитория',
                              style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .copyWith(color: const Color(0xFF533781)),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              widget._project.targetAudience,
                              style: Theme.of(context).textTheme.body1,
                            ),
                            const SizedBox(height: 24.0),
                            Text(
                              'Инвесторы',
                              style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .copyWith(color: const Color(0xFF533781)),
                            ),
                            const SizedBox(height: 17.0),
                            _buildInvestors(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        'Дополнительная информация',
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(color: const Color(0xFF533781)),
                      ),
                      const SizedBox(height: 17.0),
                      _buildExtraInfo(context),
                      const SizedBox(height: 24.0),
                      Text(
                        'Дорожная карта',
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(color: const Color(0xFF533781)),
                      ),
                      const SizedBox(height: 17.0),
                      _buildRoadmap(),
                      const SizedBox(height: 12.0),
                      Text(
                        'Вакансии',
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(color: const Color(0xFF533781)),
                      ),
                      const SizedBox(height: 28.0),
                      _buildVacancies(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openDialogue(BuildContext context) {
    showDialogueBottomSheet(
      context: context,
//      initialHeight: 0.85,
      builder: (context) {
        return StreamBuilder<User>(
          stream: _bloc.userObservable,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return Dialogue(
                receiver: snapshot.data,
                projectName: widget._project.title,
              );
            }
            return Container();
          },
        );
      },
    );
  }

  void _showEditingDialog(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog(
        context: context,
        builder: (context) => ProjectEditDialogue(
          widget._project,
          editCallback: widget.onEdit,
        ),
      );
    });
  }

  Widget _buildVacancies() {
    return StreamBuilder<BuiltList<Vacancy>>(
      stream: _bloc.vacancies,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: snapshot.data
                .map((vacancy) => VacancyMiniCard(vacancy))
                .toList(),
          );
        } else if (snapshot.hasError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${snapshot.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildRoadmap() {
    return StreamBuilder<BuiltList<Chapter>>(
      stream: _bloc.roadmap,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RoadmapWidget(
            chapters: snapshot.data.toList(),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildExtraInfo(BuildContext context) {
    return ExtraInfoCard(
      leading: Icon(Icons.ac_unit),
      content: Flexible(
        child: Text(
          widget._project.additionalInfo,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.body1,
        ),
      ),
      showLowerDivider: true,
    );
  }

  Widget _buildInvestors() {
    return Column(
      children: widget._project.investors
          .replaceAll(RegExp(r"[\'\[\]\s]"), '')
          .split(',')
          .map(
        (investor) {
          return Row(
            children: <Widget>[
              Text(
                investor,
                style: Theme.of(context).textTheme.body1,
              )
            ],
          );
        },
      ).toList(),
    );
  }

  Widget _buildTeam() {
    return StreamBuilder<List<User>>(
      stream: _bloc.team,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final last = snapshot.data.last;
          return Column(
            children: snapshot.data
                .map((user) => UserMiniCard(
                      user,
                      showLowerDivider: user == last,
                    ))
                .toList(),
          );
        } else if (snapshot.hasError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${snapshot.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: NovaButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.favorite_border,
                  color: const Color(0xFF7E4599),
                ),
                StreamBuilder<int>(
                    stream: _bloc.likes,
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.hasData
                            ? snapshot.data.toString()
                            : widget._project.likes.toString(),
                        style: Theme.of(context).textTheme.button,
                      );
                    }),
              ],
            ),
            onPressed: () => _bloc.like.add(widget._project.id),
          ),
        ),
        SizedBox(width: 8.0),
        Expanded(
          flex: 2,
          child: NovaButton(
            child: Text(
              'Связаться',
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: () => _openDialogue(context),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

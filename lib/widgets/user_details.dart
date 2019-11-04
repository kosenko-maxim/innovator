import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../blocs/blocs.dart';
import '../misc/misc.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

/// детали пользоывтеля
class UserDetails extends StatefulWidget {
  final User _user;
  final ScrollController controller;

  UserDetails(
    this._user, {
    this.controller,
  });

  @override
  _UserDetailsState createState() => _UserDetailsState(_user);
}

class _UserDetailsState extends State<UserDetails> {
  final UserDetailsBloc _bloc;
  _UserDetailsState(User user) : _bloc = UserDetailsBloc(user);

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 1.0,
        minChildSize: 0.99999,
        builder: (context, controller) {
          return Scaffold(
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
                        image: widget._user.profilePic == null ||
                                widget._user.profilePic.isEmpty ||
                                !widget._user.profilePic.startsWith('http')
                            ? AssetImage('assets/user.png')
                            : NetworkImage(widget._user.profilePic),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 280.0),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 32.0, bottom: 32.0),
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
                        Padding(
                          padding: const EdgeInsets.only(right: 32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${widget._user.firstname} ${widget._user.lastname}',
                                style: Theme.of(context)
                                    .textTheme
                                    .display2
                                    .copyWith(color: const Color(0xFF533781)),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                '${widget._user.city}, ${widget._user.country}',
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(color: const Color(0xFF9786BC)),
                              ),
                              const SizedBox(height: 16.0),
                              if (widget._user.isExpert) ...[
                                Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.star,
                                      size: 22.0,
                                      color: const Color(0xFF533781),
                                    ),
                                    const SizedBox(width: 12.0),
                                    Text(
                                      'Эксперт',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle
                                          .copyWith(
                                              color: const Color(0xFF80469B)),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 22.0),
                              StreamBuilder<User>(
                                stream: _bloc.userObservable,
                                builder: (_, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != widget._user) {
                                    return NovaButton(
                                      onPressed: () => _openDialogue(context),
                                      child: Text(
                                        'Написать',
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                              ),
                              const SizedBox(height: 16.0),
                              _buildProjectsInfo(context),
                              const SizedBox(height: 24.0),
                              Text(
                                'Навыки',
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .copyWith(color: const Color(0xFF533781)),
                              ),
                              _buildSkills(context),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Text(
                          'Созданные проекты',
                          style: Theme.of(context)
                              .textTheme
                              .display1
                              .copyWith(color: const Color(0xFF533781)),
                        ),
                        const SizedBox(height: 17.0),
                        _buildCreatedProjects(),
                        const SizedBox(height: 24.0),
                        Text(
                          'Участник в проектах',
                          style: Theme.of(context)
                              .textTheme
                              .display1
                              .copyWith(color: const Color(0xFF533781)),
                        ),
                        const SizedBox(height: 17.0),
                        _buildProjectsMember(),
                        const SizedBox(height: 24.0),
                        Padding(
                          padding: const EdgeInsets.only(right: 32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Работа',
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .copyWith(color: const Color(0xFF533781)),
                              ),
                              SizedBox(height: 17.0),
                              _buildWork(),
                              const SizedBox(height: 32.0),
                              Text(
                                'Образование',
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .copyWith(color: const Color(0xFF533781)),
                              ),
                              SizedBox(height: 17.0),
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: 5.0,
                                    width: 5.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF9786BC),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 12.0),
                                  Text(
                                    widget._user.education,
                                    style: Theme.of(context)
                                        .textTheme
                                        .body1
                                        .copyWith(
                                            color: const Color(0xFF533781)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _openDialogue(BuildContext context) {
    showDialogueBottomSheet(
      context: context,
//      initialHeight: 0.85,
      builder: (context) {
        return Dialogue(
          receiver: widget._user,
        );
      },
    );
  }

  Widget _buildSkills(BuildContext context) {
    return Material(
      color: const Color(0xFFFFFFFF),
      child: Wrap(
        spacing: 4.0,
        runSpacing: -12.0,
        children: widget._user.skills
            // .replaceAll(RegExp(r"[\'\[\]\s]"), '')
            .split(',')
            .map(
              (skill) => Chip(
                label: Text(
                  skill,
                  style: Theme.of(context).textTheme.body2,
                ),
                backgroundColor: Color(0xFFEDEAF9),
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildProjectsInfo(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: const Color(0xFFEDEAF9),
                width: 2.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StreamBuilder<BuiltList<Project>>(
                  stream: _bloc.projectsMember,
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.hasData ? snapshot.data.length.toString() : '0',
                      style: Theme.of(context).textTheme.display4.copyWith(
                            color: const Color(0xFF533781),
                            fontSize: 36.0,
                          ),
                      overflow: TextOverflow.visible,
                    );
                  },
                ),
                SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    'Проектов как участник',
                    softWrap: true,
                    style: Theme.of(context).textTheme.body2,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 11.0),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: const Color(0xFFEDEAF9),
                width: 2.0,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StreamBuilder<BuiltList<Project>>(
                    stream: _bloc.createdProjects,
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.hasData
                            ? snapshot.data.length.toString()
                            : '0',
                        style: Theme.of(context).textTheme.display4.copyWith(
                              color: const Color(0xFF533781),
                              fontSize: 36.0,
                            ),
                        overflow: TextOverflow.visible,
                      );
                    },
                  ),
                  SizedBox(width: 8.0),
                  Flexible(
                    child: Text(
                      'Создал проектов',
                      softWrap: true,
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreatedProjects() {
    return StreamBuilder<BuiltList<Project>>(
      stream: _bloc.createdProjects,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          final last = snapshot.data.last;
          return Column(
            children: snapshot.data
                .map(
                  (project) => ProjectMiniCard(
                    project,
                    showLowerDivider: project == last,
                  ),
                )
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

  Widget _buildProjectsMember() {
    return StreamBuilder<BuiltList<Project>>(
      stream: _bloc.projectsMember,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final last = snapshot.data.last;
          return Column(
            children: snapshot.data
                .map(
                  (project) => ProjectMiniCard(
                    project,
                    showLowerDivider: project == last,
                  ),
                )
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

  Widget _buildWork() {
    return Column(
      children: widget._user.jobs
          .replaceAll(RegExp(r"[\'\[\]\s]"), '')
          .split(',')
          .map(
        (job) {
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 5.0,
                        width: 5.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9786BC),
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Container(
                      //   width: 1.0,
                      //   height: 10.0,
                      // ),
                    ],
                  ),
                  SizedBox(width: 12.0),
                  Text(
                    '$job',
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(color: const Color(0xFF533781)),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
            ],
          );
        },
      ).toList(),
    );
  }
}

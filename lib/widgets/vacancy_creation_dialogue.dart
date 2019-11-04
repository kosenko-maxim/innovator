import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import '../blocs/blocs.dart';
import '../misc/misc.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

/// диалог создания вакансии
class VacancyCreationDialogue extends StatefulWidget {
  @override
  _VacancyCreationDialogueState createState() =>
      _VacancyCreationDialogueState();
}

class _VacancyCreationDialogueState extends State<VacancyCreationDialogue> {
  final _bloc = VacancyCreationBloc();
  Project _current;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 300),
      child: Material(
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
                        children: <Widget>[
                          Text(
                            'Новая вакансия',
                            style: Theme.of(context)
                                .textTheme
                                .display2
                                .copyWith(color: const Color(0xFF533781)),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(NovaIcons.close),
                            onPressed: Navigator.of(context).pop,
                            color: const Color(0xFF533781),
                            iconSize: 12.0,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      StreamBuilder<String>(
                        stream: _bloc.titleObservable,
                        builder: (context, snapshot) {
                          return TextField(
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
                          return TextField(
                            onChanged: _bloc.description.add,
                            decoration: InputDecoration(
                              labelText: 'Описание',
                              errorText: snapshot.error,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 22.0),
                      StreamBuilder<String>(
                        stream: _bloc.skillsObservable,
                        builder: (context, snapshot) {
                          return TextField(
                            onChanged: _bloc.skills.add,
                            decoration: InputDecoration(
                              labelText: 'Навыки',
                              errorText: snapshot.error,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 22.0),
                      StreamBuilder<BuiltList<Project>>(
                        stream: _bloc.usersProjectsObservable,
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
                          return Container(
                            height: 55.0,
                            child: DropdownButton<Project>(
                              isExpanded: true,
                              value: _current,
                              onChanged: (project) {
                                setState(() => _current = project);
                                _bloc.projectId.add(project.id);
                              },
                              items: snapshot.hasData
                                  ? snapshot.data.map(
                                      (project) {
                                        return DropdownMenuItem<Project>(
                                          value: project,
                                          child: Container(
                                            height: 30.0,
                                            child: Row(
                                              children: <Widget>[
                                                NovaCircleAvatar(
                                                  radius: 30.0,
                                                  image: NetworkImage(
                                                    project.projectPic,
                                                  ),
                                                ),
                                                const SizedBox(width: 8.0),
                                                Text(
                                                  project.title,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subhead,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ).toList()
                                  : <DropdownMenuItem<Project>>[],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20.0),
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
                            child: Text('Создать вакансию'),
                            onPressed: snapshot.hasData
                                ? () {
                                    _bloc.create(data: snapshot.data).then(
                                      (_) {
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  }
                                : null,
                          );
                        },
                      ),
                      const SizedBox(height: 70.0),
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
}

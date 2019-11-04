import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../blocs/blocs.dart';
import '../misc/misc.dart';
import '../models/models.dart';
import 'nova_button.dart';
import 'widgets.dart';

/// детали вакансии
class VacancyDetails extends StatefulWidget {
  final Vacancy _vacancy;

  VacancyDetails(
    this._vacancy, {
    Key key,
  }) : super(key: key);

  @override
  _VacancyDetailsState createState() => _VacancyDetailsState(_vacancy);
}

class _VacancyDetailsState extends State<VacancyDetails> {
  final VacancyDetailsBloc _bloc;

  _VacancyDetailsState(Vacancy vacancy) : _bloc = VacancyDetailsBloc(vacancy);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.89999,
      builder: (context, controller) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                controller: controller,
                physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Container(
                      padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          const SizedBox(height: 10.0),
                          Text(
                            'Вакансия на проект',
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(color: const Color(0xFF533781)),
                          ),
                          SizedBox(height: 1.0),
                          ProjectMiniCard(
                            widget._vacancy.project,
                            showUpperDivider: false,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            widget._vacancy.title,
                            style: Theme.of(context)
                                .textTheme
                                .display2
                                .copyWith(color: const Color(0xFF533781)),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            widget._vacancy.description,
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(color: const Color(0xFF533781)),
                          ),
                          SizedBox(height: 20.0),
                          Material(
                            color: const Color(0xFFFFFFFF),
                            child: Wrap(
                              spacing: 4.0,
                              runSpacing: -12.0,
                              children: widget._vacancy.skills
                                  .replaceAll(RegExp(r"[\'\[\]\s]"), '')
                                  .split(',')
                                  .map(
                                    (skill) => Chip(
                                      label: Text(
                                        skill,
                                        style:
                                            Theme.of(context).textTheme.body2,
                                      ),
                                      backgroundColor: Color(0xFFEDEAF9),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: 32.0),
                          Text(
                            'Размeстил',
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(color: const Color(0xFF533781)),
                          ),
                          SizedBox(height: 16.0),
                          StreamBuilder<User>(
                            stream: _bloc.userObservable,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                  children: <Widget>[
                                    UserMiniCard(snapshot.data),
                                    SizedBox(height: 16.0),
                                    NovaButton(
                                      child: Text('Откликнуться'),
                                      onPressed: () =>
                                          _openDialogue(context, snapshot.data),
                                    ),
                                    SizedBox(height: 16.0),
                                  ],
                                );
                              }
                              return Center(
                                child: Column(
                                  children: <Widget>[
                                    CircularProgressIndicator(),
                                    Text('Wait...')
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _openDialogue(BuildContext context, User user) {
    showDialogueBottomSheet(
      context: context,
      builder: (context) {
        return Dialogue(
          receiver: user,
          projectName: widget._vacancy.project.title,
        );
      },
    );
  }
}

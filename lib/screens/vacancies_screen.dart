import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import '../blocs/blocs.dart';
import '../misc/misc.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

/// экран вакансии
class VacanciesScreen extends StatefulWidget {
  const VacanciesScreen({
    Key key,
  }) : super(key: key);

  @override
  VacanciesScreenState createState() => VacanciesScreenState();
}

class VacanciesScreenState extends State<VacanciesScreen> {
  final _bloc = VacanciesBloc();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 32.0),
          Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 21.0,
                right: 24.0,
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 8.0),
                  Text(
                    'Вакансии',
                    style: Theme.of(context)
                        .textTheme
                        .display4
                        .copyWith(color: const Color(0xFFFFFFFF)),
                  ),
                  Spacer(),
//                  IconButton(
//                    icon: Icon(
//                      NovaIcons.filter,
//                      color: const Color(0xFFFFFFFF),
//                    ),
//                    highlightColor: Colors.transparent,
//                    splashColor: Colors.transparent,
//                    onPressed: _openFilter,
//                  ),
//                  const SizedBox(width: 10.0),
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
            child: StreamBuilder<BuiltList<Vacancy>>(
              stream: _bloc.vacancies,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.isNotEmpty) {
                    final last = snapshot.data.last;
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
                            return Container(
                              color: const Color(0xFFFFFFFF),
                              child: Column(
                                children: <Widget>[
                                  VacancyCard(
                                    snapshot.data[index],
                                    onTap: () =>
                                        _openDetails(snapshot.data[index]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: snapshot.data[index] != last
                                        ? Divider(height: 1.0)
                                        : Container(),
                                  ),
                                ],
                              ),
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

  void _openDetails(Vacancy vacancy) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialogueBottomSheet(
          context: context,
//          initialHeight: 0.9,
          builder: (context) {
            return VacancyDetails(vacancy);
          },
        );
      },
    );
  }

//  void _openFilter() {
//    WidgetsBinding.instance.addPostFrameCallback((_) async {
//      await showDetailsBottomSheet(
//        initialHeight: 0.3,
//        context: context,
//        builder: (context) {
//          return Material(
//            color: const Color(0xFFFFFFFF),
//            borderRadius: BorderRadius.vertical(
//              top: Radius.circular(20.0),
//            ),
//            child: Padding(
//              padding: const EdgeInsets.only(top: 48.0, left: 70.0),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisAlignment: MainAxisAlignment.start,
//                mainAxisSize: MainAxisSize.min,
//                children: <Widget>[
//                  Text(
//                    'Сортировать:',
//                    style: Theme.of(context)
//                        .textTheme
//                        .body1
//                        .copyWith(color: const Color(0xFFC4BDDB)),
//                  ),
//                  const SizedBox(height: 24.0),
//                  GestureDetector(
//                    onTap: () {
//                      _bloc.filter.add(Filter.name);
//                      Navigator.of(context).pop();
//                    },
//                    child: Text(
//                      'По имени',
//                      style: Theme.of(context)
//                          .textTheme
//                          .subtitle
//                          .copyWith(color: const Color(0xFF533781)),
//                    ),
//                  ),
////                  GestureDetector(
////                    onTap: () {
////                      _bloc.filter.add(Filter.rating);
////                      Navigator.of(context).pop();
////                    },
////                    child: Text('По рейтингу'),
////                  ),
//                ],
//              ),
//            ),
//          );
//        },
//      );
//    });
//  }

  void _openSearch() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialogueBottomSheet(
          context: context,
          builder: (context) {
            return SearchWidget<Vacancy>(
              querySink: _bloc.search,
              searchStream: _bloc.searchObservable,
              builder: (vacancies) {
                return Column(
                  children: vacancies
                      .map(
                        (vacancy) => VacancyCard(vacancy),
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

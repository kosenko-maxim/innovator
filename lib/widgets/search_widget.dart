import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../misc/misc.dart';
import 'skills_selector.dart';

/// виджет поиска
class SearchWidget<T> extends StatefulWidget {
  final Sink<String> querySink;
  final Sink<List<String>> tagsSink;
  final Stream<List<T>> searchStream;
  final Widget Function(List<T>) builder;
  final List<String> tags;

  const SearchWidget({
    @required this.querySink,
    @required this.searchStream,
    @required this.builder,
    this.tagsSink,
    this.tags,
  });

  @override
  _SearchWidgetState<T> createState() => _SearchWidgetState<T>();
}

class _SearchWidgetState<T> extends State<SearchWidget<T>> {
  List<String> tags = [];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 300),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.89999,
        builder: (context, controller) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                controller: controller,
                physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: IntrinsicHeight(
                    child: Material(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
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
                            Container(
                              height: 40.0,
                              child: TextField(
                                onChanged: widget.querySink.add,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 0.0),
                                  fillColor: Color(0xFFEDEAF9),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide:
                                        BorderSide(style: BorderStyle.none),
                                  ),
                                  prefixIcon: Icon(
                                    NovaIcons.search,
                                    color: const Color(0xFF533781),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 27.0),
                            if (widget.tags != null) ...[
                              Flexible(
                                child: SkillsSelector(
                                  crossAxisCount: 1,
                                  onSelected: (skill) {
                                    tags.add(skill);
                                    widget.tagsSink.add(tags);
                                    return true;
                                  },
                                  onDeselected: (skill) {
                                    tags.remove(skill);
                                    widget.tagsSink.add(tags);
                                    return true;
                                  },
                                  skills: widget.tags,
                                ),
                              ),
                              const SizedBox(height: 27.0),
                            ],
                            Builder(
                              builder: (context) {
                                return StreamBuilder<List<T>>(
                                  stream: widget.searchStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data.isNotEmpty) {
                                      return widget.builder(snapshot.data);
                                    } else if (snapshot.hasError) {
                                      print(snapshot.error);
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
                                    return Container();
                                  },
                                );
                              },
                            ),
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
}

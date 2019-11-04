import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../misc/misc.dart';

/// экран О приложении
class AboutDialog extends StatelessWidget {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 22.0),
                      Row(
                        children: <Widget>[
                          Text(
                            'О приложении',
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
                      Text(
                        'Nova App',
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(color: const Color(0xFF533781)),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Версия 1.0',
                        style: Theme.of(context).textTheme.body1,
                      ),
                      SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () async {
                          await launch(
                            'https://nova-app.ru',
                            enableJavaScript: true,
                            forceWebView: true,
                          );
                        },
                        child: Text(
                          'nova-app.ru',
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      const SizedBox(height: 22.0),
                      Text(
                        'Разработчик',
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(color: const Color(0xFF533781)),
                      ),
                      SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          launch(
                            'https://purpleplane.ru',
                            enableJavaScript: true,
                            forceWebView: true,
                          );
                        },
                        child: Text(
                          'Purpleplane purpleplane.ru',
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      const SizedBox(height: 22.0),
                      Text(
                        'Дизайн',
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(color: const Color(0xFF533781)),
                      ),
                      SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          launch(
                            'https://fourburo.ru',
                            enableJavaScript: true,
                            forceWebView: true,
                          );
                        },
                        child: Text(
                          'Бюро "Четыре" fourburo.ru',
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      const SizedBox(height: 22.0),
                      Text(
                        'Партнеры',
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(color: const Color(0xFF533781)),
                      ),
                      SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          launch(
                            'https://fadm.gov.ru/',
                            enableJavaScript: true,
                            forceWebView: true,
                          );
                        },
                        child: Text(
                          'Росмолодежь fadm.gov.ru',
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          launch(
                            'http://роспредприниматель.рф/',
                            enableJavaScript: true,
                            forceWebView: true,
                          );
                        },
                        child: Text(
                          'Роспредприниматель роспредприниматель.рф',
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          launch(
                            'http://deltacosmos.com/',
                            enableJavaScript: true,
                            forceWebView: true,
                          );
                        },
                        child: Text(
                          'DeltaCosmos deltacosmos.com',
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          launch(
                            'http://www.cfe.ru/',
                            enableJavaScript: true,
                            forceWebView: true,
                          );
                        },
                        child: Text(
                          'Центр предпринимательства cfe.ru',
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      const SizedBox(height: 16.0),
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

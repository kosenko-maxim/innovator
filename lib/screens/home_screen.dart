import 'package:flutter/material.dart';

import '../misc/misc.dart';
import '../screens/screens.dart';
import '../widgets/widgets.dart';

/// виджет в котором находится [BottomNavigationBar], является родителем остальных экранов
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const _pages = [
    {
      'icon': NovaIcons.project,
      'title': 'Проекты',
      'body': const ProjectsScreen(key: PageStorageKey<String>('projects')),
    },
    {
      'icon': NovaIcons.people,
      'title': 'Люди',
      'body': const PeoplesScreen(key: PageStorageKey<String>('peoples')),
    },
    {
      'icon': NovaIcons.vacancy,
      'title': 'Вакансии',
      'body': const VacanciesScreen(key: PageStorageKey<String>('vacancies')),
    },
    {
      'icon': NovaIcons.chat,
      'title': 'Сообщения',
      'body': const ChatScreen(key: PageStorageKey<String>('chat')),
    },
    {
      'icon': NovaIcons.management,
      'title': 'Управление',
      'body': const ManagementScreen(key: PageStorageKey<String>('management')),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: Theme.of(context).textTheme.body2.fontSize,
        unselectedFontSize: Theme.of(context).textTheme.body2.fontSize,
        onTap: _selectTab,
        currentIndex: _currentIndex,
        items: _pages.map(
          (page) {
            return BottomNavigationBarItem(
              icon: Icon(page['icon']),
              title: Text(
                page['title'],
                style: Theme.of(context).textTheme.body2,
              ),
            );
          },
        ).toList(),
      ),
      body: Stack(
        children: <Widget>[
          const GradientBackground(),
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: _pages.map<Widget>((page) => page['body']).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _selectTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  void dispose() {
    super.dispose();
  }
}

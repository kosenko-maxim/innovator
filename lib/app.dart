import 'package:flutter/material.dart';

import 'screens/screens.dart';

/// корневой виджет
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: const Color(0xFFFFFFFF),
        textTheme: TextTheme(
          display4: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.w500,
            fontSize: 26.0,
            letterSpacing: 0.16,
          ),
          display3: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.w300,
            fontSize: 32.0,
            letterSpacing: 0.16,
          ),
          display2: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.w500,
            fontSize: 22.0,
            letterSpacing: 0.16,
          ),
          display1: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
            letterSpacing: 0.16,
          ),
          subtitle: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.w400,
            fontSize: 16.0,
          ),
          body1: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.w300,
            fontSize: 14.0,
          ),
          body2: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.w300,
            fontSize: 12.0,
            color: const Color(0xFF533781),
          ),
          button: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.w400,
            fontSize: 16.0,
            color: const Color(0xFF7E4599),
          ),
        ),
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        buttonTheme: ButtonThemeData(
          height: 48.0,
          textTheme: ButtonTextTheme.normal,
        ),
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (context) => HomeScreen(),
        '/auth': (context) => AuthenticationScreen(),
        '/splash': (context) => SplashScreen(),
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

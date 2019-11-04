import 'package:flutter/material.dart';

import '../blocs/blocs.dart';
import '../widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// сплэшскрин, показывается во время запуска, для проверки аутентификации
class _SplashScreenState extends State<SplashScreen> {
  final _bloc = SplashBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      bloc: _bloc,
      child: StreamBuilder<bool>(
        stream: _bloc.isAuthenticated,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed(
                snapshot.data ? '/home' : '/auth',
              );
            });
          } else if (snapshot.hasError) {}
          return Material(
            color: const Color(0xFFFFFFFF),
            child: Center(
              child: NovaProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../blocs/blocs.dart';
import '../misc/nova_icons.dart';
import '../widgets/widgets.dart';

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

/// экран аутентификации
class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _bloc = AuthenticationBloc();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF333333),
      body: Builder(
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.59,
            builder: (context, controller) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    controller: controller,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                        // minWidth: constraints.maxWidth,
                      ),
                      child: Material(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: _buildAuthOption(_currentIndex),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAuthOption(int index) {
    switch (index) {
      case 0:
        return _buildRegistration(context);
        break;
      case 1:
        return _buildLogin(context);
        break;
      case 2:
        return _buildReset(context);
        break;
      default:
        return Container();
    }
  }

  Widget _buildReset(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: 19.0),
        Text(
          'Восстановление пароля',
          style: Theme.of(context)
              .textTheme
              .display2
              .copyWith(color: const Color(0xFF533781)),
        ),
        const SizedBox(height: 18.0),
        StreamBuilder<String>(
          stream: _bloc.emailObservable,
          builder: (context, snapshot) {
            return TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: _bloc.email.add,
              decoration: InputDecoration(
                labelText: 'Логин',
                errorText: snapshot.error,
              ),
            );
          },
        ),
        const SizedBox(height: 22.0),
        StreamBuilder<String>(
          stream: _bloc.emailObservable,
          builder: (context, snapshot) {
            return NovaButton(
              color: const Color(0xFF80469B),
              disabledColor: const Color(0xFFEDEAF9),
              child: Text('Восстановить'),
              onPressed: snapshot.hasData
                  ? () {
                      _bloc.reset(email: snapshot.data).then((_) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) {
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('Проверьте электронную почту'),
                                backgroundColor: const Color(0xFF80469B),
                              ),
                            );
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                        );
                      });
                    }
                  : null,
            );
          },
        ),
      ],
    );
  }

  Widget _buildRegistration(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: 19.0),
        Text(
          'Регистрация',
          style: Theme.of(context)
              .textTheme
              .display2
              .copyWith(color: const Color(0xFF533781)),
        ),
        const SizedBox(height: 8.0),
        NovaButton(
          color: const Color(0xFFFFFFFF),
          child: Text('С помощью e-mail'),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          onPressed: () {
            _showRegistrationDialog(context);
          },
        ),
        const SizedBox(height: 20.0),
        GestureDetector(
          onTap: () {
            setState(() {
              _currentIndex = 1;
            });
          },
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'У меня уже есть аккаунт',
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: const Color(0xFF533781)),
            ),
          ),
        ),
        const SizedBox(height: 70.0),
      ],
    );
  }

  Widget _buildLogin(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: 19.0),
        Text(
          'Вход',
          style: Theme.of(context)
              .textTheme
              .display2
              .copyWith(color: const Color(0xFF533781)),
        ),
        const SizedBox(height: 18.0),
        StreamBuilder<String>(
          stream: _bloc.emailObservable,
          builder: (context, snapshot) {
            return TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: _bloc.email.add,
              decoration: InputDecoration(
                labelText: 'Логин',
                errorText: snapshot.error,
              ),
            );
          },
        ),
        const SizedBox(height: 22.0),
        StreamBuilder<String>(
          stream: _bloc.passwordObservable,
          builder: (context, snapshot) {
            return TextField(
              obscureText: true,
              onChanged: _bloc.password.add,
              decoration: InputDecoration(
                labelText: 'Пароль',
                errorText: snapshot.error,
              ),
            );
          },
        ),
        const SizedBox(height: 48.0),
        StreamBuilder<Map<String, String>>(
          stream: _bloc.credentialsObservable,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('${snapshot.error}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              );
            }
            return NovaButton(
              color: const Color(0xFF80469B),
              disabledColor: const Color(0xFFEDEAF9),
              child: Text('Войти'),
              onPressed: snapshot.hasData
                  ? () {
                      _bloc.login(credentials: snapshot.data).then(
                            (_) => Navigator.of(context)
                                .pushReplacementNamed('/home'),
                          );
                    }
                  : null,
            );
          },
        ),
        const SizedBox(height: 28.0),
        GestureDetector(
          onTap: () {
            setState(() {
              _currentIndex = 0;
            });
          },
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Зарегистрироваться',
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: const Color(0xFF533781)),
            ),
          ),
        ),
        const SizedBox(height: 28.0),
        GestureDetector(
          onTap: () {
            setState(() {
              _currentIndex = 2;
            });
          },
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Забыли пароль?',
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: const Color(0xFF533781)),
            ),
          ),
        ),
        const SizedBox(height: 70.0),
      ],
    );
  }

  void _showRegistrationDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Builder(builder: (context) => _RegistrationDialog());
      },
    );
  }

  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class _RegistrationDialog extends StatefulWidget {
  @override
  _RegistrationDialogState createState() => _RegistrationDialogState();
}

class _RegistrationDialogState extends State<_RegistrationDialog> {
  final _bloc = RegistrationBloc();

  TextEditingController _cityController = TextEditingController();
  bool _countryAdded = false;
  List<String> skills = [];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 300),
      child: Material(
        color: const Color(0xFFFFFFFF),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 22.0),
                      Row(
                        children: <Widget>[
                          Text(
                            'Регистрация',
                            style: Theme.of(context)
                                .textTheme
                                .display2
                                .copyWith(color: const Color(0xFF533781)),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: Navigator.of(context).pop,
                            color: const Color(0xFF533781),
                            iconSize: 18.0,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18.0),
                      Flexible(
                        child: Row(
                          children: <Widget>[
                            StreamBuilder<File>(
                              stream: _bloc.avatarObservable,
                              builder: (context, snapshot) {
                                return GestureDetector(
                                  onTap: _pickImage,
                                  child: CircleAvatar(
                                    radius: 50.0,
                                    child: snapshot.hasData
                                        ? Container()
                                        : Icon(NovaIcons.add),
                                    backgroundImage: snapshot.hasData
                                        ? FileImage(snapshot.data)
                                        : null,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 24.0),
                            Flexible(
                              child: Column(
                                children: <Widget>[
                                  StreamBuilder<String>(
                                    stream: _bloc.firstnameObservable,
                                    builder: (context, snapshot) {
                                      return TextField(
                                        onChanged: _bloc.firstname.add,
                                        decoration: InputDecoration(
                                          labelText: 'Имя',
                                          errorText: snapshot.error,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 22.0),
                                  StreamBuilder<String>(
                                    stream: _bloc.lastnameObservable,
                                    builder: (context, snapshot) {
                                      return TextField(
                                        onChanged: _bloc.lastname.add,
                                        decoration: InputDecoration(
                                          labelText: 'Фамилия',
                                          errorText: snapshot.error,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22.0),
                      StreamBuilder<String>(
                        stream: _bloc.cityObservable,
                        builder: (context, snapshot) {
                          return TextField(
                            controller: _cityController,
                            onChanged: (city) {
                              if (!_countryAdded) {
                                _cityController.value =
                                    _cityController.value.copyWith(
                                  text: _cityController.text + ', Россия',
                                );
                                _countryAdded = true;
                                _bloc.city.add(_cityController.text);
                              }
                              _bloc.city.add(city);
                            },
                            decoration: InputDecoration(
                              labelText: 'Город',
                              errorText: snapshot.error,
                              hintText: 'Город, страна',
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 22.0),
                      // StreamBuilder<String>(
                      //   stream: _bloc.skillsObservable,
                      //   builder: (context, snapshot) {
                      //     return TextField(
                      //       onChanged: _bloc.skills.add,
                      //       decoration: InputDecoration(
                      //         labelText: 'Навыки',
                      //         errorText: snapshot.error,
                      //       ),
                      //     );
                      //   },
                      // ),
                      // const SizedBox(height: 22.0),
                      StreamBuilder<String>(
                        stream: _bloc.educationObservable,
                        builder: (context, snapshot) {
                          return TextField(
                            onChanged: _bloc.education.add,
                            decoration: InputDecoration(
                              labelText: 'Образование',
                              errorText: snapshot.error,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 22.0),
                      StreamBuilder<String>(
                        stream: _bloc.jobsObservable,
                        builder: (context, snapshot) {
                          return TextField(
                            onChanged: _bloc.jobs.add,
                            decoration: InputDecoration(
                              labelText: 'Работа',
                              errorText: snapshot.error,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 22.0),
                      StreamBuilder<String>(
                        stream: _bloc.emailObservable,
                        builder: (context, snapshot) {
                          return TextField(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: _bloc.email.add,
                            decoration: InputDecoration(
                              labelText: 'e-mail',
                              errorText: snapshot.error,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 22.0),
                      StreamBuilder<String>(
                        stream: _bloc.passwordObservable,
                        builder: (context, snapshot) {
                          return TextField(
                            onChanged: _bloc.password.add,
                            decoration: InputDecoration(
                              labelText: 'Пароль',
                              errorText: snapshot.error,
                            ),
                            obscureText: true,
                          );
                        },
                      ),
                      const SizedBox(height: 22.0),
                      Expanded(
                        child: Container(
                          height: 124.0,
                          child: SkillsSelector(
                            crossAxisCount: 3,
                            onSelected: (skill) {
                              if (skills.length >= 5) return false;
                              skills.add(skill);
                              _bloc.skills.add(skills.join(','));
                              return true;
                            },
                            onDeselected: (skill) {
                              if (skills.length <= 0) return false;
                              skills.remove(skill);
                              _bloc.skills.add(skills.join(','));
                              return true;
                            },
                            skills: [
                              'Креативность',
                              'Убедительность',
                              'Сотрудничество',
                              'Адаптивность',
                              'Организованность',
                              'Ответственность',
                              'Управление временем',
                              'Целеустремленность',
                              'Амбициозность',
                              'Терпеливость',
                              'Быстрая реакция',
                              'Обучаемость',
                              'Саморазвитие',
                              'Cloud computing',
                              'Искусственный интеллект',
                              'Analitical Reasoning',
                              'Управление людьми',
                              'UX-дизайн',
                              'SMM (Social Media Marketing) - привлечение внимания к бренду через социальные сети',
                              'Разработка мобильных приложений',
                              'Облачные вычисления для прогнозирования роста облачных сервисов',
                              'Знание языков программирования Perl, Python и Ruby',
                              'Анализ статистики и Data Mining (интеллектуальный анализ данных)',
                              'Дизайн пользовательских интерфейсов',
                              'Диджитал и Онлайн-маркетинг',
                              'Подбор персонала',
                              'Развитие бизнеса',
                              'Системы электронных платежей',
                              'Бизнес-аналитика',
                              'Создание баз данных',
                              'Веб-программирование',
                              'Разработка алгоритмов',
                              'Управление базами данных',
                              'Компьютерная графика и анимация',
                              'Языки программирования C и C++',
                              'Разработка связующего программного обеспечения',
                              'Развитие Java-приложений',
                              'Обеспечение качества и юзабилити программного обеспечения',
                              'Пиар',
                              'Управление проектами по созданию программного обеспечения',
                              'Обеспечение информационной безопасности',
                              'Стратегическое планирование',
                              'Создание и управление системами хранения данных',
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      StreamBuilder<File>(
                        stream: _bloc.avatarObservable,
                        builder: (_, image) {
                          return StreamBuilder<Map<String, String>>(
                            stream: _bloc.dataObservable,
                            builder: (context, snapshot) {
                              return NovaButton(
                                color: const Color(0xFF80469B),
                                disabledColor: const Color(0xFFEDEAF9),
                                child: Text('Создать'),
                                onPressed: snapshot.hasData
                                    ? () {
                                        _bloc.submit(snapshot.data, image.data);
                                        Navigator.of(context).pop();
                                        _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text('Все прошло успешно'),
                                        ));
                                      }
                                    : null,
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 70.0),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _pickImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    _bloc.avatar.add(image);
  }

  void dispose() {
    _bloc.dispose();
    _cityController.dispose();
    super.dispose();
  }
}

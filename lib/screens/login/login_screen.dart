import 'dart:math' show min, pi;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo/screens/settings/settings_screen.dart';
import 'package:toptodo/utils/colors.dart';
import 'package:toptodo_data/toptodo_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Widget _verticalSpace = const SizedBox(height: 10);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LoginBloc>(context)..add(const AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to TOPtodo'),
        ),
        body: BlocListener<LoginBloc, LoginState>(
          listener: (BuildContext context, LoginState state) {
            if (state is LoginSuccessNoSettings) {
              Navigator.of(context).pushReplacement<dynamic, SettingsScreen>(
                MaterialPageRoute<SettingsScreen>(
                  builder: (_) => SettingsScreen(),
                ),
              );
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (BuildContext context, LoginState state) {
              if (state is LoginWaitingForSavedData) {
                return buildLoading();
              } else if (state is RetrievedSavedData) {
                return buildInputFields(context, state.savedData);
              } else if (state is LoginSuccessNoSettings) {
                return const Text('Login success!');
              } else {
                print('State: $state');
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildInputFields(BuildContext context, Credentials savedData) {
    final TextEditingController urlController = TextEditingController()
      ..text = savedData.url ?? '';
    final TextEditingController loginNameController = TextEditingController()
      ..text = savedData.loginName ?? '';
    final TextEditingController passwordController = TextEditingController()
      ..text = savedData.password ?? '';

    return Stack(
      children: <Widget>[
        CustomPaint(
          painter: _MyPainter(),
          child: Container(),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: urlController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'TOPdesk url',
                    hintText: 'https://your-environment.topdesk.net',
                  ),
                  validator: (String value) => value.isEmpty
                      ? 'fill in the url of your TOPdesk environment'
                      : null,
                ),
                _verticalSpace,
                TextFormField(
                  autocorrect: false,
                  controller: loginNameController,
                  decoration: InputDecoration(
                    labelText: 'login name',
                  ),
                ),
                _verticalSpace,
                TextFormField(
                  autocorrect: false,
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'application password',
                  ),
                ),
                _verticalSpace,
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => _connect(
                        context,
                        Credentials(
                          url: urlController.text,
                          loginName: loginNameController.text,
                          password: passwordController.text,
                        ),
                      ),
                      child: Image.asset('assets/button_denim.png'),
                    ),
                    Text(
                      'login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _connect(BuildContext context, Credentials credentials) {
    BlocProvider.of<LoginBloc>(context)..add(TryLogin(credentials));
  }
}

class _MyPainter extends CustomPainter {
  static const int _bottomMargin = 25;
  static final Paint _paint = Paint()..color = forest100;

  @override
  void paint(Canvas canvas, Size size) {
    final double ratio = size.width / (size.height - _bottomMargin);
    if (ratio >= 1) {
      quarterCircle(size, canvas);
    } else if (ratio >= .6) {
      mediumShape(size, canvas);
    } else {
      longShape(size, canvas);
    }
  }

  void quarterCircle(Size size, Canvas canvas) {
    final double radius = size.height - _bottomMargin;
    final Rect rect = Offset(-radius, -radius) & Size(radius * 2, radius * 2);
    canvas.drawArc(rect, 0, pi / 2, true, _paint);
  }

  void mediumShape(Size size, Canvas canvas) {
    final double radius = size.width - _bottomMargin;
    final Rect rect = Offset(-radius, 0) & Size(radius * 2, radius * 2);

    canvas.drawArc(rect, 0, pi / 2, true, _paint);
    canvas.drawRect(const Offset(0, 0) & Size(radius, radius), _paint);
  }

  void longShape(Size size, Canvas canvas) {
    final double radius = (size.height - _bottomMargin) / 3;
    final double blockHeight = size.height - _bottomMargin - radius;

    final Rect rect =
        Offset(-radius, blockHeight - radius) & Size(2 * radius, 2 * radius);
    canvas.drawArc(rect, 0, pi / 2, true, _paint);

    canvas.drawRect(const Offset(0, 0) & Size(radius, blockHeight), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

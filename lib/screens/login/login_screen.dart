import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo/screens/settings/settings_screen.dart';
import 'package:toptodo/widgets/td_button.dart';
import 'package:toptodo/widgets/td_shapes.dart';
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
                return buildLoading();
              } else if (state is LoginSubmitting) {
                return buildLoading();
              } else {
                throw StateError('unknown state: $state');
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
          painter: TdShape(),
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
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: true,
                      onChanged: (bool value) {
                        print(value);
                      },
                    ),
                    const Text('remember'),
                  ],
                ),
                _verticalSpace,
                TdButton(
                  text: 'log in',
                  onTap: () => _connect(
                    context,
                    Credentials(
                      url: urlController.text,
                      loginName: loginNameController.text,
                      password: passwordController.text,
                    ),
                  ),
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

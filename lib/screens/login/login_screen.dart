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
                return _CredentialsForm.withSavedDate(
                  state.savedData,
                  state.remember,
                );
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
}

class _CredentialsForm extends StatelessWidget {
  _CredentialsForm.withSavedDate(Credentials savedData, bool remember)
      : _urlController = TextEditingController()..text = savedData.url ?? '',
        _loginNameController = TextEditingController()
          ..text = savedData.loginName ?? '',
        _passwordController = TextEditingController()
          ..text = savedData.password ?? '',
        _remember = remember;

  final TextEditingController _urlController;
  final TextEditingController _loginNameController;
  final TextEditingController _passwordController;
  final bool _remember;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Widget _verticalSpace = const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
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
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _urlController,
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
                  controller: _loginNameController,
                  decoration: InputDecoration(
                    labelText: 'login name',
                  ),
                  validator: (String value) =>
                      value.isEmpty ? 'fill in your login name' : null,
                ),
                _verticalSpace,
                TextFormField(
                  autocorrect: false,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'application password',
                  ),
                  validator: (String value) => value.isEmpty
                      ? 'fill in your application password'
                      : null,
                ),
                _verticalSpace,
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _remember,
                      onChanged: (bool value) {
                        BlocProvider.of<LoginBloc>(context)
                          ..add(RememberToggle(_createCredentials(), value));
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
                    _createCredentials(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Credentials _createCredentials() => Credentials(
        url: _urlController.text,
        loginName: _loginNameController.text,
        password: _passwordController.text,
      );

  void _connect(BuildContext context, Credentials credentials) {
    if (_formKey.currentState.validate()) {
      BlocProvider.of<LoginBloc>(context)..add(TryLogin(credentials));
    }
  }
}

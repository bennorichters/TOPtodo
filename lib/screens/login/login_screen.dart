import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptopdo/screens/settings/settings_screen.dart';
import 'package:toptodo_data/toptodo_data.dart';

import 'bloc/bloc.dart';

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
          title: const Text('login'),
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

    return Padding(
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
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 5.0),
                ),
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
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 5.0),
                ),
                hintText: 'login name',
              ),
            ),
            _verticalSpace,
            TextFormField(
              autocorrect: false,
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 5.0),
                ),
                hintText: 'application password',
              ),
            ),
            _verticalSpace,
            FloatingActionButton(
              onPressed: () => _connect(
                context,
                Credentials(
                  url: urlController.text,
                  loginName: loginNameController.text,
                  password: passwordController.text,
                ),
              ),
              child: Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
    );
  }

  void _connect(BuildContext context, Credentials credentials) {
    BlocProvider.of<LoginBloc>(context)..add(TryLogin(credentials));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptopdo/data/model/credentials.dart';
import 'package:toptopdo/screens/settings/settings_screen.dart';

import 'bloc/bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _verticalSpace = SizedBox(height: 10);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LoginBloc>(context)..add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('login'),
        ),
        body: BlocListener<LoginBloc, LoginState>(listener: (context, state) {
          if (state is LoginSuccess) {
            print('Settings ${state.settings}');
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => SettingsScreen(
                  credentials: state.credentials,
                ),
              ),
            );
          }
        }, child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginWaitingForSavedData) {
              return buildLoading();
            } else if (state is RetrievedSavedData) {
              return buildInputFields(context, state.savedData);
            } else if (state is LoginSuccess) {
              return Text('Login success!');
            } else {
              print('State: $state');
              return Container();
            }
          },
        )),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildInputFields(BuildContext context, Credentials savedData) {
    final urlController = TextEditingController()..text = savedData.url ?? '';
    final loginNameController = TextEditingController()
      ..text = savedData.loginName ?? '';
    final passwordController = TextEditingController()
      ..text = savedData.password ?? '';

    return Padding(
      padding: EdgeInsets.all(15),
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

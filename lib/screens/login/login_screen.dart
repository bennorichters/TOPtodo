import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo/constants/keys.dart' as ttd_keys;
import 'package:toptodo/screens/login/widgets/credentials_form.dart';
import 'package:toptodo/screens/login/widgets/login_help_dialog.dart';
import 'package:toptodo/widgets/error_dialog.dart';

class LoginScreenArguments {
  const LoginScreenArguments({@required this.logOut});
  final bool logOut;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({@required this.logOut, Key key}) : super(key: key);
  final bool logOut;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<LoginBloc>(context)
        .add(widget.logOut ? const LogOut() : const CredentialsInit());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to TOPtodo'),
          actions: [
            IconButton(
              key: Key(ttd_keys.loginScreenHelpButton),
              icon: const Icon(Icons.help),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => LoginHelpDialog(),
                );
              },
            )
          ],
        ),
        body: BlocListener<LoginBloc, LoginState>(
          listener: (BuildContext context, LoginState state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacementNamed(
                context,
                state.settings.isComplete() ? 'incident' : 'settings',
              );
            } else if (state is LoginFailed) {
              showDialog(
                context: context,
                builder: (BuildContext context) => ErrorDialog(
                  cause: state.cause,
                  stackTrace: state.stackTrace,
                  activeScreenIsLogin: true,
                ),
              );
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (BuildContext context, LoginState state) {
              if (state is WithCredentials) {
                return CredentialsForm.withSavedDate(
                  state.credentials,
                  state.remember,
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}

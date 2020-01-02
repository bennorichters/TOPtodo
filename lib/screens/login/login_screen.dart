import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo/screens/incident/incident_screen.dart';
import 'package:toptodo/screens/login/widgets/credentials_form.dart';
import 'package:toptodo/screens/settings/settings_screen.dart';
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
      ..add(widget.logOut ? const LogOut() : const CredentialsInit());
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
            if (state is LoginSuccessIncompleteSettings) {
              Navigator.of(context).pushReplacement<dynamic, SettingsScreen>(
                MaterialPageRoute<SettingsScreen>(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            } else if (state is LoginSuccessValidSettings) {
              Navigator.of(context).pushReplacement<dynamic, IncidentScreen>(
                MaterialPageRoute<IncidentScreen>(
                  builder: (_) => const IncidentScreen(),
                ),
              );
            } else if (state is LoginFailed) {
              showDialog(
                context: context,
                builder: (BuildContext context) => ErrorDialog(
                  cause: state.cause,
                  activeScreenIsLogin: true,
                ),
              );
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (BuildContext context, LoginState state) {
              if (state is LoginWaitingForSavedData) {
                return buildLoading();
              } else if (state is WithSavedData) {
                return CredentialsForm.withSavedDate(
                  state.savedData,
                  state.remember,
                );
              } else if (state is LoginSuccess) {
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

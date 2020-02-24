import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/init/bloc.dart';
import 'package:toptodo/screens/init/widgets/init_data_progress.dart';
import 'package:toptodo/screens/login/login_screen.dart';
import 'package:toptodo/widgets/error_dialog.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<InitBloc>(context).add(const RequestInitData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to TOPtodo'),
      ),
      body: BlocListener<InitBloc, InitState>(
        listener: (BuildContext context, InitState state) {
          if (state is LoadingDataFailed) {
            showDialog(
              context: context,
              builder: (BuildContext context) => ErrorDialog(
                cause: state.cause,
                stackTrace: state.stackTrace,
                activeScreenIsLogin: false,
              ),
            );
          } else if (state is InitData) {
            if (state.hasIncompleteCredentials()) {
              Navigator.pushReplacementNamed(
                context,
                'login',
                arguments: LoginScreenArguments(logOut: false),
              );
            } else if (state.hasIncompleteSettings()) {
              Navigator.pushReplacementNamed(context, 'settings');
            } else if (state.isReady()) {
              Navigator.pushReplacementNamed(context, 'incident');
            }
          }
        },
        child: BlocBuilder<InitBloc, InitState>(
          builder: (BuildContext context, InitState state) {
            if (state is InitData) {
              return InitDataProgress(state);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

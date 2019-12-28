import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/init/bloc.dart';
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
    BlocProvider.of<InitBloc>(context)..add(const RequestInitData());
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
                state.cause,
                onClose: (BuildContext context) {
                  // TODO: Navigate to login screen
                },
              ),
            );
          }
        },
        child: BlocBuilder<InitBloc, InitState>(
          builder: (BuildContext context, InitState state) {
            if (state is InitData) {
              return _InitDataProgress(state);
            } else {
              // TODO:
              return Text('Something todo here $state');
            }
          },
        ),
      ),
    );
  }
}

class _InitDataProgress extends StatelessWidget {
  const _InitDataProgress(this.state);
  final InitData state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state.credentials == null
                  ? CircularProgressIndicator()
                  : Icon(Icons.done),
              const Text('credentials'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state.currentOperator == null
                  ? CircularProgressIndicator()
                  : Icon(Icons.done),
              const Text('your operator profile'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state.settings == null
                  ? CircularProgressIndicator()
                  : Icon(Icons.done),
              const Text('settings'),
            ],
          ),
        ],
      ),
    );
  }
}

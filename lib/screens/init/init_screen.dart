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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.done),
                      const Text('credentials'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.done),
                      const Text('your operator profile'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.done),
                      const Text('settings'),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/init/bloc.dart';
import 'package:toptodo/screens/login/login_screen.dart';
import 'package:toptodo/utils/colors.dart';
import 'package:toptodo/widgets/error_dialog.dart';
import 'package:toptodo/widgets/td_shape.dart';

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
                cause: state.cause,
                activeScreenIsLogin: false,
              ),
            );
          } else if (state is IncompleteCredentials) {
            Navigator.pushReplacementNamed(
              context,
              'login',
              arguments: LoginScreenArguments(logOut: false),
            );
          } else if ((state is InitData) && state.isComplete()) {
            if (state.settings.isComplete()) {
              Navigator.pushReplacementNamed(context, 'incident');
            } else {
              Navigator.pushReplacementNamed(context, 'settings');
            }
          }
        },
        child: BlocBuilder<InitBloc, InitState>(
          builder: (BuildContext context, InitState state) {
            if (state is InitData) {
              return _InitDataProgress(state);
            } else {
              return Container();
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

  static const _progressDiameter = 25.0;
  static const _padding = 10.0;
  static const _firstColumnWidth = _progressDiameter + 2 * _padding;

  @override
  Widget build(BuildContext context) {
    return TdShapeBackground(
      color: TdColors.duckEgg,
      longSide: LongSide.top,
      child: Center(
        child: Table(
          columnWidths: {
            0: FixedColumnWidth(_firstColumnWidth),
            1: IntrinsicColumnWidth(),
          },
          children: [
            TableRow(
              children: _rowChildren(
                'credentials',
                state.credentials,
              ),
            ),
            TableRow(
              children: _rowChildren(
                'settings',
                state.settings,
              ),
            ),
            TableRow(
              children:
                  _rowChildren('your operator profile', state.currentOperator),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _rowChildren(String text, Object objectToLoad) {
    return [
      Padding(
        padding: const EdgeInsets.all(_padding),
        child: SizedBox(
          height: _progressDiameter,
          child: objectToLoad == null
              ? CircularProgressIndicator()
              : Icon(
                  Icons.done,
                  color: TdColors.moss,
                ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: _padding),
          child: Text(
            text,
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
    ];
  }
}

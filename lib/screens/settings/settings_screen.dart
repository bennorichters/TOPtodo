import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo/screens/settings/widgets/settings_form.dart';
import 'package:toptodo/constants/colors.dart' as ttd_colors;
import 'package:toptodo/widgets/error_dialog.dart';
import 'package:toptodo/widgets/menu_operator_button.dart';
import 'package:toptodo/widgets/td_shape.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SettingsBloc>(context)..add(SettingsInit());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (BuildContext context, SettingsState state) {
        if (state is SettingsSaved) {
          Navigator.pushReplacementNamed(context, 'incident');
        }
      },
      child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (BuildContext context, SettingsState state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            actions: [
              if (state is SettingsWithOperator)
                MenuOperatorButton(
                  state.currentOperator,
                  showSettings: false,
                ),
            ],
          ),
          body: BlocListener<SettingsBloc, SettingsState>(
            listener: (BuildContext context, SettingsState state) {
              if (state is SettingsError) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => ErrorDialog(
                    cause: state.cause,
                    stackTrace: state.stackTrace,
                    activeScreenIsLogin: false,
                  ),
                );
              }
            },
            child: (state is SettingsWithForm)
                ? SettingsForm(state)
                : const TdShapeBackground(
                    longSide: LongSide.right,
                    color: ttd_colors.duckEgg,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/incident/bloc.dart';
import 'package:toptodo/constants/colors.dart' as ttd_colors;
import 'package:toptodo/screens/incident/widgets/incident_form.dart';
import 'package:toptodo/widgets/error_dialog.dart';
import 'package:toptodo/widgets/menu_operator_button.dart';

class IncidentScreen extends StatefulWidget {
  const IncidentScreen({Key key}) : super(key: key);

  @override
  _IncidentScreenState createState() => _IncidentScreenState();
}

class _IncidentScreenState extends State<IncidentScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<IncidentBloc>(context).add(const IncidentInit());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncidentBloc, IncidentState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create todo'),
            actions: [
              if (state.currentOperator != null)
                MenuOperatorButton(state.currentOperator),
            ],
          ),
          body: BlocListener<IncidentBloc, IncidentState>(
            listener: _onEvent,
            child: IncidentForm(state),
          ),
        );
      },
    );
  }

  void _onEvent(context, state) {
    if (state is IncidentCreated) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ttd_colors.moss,
          content: Text('Incident created with number ${state.number}'),
        ),
      );
    } else if (state is IncidentCreationError) {
      showDialog(
        context: context,
        builder: (BuildContext context) => ErrorDialog(
          cause: state.cause,
          stackTrace: state.stackTrace,
          activeScreenIsLogin: false,
        ),
      );
    }
  }
}

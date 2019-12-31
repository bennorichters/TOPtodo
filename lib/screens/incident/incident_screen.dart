import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/incident/bloc.dart';
import 'package:toptodo/utils/colors.dart';
import 'package:toptodo/widgets/error_dialog.dart';
import 'package:toptodo/widgets/menu_operator_button.dart';
import 'package:toptodo/widgets/td_button.dart';

class IncidentScreen extends StatefulWidget {
  const IncidentScreen({Key key}) : super(key: key);

  @override
  _IncidentScreenState createState() => _IncidentScreenState();
}

class _IncidentScreenState extends State<IncidentScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<IncidentBloc>(context)..add(IncidentShowForm());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IncidentBloc, IncidentState>(
      listener: (context, state) {
        if (state is IncidentCreated) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: moss,
              content: Text('Incident created with number ${state.number}'),
            ),
          );
        } else if (state is IncidentCreationError) {
          showDialog(
            context: context,
            builder: (BuildContext context) => ErrorDialog(
              cause: state.cause,
              activeScreenIsLogin: false,
            ),
          );
        }
      },
      child: BlocBuilder<IncidentBloc, IncidentState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Create todo'),
              actions: [
                if (state is WithOperatorState)
                  MenuOperatorButton(state.currentOperator),
              ],
            ),
            body: _IncidentForm(state),
          );
        },
      ),
    );
  }
}

class _IncidentForm extends StatelessWidget {
  _IncidentForm(this.state);
  final IncidentState state;

  final _formKey = GlobalKey<FormState>();

  final _verticalSpace = const SizedBox(height: 10);
  final _briefDescription = TextEditingController();
  final _request = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _briefDescription,
              decoration: InputDecoration(labelText: 'Brief description'),
              validator: (value) =>
                  value.isEmpty ? 'Fill in a brief description' : null,
            ),
            _verticalSpace,
            TextFormField(
              controller: _request,
              decoration: InputDecoration(labelText: 'Request'),
              maxLength: null,
              maxLines: null,
            ),
            _verticalSpace,
            (state is SubmittingIncident)
                ? CircularProgressIndicator()
                : TdButton(
                    text: 'submit',
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        BlocProvider.of<IncidentBloc>(context)
                          ..add(
                            IncidentSubmit(
                              briefDescription: _briefDescription.text,
                              request: _request.text,
                            ),
                          );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

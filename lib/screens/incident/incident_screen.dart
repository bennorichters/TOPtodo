import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/incident/bloc.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo/screens/login/login_screen.dart';
import 'package:toptodo/screens/settings/settings_screen.dart';
import 'package:toptodo/utils/colors.dart';
import 'package:toptodo/widgets/td_button.dart';

typedef NavigateToScreen = Function(BuildContext context);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create todo'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          FlatButton(
            child: const Text(
              'log out',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              BlocProvider.of<LoginBloc>(context)..add(const LogOut());

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocListener<IncidentBloc, IncidentState>(
        listener: (context, state) {
          if (state is IncidentCreated) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: moss,
                content: Text('Incdent created with number ${state.number}'),
              ),
            );
          }
        },
        child: BlocBuilder<IncidentBloc, IncidentState>(
          builder: (context, state) => _IncidentForm(state),
        ),
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

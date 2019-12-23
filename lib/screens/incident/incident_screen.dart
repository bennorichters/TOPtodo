import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/incident/bloc.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo/screens/login/login_screen.dart';
import 'package:toptodo/screens/settings/settings_screen.dart';
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
              MaterialPageRoute(builder: (_) => SettingsScreen()),
            ),
          ),
          FlatButton(
            child: const Text(
              'log out',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              BlocProvider.of<LoginBloc>(context)..add(const AppStarted());

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<IncidentBloc, IncidentState>(
        builder: (BuildContext context, IncidentState state) {
          if (state is IncidentState) {
            return _IncidentForm();
          } else {
            throw StateError('unknown state: $state');
          }
        },
      ),
    );
  }
}

class _IncidentForm extends StatelessWidget {
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
                  value.isEmpty ? 'Fill in the brief description' : null,
            ),
            _verticalSpace,
            TextFormField(
              controller: _request,
              decoration: InputDecoration(labelText: 'Request'),
              maxLength: null,
              maxLines: null,
            ),
            _verticalSpace,
            TdButton(
              text: 'submit',
              onTap: () {
                if (_formKey.currentState.validate()) {
                  BlocProvider.of<IncidentBloc>(context)..add(IncidentSubmit());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

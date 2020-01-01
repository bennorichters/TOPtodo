import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo/utils/colors.dart';
import 'package:toptodo/widgets/td_button.dart';
import 'package:toptodo/widgets/td_shape.dart';
import 'package:toptodo_data/toptodo_data.dart';

class CredentialsForm extends StatelessWidget {
  CredentialsForm.withSavedDate(Credentials savedData, bool remember)
      : _urlController = TextEditingController()..text = savedData.url ?? '',
        _loginNameController = TextEditingController()
          ..text = savedData.loginName ?? '',
        _passwordController = TextEditingController()
          ..text = savedData.password ?? '',
        _remember = remember;

  final TextEditingController _urlController;
  final TextEditingController _loginNameController;
  final TextEditingController _passwordController;
  final bool _remember;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Widget _verticalSpace = const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomPaint(
          painter: TdShape(LongSide.left, forest100),
          child: Container(),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _urlController,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'TOPdesk url',
                    hintText: 'https://your-environment.topdesk.net',
                  ),
                  validator: (String value) => value.isEmpty
                      ? 'fill in the url of your TOPdesk environment'
                      : null,
                ),
                _verticalSpace,
                TextFormField(
                  autocorrect: false,
                  controller: _loginNameController,
                  decoration: const InputDecoration(
                    labelText: 'login name',
                  ),
                  validator: (String value) =>
                      value.isEmpty ? 'fill in your login name' : null,
                ),
                _verticalSpace,
                TextFormField(
                  autocorrect: false,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'application password',
                  ),
                  validator: (String value) => value.isEmpty
                      ? 'fill in your application password'
                      : null,
                ),
                _verticalSpace,
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _remember,
                      onChanged: (bool value) {
                        BlocProvider.of<LoginBloc>(context)
                          ..add(RememberToggle(_createCredentials()));
                      },
                    ),
                    const Text('remember'),
                  ],
                ),
                _verticalSpace,
                TdButton(
                  text: 'log in',
                  onTap: () => _connect(
                    context,
                    _createCredentials(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Credentials _createCredentials() => Credentials(
        url: _urlController.text,
        loginName: _loginNameController.text,
        password: _passwordController.text,
      );

  void _connect(BuildContext context, Credentials credentials) {
    if (_formKey.currentState.validate()) {
      BlocProvider.of<LoginBloc>(context)..add(TryLogin(credentials));
    }
  }
}

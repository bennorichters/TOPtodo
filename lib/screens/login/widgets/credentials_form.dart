import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo/screens/login/widgets/password_field.dart';
import 'package:toptodo/utils/td_colors.dart';
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

  final _formKey = GlobalKey<FormState>();
  final _verticalSpace = const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return TdShapeBackground(
      longSide: LongSide.left,
      color: TdColors.forest100,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
              PasswordField(_passwordController),
              _verticalSpace,
              Row(
                children: [
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

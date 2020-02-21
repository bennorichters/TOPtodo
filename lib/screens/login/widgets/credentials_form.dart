import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo/constants/keys.dart' as ttd_keys;
import 'package:toptodo/constants/colors.dart' as ttd_colors;
import 'package:toptodo/screens/login/widgets/password_field.dart';
import 'package:toptodo/widgets/landscape_padding.dart';
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
      color: ttd_colors.forest100,
      child: LandscapePadding(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  key: Key(ttd_keys.credentialsFormUrlField),
                  controller: _urlController,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'TOPdesk address',
                    hintText: 'https://your-environment.topdesk.net',
                  ),
                  validator: (String value) => value.isEmpty
                      ? 'fill in the url of your TOPdesk environment'
                      : null,
                ),
                _verticalSpace,
                TextFormField(
                  key: Key(ttd_keys.credentialsFormLoginNameField),
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
                      key: Key(ttd_keys.credentialsFormRememberCheckbox),
                      value: _remember,
                      onChanged: (bool value) =>
                          BlocProvider.of<LoginBloc>(context)
                              .add(RememberToggle(_createCredentials())),
                    ),
                    const Text('remember'),
                  ],
                ),
                _verticalSpace,
                TdButton(
                  key: Key(ttd_keys.credentialsFormLoginButton),
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
      ),
    );
  }

  Credentials _createCredentials() => Credentials(
        url: _urlController.text.isEmpty ? null : _urlController.text,
        loginName: _loginNameController.text.isEmpty
            ? null
            : _loginNameController.text,
        password:
            _passwordController.text.isEmpty ? null : _passwordController.text,
      );

  void _connect(BuildContext context, Credentials credentials) {
    if (_formKey.currentState.validate()) {
      BlocProvider.of<LoginBloc>(context)..add(TryLogin(credentials));
    }
  }
}

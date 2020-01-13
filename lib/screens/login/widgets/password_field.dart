import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField(this._passwordController);
  final TextEditingController _passwordController;

  @override
  State<StatefulWidget> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            autocorrect: false,
            controller: widget._passwordController,
            obscureText: _obscured,
            decoration: const InputDecoration(
              labelText: 'application password',
            ),
            validator: (String value) =>
                value.isEmpty ? 'fill in your application password' : null,
          ),
        ),
        IconButton(
          icon: _obscured
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_off),
          onPressed: () => setState(() => _obscured = !_obscured),
        ),
      ],
    );
  }
}

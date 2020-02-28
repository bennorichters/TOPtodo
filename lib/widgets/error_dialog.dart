import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:toptodo/screens/login/login_screen.dart';
import 'package:toptodo/constants/keys.dart' as ttd_keys;
import 'package:toptodo_data/toptodo_data.dart';

typedef DialogCloser = void Function(BuildContext context);

class ErrorDialog extends StatefulWidget {
  ErrorDialog({
    @required this.cause,
    @required this.stackTrace,
    @required this.activeScreenIsLogin,
  });
  final Object cause;
  final StackTrace stackTrace;
  final bool activeScreenIsLogin;

  @override
  State<StatefulWidget> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  bool details = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: details
          ? const Text('Error details')
          : const Text('Error contacting TOPdesk'),
      content: details ? _errorDetails() : _tldrMessage(),
      actions: _actions(),
    );
  }

  List<Widget> _actions() {
    final result = <Widget>[];

    result.add(
      details
          ? FlatButton(
              child: const Text('Copy error'),
              onPressed: () => Clipboard.setData(
                ClipboardData(
                  text: widget.cause.toString() +
                      '\n\n' +
                      widget.stackTrace.toString(),
                ),
              ),
            )
          : FlatButton(
              child: const Text('View details...'),
              onPressed: () => setState(() {
                details = true;
              }),
            ),
    );

    result.add(
      FlatButton(
        key: const Key(ttd_keys.errorDialogOkButton),
        child: const Text('Ok'),
        onPressed: () => _closeDialog(context),
      ),
    );

    return result;
  }

  void _closeDialog(BuildContext context) {
    if (widget.cause is TdBadRequestException) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacementNamed(context, 'settings');
    } else if (widget.activeScreenIsLogin) {
      Navigator.pop(context);
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacementNamed(
        context,
        'login',
        arguments: LoginScreenArguments(logOut: false),
      );
    }
  }

  Widget _tldrMessage() {
    if (widget.cause is TdBadRequestException) {
      return const Text(
        'Some of the settings are invalid. '
        'Update the settings.',
      );
    }

    if (widget.cause is TdCannotConnect) {
      return const Text(
        'The TOPdesk server cannot be reached. '
        'Check the TOPdesk address and your internet connection '
        'or contact your TOPdesk application manager.',
      );
    }

    if (widget.cause is TdNotAuthorizedException) {
      return const Text(
        'You do not have sufficient authorization '
        'or your password is incorrect. '
        'Contact your TOPdesk application manager.',
      );
    }

    if (widget.cause is TdServerException) {
      return const Text(
        'There was a problem with the TOPdesk server. '
        'Contact your TOPdesk application manager.',
      );
    }

    if (widget.cause is TdTimeOutException) {
      return const Text(
        'It took the TOPdesk server too long to respond. '
        'Please try again later.',
      );
    }

    if (widget.cause is TdVersionNotSupported) {
      return const Text(
        'The version of TOPdesk you are trying to connect to '
        'is not supported.',
      );
    }

    return const Text(
      'An unexpected error happened. '
      'Please try again later.',
    );
  }

  Widget _errorDetails() {
    return Container(
      width: double
          .maxFinite, // see: https://github.com/flutter/flutter/issues/18108
      child: ListView(
        children: [
          Text(widget.cause.toString()),
          const Divider(),
          Text(widget.stackTrace.toString()),
        ],
      ),
    );
  }
}

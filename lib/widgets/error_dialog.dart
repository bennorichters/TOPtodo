import 'package:flutter/material.dart';
import 'package:toptodo_data/toptodo_data.dart';

typedef DialogCloser = void Function(BuildContext context);

class ErrorDialog extends StatefulWidget {
  ErrorDialog({this.cause, this.activeScreenIsLogin});
  final Exception cause;
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
      content: details ? Text(widget.cause.toString()) : _tldrMessage(),
      actions: _actions(),
    );
  }

  List<Widget> _actions() {
    final result = <Widget>[];
    if (!details) {
      result.add(
        FlatButton(
          child: const Text('View details...'),
          onPressed: () {
            setState(() {
              details = true;
            });
          },
        ),
      );
    }

    result.add(
      FlatButton(
        child: const Text('Ok'),
        onPressed: () => _closeDialog(context),
      ),
    );

    return result;
  }

  void _closeDialog(BuildContext context) {
    if (widget.cause is TdBadRequestException) {
      Navigator.pushReplacementNamed(context, 'settings');
    } else if (widget.activeScreenIsLogin) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }

  Widget _tldrMessage() {
    if (widget.cause is TdNotAuthorizedException) {
      return const Text('You do not have sufficient authorization. '
          'Contact your TOPdesk application manager.');
    }

    if (widget.cause is TdTimeOutException) {
      return const Text('It took the TOPdesk server too long to respond. '
          'Please try again later.');
    }

    if (widget.cause is TdBadRequestException) {
      return const Text('Some of the settings are invalid. '
          'Update the settings.');
    }

    if (widget.cause is TdServerException) {
      return const Text('There was a problem with the TOPdesk server. '
          'Contact your TOPdesk application manager.');
    }

    return const Text('An unexpected error happened. '
        'Please try again later.');
  }
}

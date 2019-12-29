import 'package:flutter/material.dart';
import 'package:toptodo_data/toptodo_data.dart';

typedef DialogCloser = void Function(BuildContext context);

void _closeDialog(BuildContext context) => Navigator.of(context).pop();

class ErrorDialog extends StatefulWidget {
  ErrorDialog(this.cause, {this.onClose = _closeDialog});
  final Exception cause;
  final DialogCloser onClose;

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
      content:
          details ? Text(widget.cause.toString()) : _tldrMessage(widget.cause),
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
        onPressed: () {
          widget.onClose(context);
        },
      ),
    );

    return result;
  }

  Widget _tldrMessage(Exception cause) {
    if (cause is TdNotAuthorizedException) {
      return const Text('You do not have sufficient authorization. '
          'Contact your TOPdesk application manager.');
    }

    if (cause is TdTimeOutException) {
      return const Text('It took the TOPdesk server too long to respond. '
          'Please try again later.');
    }

    if (cause is TdServerException) {
      return const Text('There was a problem with the TOPdesk server. '
          'Contact your TOPdesk application manager.');
    }

    return const Text('An unexpected error happened. '
        'Please try again later.');
  }
}

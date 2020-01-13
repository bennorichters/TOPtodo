import 'package:flutter/material.dart';
import 'package:toptodo/widgets/dialog_header.dart';

class LoginHelpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DialogHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
            child: const Text(
                'The application password that you need to login is not your '
                'normal password. It instead is a separate password that you '
                'will need to create using your TOPdesk environment. In the '
                'operator settings you can create a new application password '
                'that you can use here.\n'
                '\n'
                'Your operator profile should also be authorized to use the '
                'REST API. Contact your TOPdesk application manager to verify '
                'this.'),
          ),
        ],
      ),
    );
  }
}

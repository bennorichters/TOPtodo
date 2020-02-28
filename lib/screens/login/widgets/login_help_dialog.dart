import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:toptodo/constants/keys.dart' as ttd_keys;
import 'package:toptodo/widgets/dialog_header.dart';

class LoginHelpDialog extends StatelessWidget {
  const LoginHelpDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DialogHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
              child: RichText(
                key: const Key(ttd_keys.loginHelpDialogUrlLauncher),
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    const TextSpan(
                      text: 'Fill in the TOPdesk address and your credentials. '
                          'Note that the ',
                    ),
                    const TextSpan(
                      text: 'application password ',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    const TextSpan(
                      text: 'differs from your normal password. Read the ',
                    ),
                    TextSpan(
                      text: 'online documentation ',
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch(
                            'https://bennorichters.github.io/TOPtodo/',
                          );
                        },
                    ),
                    const TextSpan(
                      text: 'for more details.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

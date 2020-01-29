import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:toptodo/widgets/dialog_header.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginHelpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DialogHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                        text:
                            'Fill in the TOPdesk address and your credentials. '
                            'Note that the '),
                    TextSpan(
                      text: 'application password ',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    TextSpan(
                      text: 'differs from your normal password. Read the ',
                    ),
                    TextSpan(
                      text: 'online documentation ',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch(
                            'https://bennorichters.github.io/TOPtodo/',
                          );
                        },
                    ),
                    TextSpan(
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

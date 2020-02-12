import 'package:flutter/material.dart';
import 'package:toptodo/toptodo_app.dart';
import 'package:toptodo_local_storage/toptodo_local_storage.dart';
import 'package:toptodo_topdesk_api/toptodo_topdesk_api.dart';

void main() => runApp(
      TopToDoApp(
        credentialsProvider: SecureStorageCredentials(),
        settingsProvider: SharedPreferencesSettingsProvider(),
        topdeskProvider: ApiTopdeskProvider(),
      ),
    );

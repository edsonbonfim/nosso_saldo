import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'controllers/controllers.dart';
import 'models/models.dart';
import 'repositories/repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final lang = "pt_BR";

  Intl.defaultLocale = lang;
  await initializeDateFormatting(lang, null);

  await openBox();

  final userRepository = UserRepository();

  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(repository: userRepository)
          ..add(AppStarted());
      },
      child: App(),
    ),
  );
}

Future<Box> openBox() async {
  if (kIsWeb) {
    Hive.registerAdapter(UserAdapter());
    return Hive.openBox("settings");
  }

  String path;

  Map<String, String> envVars = Platform.environment;

  if (Platform.isMacOS) {
    path = envVars['HOME'];
  } else if (Platform.isLinux) {
    path = envVars['HOME'];
  } else if (Platform.isWindows) {
    path = envVars['UserProfile'];
  } else {
    path = (await getApplicationDocumentsDirectory()).path;
  }

  Hive
    ..init(path)
    ..registerAdapter(UserAdapter());

  return Hive.openBox("settings");
}

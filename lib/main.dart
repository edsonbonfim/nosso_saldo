import 'dart:io';

import 'package:bloc/bloc.dart';
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

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    // print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    // print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    // print(error);
    super.onError(bloc, error, stackTrace);
  }
}

Future<Box> openBox() async {
  if (kIsWeb) {
    Hive.registerAdapter(UserAdapter());
    return Hive.openBox("settings");
  }

  String path;

  Map<String, String> envVars = Platform.environment;

  if (Platform.isLinux) {
    path = envVars['HOME'];
  } else {
    path = (await getApplicationDocumentsDirectory()).path;
  }

  Hive
    ..init(path)
    ..registerAdapter(UserAdapter());

  return Hive.openBox("settings");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final lang = "pt_BR";

  Intl.defaultLocale = lang;
  await initializeDateFormatting(lang, null);

  await openBox();

  BlocSupervisor.delegate = SimpleBlocDelegate();

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

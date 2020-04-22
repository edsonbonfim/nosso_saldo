import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'controllers/authentication/authentication_bloc.dart';
import 'controllers/authentication/authentication_event.dart';
import 'services/user_repository.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

Future<Box> openBox() async {
  if (kIsWeb) {
    return Hive.openBox("settings");
  }

  String path;

  Map<String, String> envVars = Platform.environment;

  if (Platform.isLinux) {
    path = envVars['HOME'];
  } else {
    path = (await getApplicationDocumentsDirectory()).path;
  }

  Hive.init(path);
  return Hive.openBox("settings");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await openBox();

  BlocSupervisor.delegate = SimpleBlocDelegate();

  final userRepository = UserRepository();

  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..add(AppStarted());
      },
      child: App(userRepository: userRepository),
    ),
  );
}

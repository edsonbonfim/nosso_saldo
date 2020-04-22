import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'controllers/authentication/authentication_bloc.dart';
import 'controllers/authentication/authentication_state.dart';
import 'pages/home/home_page.dart';
import 'pages/login/login_indicator.dart';
import 'pages/login/login_page.dart';
import 'pages/splash/splash_page.dart';
import 'services/user_repository.dart';

class App extends StatelessWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUninitialized) {
            return SplashPage();
          }
          if (state is AuthenticationAuthenticated) {
            return HomePage();
          }
          if (state is AuthenticationUnauthenticated) {
            return LoginPage(userRepository: userRepository);
          }
          if (state is AuthenticationLoading) {
            return LoadingIndicator();
          }
          return SizedBox();
        },
      ),
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff181F3D),
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xffDA2157),
              secondary: const Color(0xff232C51),
              onSecondary: const Color(0xff2EB9E9),
            ),
        fontFamily: "Montserrat",
      ),
    );
  }
}

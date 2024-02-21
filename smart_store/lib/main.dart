import 'package:flutter/material.dart';
import 'package:smart_store/home/home_screen.dart';
import 'package:smart_store/regisration/autherntication/auth_cubit.dart';
import 'package:smart_store/regisration/autherntication/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_store/regisration/autherntication/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_store/regisration/autherntication/authenticatein_screen.dart';
import 'package:smart_store/regisration/signup/signup_cubit.dart';
import 'package:smart_store/regisration/signup/signup_screen.dart';

final AuthRepository authRepository = AuthRepository();
final storage = const FlutterSecureStorage();
final AuthCubit authCubit =
    AuthCubit(storage: storage, authRepository: authRepository);

void main() async {
  if (authCubit.state is AuthInitial) {
    await authCubit.authenticate();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authCubit,
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: state is Authenticated
                ? const HomeScreen()
                : state is AuthenticationFailed || state is Authenticating
                    ? const AuthenticatingScreen()
                    : BlocProvider<SignupCubit>(
                        create: (_) => SignupCubit(),
                        child:  SignupScreen()),
          );
        },
      ),
    );
  }
}

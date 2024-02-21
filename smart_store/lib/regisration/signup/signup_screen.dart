import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_store/regisration/otp/otp_cubit.dart';
import 'package:smart_store/regisration/signup/signup_cubit.dart';
import 'package:smart_store/regisration/signup/signup_state.dart';

import '../../constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../login/login_screen.dart';
import '../otp/otp_screen.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final formKey = GlobalKey<FormState>();
  late String _email;
  late String _phone;
  late String _name;
   String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: BlocConsumer<SignupCubit, SignupState>(
                listener: (context, state) {
                  if (state is SignupSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider<OtpCubit>(
                          create: (_) => OtpCubit(),
                          child: OtpScreen(
                            _email,
                            _name,
                            _password!,
                            _phone,
                          ),
                        ),
                      ),
                    );
                  } else if (state is SignupFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMsg),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      Image.asset(
                        'assets/images/logo.jpg',
                        height: 100,
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      _emailField(
                        state is! SignupSubmitting,
                        (state is SignupFailed) ? state.errorMsg : null,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      _phoneField(
                        state is! SignupSubmitting,
                        (state is SignupFailed) ? state.errorMsg : null,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      _nameField(
                        state is! SignupSubmitting,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      _passwordField(
                        state is! SignupSubmitting,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      _confirmPasswordField(
                        state is! SignupSubmitting,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      if (state is SignupSubmitting)
                        const CircularProgressIndicator(),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                          fixedSize: MaterialStateProperty.all(
                            const Size(
                              double.maxFinite,
                              60,
                            ),
                          ),
                        ),
                        onPressed: (state is SignupSubmitting)
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  BlocProvider.of<SignupCubit>(context)
                                      .requestOtp(
                                    _email,
                                    _phone,
                                  );
                                }
                              },
                        child: const Text("Create Account"),
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text("Already have an account? Login"),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailField(enableForm, error) {
    return TextFormField(
      enabled: enableForm,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        enabledBorder: ENABLED_BORDER,
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: ERROR_BORDER,
        errorText: error == 'email already exists' ? error : null,
        errorStyle: const TextStyle(
          height: 1,
        ),
        hintText: "Enter your Email Address",
        labelText: "Email Address",
        suffixIcon: const Icon(Icons.email),
      ),
      validator: (value) {
        if (!RegExp(EMAIL_REGEX).hasMatch(value!)) {
          return "Please enter a valid email";
        }
        _email = value;
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }

  Widget _phoneField(enableForm, error) {
    return TextFormField(
      maxLength: 11,
      enabled: enableForm,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        enabledBorder: ENABLED_BORDER,
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: ERROR_BORDER,
        errorText: error == 'phone already exists' ? error : null,
        errorStyle: const TextStyle(
          height: 1,
        ),
        hintText: "Enter your phone no.",
        labelText: "Phone",
        suffixIcon: const Icon(Icons.smartphone),
      ),
      validator: (value) {
        if (value!.length != 11) {
          return "Please enter a valid phone number!";
        }
        _phone = value;
        return null;
      },
      keyboardType: TextInputType.number,
      style: const TextStyle(
        fontSize: 14,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }

  Widget _nameField(enableForm) {
    return TextFormField(
      enabled: enableForm,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        enabledBorder: ENABLED_BORDER,
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: ERROR_BORDER,
        errorStyle: const TextStyle(
          height: 1,
        ),
        hintText: "Enter your Name",
        labelText: "Fullname",
        suffixIcon: const Icon(Icons.person),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter a valid name!";
        }
        _name = value;
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        fontSize: 14,
      ),
    );
  }

  Widget _passwordField(enableForm) {
    return TextFormField(
      enabled: enableForm,
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        enabledBorder: ENABLED_BORDER,
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: ERROR_BORDER,
        errorStyle: const TextStyle(
          height: 1,
        ),
        hintText: "Password",
        labelText: "Password",
        suffixIcon: const Icon(Icons.lock),
      ),
      validator: (value) {
        if (value!.length < 8) {
          return "at least 8 characters";
        }
        _password = value;
        return null;
      },
      style: const TextStyle(
        fontSize: 14,
      ),
    );
  }

  Widget _confirmPasswordField(enableForm) {
    return TextFormField(
      enabled: enableForm,
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        enabledBorder: ENABLED_BORDER,
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: ERROR_BORDER,
        errorStyle: const TextStyle(
          height: 1,
        ),
        hintText: "Confirm Password",
        labelText: "Confirm Password",
        suffixIcon: const Icon(Icons.lock),
      ),
      validator: (value) {
        if (value != _password) {
          return "passwords do not match";
        }
        return null;
      },
      style: const TextStyle(
        fontSize: 14,
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';
import '../autherntication/auth_cubit.dart';
import 'otp_cubit.dart';
import 'otp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpScreen extends StatefulWidget {
  final formKey = GlobalKey<FormState>();

  final String _email, _name, _password, _phone;
  late String _otp;
  late bool onlyVerify;

  var timer;
  int time = 0;

  OtpScreen(
    this._email,
    this._name,
    this._password,
    this._phone, {
    this.onlyVerify = false,
    super.key,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: widget.formKey,
              child: BlocConsumer<OtpCubit, OtpState>(
                listener: (context, state) {
                  if (state is OtpVerificationFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMsg),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  if (state is OtpVerified) {
                    if (widget.onlyVerify) {
                      //todo only verify
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Otp Verified"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      BlocProvider.of<AuthCubit>(context).loggedIN(state.token);
                      Navigator.of(context).pop(context);
                    }
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      Image.asset(
                        'assets/images/otp.png',
                        height: 100,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text(
                        'Phone Verification',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text(
                        "A verification code has been successfully sent to your phone no.",
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      _otpField(
                        state is! OtpVerifying,
                        state is OtpVerificationFailed ? state.errorMsg : null,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextButton(
                        onPressed: widget.time != 0
                            ? null
                            : () {
                                BlocProvider.of<OtpCubit>(context).resendOtp(
                                  widget._phone,
                                );
                                startTimer();
                              },
                        child: Text(
                          widget.time != 0
                              ? "wait for ${widget.time} seconds to resend"
                              : "Resend Otp",
                        ),
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      if (state is OtpVerifying)
                        const CircularProgressIndicator(),
                      const SizedBox(
                        height: 48,
                      ),
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
                        onPressed: state is OtpVerifying
                            ? null
                            : () {
                                if (widget.formKey.currentState!.validate()) {
                                  if (widget.onlyVerify) {
                                    //todo only verify
                                  } else {
                                    BlocProvider.of<OtpCubit>(context)
                                        .verifyOtp(
                                      email: widget._email,
                                      name: widget._name,
                                      password: widget._password,
                                      phone: widget._phone,
                                      otp: widget._otp,
                                    );
                                  }
                                }
                              },
                        child: const Text("Verify"),
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

  Widget _otpField(enableForm, error) {
    return TextFormField(
      maxLength: 6,
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
        errorText: error,
        errorStyle: const TextStyle(
          height: 1,
        ),
        hintText: "Enter 6 digit verification code",
        labelText: "Verification Otp",
        suffixIcon: const Icon(Icons.sms),
      ),
      validator: (value) {
        if (value!.length != 6) {
          return "Invalid Otp!";
        }
        widget._otp = value;
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

  void startTimer() {
    widget.time = 60;
    const oneSec = Duration(seconds: 1);
    widget.timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (!mounted) {
          // Check if the widget is still mounted
          timer.cancel();
          return;
        }
        if (widget.time == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            widget.time--;
          });
        }
      },
    );
  }
}

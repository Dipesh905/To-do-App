import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/controller/services/firebase_auth_services.dart';
import 'package:todoapp/controller/signup_screen_provider.dart';
import 'package:todoapp/view/screens/log_in_screen.dart';
import 'package:todoapp/view/widgets/button_widget.dart';
import 'package:todoapp/view/widgets/input_field_widget.dart';

class SignUpScreen extends ConsumerWidget {
  SignUpScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FirebaseFunction _firebaseFunction = FirebaseFunction();

  final RegExp _passwordregex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  final RegExp _emailregex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  final GlobalKey<FormState> _signupscreenkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const TextStyle textStyle = TextStyle(
      fontSize: 30,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: _signupscreenkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: const Text(
                      'Create an account',
                      style: textStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(
                      'Email Address',
                      style: textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InputFieldWidget(
                      surfixIcon: const Icon(Icons.email),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        } else if (_emailregex
                            .hasMatch(_emailController.text)) {
                          return null;
                        } else {
                          return 'Invalid email please enter correct email';
                        }
                      },
                      hintText: 'abc@gmail.com',
                      controller: _emailController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(
                      'Password',
                      style: textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InputFieldWidget(
                      obsecureText: ref.watch(obsecureValueProvider),
                      surfixIcon: IconButton(
                        onPressed: () {
                          ref
                              .read(obsecureValueProvider.notifier)
                              .update((bool state) => !state);
                        },
                        icon: ref.watch(obsecureValueProvider)
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        } else if (_passwordregex
                            .hasMatch(_passwordController.text)) {
                          return null;
                        } else {
                          return 'Use atleast 1 Uppercase,lowercase,Number and Special Character';
                        }
                      },
                      hintText: '**********',
                      controller: _passwordController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(
                      'Confirm Password',
                      style: textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InputFieldWidget(
                      obsecureText: ref.watch(confirmPasswordObsecureProvider),
                      surfixIcon: IconButton(
                        onPressed: () {
                          ref
                              .read(confirmPasswordObsecureProvider.notifier)
                              .update((bool state) => !state);
                        },
                        icon: ref.watch(confirmPasswordObsecureProvider)
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please re-enter your password';
                        } else if (_confirmPasswordController.text ==
                            _passwordController.text) {
                          return null;
                        } else {
                          return "Password doesn't match";
                        }
                      },
                      hintText: '**********',
                      controller: _confirmPasswordController,
                    ),
                  ),
                  ButtonWidget(
                    onPressed: () async {
                      if (_signupscreenkey.currentState!.validate()) {
                        try {
                          await EasyLoading.show();
                          final UserCredential? userCredential =
                              await _firebaseFunction
                                  .createUserWithEmailAndPassword(
                            emailAddress: _emailController.text,
                            password: _passwordController.text,
                            context: context,
                          );

                          if (userCredential != null) {
                            await EasyLoading.showSuccess(
                              'You have successfully created your account',
                              duration: const Duration(seconds: 5),
                              dismissOnTap: true,
                            );

                            _emailController.clear();
                            _passwordController.clear();
                            _confirmPasswordController.clear();
                          }
                        } catch (err) {
                          // await EasyLoading.showError(
                          //   'SomeThing Went Wrong while Logging In,Please Try Again Later',
                          // );
                        }
                      }
                    },
                    buttonTitle: 'Sign Up',
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: const TextStyle(color: Colors.grey, fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign In Here',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.blueAccent,
                            fontSize: 18,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute<LogInScreen>(
                                  builder: (BuildContext context) =>
                                      LogInScreen(),
                                ),
                              );
                            },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/controller/services/firebase_auth_services.dart';
import 'package:todoapp/controller/signup_screen_provider.dart';
import 'package:todoapp/view/screens/home_screen.dart';
import 'package:todoapp/view/screens/sign_up_screen.dart';
import 'package:todoapp/view/widgets/button_widget.dart';
import 'package:todoapp/view/widgets/input_field_widget.dart';

class LogInScreen extends ConsumerWidget {
  LogInScreen({super.key});

  final FirebaseFunction _firebaseFunction = FirebaseFunction();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _loginscreenkey = GlobalKey<FormState>();

  final RegExp _passwordregex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  final RegExp _emailregex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

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
          child: Form(
            key: _loginscreenkey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Login',
                          style: textStyle,
                        ),
                        Text(
                          'Welcome back to the app ',
                          style: textStyle.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize: 18,
                          ),
                        ),
                      ],
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
                      hintText: 'abc@gmail.com',
                      controller: _emailController,
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
                  InputFieldWidget(
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
                    hintText: '************',
                    controller: _passwordController,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Forget Password ?'),
                    ),
                  ),
                  ButtonWidget(
                    onPressed: () async {
                      if (_loginscreenkey.currentState!.validate()) {
                        try {
                          await EasyLoading.show();
                          final UserCredential? value = await _firebaseFunction
                              .signInWithEmailAndPassword(
                            emailAddress: _emailController.text,
                            password: _passwordController.text,
                            context: context,
                          );

                          if (value != null) {
                            await EasyLoading.dismiss();
                            await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute<HomeScreen>(
                                builder: (BuildContext context) => HomeScreen(),
                              ),
                            );
                          }
                        } catch (err) {
                          await EasyLoading.showError(
                            'SomeThing Went Wrong while Logging In,Please Try Again Later',
                          );
                        }
                      }
                    },
                    buttonTitle: 'Log In',
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 18),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Create One',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.blueAccent,
                              fontSize: 18,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute<SignUpScreen>(
                                    builder: (BuildContext context) =>
                                        SignUpScreen(),
                                  ),
                                );
                              },
                          )
                        ],
                      ),
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final FirebaseAuth firebaseAuthInstance = FirebaseAuth.instance;

class FirebaseFunction {
  /// method to create User With Email And Password
  Future<UserCredential?> createUserWithEmailAndPassword({
    required String emailAddress,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final UserCredential credential =
          await firebaseAuthInstance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.red,
              title: Text('Error'),
              content: const Text(
                'You have entered weak password, Please try again with strong password. Use atleast 1 Uppercase,LowerCase,Number And Special Character For Strong Password ',
              ),
            );
          },
        );
      } else if (e.code == 'email-already-in-use') {
        await EasyLoading.dismiss();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.red,
              title: Text('Error'),
              content: const Text(
                'The account already exists for that email. Please try Again With Another Email',
              ),
            );
          },
        );
      }
    } catch (e) {
      await EasyLoading.dismiss();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.red,
            title: Text('Error'),
            content: const Text('Something Went Wrong,Try Again'),
          );
        },
      );
    }

    return null;
  }

  /// method to sign In With Email And Password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String emailAddress,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final UserCredential credential =
          await firebaseAuthInstance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        await EasyLoading.dismiss();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.red,
              title: Text('Error'),
              content: const Text(
                "The account didn't exists for that email. Please try again with your correct email",
              ),
            );
          },
        );
      } else if (e.code == 'wrong-password') {
        await EasyLoading.dismiss();

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.red,
              title: Text('Error'),
              content: const Text(
                'Wrong password, Please Try Again With Correct Password',
              ),
            );
          },
        );
      }
    }

    return null;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signup_firebase/features/presentaion/cubit/login_state.dart';
import 'package:signup_firebase/features/presentaion/pages/dashboard.dart';


import '../pages/login.dart';

class logincubit extends Cubit<String>{
  logincubit() : super("");
  //FirebaseAuth auth = FirebaseAuth.instance;

  void authentication() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "barry.allen@example.com",
          password: "SuperSecretPassword!"
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
  void authenticationEmail(String _email,String _pwd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _pwd
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
  void LoginEmailPwd(String email,String pwd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pwd
      );
      if(userCredential.user != null){
        debugPrint('user login');
        emit("sucess");
        LoginStateSucc();
      }

    } on FirebaseAuthException catch (e) {
      LoginStateFailure();
      emit("failure"
          //LoginStateFailure()
      );
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }

    }
  }
}

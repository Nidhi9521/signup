import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signup_firebase/features/presentaion/cubit/user_state.dart';

class userCubit extends Cubit<IntailState>{
  userCubit() : super(userLogin());

  void LoginEmailPwd(String email,String pwd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pwd
      );
      if(userCredential.user != null){
        debugPrint('user login');
        emit(userLoginSuccess('success'));
      }
    } on FirebaseAuthException catch (e) {
      emit(userLoginFailure('failure'));
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
    }
  }

  void Signup(String email,String pwd) async{

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: pwd
      );
      emit(SignUpSucc());
    } on FirebaseAuthException catch (e) {
      emit(SignUpError());
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }



  void Emailchanged(email){
    if(email.isEmpty){
      emit(EmailError('pls enter valid email'));
    }else{
      emit(EmailSucc());
    }
  }

  void Pwdchanged(pwd){
    if(pwd.isEmpty){
      emit(PwdError('pls enter Valid Pwd'));
    }else{
      emit(PwdSucc());
    }
  }
}
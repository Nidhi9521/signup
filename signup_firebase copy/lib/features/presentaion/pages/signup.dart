import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signup_firebase/features/presentaion/cubit/dashboard_cubit.dart';
import 'package:signup_firebase/features/presentaion/cubit/login_cubit.dart';
import 'package:signup_firebase/features/presentaion/cubit/signup_cubit.dart';
import 'package:signup_firebase/features/presentaion/cubit/user_cubit.dart';
import 'package:signup_firebase/features/presentaion/pages/dashboard.dart';
import 'package:signup_firebase/features/presentaion/pages/login.dart';

import '../cubit/user_state.dart';

class signup extends StatelessWidget {
   signup({Key? key}) : super(key: key);
  final formGlobalKey = GlobalKey<FormState>();
  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController numberController = TextEditingController();
    return Scaffold(
        body: BlocBuilder<userCubit, IntailState>(builder: (context, state) {
      return Container(
          padding: EdgeInsets.only(
              top: 100.0, right: 20.0, left: 20.0, bottom: 20.0),
          child:Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formGlobalKey,
          child:
          ListView(children: <Widget>[
            Text(
              "Sign Up",
              style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
            SizedBox(
              height: 5.0,
            ),
            // TextField(
            //   controller: nameController,
            //   decoration: InputDecoration(
            //
            //       labelText: 'Enter Name',
            //       hintText: 'Enter Your Name'
            //   ),
            // ),
            // SizedBox(height: 5.0,),
            TextFormField(
              controller: emailController,
              // onChanged: (val) {
              //   BlocProvider.of<userCubit>(context)
              //       .Emailchanged(val.toString());
              // },
              validator: (email) {
                if (!isEmailValid(email.toString()) || email==Null)
                  return 'Entera valid email address';
                else
                  return null;
              },
              decoration: InputDecoration(
                labelText: 'Enter Email',
                hintText: 'Enter Email',
                //errorText: state is EmailError ? state.error : null,
              ),
            ),
            // SizedBox(height: 5.0,),
            // TextField(
            //   controller: numberController,
            //   decoration: InputDecoration(
            //       labelText: 'Enter Phone Number',
            //       hintText: 'Enter Phone Number'
            //   ),
            //
            // ),
            SizedBox(
              height: 5.0,
            ),

            TextFormField(
              controller: passwordController,
              obscureText: true,
              // onChanged: (val) {
              //   BlocProvider.of<userCubit>(context).Pwdchanged(val.toString());
              // },
              validator: (password) {
                if (isPasswordValid(password.toString()))
                  return null;
                else
                  return 'Enter a valid password';
              },
              decoration: InputDecoration(
                labelText: 'Enter Password',
                hintText: 'Enter Password',
                //errorText: state is PwdError ? state.error : null,
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: BlocListener<userCubit, IntailState>(
                listener: (context, state) {
                  if (state is SignUpSucc) {
                    showToast('success');
                    Navigator.of(context).pushNamed('/screen2');
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => BlocProvider(
                    //               create: (context) => userCubit(),
                    //               child: login(),
                    //             )));
                  }
                  if (state is SignUpError) {
                    showToast('Invalid Data');
                    emailController.clear();
                    passwordController.clear();
                  }
                },
                child: FlatButton(
                  child: Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    // if(state is EmailError == true) {
                    //   print('1 if');
                    // }else if (state is PwdError == true) {
                    //     print('sorry');
                    //     showToast('Sorry pls enter Data');
                    //   }
                    // else {
                    //   print('else')
                    //   ;
                    if (formGlobalKey.currentState!.validate()) {
                      formGlobalKey.currentState?.save();
                        context
                            .read<userCubit>()
                            .Signup(
                            emailController.text, passwordController.text);
                      }
                    //}
                    },
                ),
              ),
            ),

            SizedBox(
              height: 5.0,
            ),
            RichText(
                text: TextSpan(
                    text: 'have an account',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' LogIn',
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 20),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => BlocProvider(
                              //             create: (context) => userCubit(),
                              //             child: login())));
                              Navigator.of(context).pushNamed('/screen2');

                            })
                    ]))
          ])));
    }))
    ;
  }
   bool isPasswordValid(String password) => password.length == 6;

   bool isEmailValid(email) {
     if (EmailValidator.validate(email)) {
       return true;
     } else {
       return false;
     }
   }
}

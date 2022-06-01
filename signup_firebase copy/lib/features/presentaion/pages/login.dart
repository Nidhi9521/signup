import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../cubit/user_cubit.dart';
import '../cubit/user_state.dart';

class login extends StatelessWidget {
  login({Key? key}) : super(key: key);
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
    return
        Scaffold(
            body: Container(
                padding: const EdgeInsets.only(
                    top: 100.0, right: 20.0, left: 20.0, bottom: 20.0),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formGlobalKey,
                  child: ListView(
                    children: <Widget>[
                      Text(
                        "LOGIN",
                        style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (email) {
                          if (!isEmailValid(email.toString()) || email==Null)
                            return 'Entera valid email address';
                          else
                            return null;
                        },
                        decoration: const InputDecoration(
                            icon: Icon(Icons.email),
                            labelText: 'Enter Email',
                            hintText: 'Enter Email'),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (password) {
                          if (isPasswordValid(password.toString()))
                            return null;
                          else
                            return 'Enter a valid password';
                        },
                        decoration: const InputDecoration(
                            icon: Icon(Icons.remove_red_eye),
                            labelText: 'Enter Password',
                            hintText: 'Enter Password'),
                      ),
                      Container(
                        margin: const EdgeInsets.all(25),
                        child: BlocListener<userCubit, IntailState>(
                          listener: (context, state) async {
                            if (state is userLoginSuccess) {
                              showToast('success');
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('email', emailController.text);
                              //Navigator.popAndPushNamed(context, '/screen4');
                              //Navigator.of(context).pushNamedAndRemoveUntil('/screen4', ModalRoute.withName('/screen2'));
                              Navigator.of(context).pushNamedAndRemoveUntil('/screen4', (Route<dynamic> route) => false);
                            }
                            if (state is userLoginFailure) {
                              showToast('Failure');
                              emailController.clear();
                              passwordController.clear();
                            }
                          },
                          child: FlatButton(
                            onPressed: () {
                              if (formGlobalKey.currentState!.validate()) {
                                formGlobalKey.currentState?.save();
                                context.read<userCubit>().LoginEmailPwd(
                                    emailController.text,
                                    passwordController.text);
                              }
                            },color: Colors.blueAccent,
                            child: const Text(
                              'LogIn',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RichText(
                                  text: TextSpan(
                                      text: 'Don\'t have an account?',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 20),
                                      children: <TextSpan>[
                                    TextSpan(
                                        text: ' Sign up',
                                        style: const TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 20),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // Navigator.pushReplacement(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             BlocProvider(
                                            //                 create: (context) =>
                                            //                     userCubit(),
                                            //                 child: signup())));
                                            Navigator.of(context).pushNamed('/screen3');
                                          })
                                  ]))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )));
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

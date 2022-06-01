import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup_firebase/features/presentaion/cubit/dashboard_cubit.dart';
import 'package:signup_firebase/features/presentaion/cubit/user_cubit.dart';
import 'package:signup_firebase/features/presentaion/pages/dashboard.dart';
import 'features/presentaion/pages/login.dart';
import 'features/presentaion/pages/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/screen2': (BuildContext context) =>
            BlocProvider(create: (context) => userCubit(), child: login()),
        '/screen3': (BuildContext context) =>
            BlocProvider(create: (context) => userCubit(), child: signup()),
        '/screen4': (BuildContext context) =>
            BlocProvider(create: (context) => DashCubit(), child: DashBoard()),
        '/screen1': (BuildContext context) => new MyHomePage()
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> {
  late bool newLaunch;
  var finalEmail;

  @override
  void initState() {
    super.initState();
    getValidationData().whenComplete(() async {
      Timer(
          Duration(seconds: 5),
          () => finalEmail == null
              ? Navigator.of(context).pushNamedAndRemoveUntil(
                  '/screen2', (Route<dynamic> route) => false)
              : Navigator.of(context).pushNamedAndRemoveUntil(
                  '/screen4', ModalRoute.withName('/screen1')));
    });
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    setState(() {
      finalEmail = obtainedEmail;
    });
    print(finalEmail);
  }

  loadNewLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bool? _newLaunch = prefs.getBool('id');
      newLaunch = _newLaunch!;
    });
    //bool newLaunch =prefs.getBool('id') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //color: Colors.yellow,
        child: FlutterLogo(size: MediaQuery.of(context).size.height));
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Splash Screen Example")),
      body: Center(
          child: Text("Welcome to Home Page",
              style: TextStyle(color: Colors.black, fontSize: 30))),
    );
  }
}

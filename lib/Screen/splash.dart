import 'package:chat/Api/apis.dart';
import 'package:chat/Screen/naviagtion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import 'auth/login_screen.dart';

//splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      //exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white));

      if (Api.auth.currentUser != null) {
        //navigate to home screen
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const NavigationExample()));
      } else {
        //navigate to login screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    return Scaffold(
        //body
        body: Column(
      children: [
        SizedBox(
          height: 40,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset('images/splash.png'),
        ),
        SizedBox(
          height: mq.height * .2,
        ),
        CircularProgressIndicator()
      ],
    ));
  }
}

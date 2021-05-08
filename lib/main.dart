import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:Muzico/home.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(
          useLoader: false,
          photoSize: 50,
          image: Image.asset("assets/white.png"),
          seconds: 2,
          title: Text(
            "muzico",
            style: TextStyle(
              fontFamily: "Gilroy",
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          navigateAfterSeconds: new HomePage(),
          backgroundColor: Colors.black,
        ));
  }
}

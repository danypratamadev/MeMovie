import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:memovie/provider/mainprovider.dart';
import 'package:memovie/start/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainProvider>(
          create: (context) => MainProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'MeMovie',
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.grey.shade100,
          backgroundColor: Colors.white,
          accentColor: Colors.lightBlue.shade900,
          primaryColor: Colors.lightBlue.shade900,
          buttonColor: Colors.lightBlue.shade900,
          dialogBackgroundColor: Colors.white,
          textSelectionHandleColor: Colors.lightBlue.shade900,
          cursorColor: Colors.lightBlue.shade900,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

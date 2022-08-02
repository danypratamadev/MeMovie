import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:memovie/page/home.dart';
import 'package:memovie/provider/mainprovider.dart';
import 'package:memovie/start/login.dart';

class SplashPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    var mainprovider = Provider.of<MainProvider>(context, listen: false);

    var themeApp = Theme.of(context);

    Timer(
      Duration(milliseconds: 1500,), () async {
        bool auth = await mainprovider.getCurrentUser();
        if(auth){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage(),));
        }else{
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage(action: 10,),));
        }
      }
    );

    return Scaffold(
      backgroundColor: themeApp.accentColor,
      body: Container(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'MeMovie',
                    style: themeApp.textTheme.headline4.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  SizedBox(
                    width: 25.0,
                    height: 25.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.8,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              child: Center(
                child: Text(
                  'UJIAN AKHIR SEMESTER',
                  style: themeApp.textTheme.caption.copyWith(
                    color: Colors.white54,
                  ),
                ),
              ),
              left: 0.0,
              right: 0.0,
              bottom: 52.0,
            )
          ],
        ),
      ),
    );
  }

}
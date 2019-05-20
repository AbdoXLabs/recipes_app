import 'package:flutter/material.dart';
import 'package:recipes_app/configs/config.dart';

import 'package:recipes_app/views/pages/main_page.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // GDPR : Non Personalized Ads
     FirebaseAdMob.instance.initialize(appId: Config.admobAppID, analyticsEnabled: Config.personalizedAds, trackingId: null);

     try {
       //Push notifications
       final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
     } catch (e){}

    return new MaterialApp(
      title: Config.appName,
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
      //home: MainPage(title: 'Recipes App'),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(title: Config.appName),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


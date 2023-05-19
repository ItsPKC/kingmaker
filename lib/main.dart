import 'package:firebase_core/firebase_core.dart';
// Import the generated file
// import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kingmaker/services/ad_state.dart';
import 'package:kingmaker/services/googleAds.dart';
import 'package:kingmaker/services/myUser.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'checkPost/wrapper.dart';
import 'content/globalVariable.dart';
import 'services/AuthService.dart';
// Import the firebase_app_check plugin
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  await FirebaseAppCheck.instance.activate(
    // webRecaptchaSiteKey:
    //     '6LcYPf8hAAAAABZF8vFS8zxpIm8O5z76eEWbA1Yy', // Only For Web
    // Set androidProvider to `AndroidProvider.debug`
    androidProvider: AndroidProvider.debug,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
    // DeviceOrientation.landscapeLeft,
    // DeviceOrientation.landscapeRight,
  ]);
  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle(
  //     statusBarBrightness: Brightness.light,
  //     statusBarColor: Colors.black,
  //   ),
  // );
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );

  // Set Ads behaviour data stored in storage
  prefs = await SharedPreferences.getInstance();
  initialiseAdsData(); // Controlled By firebase

  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  runApp(
    Provider.value(
      value: adState,
      builder: (context, child) => MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  // loadAdsSDK() async {
  //   sdkConfiguration = await AppLovinMAX.initialize('');
  // }

  @override
  void initState() {
    super.initState();
    // loadAdsSDK();
    // createInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser>.value(
      initialData: MyUser(),
      value: AuthService().userValidator,
      catchError: (_, err) {
        print('Custom Error : $err');
        return MyUser();
      },
      child: MaterialApp(
        title: 'Kingmaker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Wrapper(),
      ),
    );
  }
}

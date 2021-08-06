import 'package:farinwatatv/pages/root_page.dart';
import 'package:farinwatatv/theme/color.dart';
import 'package:farinwatatv/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/app_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp(model: AppModel()));
  });
}

class MyApp extends StatelessWidget {
  final AppModel model;
  const MyApp({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: model,
      child: FutureBuilder(
        future: model.initApp(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Splash(),
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData.dark(),
              home: RootPage(),
            );
          }
        },
      ),
    );
    // return FutureBuilder(
    //   future: Future.delayed(Duration(seconds: 3)),
    //   builder: (context, AsyncSnapshot snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return MaterialApp(home: Splash());
    //     } else {
    //
    //     }
    //   },
    // );
    // SplashScreen(
    //     gradientBackground: LinearGradient(
    //       begin: Alignment.topCenter,
    //       end: Alignment.bottomCenter,
    //       colors: [black, black],
    //     ),
    //     seconds: 5,
    //     navigateAfterSeconds: RootPage(),
    //     title: Text(
    //       'Farinwata TV\n On Startimes Channel 178 / 470',
    //       textAlign: TextAlign.center,
    //       style: TextStyle(
    //         fontFamily: 'Bad Script',
    //         fontSize: 20,
    //         color: grey,
    //         fontWeight: FontWeight.bold,
    //         letterSpacing: 2.0,
    //       ),
    //     ),
    //     image: Image.asset('assets/images/icon.png'),
    //     photoSize: 100.0,
    //     loaderColor: grey),
    // RootPage(),
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: black,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 120, bottom: 10),
                child: Image(
                  width: 150,
                  height: 150,
                  image: AssetImage('assets/images/icon.png'),
                ),
              ),
              Text(
                'Farinwata TV',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Bad Script',
                  fontSize: 20,
                  color: grey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              Text(
                'Startimes Channel 178 / 470',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Bad Script',
                  fontSize: 13,
                  color: grey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Progress.indicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

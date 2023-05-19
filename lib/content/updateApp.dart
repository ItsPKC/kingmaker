import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../navigation/clipShadowPath.dart';

class UpdateApp extends StatefulWidget {
  final _data;
  final String _currentVersion;
  UpdateApp(this._data, this._currentVersion);
  @override
  _UpdateAppState createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {
  var initialTimer = 5;
  reduceTimer() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        initialTimer -= 1;
      });
      if (initialTimer > 0) {
        reduceTimer();
      }
    });
  }

  Future<void> _makeRequestOutSide(url) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          print('Can\'t lauch now !!!');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Kingmaker',
                  style: TextStyle(
                    fontFamily: 'Signika',
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    letterSpacing: 1,
                    color: Color.fromRGBO(255, 0, 0, 1),
                  ),
                ),
                content: Text(
                  'Failed to connect ...',
                  style: TextStyle(
                    fontFamily: 'Signika',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    letterSpacing: 1,
                    color: Color.fromRGBO(36, 14, 123, 1),
                  ),
                ),
                actions: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 0, 0, 1),
                        border: Border.all(
                          color: Color.fromRGBO(255, 0, 0, 1),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Close',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          letterSpacing: 2,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print(e);
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text('WA Assist'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Icon(
                    Icons.network_check,
                    size: 32,
                    color: Color.fromRGBO(255, 0, 0, 1),
                  ),
                ),
                Text(
                  'No Internet',
                  style: TextStyle(
                    fontFamily: 'Signika',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    letterSpacing: 1,
                    color: Color.fromRGBO(36, 14, 123, 1),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              GestureDetector(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 0, 0, 1),
                    border: Border.all(
                      color: Color.fromRGBO(255, 0, 0, 1),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Close',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      letterSpacing: 2,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    reduceTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                margin: EdgeInsets.fromLTRB(0, 40, 0, 20),
                child: ClipShadowPath(
                  shadow: BoxShadow(
                    color: Color.fromRGBO(190, 190, 190, 1),
                    offset: Offset(0, 0.5),
                    blurRadius: 1,
                  ),
                  buildPath: getClip,
                  child: Container(
                    padding: EdgeInsets.only(top: 4),
                    height: 180,
                    width: 180,
                    color: Colors.white,
                    child: Image.asset(
                      'assets/logoSplash.png',
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Update Available !!!',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: const [
                                  Color.fromRGBO(100, 0, 255, 1),
                                  Color.fromARGB(255, 210, 6, 210),
                                  Color.fromRGBO(255, 60, 0, 1),
                                  Color.fromRGBO(255, 102, 0, 1),
                                  Color.fromRGBO(230, 0, 35, 1),
                                ],
                              ).createShader(
                                Rect.fromLTWH(0.0, 0.0, 300.0, 45.0),
                              ),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            '${widget._currentVersion}   -->   ${widget._data['version']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0,
                              color: Color.fromRGBO(230, 0, 35, 1),
                            ),
                          ),
                        ),
                        // FittedBox(
                        //   child: Text(
                        //     'Updated on  :  ${widget._data['date']}',
                        //     style: TextStyle(
                        //       // fontSize: 16,
                        //       fontWeight: FontWeight.w600,
                        //     ),
                        //   ),
                        // ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget._data['notice'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Signika',
                                height: 1.75,
                                color: Color.fromRGBO(36, 14, 123, 1)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: widget._data['compulsoryUpdate']
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(255, 0, 0, 1),
                                padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                              ),
                              onPressed: () async {
                                var url = widget._data['appLink'];
                                _makeRequestOutSide(url);
                              },
                              child: Text(
                                'Update Now',
                                style: TextStyle(
                                  fontFamily: 'Signika',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(255, 0, 0, 1),
                              ),
                              onPressed: () {
                                if (initialTimer == 0) {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text(
                                (initialTimer > 0)
                                    ? '$initialTimer'
                                    : 'Not Now',
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontFamily: 'Signika',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(255, 0, 0, 1),
                              ),
                              onPressed: () async {
                                var url = widget._data['appLink'];
                                _makeRequestOutSide(url);
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Update',
                                style: TextStyle(
                                  fontFamily: 'Signika',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Path getClip(Size size) {
  var path = Path();

  path.lineTo(0.0, 40.0);
  // path.lineTo(0.0, size.height);
  // path.lineTo(size.width, size.height);
  // path.lineTo(size.width, 40.0);
  path.lineTo(0, 78);
  path.quadraticBezierTo(20, size.height / 2, 20, size.height * 3 / 4);
  path.quadraticBezierTo(20, size.height, size.width / 3, size.height - 20);
  path.lineTo(size.width * 2 / 3, size.height - 20);
  path.quadraticBezierTo(
      size.width - 20, size.height, size.width - 20, size.height * 3 / 4);
  path.quadraticBezierTo(size.width - 20, size.height / 2, size.width, 78);
  path.lineTo(size.width, 40.0);
  path.quadraticBezierTo(size.width * 5 / 6, 40, size.width * 4 / 6, 20);
  path.quadraticBezierTo(size.width / 2, 0, size.width * 2 / 6, 20);
  path.quadraticBezierTo(size.width * 1 / 6, 40, 0, 40);
  path.lineTo(0.0, 0.0);
  path.close();
  return path;
}

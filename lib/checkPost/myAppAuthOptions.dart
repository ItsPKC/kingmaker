import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:kingmaker/navigation/clipShadowPath.dart';

import '../services/AuthService.dart';

class MyAppAuthOptions extends StatefulWidget {
  final Function pageNumberSelector;
  const MyAppAuthOptions(this.pageNumberSelector, {super.key});

  @override
  State<MyAppAuthOptions> createState() => _MyAppAuthOptionsState();
}

class _MyAppAuthOptionsState extends State<MyAppAuthOptions> {
  var wantToTryManualAuth = false;
  var progressIndicatorValue = false;
  _logInButtonAction() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        progressIndicatorValue = true;
      });
      var _result = await AuthService().logInWithGmail();
      print('#####################################################');
      print(_result);
      if (_result == 'Canceled') {
        setState(() {
          progressIndicatorValue = false;
        });
      }
      if (_result == null) {
        setState(() {
          progressIndicatorValue = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                authStatusHeading, // imported from AuthService.dart
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(230, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Signika',
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
              content: Text(
                authStatusMessage, // imported from AuthService.dart
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Signika',
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
              backgroundColor: Color.fromRGBO(255, 255, 255, 1),
              actionsAlignment: authStatusHeading != 'User Not Found'
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.spaceBetween,
              actions: [
                OutlinedButton(
                  // borderSide: BorderSide(
                  //   width: 1.5,
                  //   color: Color.fromRGBO(255, 0, 0, 1),
                  // ),
                  child: Text(
                    'Retry',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 0, 0, 1),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Signika',
                      letterSpacing: 1.5,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                if (authStatusHeading == 'User Not Found')
                  OutlinedButton(
                    // borderSide: BorderSide(
                    //   width: 1.5,
                    //   color: Color.fromRGBO(255, 0, 0, 1),
                    // ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(230, 0, 0, 1),
                      ),
                    ),
                    child: Text(
                      'Sign Up Now',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Signika',
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.pageNumberSelector(2);
                    },
                  ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text('GECA'),
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
                FittedBox(
                  child: Text(
                    'No internet  ?',
                    style: TextStyle(
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      letterSpacing: 1,
                      color: Color.fromRGBO(36, 14, 123, 1),
                    ),
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
  Widget build(BuildContext context) {
    return (progressIndicatorValue)
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(255, 255, 255, 1)),
            ),
          )
        : Stack(
            children: [
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   height: 55,
              //   alignment: Alignment.center,
              //   decoration: const BoxDecoration(
              //     color: Color.fromRGBO(255, 255, 255, 1),
              //     borderRadius: BorderRadius.only(
              //       bottomRight: Radius.circular(500),
              //       bottomLeft: Radius.circular(500),
              //     ),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Color.fromRGBO(0, 0, 0, 1),
              //         offset: Offset(0, 1),
              //         blurRadius: 1,
              //       ),
              //     ],
              //   ),
              //   child: Text(
              //     'Welcome to Kingmaker',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       // color: Color.fromRGBO(15, 35, 123, 1),
              //       fontWeight: FontWeight.w600,
              //       fontSize: 21,
              //       fontFamily: 'Signika',
              //       letterSpacing: 1,
              //       shadows: const [
              //         Shadow(
              //           color: Color.fromRGBO(255, 255, 255, 1),
              //           blurRadius: 2,
              //           offset: Offset(0, 0),
              //         ),
              //       ],
              //       foreground: Paint()
              //         ..shader = LinearGradient(
              //           begin: Alignment.bottomLeft,
              //           end: Alignment.topRight,
              //           colors: const [
              //             Color.fromRGBO(100, 0, 255, 1),
              //             Color.fromARGB(255, 210, 6, 210),
              //             Color.fromRGBO(255, 60, 0, 1),
              //             Color.fromRGBO(255, 102, 0, 1),
              //             Color.fromRGBO(230, 0, 35, 1),
              //           ],
              //         ).createShader(
              //           Rect.fromLTWH(0.0, 0.0, 300.0, 25.0),
              //         ),
              //     ),
              //   ),
              // ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  !wantToTryManualAuth
                      ? Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            alignment: Alignment.center,
                            child: ClipShadowPath(
                              shadow: BoxShadow(
                                color: Colors.black,
                                blurRadius: 1.5,
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
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(
                      top: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 55,
                          margin: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                blurRadius: 1,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    _logInButtonAction();
                                  },
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          height: 55,
                                          width: 55,
                                          padding: EdgeInsets.all(13),
                                          child:
                                              Image.asset('assets/Google.png'),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'Login with Google',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.navigate_next_rounded,
                                    color: Color.fromRGBO(230, 0, 0, 1),
                                    size: 34,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (wantToTryManualAuth)
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                Container(
                                  color: Color.fromRGBO(255, 255, 255, 0.5),
                                  height: 1.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5 -
                                          50,
                                  margin: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 1.5),
                                  alignment: Alignment.center,
                                  height: 20,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 0.5),
                                    borderRadius: BorderRadius.circular(25),
                                    // boxShadow: const [
                                    //   BoxShadow(
                                    //     blurRadius: 5,
                                    //     color: Color.fromRGBO(0, 0, 0, 0.25),
                                    //     offset: Offset(0, 1),
                                    //   ),
                                    // ],
                                  ),
                                  child: Text(
                                    'OR',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.5),
                                      fontFamily: 'Signika',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Color.fromRGBO(255, 255, 255, 0.5),
                                  height: 1.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5 -
                                          50,
                                  margin: EdgeInsets.fromLTRB(10, 0, 15, 0),
                                ),
                              ],
                            ),
                          ),

                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Container(
                        //         margin: EdgeInsets.fromLTRB(15, 10, 10, 0),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(8),
                        //           color: Color.fromRGBO(255, 255, 255, 1),
                        //           boxShadow: const [
                        //             BoxShadow(
                        //               color: Color.fromRGBO(0, 0, 0, 1),
                        //               blurRadius: 1,
                        //               offset: Offset(0, 1),
                        //             ),
                        //           ],
                        //         ),
                        //         child: ClipRRect(
                        //           borderRadius: BorderRadius.circular(8),
                        //           child: Material(
                        //             color: Colors.transparent,
                        //             child: InkWell(
                        //               onTap: () {
                        //                 widget.pageNumberSelector(1);
                        //               },
                        //               child: Container(
                        //                 height: 50,
                        //                 alignment: Alignment.center,
                        //                 padding: EdgeInsets.all(10),
                        //                 decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(8),
                        //                 ),
                        //                 child: Text(
                        //                   'Login',
                        //                   style: TextStyle(
                        //                     fontWeight: FontWeight.w600,
                        //                     fontSize: 18,
                        //                     letterSpacing: 1,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: Container(
                        //         margin: EdgeInsets.fromLTRB(10, 10, 15, 0),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(8),
                        //           color: Color.fromRGBO(255, 255, 255, 1),
                        //           boxShadow: const [
                        //             BoxShadow(
                        //               color: Color.fromRGBO(0, 0, 0, 1),
                        //               blurRadius: 1,
                        //               offset: Offset(0, 1),
                        //             ),
                        //           ],
                        //         ),
                        //         child: ClipRRect(
                        //           borderRadius: BorderRadius.circular(8),
                        //           child: Material(
                        //             color: Colors.transparent,
                        //             child: InkWell(
                        //               onTap: () {
                        //                 widget.pageNumberSelector(2);
                        //               },
                        //               child: Container(
                        //                 height: 50,
                        //                 alignment: Alignment.center,
                        //                 padding: EdgeInsets.all(10),
                        //                 decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(8),
                        //                 ),
                        //                 child: Text(
                        //                   'Signup',
                        //                   style: TextStyle(
                        //                     fontWeight: FontWeight.w600,
                        //                     fontSize: 18,
                        //                     letterSpacing: 1,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        if (wantToTryManualAuth)
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  blurRadius: 1,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  widget.pageNumberSelector(1);
                                },
                                child: Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: SizedBox(
                                          height: 55,
                                          width: 55,
                                          child: Icon(
                                            Icons.mail_rounded,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'Login with Email',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (wantToTryManualAuth)
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  blurRadius: 1,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  widget.pageNumberSelector(2);
                                },
                                child: Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: SizedBox(
                                          height: 55,
                                          width: 55,
                                          child: Icon(
                                            Icons.mail_rounded,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'Register with Email',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                        Container(
                          margin: EdgeInsets.fromLTRB(0, 30, 0, 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: Material(
                              color: Color.fromRGBO(255, 255, 255, 0.3),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    wantToTryManualAuth = !wantToTryManualAuth;
                                  });
                                },
                                child: Container(
                                  padding: wantToTryManualAuth
                                      ? EdgeInsets.fromLTRB(20, 4.5, 20, 4.5)
                                      : EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: wantToTryManualAuth == false
                                      ? Text(
                                          'Try custom Login or SignUp',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 0.6),
                                            fontFamily: 'Signika',
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.75,
                                          ),
                                        )
                                      : Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          size: 28,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
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

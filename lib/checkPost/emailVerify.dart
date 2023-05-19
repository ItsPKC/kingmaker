import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kingmaker/content/globalVariable.dart';
import 'package:kingmaker/services/AuthService.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailVerify extends StatefulWidget {
  final Function forceSetState;
  const EmailVerify(this.forceSetState, {Key? key}) : super(key: key);

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  var checkingStatus = false;
  var displayMessage = 'Your email is not verified';
  var lastResendAfter = prefs.get('lastResendAfter') ?? 120;
  var resendMailCounter = prefs.get('resendMailCounter') ?? 120;

  resendMailCounterController() async {
    if (resendMailCounter > 0) {
      Future.delayed(Duration(seconds: 1), () async {
        if (mounted) {
          setState(() {
            resendMailCounter -= 1;
          });
          resendMailCounterController();
          await prefs.setInt('resendMailCounter', resendMailCounter);
        }
      });
    } else {
      await prefs.setInt('lastResendAfter', min(2 * lastResendAfter, 3600));
    }
  }

  Future<void> isItVerified() async {
    setState(() {
      checkingStatus = true;
    });
    await AuthService().reloadAuthenticationToken().then((userData) async {
      print(
          '---------------isItVerifiedTes--------------${userData.emailVerified}');
      setState(() {
        checkingStatus = false;
      });
      if (userData.emailVerified) {
        await prefs.setBool('emailVerfied', true);
        emailVerfied = true;
        widget.forceSetState();
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Oops!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Color.fromRGBO(230, 0, 0, 1),
                fontFamily: 'Signika',
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Email verification is pending. Please check inbox and verify your email address.\n\nIf your are stuck, watch this video.\n',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Signika',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.7,
                    height: 1.25,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    try {
                      if (await canLaunchUrl(Uri.parse(
                          'https://www.youtube.com/watch?v=3bqo0iGvgk0'))) {
                        await launchUrl(
                          Uri.parse(
                              'https://www.youtube.com/watch?v=3bqo0iGvgk0'),
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        print('Can\'t lauch now !!!');
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(200, 200, 200, 1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Image.asset('assets/KingmakerGuide.png'),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 0, 0, 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextButton(
                  child: Text(
                    'OK',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      letterSpacing: 2,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    resendMailCounterController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Color.fromRGBO(0, 0, 0, 1),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      150,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.75,
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Icon(
                            Icons.email_rounded,
                            color: Color.fromRGBO(255, 255, 255, 1),
                            size: MediaQuery.of(context).size.width * 0.45,
                          ),
                        ),
                        Text(
                          'Email verification Pending!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.7),
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                            letterSpacing: 2,
                            height: 1.75,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 25),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            '${currentUserCredential.email}\n\nWe have sent a verification email. Please check inbox and verify your email address.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.7),
                              fontFamily: 'Signika',
                              // fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: 1,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(200, 255, 200, 1),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 1),
                                  blurRadius: 0.5,
                                ),
                              ],
                              gradient: LinearGradient(colors: const [
                                Color.fromRGBO(220, 220, 220, 1),
                                Color.fromRGBO(255, 255, 255, 1),
                                Color.fromRGBO(255, 255, 255, 1),
                              ], stops: const [
                                0.1,
                                0.2,
                                0.5
                              ]),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  isItVerified();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: 46,
                                        width: 46,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(23),
                                          child: Image(
                                            image:
                                                AssetImage('assets/logo.png'),
                                          ),
                                        ),
                                      ),
                                      checkingStatus
                                          ? CupertinoActivityIndicator(
                                              radius: 20,
                                            )
                                          : Text(
                                              'Continue',
                                              style: TextStyle(
                                                fontFamily: 'Signika',
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 2,
                                              ),
                                            ),
                                      Container(
                                        height: 46,
                                        width: 46,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(23),
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 36,
                                          color: Color.fromRGBO(255, 0, 0, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  await eraseCurrentUserDataToLogout();
                                  await AuthService().signOut();
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  child: Text(
                                    '< Back',
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 0.7),
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                      // decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  if (resendMailCounter > 0) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          'Please wait !',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color.fromRGBO(230, 0, 0, 1),
                                            fontFamily: 'Signika',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        content: Text(
                                          'You can send another verificaiton mail after $resendMailCounter seconds. ',
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Signika',
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.7,
                                          ),
                                        ),
                                        actions: [
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  Color.fromRGBO(255, 0, 0, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            child: TextButton(
                                              child: Text(
                                                'OK',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Signika',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 22,
                                                  letterSpacing: 2,
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                ),
                                              ),
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    var connectivityResult =
                                        await (Connectivity()
                                            .checkConnectivity());
                                    if (connectivityResult !=
                                        ConnectivityResult.none) {
                                      // ---------------------------------
                                      // This is on the top to avoid consecutive request for another mail
                                      resendMailCounter = 2 * lastResendAfter;
                                      lastResendAfter *= 2;
                                      await prefs.setInt('lastResendAfter',
                                          2 * lastResendAfter);
                                      resendMailCounterController();
                                      // ---------------------------------
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            'Email sent',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color:
                                                  Color.fromRGBO(230, 0, 0, 1),
                                              fontFamily: 'Signika',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          content: Text(
                                            'Another verification email has been sent successfully. Please check inbox and verify your email address. ',
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontFamily: 'Signika',
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.7,
                                            ),
                                          ),
                                          actions: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    255, 0, 0, 1),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                              child: TextButton(
                                                child: Text(
                                                  'OK',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Signika',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 22,
                                                    letterSpacing: 2,
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                      try {
                                        await AuthService()
                                            .resendVerificationMail();
                                      } catch (e) {
                                        print(e);
                                      }
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Kingmaker'),
                                            content: Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                                  child: Icon(
                                                    Icons.network_check,
                                                    size: 32,
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                  ),
                                                ),
                                                FittedBox(
                                                  child: Text(
                                                    'No internet  ?',
                                                    style: TextStyle(
                                                      fontFamily: 'Signika',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20,
                                                      letterSpacing: 1,
                                                      color: Color.fromRGBO(
                                                          36, 14, 123, 1),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 0, 0, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                child: TextButton(
                                                  child: Text(
                                                    'Close',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Signika',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 22,
                                                      letterSpacing: 2,
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 1),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 3, 0, 3),
                                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  child: Text(
                                    '${resendMailCounter > 0 ? resendMailCounter : ''}${resendMailCounter > 0 ? 's' : ''}${resendMailCounter > 0 ? ' - ' : ''}Resend verification mail',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 0.7),
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                      // decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

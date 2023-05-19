import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kingmaker/content/dpGramPlatform.dart';
import 'package:kingmaker/content/globalVariable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DpGram extends StatefulWidget {
  final Function _pageNumberSelector;
  const DpGram(this._pageNumberSelector, {Key? key}) : super(key: key);

  @override
  State<DpGram> createState() => _DpGramState();
}

class _DpGramState extends State<DpGram> {
  var isUpdatingPlatformPriority = false;

  Future _refresh() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text('WA Assist'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                Container(
                  height: 100,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Icon(
                    Icons.network_check,
                    size: 48,
                    color: Color.fromRGBO(36, 14, 123, 1),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 0, 0, 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextButton(
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
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        },
      );
    } else {
      if (privateInfo == null) {
        getPrivateInfo();
      }
      setState(() {});
    }
    return true;
  }

  // showIntro() async {
  //   var dpGramWarningShownCounter =
  //       prefs.getInt('dpGramWarningShownCounter') ?? 0;

  //   await prefs.setInt(
  //       'dpGramWarningShownCounter', (dpGramWarningShownCounter + 1));
  //   Future.delayed(
  //     Duration(milliseconds: 250),
  //     () {
  //       if (mounted) {
  //         showDialog(
  //           barrierDismissible: false,
  //           context: context,
  //           builder: (context) {
  //             return WillPopScope(
  //               onWillPop: () async {
  //                 return false;
  //               },
  //               child: AlertDialog(
  //                 content: Stack(
  //                   alignment: Alignment.bottomCenter,
  //                   children: [
  //                     Container(
  //                       color: Color.fromRGBO(255, 255, 255, 1),
  //                       // alignment: Alignment.topCenter,
  //                       child: Image.asset('assets/dpGramWarning.gif'),
  //                     ),
  //                     GestureDetector(
  //                       onTap: () async {
  //                         Navigator.pop(context);
  //                       },
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           shape: BoxShape.circle,
  //                           color: Color.fromRGBO(255, 255, 255, 1),
  //                           boxShadow: const [
  //                             BoxShadow(
  //                               color: Color.fromRGBO(0, 0, 0, 0.35),
  //                               offset: Offset(0, 1),
  //                               blurRadius: 1,
  //                             ),
  //                           ],
  //                         ),
  //                         child: Padding(
  //                           padding: EdgeInsets.all(8),
  //                           child: Icon(
  //                             Icons.close_rounded,
  //                             size: 28,
  //                             color: Color.fromRGBO(230, 0, 0, 1),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       }
  //     },
  //   );
  // }

  refresher100() {
    print('.....Refresher');
    Future.delayed(Duration(milliseconds: 200), () {
      // Don't mind regular setState call
      if (mounted) {
        setState(() {});
      }
      if (privateInfo == null) {
        refresher100();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // var dpGramWarningShownCounter = 0;
    // if (showndpGramWarning == false) {
    //   if (dpGramWarningShownCounter == 0) {
    //     showIntro();
    //   }
    //   showndpGramWarning = true;
    // }
    if (privateInfo == null) {
      refresher100();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (privateInfo == null) {
      return RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Container(
          padding: EdgeInsets.all(15),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                isGettingPrivateInfo
                    ? 'Please wait, fetching details.'
                    : 'Failed to fetch data',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Signika',
                  fontSize: 18,
                  letterSpacing: 1.5,
                  height: 2,
                  // fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              isGettingPrivateInfo
                  ? CupertinoActivityIndicator(
                      radius: 20,
                    )
                  : OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Color.fromRGBO(230, 0, 0, 1),
                        ),
                      ),
                      onPressed: () async {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult != ConnectivityResult.none) {
                          if (!isGettingPrivateInfo) {
                            getPrivateInfo();
                            setState(() {});
                          } else {
                            setState(() {});
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
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
                                    Container(
                                      height: 100,
                                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Icon(
                                        Icons.network_check,
                                        size: 48,
                                        color: Color.fromRGBO(36, 14, 123, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 0, 0, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: TextButton(
                                      child: Text(
                                        'Close',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Signika',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                          letterSpacing: 2,
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
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
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Text(
                          'Refresh',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(230, 0, 0, 1),
                            fontFamily: 'Signika',
                            fontSize: 16,
                            // fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).clearSnackBars();
        widget._pageNumberSelector(1);
        return false;
      },
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(244, 245, 255, 1),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 20, 15, 7.5),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(8),
                      // boxShadow: const [
                      //   BoxShadow(
                      //     color: Color.fromRGBO(0, 0, 0, 0.35),
                      //     blurRadius: 0.25,
                      //     offset: Offset(0, 0.25),
                      //   ),
                      // ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Column(
                        //   children: [
                        //     Container(
                        //       height: 60,
                        //       width: 60,
                        //       margin: EdgeInsets.only(bottom: 10),
                        //       decoration: BoxDecoration(
                        //         color: Color.fromRGBO(255, 255, 255, 1),
                        //         shape: BoxShape.circle,
                        //         boxShadow: const [
                        //           BoxShadow(
                        //             color: Colors.grey,
                        //             offset: Offset(0, 0.5),
                        //             blurRadius: 0.25,
                        //           ),
                        //         ],
                        //       ),
                        //       child: ClipRRect(
                        //         borderRadius: BorderRadius.circular(30),
                        //         child: Material(
                        //           child: InkWell(
                        //             onTap: () async {
                        //               if (!(piuserID == '' ||
                        //                   piuserID == 'Add User ID' ||
                        //                   pifirstName == '' ||
                        //                   pifirstName == 'Add Name')) {
                        //                 if (!isPublishingDpGram) {
                        //                   await updatePublicProfile();
                        //                 }
                        //               } else {
                        //                 showDialog(
                        //                   context: context,
                        //                   builder: (BuildContext context) {
                        //                     return AlertDialog(
                        //                       title: Text(
                        //                         'Please add "User ID" and "Name" to publish your profile on dpGram.com',
                        //                         textAlign: TextAlign.center,
                        //                         style: TextStyle(
                        //                           color: Color.fromRGBO(230, 0, 0, 1),
                        //                           fontWeight: FontWeight.w600,
                        //                           fontFamily: 'Signika',
                        //                           fontSize: 18,
                        //                           letterSpacing: 1,
                        //                           height: 1.25,
                        //                         ),
                        //                       ),
                        //                       backgroundColor:
                        //                           Color.fromRGBO(255, 255, 255, 1),
                        //                       actionsAlignment:
                        //                           MainAxisAlignment.spaceBetween,
                        //                       actions: [
                        //                         OutlinedButton(
                        //                           child: Text(
                        //                             'Close',
                        //                             style: TextStyle(
                        //                               color: Color.fromRGBO(
                        //                                   255, 0, 0, 1),
                        //                               fontWeight: FontWeight.w500,
                        //                               fontFamily: 'Signika',
                        //                               fontSize: 18,
                        //                             ),
                        //                           ),
                        //                           onPressed: () {
                        //                             Navigator.of(context).pop();
                        //                           },
                        //                         ),
                        //                         OutlinedButton(
                        //                           style: ButtonStyle(
                        //                             backgroundColor:
                        //                                 MaterialStateProperty.all(
                        //                               Color.fromRGBO(230, 0, 0, 1),
                        //                             ),
                        //                           ),
                        //                           child: Text(
                        //                             'Update now',
                        //                             style: TextStyle(
                        //                               color: Color.fromRGBO(
                        //                                   255, 255, 255, 1),
                        //                               fontWeight: FontWeight.w500,
                        //                               fontFamily: 'Signika',
                        //                               fontSize: 18,
                        //                             ),
                        //                           ),
                        //                           onPressed: () {
                        //                             Navigator.of(context).pop();
                        //                             widget._pageNumberSelector(8);
                        //                           },
                        //                         ),
                        //                       ],
                        //                     );
                        //                   },
                        //                 );
                        //               }
                        //             },
                        //             child: SizedBox(
                        //               height: 60,
                        //               width: 60,
                        //               child: isPublishingDpGram
                        //                   ? CupertinoActivityIndicator(
                        //                       radius: 15,
                        //                     )
                        //                   : Icon(
                        //                       Icons.publish_rounded,
                        //                       size: 30,
                        //                       color: Color.fromRGBO(255, 0, 0, 1),
                        //                     ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     Text(
                        //       'Update',
                        //       //'Publish',
                        //       style: TextStyle(
                        //         color: Color.fromRGBO(100, 100, 100, 1),
                        //         letterSpacing: 1,
                        //         fontFamily: 'Signika',
                        //         fontWeight: FontWeight.w600,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Future.delayed(Duration(milliseconds: 200),
                                      () {
                                    widget._pageNumberSelector(18);
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.analytics_rounded,
                                      size: 34,
                                      color: Color.fromRGBO(255, 120, 0, 1),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'Analytics',
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 120, 0, 1),
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  Future.delayed(Duration(milliseconds: 180),
                                      () async {
                                    if (!(piuserID == '' ||
                                        piuserID == 'Add User ID' ||
                                        pifirstName == '' ||
                                        pifirstName == 'Add Name')) {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) {
                                      //     return MyWebView(
                                      //         'https://dpgram.com/$piuserID');
                                      //   }),
                                      // );
                                      // makeRequest(
                                      //     context,
                                      //     Uri.parse(
                                      //         'https://dpgram.com/$piuserID'));
                                      try {
                                        if (await canLaunchUrl(Uri.parse(
                                            'https://dpgram.com/$piuserID'))) {
                                          await launchUrl(
                                            Uri.parse(
                                                'https://dpgram.com/$piuserID'),
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                        } else {
                                          print('Can\'t lauch now !!!');
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Please add "User ID" and "Name" to access your account.', // imported from AuthService.dart
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    230, 0, 0, 1),
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Signika',
                                                fontSize: 18,
                                                letterSpacing: 1,
                                                height: 1.25,
                                              ),
                                            ),
                                            backgroundColor: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            actionsAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            actions: [
                                              OutlinedButton(
                                                child: Text(
                                                  'Close',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        255, 0, 0, 1),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Signika',
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              OutlinedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    Color.fromRGBO(
                                                        230, 0, 0, 1),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Update now',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Signika',
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  widget._pageNumberSelector(8);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.visibility_rounded,
                                      size: 34,
                                      // color: Color.fromRGBO(0, 165, 65, 1),
                                      color: Color.fromRGBO(36, 14, 123, 1),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'Preview',
                                      style: TextStyle(
                                        // color: Color.fromRGBO(0, 165, 65, 1),
                                        color: Color.fromRGBO(36, 14, 123, 1),
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Future.delayed(Duration(milliseconds: 200),
                                      () {
                                    accountSettingRedirectNumber = 11;
                                    widget._pageNumberSelector(8);
                                  });

                                  // if (!(piuserID == '' ||
                                  //     piuserID == 'Add User ID' ||
                                  //     pifirstName == '' ||
                                  //     pifirstName == 'Add Name')) {
                                  //   Share.share(
                                  //     '*Hello !*\n\nTake a look at my Digital Empire and *join me* on every platform.\n\n👉  dpGram.com/$piuserID\n\n*Thanks.*',
                                  //   );
                                  // } else {
                                  //   showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       return AlertDialog(
                                  //         title: Text(
                                  //           'Please add "User ID" and "Name" to share your dpGram profile.', // imported from AuthService.dart
                                  //           textAlign: TextAlign.center,
                                  //           style: TextStyle(
                                  //             color: Color.fromRGBO(230, 0, 0, 1),
                                  //             fontWeight: FontWeight.w600,
                                  //             fontFamily: 'Signika',
                                  //             fontSize: 18,
                                  //             letterSpacing: 1,
                                  //             height: 1.25,
                                  //           ),
                                  //         ),
                                  //         backgroundColor:
                                  //             Color.fromRGBO(255, 255, 255, 1),
                                  //         actionsAlignment:
                                  //             MainAxisAlignment.spaceBetween,
                                  //         actions: [
                                  //           OutlinedButton(
                                  //             child: Text(
                                  //               'Close',
                                  //               style: TextStyle(
                                  //                 color: Color.fromRGBO(
                                  //                     255, 0, 0, 1),
                                  //                 fontWeight: FontWeight.w500,
                                  //                 fontFamily: 'Signika',
                                  //                 fontSize: 18,
                                  //               ),
                                  //             ),
                                  //             onPressed: () {
                                  //               Navigator.of(context).pop();
                                  //             },
                                  //           ),
                                  //           OutlinedButton(
                                  //             style: ButtonStyle(
                                  //               backgroundColor:
                                  //                   MaterialStateProperty.all(
                                  //                 Color.fromRGBO(230, 0, 0, 1),
                                  //               ),
                                  //             ),
                                  //             child: Text(
                                  //               'Update now',
                                  //               style: TextStyle(
                                  //                 color: Color.fromRGBO(
                                  //                     255, 255, 255, 1),
                                  //                 fontWeight: FontWeight.w500,
                                  //                 fontFamily: 'Signika',
                                  //                 fontSize: 18,
                                  //               ),
                                  //             ),
                                  //             onPressed: () {
                                  //               Navigator.of(context).pop();
                                  //               widget._pageNumberSelector(8);
                                  //             },
                                  //           ),
                                  //         ],
                                  //       );
                                  //     },
                                  //   );
                                  // }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.manage_accounts_rounded,
                                      size: 34,
                                      // color: Color.fromRGBO(36, 14, 123, 1),
                                      color: Color.fromRGBO(0, 165, 65, 1),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'Settings',
                                      style: TextStyle(
                                        // color: Color.fromRGBO(36, 14, 123, 1),

                                        color: Color.fromRGBO(0, 165, 65, 1),
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(15, 7.5, 15, 20),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(8),
                      // border: Border(
                      //   top: BorderSide(
                      //     color: Color.fromRGBO(200, 200, 200, 1),
                      //     style: BorderStyle.solid,
                      //   ),
                      // ),
                      // boxShadow: const [
                      //   BoxShadow(
                      //     color: Color.fromRGBO(0, 0, 0, 0.35),
                      //     blurRadius: 0.25,
                      //     offset: Offset(0, 0.25),
                      //   ),
                      // ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            height: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              child: Material(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                child: InkWell(
                                  onTap: () {
                                    Future.delayed(
                                      Duration(milliseconds: 200),
                                      () {
                                        aboutInitialExpanderNumber = 1;
                                        widget._pageNumberSelector(8);
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 15),
                                    alignment: Alignment.centerLeft,
                                    height: 20,
                                    child: FittedBox(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'dpGram.com/',
                                              style: TextStyle(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                fontSize: 16,
                                                fontFamily: 'Signika',
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            TextSpan(
                                              text: piuserID,
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    230, 0, 35, 1),
                                                fontSize: 16,
                                                fontFamily: 'Signika',
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic,
                                                letterSpacing: 0.5,
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
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              if (!(piuserID == '' ||
                                  piuserID == 'Add User ID' ||
                                  pifirstName == '' ||
                                  pifirstName == 'Add Name')) {
                                await Clipboard.setData(
                                  ClipboardData(
                                      text: 'https://dpGram.com/$piuserID'),
                                );
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(milliseconds: 750),
                                    content: Text(
                                      'Your dpGram link copied.',
                                      style: TextStyle(
                                        fontFamily: 'Signika',
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Please add "User ID" and "Name" to get your link.', // imported from AuthService.dart
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color.fromRGBO(230, 0, 0, 1),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Signika',
                                          fontSize: 18,
                                          letterSpacing: 1,
                                          height: 1.25,
                                        ),
                                      ),
                                      backgroundColor:
                                          Color.fromRGBO(255, 255, 255, 1),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      actions: [
                                        OutlinedButton(
                                          child: Text(
                                            'Close',
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(255, 0, 0, 1),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              fontSize: 18,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        OutlinedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Color.fromRGBO(230, 0, 0, 1),
                                            ),
                                          ),
                                          child: Text(
                                            'Update now',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              fontSize: 18,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            widget._pageNumberSelector(8);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Container(
                              height: 60,
                              width: 50,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.copy,
                                color: Color.fromRGBO(0, 0, 0, 0.2),
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              if (!(piuserID == '' ||
                                  piuserID == 'Add User ID' ||
                                  pifirstName == '' ||
                                  pifirstName == 'Add Name')) {
                                Share.share(
                                  // '*Hello !*\n\nTake a look at the $pifirstName\'s Digital Empire.\n\n👉  dpGram.com/$piuserID',
                                  '*Hello !*\n\nTake a look at my Digital Empire and *join me* on every platform.\n\n👉  dpGram.com/$piuserID\n\n*Thanks.*',
                                  // '*Hello !*\n\nTake a look at my Digital Empire. It would be nice to see you there.\n\nLet\'s explore it -\n\n👉  dpGram.com/$piuserID\n\nThanks.',
                                ); //3z4mkze
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Please add "User ID" and "Name" to share your dpGram profile.', // imported from AuthService.dart
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color.fromRGBO(230, 0, 0, 1),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Signika',
                                          fontSize: 18,
                                          letterSpacing: 1,
                                          height: 1.25,
                                        ),
                                      ),
                                      backgroundColor:
                                          Color.fromRGBO(255, 255, 255, 1),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      actions: [
                                        OutlinedButton(
                                          child: Text(
                                            'Close',
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(255, 0, 0, 1),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              fontSize: 18,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        OutlinedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Color.fromRGBO(230, 0, 0, 1),
                                            ),
                                          ),
                                          child: Text(
                                            'Update now',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              fontSize: 18,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            widget._pageNumberSelector(8);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Container(
                              height: 60,
                              width: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Color.fromRGBO(0, 0, 0, 0.05),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              child: Icon(
                                Icons.share,
                                size: 26,
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

            // GestureDetector(
            //   child: Container(
            //     height: 50,
            //     padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
            //     margin: EdgeInsets.fromLTRB(15, 25, 15, 10),
            //     decoration: BoxDecoration(
            //       color: Color.fromRGBO(8, 8, 8, 1),
            //       borderRadius: BorderRadius.circular(10),
            //       boxShadow: const [
            //         BoxShadow(
            //           color: Colors.grey,
            //           offset: Offset(0, 0.5),
            //           blurRadius: 0.25,
            //         )
            //       ],
            //       gradient: LinearGradient(
            //         colors: const [
            //           Color.fromRGBO(230, 0, 0, 0.8),
            //           Color.fromRGBO(230, 0, 0, 1)
            //         ],
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //       ),
            //     ),
            //     child: Row(
            //       children: const [
            //         Icon(
            //           Icons.manage_accounts_rounded,
            //           size: 24,
            //           color: Color.fromRGBO(255, 255, 255, 1),
            //         ),
            //         SizedBox(
            //           width: 15,
            //         ),
            //         Text(
            //           'About me',
            //           style: TextStyle(
            //             color: Color.fromRGBO(255, 255, 255, 1),
            //             fontSize: 16,
            //             fontFamily: 'Signika',
            //             fontWeight: FontWeight.w600,
            //             letterSpacing: 2,
            //           ),
            //         ),
            //         Expanded(
            //           child: Align(
            //             alignment: Alignment.centerRight,
            //             child: Icon(
            //               Icons.arrow_forward_ios_rounded,
            //               size: 20,
            //               color: Color.fromRGBO(255, 255, 255, 1),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            //   onTap: () {
            //     widget._pageNumberSelector(8);
            //   },
            // ),
            Container(
              height: 50,
              // width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [
                    Color.fromRGBO(244, 245, 255, 1),
                    Color.fromRGBO(255, 255, 255, 1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                // boxShadow: const [
                //   BoxShadow(
                //     color: Colors.grey,
                //     offset: Offset(0, 0.5),
                //     blurRadius: 0.25,
                //   )
                // ],
                // gradient: LinearGradient(
                //   colors: const [
                //     Color.fromRGBO(16, 16, 16, 0.8),
                //     Color.fromRGBO(16, 16, 16, 1)
                //   ],
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                // ),
                // gradient: LinearGradient(
                //   colors: const [
                //     Colors.blue,
                //     Color.fromRGBO(175, 6, 175, 1),
                //     Color.fromRGBO(255, 60, 0, 1),
                //     Colors.orange,
                //     Color.fromRGBO(255, 102, 0, 1)
                //   ],
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(9, 10, 9, 10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 22.5,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(0, 2.5, 0, 0),
                        child: FittedBox(
                          child: Text(
                            'PROFILE BOOK',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color.fromRGBO(230, 0, 35, 1),
                              fontSize: 16,
                              fontFamily: 'Signika',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                blurRadius: 1,
                                offset: Offset(0, 0.5),
                              ),
                            ],
                          ),
                          child: Material(
                            // color: Color.fromRGBO(50, 50, 50, 1),
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  // border: Border.all(
                                  //   color: Color.fromRGBO(0, 0, 0, 0.1),
                                  //   width: 0.5,
                                  // ),
                                ),
                                child: Icon(
                                  Icons.add_rounded,
                                  // color: Color.fromRGBO(255, 255, 255, 1),
                                  color: Color.fromRGBO(36, 14, 123, 1),
                                ),
                              ),
                              onTap: () {
                                widget._pageNumberSelector(12);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 17,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                blurRadius: 1,
                                offset: Offset(0, 0.5),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  // border: Border.all(
                                  //   color: Color.fromRGBO(0, 0, 0, 0.1),
                                  //   width: 0.5,
                                  // ),
                                ),
                                child: Icon(
                                  Icons.shuffle_rounded,
                                  size: 21,
                                  // color: Color.fromRGBO(255, 255, 255, 1),
                                  color: Color.fromRGBO(36, 14, 123, 1),
                                ),
                              ),
                              onTap: () async {
                                widget._pageNumberSelector(13);
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            DpGramPlatform(widget._pageNumberSelector, _refresh),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

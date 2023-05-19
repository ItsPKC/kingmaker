import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kingmaker/content/dpGramPlatform.dart';
import 'package:kingmaker/content/globalVariable.dart';
import 'package:kingmaker/services/googleAds.dart';
import 'package:url_launcher/url_launcher.dart';

class DpGram extends StatefulWidget {
  final Function _pageNumberSelector;
  const DpGram(this._pageNumberSelector, {Key? key}) : super(key: key);

  @override
  State<DpGram> createState() => _DpGramState();
}

class _DpGramState extends State<DpGram> {
  var isPublishingDpGram = false;
  var isUpdatingPlatformPriority = false;

  Future<void> updatePublicProfile() async {
    showInterstitialAd();
    setState(() {
      isPublishingDpGram = true;
    });
    print('--------------');
    var _publish = FirebaseFunctions.instanceFor(region: 'asia-south1')
        .httpsCallable('updatePublicProfile');
    await _publish({}).then((value) {
      setState(() {
        isPublishingDpGram = false;
      });
      if (value.data == 'Successful') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            content: Text(
              'Congratulations! dpGram has been updated.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: 'Signika',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
                height: 1.5,
              ),
            ),
          ),
        );
      }
    }).catchError((error) {
      setState(() {
        isPublishingDpGram = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1500),
          content: Text(
            'Failed to updated.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'Signika',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
              height: 1.5,
            ),
          ),
        ),
      );
    });
  }

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
  }

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
              decoration: BoxDecoration(
                color: Color.fromRGBO(200, 255, 255, 1),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 0.25),
                    blurRadius: 0.25,
                  ),
                ],
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
                    child: InkWell(
                      onTap: () {
                        widget._pageNumberSelector(18);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 45,
                            width: 45,
                            child: isPublishingDpGram
                                ? CupertinoActivityIndicator(
                                    radius: 15,
                                  )
                                : Icon(
                                    Icons.analytics_rounded,
                                    size: 30,
                                    color: Color.fromRGBO(255, 0, 0, 1),
                                  ),
                          ),
                          Text(
                            'Analytics',
                            //'Publish',
                            style: TextStyle(
                              color: Color.fromRGBO(100, 100, 100, 1),
                              letterSpacing: 1,
                              fontFamily: 'Signika',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
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
                            if (await canLaunchUrl(
                                Uri.parse('https://dpgram.com/$piuserID'))) {
                              await launchUrl(
                                Uri.parse('https://dpgram.com/$piuserID'),
                                mode: LaunchMode.externalApplication,
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
                                        color: Color.fromRGBO(255, 0, 0, 1),
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
                                        color: Color.fromRGBO(255, 255, 255, 1),
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
                      child: Column(
                        children: [
                          SizedBox(
                            height: 45,
                            width: 45,
                            child: isPublishingDpGram
                                ? CupertinoActivityIndicator(
                                    radius: 15,
                                  )
                                : Icon(
                                    Icons.visibility_rounded,
                                    size: 31,
                                    color: Color.fromRGBO(255, 0, 0, 1),
                                  ),
                          ),
                          Text(
                            'Preview',
                            style: TextStyle(
                              color: Color.fromRGBO(100, 100, 100, 1),
                              letterSpacing: 1,
                              fontFamily: 'Signika',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Future.delayed(Duration(milliseconds: 200), () {
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
                        children: [
                          SizedBox(
                            height: 45,
                            width: 45,
                            child: isPublishingDpGram
                                ? CupertinoActivityIndicator(
                                    radius: 15,
                                  )
                                : Icon(
                                    Icons.manage_accounts_rounded,
                                    size: 30,
                                    color: Color.fromRGBO(255, 0, 0, 1),
                                  ),
                          ),
                          Text(
                            'Settings',
                            style: TextStyle(
                              color: Color.fromRGBO(100, 100, 100, 1),
                              letterSpacing: 1,
                              fontFamily: 'Signika',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 0.5),
                    blurRadius: 0.25,
                  )
                ],
                gradient: LinearGradient(
                  colors: const [
                    Color.fromRGBO(16, 16, 16, 0.8),
                    Color.fromRGBO(16, 16, 16, 1)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 20,
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        child: Text(
                          'PROFILE BOOK',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 16,
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w600,
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
                      Material(
                        color: Color.fromRGBO(50, 50, 50, 1),
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Color.fromRGBO(100, 100, 100, 1),
                              ),
                            ),
                            child: Icon(
                              Icons.add_rounded,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                          onTap: () {
                            widget._pageNumberSelector(12);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Material(
                        color: Color.fromRGBO(50, 50, 50, 1),
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
                              border: Border.all(
                                color: Color.fromRGBO(100, 100, 100, 1),
                              ),
                            ),
                            // child: FittedBox(
                            //   child: Text(
                            //     'Reorder',
                            //     overflow: TextOverflow.ellipsis,
                            //     style: TextStyle(
                            //       color: Color.fromRGBO(255, 255, 255, 1),
                            //       fontFamily: 'Signika',
                            //       fontWeight: FontWeight.w500,
                            //       letterSpacing: 1,
                            //     ),
                            //   ),
                            // ),
                            child: Icon(
                              Icons.shuffle_rounded,
                              size: 21,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                          onTap: () async {
                            widget._pageNumberSelector(13);
                          },
                        ),
                      ),
                    ],
                  )
                ],
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

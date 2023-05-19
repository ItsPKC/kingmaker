import 'package:flutter/material.dart';
import 'package:kingmaker/content/globalVariable.dart';
import 'package:kingmaker/permisson/storagePermissionDenied.dart';
import 'package:permission_handler/permission_handler.dart';

class JoinTrend extends StatefulWidget {
  final Function _pageNumberSelector;
  JoinTrend(this._pageNumberSelector, {Key? key}) : super(key: key);

  @override
  _JoinTrendState createState() => _JoinTrendState();
}

class _JoinTrendState extends State<JoinTrend> {
  var _animationConstant = 1.0;
  final _textList = [
    '#Hashtag',
    '#Audio',
    '#Reels',
    '#Shorts',
    '#Snap',
    '#Memes',
    '& many more',
  ];

  setTextList() {
    // To avoid error due termination on last index
    if (textListIndex > _textList.length - 1) {
      // -1 - last not allowed
      textListIndex = 0;
    }
    Future.delayed(Duration(milliseconds: 750), () {
      // 750 added on next call
      // Change Opticity
      if (mounted) {
        if (_animationConstant == 1.0) {
          setState(() {
            _animationConstant = 0.0;
          });
        } else {
          setState(() {
            _animationConstant = 1.0;
          });
        }
      }

      // Change Text
      Future.delayed(
        Duration(milliseconds: 500),
        () {
          if (mounted) {
            setState(() {
              if (textListIndex == _textList.length - 1) {
                //4 to skip last part
                textListIndex = 0;
              } else {
                textListIndex += 1;
              }
            });
          }
          prefs.setInt('textListIndex', textListIndex);
        },
      );

      // Change Opticity
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          if (_animationConstant == 1.0) {
            setState(() {
              _animationConstant = 0.0;
            });
          } else {
            setState(() {
              _animationConstant = 1.0;
            });
          }
        }
      });

      if (textListIndex == _textList.length - 2) {
        //max-1
        Future.delayed(Duration(seconds: 3), () {
          if (mounted) {
            setTextList();
          }
        });
      } else {
        Future.delayed(Duration(milliseconds: 750), () {
          if (mounted) {
            setTextList();
          }
        });
      }
    });
  }

  myGrid(icon, name, fnc) {
    return GestureDetector(
      onTap: fnc,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(
          //   color: Color.fromRGBO(0, 0, 0, 1),
          //   width: 1,
          // ),
          // gradient: LinearGradient(
          //   colors: const [
          //     Color.fromRGBO(0, 0, 0, 1),
          //     Color.fromRGBO(50, 50, 50, 1),
          //     Color.fromRGBO(0, 0, 0, 1),
          //   ],
          //   stops: const [0, 0.8, 1],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              offset: Offset(0.5, 0.75),
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: icon,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(2, 6, 2, 6),
              height: 30,
              decoration: BoxDecoration(
                color: Color.fromRGBO(250, 250, 250, 1),
                // borderRadius: BorderRadius.circular(3.5),
                // backgroundBlendMode: BlendMode.colorBurn,
                // gradient: LinearGradient(
                //   colors: const [
                //     Color.fromRGBO(50, 50, 50, 1),
                //     Color.fromRGBO(0, 0, 0, 1),
                //   ],
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                // ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: FittedBox(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Signika',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    // color: Color.fromRGBO(255, 255, 255, 1),
                    color: Color.fromRGBO(230, 0, 35, 1),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkStorageAccess() async {
    var _status = await Permission.storage.status;
    if (_status.isGranted) {
      return;
    } else if (_status.isPermanentlyDenied) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoragePermissionDenied(),
        ),
      );
    } else {
      await Permission.storage.request().then((value) {
        if (value.isGranted) {
          return;
        }
        if (value.isGranted == false) {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoragePermissionDenied(),
            ),
          );
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setTextList();
  }

  @override
  Widget build(BuildContext context) {
    // if (privateInfo == null) {
    //   return RefreshIndicator(
    //     onRefresh: () async {
    //       setState(() {});
    //     },
    //     child: Container(
    //       padding: EdgeInsets.all(15),
    //       alignment: Alignment.center,
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         mainAxisSize: MainAxisSize.max,
    //         children: [
    //           Text(
    //             isGettingPrivateInfo
    //                 ? 'Please wait, fetching details.'
    //                 : 'Failed to fetch data',
    //             textAlign: TextAlign.center,
    //             style: TextStyle(
    //               fontFamily: 'Signika',
    //               fontSize: 18,
    //               letterSpacing: 1.5,
    //               height: 2,
    //               // fontWeight: FontWeight.w600,
    //             ),
    //           ),
    //           SizedBox(
    //             height: 50,
    //           ),
    //           isGettingPrivateInfo
    //               ? CupertinoActivityIndicator(
    //                   radius: 20,
    //                 )
    //               : OutlinedButton(
    //                   style: OutlinedButton.styleFrom(
    //                     side: BorderSide(
    //                       color: Color.fromRGBO(230, 0, 0, 1),
    //                     ),
    //                   ),
    //                   onPressed: () async {
    //                     var connectivityResult =
    //                         await (Connectivity().checkConnectivity());
    //                     if (connectivityResult != ConnectivityResult.none) {
    //                       if (!isGettingPrivateInfo) {
    //                         getPrivateInfo();
    //                         setState(() {});
    //                       } else {
    //                         setState(() {});
    //                       }
    //                     } else {
    //                       showDialog(
    //                         context: context,
    //                         builder: (context) {
    //                           return AlertDialog(
    //                             content: Column(
    //                               mainAxisSize: MainAxisSize.min,
    //                               children: [
    //                                 FittedBox(
    //                                   child: Text(
    //                                     'No internet  ?',
    //                                     style: TextStyle(
    //                                       fontFamily: 'Signika',
    //                                       fontWeight: FontWeight.w600,
    //                                       fontSize: 20,
    //                                       letterSpacing: 1,
    //                                       color: Color.fromRGBO(36, 14, 123, 1),
    //                                     ),
    //                                   ),
    //                                 ),
    //                                 Container(
    //                                   height: 100,
    //                                   margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //                                   child: Icon(
    //                                     Icons.network_check,
    //                                     size: 48,
    //                                     color: Color.fromRGBO(36, 14, 123, 1),
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                             actions: <Widget>[
    //                               Container(
    //                                 width: double.infinity,
    //                                 decoration: BoxDecoration(
    //                                   color: Color.fromRGBO(255, 0, 0, 1),
    //                                   borderRadius: BorderRadius.circular(5),
    //                                 ),
    //                                 // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //                                 child: TextButton(
    //                                   child: Text(
    //                                     'Close',
    //                                     textAlign: TextAlign.center,
    //                                     style: TextStyle(
    //                                       fontFamily: 'Signika',
    //                                       fontWeight: FontWeight.w600,
    //                                       fontSize: 22,
    //                                       letterSpacing: 2,
    //                                       color:
    //                                           Color.fromRGBO(255, 255, 255, 1),
    //                                     ),
    //                                   ),
    //                                   onPressed: () async {
    //                                     Navigator.of(context).pop();
    //                                   },
    //                                 ),
    //                               ),
    //                             ],
    //                           );
    //                         },
    //                       );
    //                     }
    //                   },
    //                   child: Container(
    //                     padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //                     child: Text(
    //                       'Refresh',
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                         color: Color.fromRGBO(230, 0, 0, 1),
    //                         fontFamily: 'Signika',
    //                         fontSize: 16,
    //                         // fontWeight: FontWeight.w600,
    //                         letterSpacing: 2,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    // Show only after initital Data is loaded.
    return WillPopScope(
      onWillPop: () async {
        widget._pageNumberSelector(1);
        return false;
      },
      child: Container(
        color: Color.fromRGBO(255, 255, 255, 1),
        child: Stack(
          children: [
            ListView(
              children: [
                Container(
                  // 15 + 55 = 70
                  margin: EdgeInsets.fromLTRB(15, 76, 15, 15),
                  decoration: BoxDecoration(
                    // color: Color.fromRGBO(16, 16, 16, 1),
                    borderRadius: BorderRadius.circular(8),
                    // border: Border.all(
                    //   width: 2,
                    //   color: Color.fromRGBO(16, 16, 16, 1),
                    // ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 0.5),
                        blurRadius: 0.25,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 155,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            Opacity(
                              opacity: 0.2,
                              child: SizedBox(
                                height: 155,
                                child: Image.asset(
                                  'assets/JoinTrend.png',
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                ),
                              ),
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity: _animationConstant,
                                child: Center(
                                  child: Text(
                                    _textList[textListIndex],
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontSize: 32,
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            AnimatedOpacity(
                              duration: Duration(milliseconds: 500),
                              opacity: textListIndex == _textList.length - 1
                                  ? 0.0
                                  : 1.0,
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                child: Text(
                                  'Trending',
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 0.6),
                                    // fontSize: 18,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w700,
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
                GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  // padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 50),

                  children: [
                    // ...(joinTrendType).map(
                    //   (e) => myGrid(
                    //     Icon(
                    //       Icons.travel_explore_rounded,
                    //       size: 34,
                    //     ),
                    //     e,
                    //     () {
                    //       currentSoundType = e;
                    //       widget._pageNumberSelector(9);
                    //     },
                    //   ),
                    // ),
                    if (joinTrendType.contains('Global'))
                      myGrid(
                        Icon(
                          Icons.travel_explore_rounded,
                          size: 34,
                          color: Color.fromRGBO(36, 14, 123, 1),
                        ),
                        'Global',
                        () {
                          currentSoundType = 'Global';
                          widget._pageNumberSelector(9);
                        },
                      ),
                    if (joinTrendType.contains('Music'))
                      myGrid(
                        Icon(
                          Icons.music_note_rounded,
                          size: 34,
                          color: Color.fromRGBO(36, 14, 123, 1),
                        ),
                        'Music',
                        () {
                          currentSoundType = 'Music';
                          widget._pageNumberSelector(9);
                        },
                      ),
                    if (joinTrendType.contains('Dialog'))
                      myGrid(
                        Icon(
                          Icons.mic,
                          size: 34,
                          color: Color.fromRGBO(36, 14, 123, 1),
                        ),
                        'Dialog',
                        () {
                          currentSoundType = 'Dialog';
                          widget._pageNumberSelector(9);
                        },
                      ),
                    if (joinTrendType.contains('Poetry'))
                      myGrid(
                        Icon(
                          // Icons.border_color_rounded,
                          Icons.auto_stories_rounded,
                          size: 30,
                          color: Color.fromRGBO(36, 14, 123, 1),
                        ),
                        'Poetry',
                        () {
                          currentSoundType = 'Poetry';
                          widget._pageNumberSelector(9);
                        },
                      ),
                    if (joinTrendType.contains('Motivation'))
                      myGrid(
                        Icon(
                          Icons.psychology_rounded,
                          size: 36,
                          color: Color.fromRGBO(36, 14, 123, 1),
                        ),
                        'Motivation',
                        () {
                          currentSoundType = 'Motivation';
                          widget._pageNumberSelector(9);
                        },
                      ),
                    if (joinTrendType.contains('Tunes'))
                      myGrid(
                        Icon(
                          Icons.tune_rounded,
                          size: 34,
                          color: Color.fromRGBO(36, 14, 123, 1),
                        ),
                        'Tunes',
                        () {
                          currentSoundType = 'Tunes';
                          widget._pageNumberSelector(9);
                        },
                      ),
                    if (joinTrendType.contains('Tech'))
                      myGrid(
                        Icon(
                          Icons.computer,
                          size: 36,
                          color: Color.fromRGBO(36, 14, 123, 1),
                        ),
                        'Tech',
                        () {
                          currentSoundType = 'Tech';
                          widget._pageNumberSelector(9);
                        },
                      ),
                    if (joinTrendType.contains('Memes'))
                      myGrid(
                        Icon(
                          Icons.face_rounded,
                          size: 36,
                          color: Color.fromRGBO(36, 14, 123, 1),
                        ),
                        'Memes',
                        () {
                          currentSoundType = 'Memes';
                          widget._pageNumberSelector(9);
                        },
                      ),
                  ],
                ),
              ],
            ),
            Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(170, 170, 170, 1),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      widget._pageNumberSelector(1);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.fromLTRB(8, 8, 0, 8),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(right: 3),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        shape: BoxShape.circle,
                        // image: DecorationImage(
                        //   image: AssetImage('assets/logoAppBar.png'),
                        // ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            offset: Offset(0, 0),
                            blurRadius: 1,
                          )
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color.fromRGBO(255, 0, 0, 1),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Join the trend',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Signika',
                        fontSize: 22,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(255, 0, 0, 1),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 15),
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 56,
                      child: Icon(
                        Icons.trending_up_rounded,
                        size: 34,
                        color: Color.fromRGBO(255, 0, 0, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

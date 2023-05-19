import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kingmaker/content/dpGramReferralCheck.dart';
import 'package:kingmaker/content/globalVariable.dart';
import 'package:kingmaker/permisson/storagePermissionDenied.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  final Function _pageNumberSelector;
  HomeScreen(this._pageNumberSelector, {Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isSetTextListRunning = false;
  var _animationConstant = 1.0;
  final _textList = [
    '#Hashtag',
    '#Audio',
    '#Reels',
    '#Shorts',
    '#Snap',
    '#Memes',
    '& many more',
    'Try Now',
  ];

  setTextList() {
    // To avoid error due termination on last index
    if (textListIndex > _textList.length - 1) {
      textListIndex = 0;
    }
    Future.delayed(Duration(milliseconds: 1000), () {
      //500 added on next call
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
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted) {
            setTextList();
          }
        });
      }
    });
  }

  myGrid(element) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 1.5,
            offset: Offset(0, 0.5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Material(
          color: Color.fromRGBO(255, 255, 255, 1),
          child: InkWell(
            onTap: () {
              makeRequestExternal(context,
                  Uri.parse('https://dpgram.com/${element['username']}'));
            },
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // border: Border.all(
                //   color: Color.fromRGBO(0, 0, 0, 0.25),
                //   width: 0.5,
                // ),
                // boxShadow: const [
                //   BoxShadow(
                //     color: Colors.grey,
                //     offset: Offset(0, 0.5),
                //     blurRadius: 1,
                //   ),
                // ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            border: Border.all(
                              width: 0.5,
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            maxRadius:
                                MediaQuery.of(context).size.width * 0.125,
                            child: ClipOval(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: '${element['imageLink']}',
                                    imageBuilder: (context, imageProvider) {
                                      return Image(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        backgroundColor:
                                            Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/person.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
                          child: FittedBox(
                            child: Row(
                              children: [
                                Text(
                                  '${element['name']}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Signika',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                if (element['verifyStatus'] ?? false)
                                  Icon(
                                    Icons.verified,
                                    size: 16,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(2, 6, 2, 6),
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.035),
                      borderRadius: BorderRadius.circular(3.5),
                      // gradient: LinearGradient(
                      //   colors: const [
                      //     Color.fromRGBO(50, 50, 50, 1),
                      //     Color.fromRGBO(0, 0, 0, 1),
                      //   ],
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      // ),
                    ),
                    child: FittedBox(
                      child: Text(
                        '@${element['username']}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Signika',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(0, 0, 0, 1),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  checkStorageAccess() async {
    var deviceInfo = await DeviceInfoPlugin().deviceInfo;
    print(
        'iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii ${deviceInfo.data['version']['sdkInt']}');
    if (deviceInfo.data['version']['sdkInt'] < 33) {
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
    } else {
      var _status1 = await Permission.videos.status;
      var _status2 = await Permission.audio.status;
      var _status3 = await Permission.photos.status;
      print(
          'iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii2$_status1 $_status2 $_status3 ${deviceInfo.data['version']['sdkInt']}');
      await Permission.photos.request();
      await Permission.videos.request();
      await Permission.audio.request();

      // ------------------------------------------

      var _statusV = await Permission.videos.status;
      if (_statusV.isGranted) {
        return;
      } else if (_statusV.isPermanentlyDenied) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoragePermissionDenied(),
          ),
        );
      } else {
        await Permission.videos.request().then((value) {
          if (value.isGranted) {
            return;
          }
          // if (value.isGranted == false) {
          //   if (!mounted) return;
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => StoragePermissionDenied(),
          //     ),
          //   );
          // }
        });
      }

      var _statusA = await Permission.audio.status;
      if (_statusA.isGranted) {
        return;
      } else if (_statusA.isPermanentlyDenied) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoragePermissionDenied(),
          ),
        );
      } else {
        await Permission.audio.request().then((value) {
          if (value.isGranted) {
            return;
          }
          // if (value.isGranted == false) {
          //   if (!mounted) return;
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => StoragePermissionDenied(),
          //     ),
          //   );
          // }
        });
      }
    }
  }

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

  // showIntro() async {
  //   Future.delayed(
  //     Duration(milliseconds: 250),
  //     () {
  //       if (mounted) {
  //         showDialog(
  //           barrierDismissible: false,
  //           context: context,
  //           builder: (context) {
  //             return IntroScreen();
  //           },
  //         );
  //       }
  //     },
  //   );
  // }

  @override
  void initState() {
    print(widget._pageNumberSelector);
    super.initState();
    checkStorageAccess();

    if (privateInfo == null) {
      refresher100();
    }
    setTextList();

    // var initialAppDemo = prefs.getInt('initialAppDemo') ?? 0;
    // print(initialAppDemo);
    // if (initialAppDemo == 0) {
    // showIntro();
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  onBackPressed() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Exit ?',
              style: TextStyle(
                fontSize: 24,
                color: Color.fromRGBO(230, 0, 0, 1),
                fontFamily: 'Signika',
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            content: Text(
              'Are you sure to exit app ?',
              style: TextStyle(
                fontFamily: 'Signika',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                letterSpacing: 0.75,
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              Padding(
                padding: EdgeInsets.only(left: 6),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(36, 14, 123, 1),
                    ),
                  ),
                  child: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(255, 0, 0, 1),
                    ),
                  ),
                  child: Icon(Icons.done_rounded),
                  onPressed: () async {
                    Navigator.pop(context);
                    SystemNavigator.pop();
                  },
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // Show only after initital Data is loaded.
    return WillPopScope(
      onWillPop: () async {
        onBackPressed();
        return false;
      },
      child: Container(
        color: Color.fromRGBO(255, 255, 255, 1),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(15, 20, 15, 12.5),
              decoration: BoxDecoration(
                color: Color.fromRGBO(16, 16, 16, 1),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 0.5),
                    blurRadius: 0.25,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  child: InkWell(
                    onTap: () {
                      widget._pageNumberSelector(14);
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 155,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7),
                              topRight: Radius.circular(7),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Opacity(
                                opacity: 0.2,
                                child: Container(
                                  height: 155,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight: Radius.circular(7),
                                    ),
                                  ),
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
                                    topLeft: Radius.circular(7),
                                    topRight: Radius.circular(7),
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
                                        shadows: const [
                                          Shadow(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            blurRadius: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity: textListIndex ==
                                            _textList.length - 1 ||
                                        textListIndex == _textList.length - 2
                                    ? 0.0
                                    : 1.0,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  child: Text(
                                    'Trending',
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 0.8),
                                      // fontSize: 18,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w600,
                                      shadows: const [
                                        Shadow(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 35,
                          width: double.infinity,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(2.25),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(6)
                              // borderRadius: BorderRadius.only(
                              //   bottomRight: Radius.circular(6),
                              //   bottomLeft: Radius.circular(6),
                              // ),
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Join the Trend     ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Signika',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(255, 0, 0, 1),
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Icon(
                                Icons.trending_up_rounded,
                                color: Color.fromRGBO(255, 0, 0, 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // GridView(
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 3,
            //     childAspectRatio: 1,
            //     crossAxisSpacing: 15,
            //     mainAxisSpacing: 15,
            //   ),
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   // padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
            //   padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            //   children: [
            //     myGrid(
            //       Icon(
            //         Icons.travel_explore_rounded,
            //         size: 34,
            //       ),
            //       'Global',
            //       () {
            //         currentSoundType = 'Global';
            //         widget._pageNumberSelector(9);
            //       },
            //     ),
            //     myGrid(
            //       Icon(
            //         Icons.music_note_rounded,
            //         size: 34,
            //       ),
            //       'Music',
            //       () {
            //         currentSoundType = 'Music';
            //         widget._pageNumberSelector(9);
            //       },
            //     ),
            //     myGrid(
            //       Icon(
            //         Icons.mic,
            //         size: 34,
            //       ),
            //       'Dialog',
            //       () {
            //         currentSoundType = 'Dialog';
            //         widget._pageNumberSelector(9);
            //       },
            //     ),
            //     myGrid(
            //       Icon(
            //         Icons.tune_rounded,
            //         size: 34,
            //       ),
            //       'Tunes',
            //       () {
            //         currentSoundType = 'Tunes';
            //         widget._pageNumberSelector(9);
            //       },
            //     ),
            //     myGrid(
            //       Icon(
            //         // Icons.border_color_rounded,
            //         Icons.auto_stories_rounded,
            //         size: 30,
            //       ),
            //       'Poetry',
            //       () {
            //         currentSoundType = 'Poetry';
            //         widget._pageNumberSelector(9);
            //       },
            //     ),
            //     myGrid(
            //       Icon(
            //         Icons.psychology_rounded,
            //         size: 36,
            //       ),
            //       'Motivation',
            //       () {
            //         currentSoundType = 'Motivation';
            //         widget._pageNumberSelector(9);
            //       },
            //     ),
            //   ],
            // ),

            (privateInfo == null)
                ? Container(
                    height: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          isGettingPrivateInfo
                              ? isCreatingAccount
                                  ? 'Welcome! Creating Your Account.'
                                  : 'Loading Your Data !'
                              : 'Failed to get data',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Signika',
                            fontSize: 18,
                            letterSpacing: 1.5,
                            height: 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 40,
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
                                  var connectivityResult = await (Connectivity()
                                      .checkConnectivity());
                                  if (connectivityResult !=
                                      ConnectivityResult.none) {
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
                                                    color: Color.fromRGBO(
                                                        36, 14, 123, 1),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 100,
                                                margin: EdgeInsets.fromLTRB(
                                                    10, 0, 10, 0),
                                                child: Icon(
                                                  Icons.network_check,
                                                  size: 48,
                                                  color: Color.fromRGBO(
                                                      36, 14, 123, 1),
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
                  )
                : Container(
                    margin: EdgeInsets.fromLTRB(15, 12.5, 15, 12.5),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(16, 16, 16, 1),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 1),
                          blurRadius: 0.5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (dpGramAccountStatus) {
                              widget._pageNumberSelector(11);
                            } else {
                              Future.delayed(Duration(milliseconds: 300), () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return DpGramReferralCheck(
                                          widget._pageNumberSelector);
                                    },
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                    transitionDuration:
                                        Duration(milliseconds: 250),
                                    reverseTransitionDuration:
                                        Duration(milliseconds: 100),
                                  ),
                                );
                              });
                            }
                          },
                          child: Column(children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.75,
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Image(
                                image: AssetImage(
                                  'assets/dpgram-motto.png',
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: Container(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        if (dpGramAccountStatus) {
                                          widget._pageNumberSelector(11);
                                        } else {
                                          Future.delayed(
                                              Duration(milliseconds: 200), () {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                    animation,
                                                    secondaryAnimation) {
                                                  return DpGramReferralCheck(
                                                      widget
                                                          ._pageNumberSelector);
                                                },
                                                transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) {
                                                  return FadeTransition(
                                                    opacity: animation,
                                                    child: child,
                                                  );
                                                },
                                                transitionDuration:
                                                    Duration(milliseconds: 250),
                                                reverseTransitionDuration:
                                                    Duration(milliseconds: 100),
                                              ),
                                            );
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(6),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 46,
                                              width: 46,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(23),
                                              ),
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/dpgram-logo.png'),
                                              ),
                                            ),
                                            Text(
                                              // 'dpGram',
                                              'Connect Links',
                                              style: TextStyle(
                                                fontFamily: 'Signika',
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 1,
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
                                                color: Color.fromRGBO(
                                                    255, 0, 0, 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                      ),
                    ),
                  ),
            if (previewUserList.isNotEmpty)
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    Container(
                      height: 55,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(14, 10, 15, 0),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //   colors: const [
                          //     Color.fromRGBO(247, 247, 247, 1),
                          //     Colors.white,
                          //   ],
                          //   begin: Alignment.topCenter,
                          //   end: Alignment.bottomCenter,
                          // ),
                          ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (dpGramAccountStatus) {
                                  widget._pageNumberSelector(11);
                                } else {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return DpGramReferralCheck(
                                            widget._pageNumberSelector);
                                      },
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                      transitionDuration:
                                          Duration(milliseconds: 250),
                                      reverseTransitionDuration:
                                          Duration(milliseconds: 100),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                height: 22,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(right: 5),
                                child: FittedBox(
                                  child: Text(
                                    'List profiles like them !',
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'Signika',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        // radius: 35,
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          shape: BoxShape.circle,
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.2),
                                              offset: Offset(0, 0.5),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.library_books_rounded,
                                          color: Color.fromRGBO(36, 14, 123, 1),
                                          size: 36,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 35,
                                      ),
                                      Text(
                                        'Proper docs and videos are available to explain each and every features of Kingmaker.\n\nTry it and be a PRO !',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          color: Color.fromRGBO(36, 14, 123, 1),
                                          fontSize: 18,
                                          fontFamily: 'Signika',
                                          fontWeight: FontWeight.w600,
                                          height: 1.35,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 30,
                                      // ),
                                      // Text(
                                      //   'Enjoy  !!!',
                                      //   textAlign: TextAlign.justify,
                                      //   style: TextStyle(
                                      //     fontSize: 24,
                                      //     fontFamily: 'Signika',
                                      //     fontWeight: FontWeight.w500,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  actionsAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  actions: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 32,
                                        padding:
                                            EdgeInsets.fromLTRB(12, 6, 12, 6),
                                        decoration: BoxDecoration(
                                          // color:
                                          //     Color.fromRGBO(36, 14, 123, 1),
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.25),
                                              offset: Offset(0, 0),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          size: 19,
                                          color: Color.fromRGBO(230, 0, 35, 1),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        makeRequestExternal(
                                          context,
                                          Uri.parse(
                                            'https://dpgram.com/en/HowToUse/Kingmaker',
                                          ),
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 32,
                                        padding:
                                            EdgeInsets.fromLTRB(12, 7, 12, 7),
                                        decoration: BoxDecoration(
                                          // color: Color.fromRGBO(36, 14, 123, 1),
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.25),
                                              offset: Offset(0, 0),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          'Continue',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(230, 0, 35, 1),
                                            fontFamily: 'Signika',
                                            fontSize: 15,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.video_collection_rounded,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 4 / 5,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 16,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      // padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
                      padding: EdgeInsets.fromLTRB(15, 12.5, 15, 50),
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
                        ...previewUserList.map(
                          (element) => myGrid(element),
                        ),
                      ],
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

// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   final Function _pageNumberSelector;
//   HomeScreen(this._pageNumberSelector);
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   myGrid(imageAddress, blockTitle, navRoute) {
//     return GestureDetector(
//       child: AspectRatio(
//         aspectRatio: 7 / 3,
//         child: Container(
//           margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
//           decoration: BoxDecoration(
//             color: Color.fromRGBO(255, 255, 255, 1),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.grey,
//                 offset: Offset(0, 0.5),
//                 blurRadius: 0.25,
//               ),
//             ],
//             borderRadius: BorderRadius.circular(5),
//           ),
//           child: Row(
//             children: [
//               AspectRatio(
//                 aspectRatio: 0.75,
//                 child: Container(
//                   alignment: Alignment.center,
//                   child: Text('f'),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                   child: Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
//                     // color: Colors.amber,
//                     alignment: Alignment.topLeft,
//                     child: Text(
//                       'Share Video Post.',
//                       textAlign: TextAlign.justify,
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 1.5,
//                         height: 1.25,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Row(
//                       children: const [
//                         Icon(
//                             // Icons.timer_rounded,
//                             // Icons.access_time_filled_rounded,
//                             Icons.access_time_rounded,
//                             color: Colors.deepOrange),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Text(
//                           '27/11/2022',
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Text('12:00 PM'),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: const [
//                             Icon(Icons.monetization_on_rounded,
//                                 // size: 22,
//                                 color: Colors.deepOrange),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Text(
//                               '0.1',
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontFamily: 'Signika',
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.deepOrange),
//                             )
//                           ],
//                         ),
//                         GestureDetector(
//                           child: Text(
//                             'Join',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontFamily: 'Signika',
//                               fontWeight: FontWeight.w600,
//                               letterSpacing: 1,
//                               color: Color.fromRGBO(0, 0, 255, 1),
//                             ),
//                           ),
//                           onTap: () {
//                             widget._pageNumberSelector(16);
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ))
//             ],
//           ),
//         ),
//       ),
//       onTap: navRoute,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return false;
//       },
//       child: Container(
//         // color: Color.fromRGBO(0, 255, 255, 0.1),
//         color: Color.fromRGBO(247, 247, 247, 1),
//         child: ListView(
//           // reverse: true,
//           keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//           // padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
//           // scrollDirection: Axis.horizontal,
//           // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           //   crossAxisCount: 1,
//           //   crossAxisSpacing: 15,
//           //   mainAxisSpacing: 15,
//           //   childAspectRatio: 5 / 2,
//           // ),
//           children: [
//             SizedBox(
//               height: 20,
//             ),
//             myGrid(
//               'assets/LeatherTexture/L53.jpg',
//               'Survey',
//               () {
//                 // Navigator.of(context).push(
//                 //   MaterialPageRoute(
//                 //     builder: (_) => Survey(),
//                 //   ),
//                 // );
//               },
//             ),
//             myGrid(
//               'assets/LeatherTexture/L73.jpg',
//               'Daily Challenge',
//               () {
//                 // Navigator.of(context).push(
//                 //   MaterialPageRoute(
//                 //     builder: (_) => WithImageProof(),
//                 //   ),
//                 // );
//               },
//             ),
//             myGrid(
//               'assets/LeatherTexture/L73.jpg',
//               'Video Proof',
//               () {
//                 // Navigator.of(context).push(
//                 //   MaterialPageRoute(
//                 //     builder: (_) => WithVideoProof(),
//                 //   ),
//                 // );
//               },
//             ),
//             myGrid(
//               'assets/LeatherTexture/L73.jpg',
//               'Audio Proof',
//               () {
//                 // Navigator.of(context).push(
//                 //   MaterialPageRoute(
//                 //     builder: (_) => WithAudioProof(),
//                 //   ),
//                 // );
//               },
//             ),
//             myGrid(
//               'assets/LeatherTexture/L73.jpg',
//               'My WebView',
//               () {
//                 // Navigator.of(context).push(
//                 //   MaterialPageRoute(
//                 //     builder: (_) => Survey1(),
//                 //   ),
//                 // );
//               },
//             ),
//             myGrid(
//               'assets/LeatherTexture/L73.jpg',
//               'My WebView',
//               () {
//                 // Navigator.of(context).push(
//                 //   MaterialPageRoute(
//                 //     builder: (_) => Survey1(),
//                 //   ),
//                 // );
//               },
//             ),
//             myGrid(
//               'assets/LeatherTexture/L73.jpg',
//               'My WebView',
//               () {
//                 // Navigator.of(context).push(
//                 //   MaterialPageRoute(
//                 //     builder: (_) => Survey1(),
//                 //   ),
//                 // );
//               },
//             ),
//             SizedBox(
//               height: 30,
//             ),

//             // myGrid('assets/LeatherTexture/L53.jpg', 'Twitter'),
//             // myGrid('assets/LeatherTexture/L73.jpg', 'Facebook Page'),
//             // myGrid('assets/LeatherTexture/L53.jpg', 'Facebook Group'),
//             // myGrid('assets/LeatherTexture/L103.jpg', 'Facebook Profile'),
//             // myGrid('assets/LeatherTexture/L43.jpg', 'Instagram Page'),
//             // myGrid('assets/LeatherTexture/L103.jpg', 'Instagram Profile'),
//           ],
//         ),
//       ),
//     );
//   }
// }

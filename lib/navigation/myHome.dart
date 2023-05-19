import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kingmaker/content/aboutme.dart';
import 'package:kingmaker/content/account.dart';
import 'package:kingmaker/content/dpGram.dart';
import 'package:kingmaker/content/dpGramAddPlatform.dart';
import 'package:kingmaker/content/dpGramAnalyticsViews.dart';
import 'package:kingmaker/content/dpGramPlatformPriority.dart';
import 'package:kingmaker/content/favouriteCollection.dart';
import 'package:kingmaker/content/globalVariable.dart';
import 'package:kingmaker/content/joinTrend.dart';
import 'package:kingmaker/content/soundCollection.dart';
import 'package:kingmaker/content/homeScreen.dart';
import 'package:kingmaker/content/ongoingTask.dart';
import 'package:kingmaker/content/timeline.dart';
import 'package:kingmaker/navigation/introScreen.dart';
import 'package:kingmaker/payment/analytics.dart';
import 'package:kingmaker/payment/analyticsEarning.dart';
import 'package:kingmaker/payment/analyticsView.dart';
import 'package:kingmaker/payment/myRecord.dart';
import 'package:kingmaker/payment/updateDetails.dart';
import 'package:kingmaker/payment/withdraw.dart';
import 'package:provider/provider.dart';
import '../services/ad_state.dart';
import '../services/googleAds.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  // ---------------- Ads Start

  // Banner Ads
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context, listen: false);
    adState.initialization.then(
      (status) {
        if (mounted) {
          setState(
            () {
              banner1 = BannerAd(
                adUnitId: adState.bannerAdUnitId1,
                // ignore: deprecated_member_use
                size: AdSize.smartBanner,
                request: AdRequest(),
                // listener: adState.adListener,
                listener: BannerAdListener(
                  // Called when an ad is successfully received.
                  onAdLoaded: (Ad ad) {
                    numBanner1Attempts = 0;
                    if (isAdsAvailableB1 == false) {
                      // Not using setState may lead to not showing ads on load completed when it is not showing.
                      // But it may help to avoid many unusual stuff, mainly when
                      // some other widget are active over ads containing page/widget.
                      // -----------------------------------------------------------------
                      // But their is only one banner ads and int ads are managed other way -
                      // that's we can use setState otherwise it's strictly prohobited
                      setState(() {
                        isAdsAvailableB1 = true;
                      });
                    }
                    print('Ads Loaded');
                  },
                  // Called when an ad request failed.
                  onAdFailedToLoad: (Ad ad, LoadAdError error) {
                    ad.dispose();
                    // print('Ad failed to load - Banner 1 : $error');
                    print('Ad failed to load - Banner 1');
                    if (isAdsAvailableB1 == false) {
                      reloadBanner1() async {
                        if (numBanner1Attempts <= 2) {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult != ConnectivityResult.none) {
                            print('Ads loading - Banner1 - With Internet');
                            Future.delayed(Duration(seconds: bAds1), () {
                              numBanner1Attempts += 1;
                              if (mounted) {
                                banner1!.load();
                              }
                            });
                          } else {
                            print('Ads loading - Banner1 - No Internet');
                            Future.delayed(Duration(seconds: 2), () {
                              if (mounted) {
                                reloadBanner1();
                              }
                            });
                          }
                        }
                      }

                      reloadBanner1();
                    }
                  },
                  // Called when an ad opens an overlay that covers the screen.
                  onAdOpened: (Ad ad) => print('Ad opened.'),
                  // Called when an ad removes an overlay that covers the screen.
                  onAdClosed: (Ad ad) => print('Ad closed.'),
                  // Called when an impression is recorded for a NativeAd.
                  onAdImpression: (ad) {
                    print('Ad impression.');
                  },
                ),
              );
              if (showBanner1 == 1) {
                banner1!.load();
              }
              var w2 = GetDeviceSize.myWidth;
              // 80 for default margin and 20 for internal padding
              var h2 = (0.7 * w2).truncate();
              banner2 = BannerAd(
                adUnitId: adState.bannerAdUnitId2,
                // ignore: deprecated_member_use
                size: AdSize(
                  height: h2,
                  width: w2,
                ),
                request: AdRequest(),
                // listener: adState.adListener,
                listener: BannerAdListener(
                  // Called when an ad is successfully received.
                  onAdLoaded: (Ad ad) {
                    numBanner2Attempts = 0;
                    if (isAdsAvailableB2 == false) {
                      // Not using setState may lead to not showing ads on load completed when it is not showing.
                      // But it may help to avoid many unusual stuff, mainly when
                      // some other widget are active over ads containing page/widget.
                      // -----------------------------------------------------------------
                      // But their is only one banner ads and int ads are managed other way -
                      // that's we can use setState otherwise it's strictly prohobited
                      isAdsAvailableB2 = true;
                    }
                    print('Ads Loaded - Banner 2');
                  },
                  // Called when an ad request failed.
                  onAdFailedToLoad: (Ad ad, LoadAdError error) {
                    ad.dispose();
                    // print('Ad failed to load - Banner 2 : $error');
                    print('Ad failed to load - Banner 2');
                    if (isAdsAvailableB2 == false) {
                      reloadBanner2() async {
                        if (numBanner2Attempts <= 2) {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult != ConnectivityResult.none) {
                            print('Ads loading - Banner2 - With Internet');
                            Future.delayed(Duration(seconds: bAds2), () {
                              numBanner2Attempts += 1;

                              if (mounted) {
                                banner2!.load();
                              }
                            });
                          } else {
                            print('Ads loading - Banner2 - No Internet');
                            Future.delayed(Duration(seconds: 2), () {
                              if (mounted) {
                                reloadBanner2();
                              }
                            });
                          }
                        }
                      }

                      reloadBanner2();
                    }
                  },
                  // Called when an ad opens an overlay that covers the screen.
                  onAdOpened: (Ad ad) => print('Ad opened.'),
                  // Called when an ad removes an overlay that covers the screen.
                  onAdClosed: (Ad ad) => print('Ad closed.'),
                  // Called when an impression is recorded for a NativeAd.
                  onAdImpression: (ad) {
                    print('Ad impression.');
                  },
                ),
              );
              // In 20 seconds most probably data loading from firebase will be completed
              // It is also true that this ads is not going to show in first attemp
              // So, ad have much time to load
              // It also help to increase admob ads quality
              Future.delayed(Duration(seconds: 20), () {
                if (showBanner2 == 1) {
                  banner2!.load();
                }
              });
            },
          );
        }
      },
    );
  }

  // ---------------- Ads End

  var showNavigationBar = true;
  var pageNumber = 1;
  var myDrawerKey = GlobalKey<ScaffoldState>();
  var activeButton = 1;

  void pageNumberSelector(asd) {
    setState(() {
      pageNumber = asd;
      // Force change if fall to main via other route
      switch (asd) {
        case 1:
          activeButton = 1;
          break;
        case 2:
          activeButton = 2;
          break;
        case 3:
          activeButton = 3;
          break;
        case 4:
          activeButton = 4;
          break;
        case 5:
          activeButton = 4;
          break;
        case 6:
          activeButton = 4;
          break;
        case 7:
          activeButton = 4;
          break;
        case 8:
          activeButton = 4;
          break;
        case 11:
          activeButton = 11;
          break;
        case 12:
          activeButton = 11;
          break;
        case 13:
          activeButton = 11;
          break;
        case 14:
          activeButton = 14;
          break;
        default:
          activeButton = activeButton;
      }
      // activeButton; // to change the color of navigation bar
    });
  }

  void shouldShowNavigationBar(val) {
    setState(() {
      showNavigationBar = val;
    });
  }

  pager(fnc, number) {
    var pageList = [
      HomeScreen(fnc), //1
      OngoingTask(fnc), //2
      Timeline(fnc), //3
      Account(fnc), //4
      UpdatePaymentDetails(fnc), //5
      Withdraw(fnc), //6
      MyRecord(fnc), //7
      AboutMe(fnc), //8
      SoundCollection(fnc), //9
      FavouriteCollection(fnc), //10
      DpGram(fnc), //11
      DpGramAddPlatForm(fnc), //12
      DpGramPlatformPriority(fnc), //13
      JoinTrend(fnc), //14
      Analytics(fnc), //15
      AnalyticsViews(fnc), //16
      AnalyticsEarning(fnc), //17
      DpGramAnalyticsViews(fnc), //18
    ];
    return pageList[number];
  }

  @override
  void initState() {
    super.initState();
    // Present in global Variable
    getPrivateInfo();
    checkForUpdate(context, mounted);
  }

  var initialAppDemo = prefs.getInt('initialAppDemo') ?? 0;

  forceSetState() async {
    // Keep it 1 to avoid lag.
    initialAppDemo = 1;
    await prefs.setInt('initialAppDemo', 1);
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        initialAppDemo;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return initialAppDemo == 0
        ? IntroScreen(() => forceSetState())
        : SafeArea(
            child: Scaffold(
              backgroundColor: Color.fromRGBO(255, 255, 255, 1),
              // key: myDrawerKey,
              // drawer: MyDrawer(),
              // appBar: AppBar(
              //   systemOverlayStyle: SystemUiOverlayStyle(
              //     statusBarColor: Color.fromRGBO(0, 0, 0, 1),
              //   ),
              //   backgroundColor: Color.fromRGBO(255, 255, 255, 1),
              //   // backgroundColor: Colors.tealAccent,
              //   title: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: const [
              //       Text(
              //         'mini',
              //         style: TextStyle(
              //           color: Color.fromRGBO(0, 0, 255, 1),
              //           fontFamily: 'Signika',
              //           fontSize: 18,
              //         ),
              //       ),
              //       FittedBox(
              //         child: Text(
              //           'Expert',
              //           style: TextStyle(
              //             fontSize: 26,
              //             color: Color.fromRGBO(0, 0, 255, 1),
              //             fontWeight: FontWeight.w600,
              //             letterSpacing: 2,
              //             fontFamily: 'Signika',
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              //   leading: Button1(myDrawerKey),
              //   // leading: IconButton(
              //   //   icon: Icon(
              //   //     Icons.home_rounded,
              //   //     size: 32,
              //   //   ),
              //   //   onPressed: () {
              //   //     myDrawerKey.currentState.openDrawer();
              //   //   },
              //   // ),
              //   actions: [
              //     // (pageNumber != 2)
              //     //     ? GestureDetector(
              //     //         child: Button21(),
              //     //         onTap: () {
              //     //           pageNumberSelector(2);
              //     //         },
              //     //       )
              //     //     : Button22(),

              //     (pageNumber != 3)
              //         ? Button31(() => pageNumberSelector(3))
              //         : Button32(),
              //     (pageNumber != 2)
              //         ? Button21(() => pageNumberSelector(2))
              //         : Button22(),
              //     (pageNumber != 1)
              //         ? Button11(() => pageNumberSelector(1))
              //         : Button12(),
              //     // IconButton(
              //     //   icon: Icon(
              //     //     Icons.notifications_active_rounded,
              //     //     // Icons.error_outline_rounded,
              //     //     // Icons.info_outline_rounded,
              //     //     // Icons.pending_rounded,
              //     //     // Icons.verified_rounded,
              //     //     // Icons.verified_user_rounded,
              //     //     // Icons.eco_rounded,
              //     //     size: 30,
              //     //   ),
              //     //   onPressed: () {},
              //     // ),
              //   ],
              // ),
              appBar: (pageNumber == 1)
                  ? AppBar(
                      titleSpacing: 0,
                      backgroundColor: Colors.transparent,
                      elevation: 2,
                      title: Container(
                        height: 56,
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image:
                                            AssetImage('assets/logoAppBar.png'),
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.5),
                                          offset: Offset(0, 0),
                                          blurRadius: 1,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'Kingmaker',
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Signika',
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.tealAccent,
                                  highlightColor:
                                      Color.fromRGBO(160, 255, 255, 1),
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color.fromRGBO(36, 14, 123, 1),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.library_books,
                                          color: Color.fromRGBO(36, 14, 123, 1),
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'Guide',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(36, 14, 123, 1),
                                            fontSize: 14,
                                            fontFamily: 'Signika',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // onTap: () {
                                  //   Future.delayed(
                                  //     Duration(milliseconds: 200),
                                  //     () {
                                  //       pageNumberSelector(6);
                                  //     },
                                  //   );
                                  // },
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
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                                shape: BoxShape.circle,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.2),
                                                    offset: Offset(0, 0.5),
                                                    blurRadius: 2,
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                Icons.library_books_rounded,
                                                color: Color.fromRGBO(
                                                    36, 14, 123, 1),
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
                                                color: Color.fromRGBO(
                                                    36, 14, 123, 1),
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
                                              padding: EdgeInsets.fromLTRB(
                                                  12, 6, 12, 6),
                                              decoration: BoxDecoration(
                                                // color:
                                                //     Color.fromRGBO(36, 14, 123, 1),
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.25),
                                                    offset: Offset(0, 0),
                                                    blurRadius: 2,
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                size: 19,
                                                color: Color.fromRGBO(
                                                    230, 0, 35, 1),
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
                                              padding: EdgeInsets.fromLTRB(
                                                  12, 7, 12, 7),
                                              decoration: BoxDecoration(
                                                // color: Color.fromRGBO(36, 14, 123, 1),
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.25),
                                                    offset: Offset(0, 0),
                                                    blurRadius: 2,
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                'Continue',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      230, 0, 35, 1),
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
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : AppBar(
                      toolbarHeight: 0,
                    ),
              bottomNavigationBar: (showNavigationBar)
                  ? BottomAppBar(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // borderRadius: BorderRadius.only(
                          //   topLeft: Radius.circular(5),
                          //   topRight: Radius.circular(5),
                          // ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, -0.25),
                              // blurRadius: 0.25,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                child: Container(
                                  // Used expand gesture area
                                  color: Colors.transparent,
                                  height: 50,
                                  child: Icon(
                                    Icons.home_rounded,
                                    color: (activeButton == 1)
                                        ? Color.fromRGBO(255, 0, 0, 1)
                                        : Color.fromRGBO(125, 125, 125, 1),
                                    // color: Color.fromRGBO(255, 0, 0, 1),
                                    size: 32,
                                  ),
                                ),
                                onTap: () {
                                  activeButton = 1;
                                  pageNumberSelector(1);
                                },
                              ),
                            ),

                            // Expanded(
                            //   child: GestureDetector(
                            //     child: Container(
                            //       // Used expand gesture area
                            //       color: Colors.transparent,
                            //       height: 50,
                            //       child: Icon(
                            //         // Icons.task_alt_rounded,
                            //         // Icons.filter_vintage_rounded,
                            //         Icons.center_focus_strong_rounded,
                            //         color: (activeButton == 2)
                            //             ? Color.fromRGBO(255, 0, 0, 1)
                            //             : Color.fromRGBO(125, 125, 125, 1),
                            //         size: 30,
                            //       ),
                            //     ),
                            //     onTap: () {
                            //       activeButton = 2;
                            //       pageNumberSelector(2);
                            //     },
                            //   ),
                            // ),
                            Expanded(
                              child: GestureDetector(
                                child: Container(
                                  // Used expand gesture area
                                  color: Colors.transparent,
                                  height: 50,
                                  child: Icon(
                                    // Icons.task_alt_rounded,
                                    // Icons.filter_vintage_rounded,
                                    Icons.trending_up_rounded,
                                    color: (activeButton == 14)
                                        ? Color.fromRGBO(255, 0, 0, 1)
                                        : Color.fromRGBO(125, 125, 125, 1),
                                    size: 30,
                                  ),
                                ),
                                onTap: () {
                                  activeButton = 14;
                                  pageNumberSelector(14);
                                },
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                child: Container(
                                  // Used expand gesture area
                                  color: Colors.transparent,
                                  height: 50,
                                  child: Icon(
                                    Icons.favorite,
                                    // Icons.account_circle_rounded,
                                    color: (activeButton == 10)
                                        ? Color.fromRGBO(255, 0, 0, 1)
                                        : Color.fromRGBO(125, 125, 125, 1),
                                    size: 30,
                                  ),
                                ),
                                onTap: () {
                                  activeButton = 10;
                                  pageNumberSelector(10);
                                },
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                child: Container(
                                  key: Key('$activeButton'),
                                  // Used expand gesture area
                                  color: Colors.transparent,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    color: Colors.transparent,
                                    child: activeButton == 11
                                        ? Image.asset(
                                            'assets/dpgramRed.png',
                                            fit: BoxFit.contain,
                                          )
                                        : Image.asset(
                                            'assets/dpgramGrey.png',
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                ),
                                onTap: () {
                                  activeButton = 11;
                                  pageNumberSelector(11);
                                },
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                child: Container(
                                  // Used expand gesture area
                                  color: Colors.transparent,
                                  height: 50,
                                  child: Icon(
                                    Icons.account_circle_rounded,
                                    // Icons.account_circle_rounded,
                                    color: (activeButton == 4)
                                        ? Color.fromRGBO(255, 0, 0, 1)
                                        : Color.fromRGBO(125, 125, 125, 1),
                                    size: 30,
                                  ),
                                ),
                                onTap: () {
                                  activeButton = 4;
                                  pageNumberSelector(4);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              // body: pager(pageNumberSelector, (pageNumber - 1)),
              body: pager(pageNumberSelector, (pageNumber - 1)),
            ),
          );
  }
}

// Future<bool> _onBackPressed(BuildContext context) {
//   return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Are you sure?'),
//             content: Text('Do you want to exit ?'),
//             actions: <Widget>[
//               TextButton(
//                 child: Text('Yes'),
//                 onPressed: () {
//                   Navigator.of(context).pop(true);
//                 },
//               ),
//               TextButton(
//                 child: Text('No'),
//                 onPressed: () {
//                   Navigator.of(context).pop(false);
//                 },
//               ),
//             ],
//           );
//         },
//       ) ??
//       false;
// }

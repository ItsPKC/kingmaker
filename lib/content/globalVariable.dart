// To hold the current selected sound type name from Home Screen.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kingmaker/content/serverMaintainance.dart';
import 'package:kingmaker/content/updateApp.dart';
import 'package:kingmaker/services/ad_state.dart';
import 'package:kingmaker/services/googleAds.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// Is Email verified
var emailVerfied = prefs.getBool('emailVerfied') ?? false;

// To manage flash on homePage (Join the trend)
var textListIndex = 0;
// Manage dpGram Warning
var showndpGramWarning = false;

// Obtain shared preferences.
var prefs;

// Trend Type
var joinTrendType = prefs.getStringList('joinTrendType') ??
    ['Global', 'Music', 'Dialog', 'Poetry', 'Motivation', 'Memes'];
var aboutInitialExpanderNumber = 0;
// To set return from about me
var accountSettingRedirectNumber = 0;

var myAuthUID = '';
var currentSoundType = '';
final firestore = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final firebaseFunctions = FirebaseFunctions.instance;
String soundSource = '';
var dpgramPlatformList = [];

// Store Profile Image Here Once Loaded
var accountProfileImage;

// Creator Account - For creators/influencers only
var isCreatorAccountActive = false;
var isCreatingAccount = false;

var previewUserList = [];

// Private info and their data.
var initialInfo;
var creatorInfo;
var privateInfo;
var isGettingPrivateInfo = false;
var isGettingCreatorInfo = false;
var favouriteCollectionData = [];
var platformPriorityChangeDetected = false;
var platformPriority = [];
var piPlatform = {};
var piuserID = 'Add User ID';
var piCategory = '';
var pifirstName = 'Add Name';
var pimiddleName = '';
var pilastName = '';
var pidobDD = DateTime.now().day.toString();
var pidobMM = DateTime.now().month.toString();
var pidobYYYY = DateTime.now().year.toString();
var pibusinessMail = '';
var pishowBM = false;
var pishowWAN = false;
var
// ignore: non_constant_identifier_names
    piWANumber = '';
var picountryCode = '91';
var pitop1 = '';
var pitop2 = '';
var pitop3 = '';
var dpGramAccountStatus = prefs.getBool('dpGramAccountStatus') ?? false;

var categoryList = []; // Will be updated by initial document data

var rateMessage = 'Total views ( Realtime )';
var minimumCashOut = 0;
var earlyAccessInvite = false;
var additionalMessage = '';
var bonusProgram = false;

// picc and pivc will remained same for both all-around
// var picc = 0;
// var pivc = 0;

var picc = 0;
var pivc = 0;
var piccHistory = [];
var pivcHistory = [];
var picreatorAccountStatus = 0;
var pinotificationHistory = [];
var pipaymentMethod = [];
var pipayoutHistory = [];
var piprocessingPayout = false;

// Stream<bool> privateInfoStream() async* {
//   while (true) {
//     await Future<void>.delayed(Duration(milliseconds: 1000));
//     print('privateInfo');
//     yield privateInfo == null;
//   }
// }

setCreatorInfo() {
  if (creatorInfo != null) {
    picc = creatorInfo['cc'] ?? picc;
    piccHistory = creatorInfo['ccHistory'] ?? [];
    pivcHistory = creatorInfo['vcHiIstory'] ?? [];
    // pivc can be updated by this process only when creator account is not banned
    if (creatorInfo['creatorAccountStatus'] != null &&
        creatorInfo['creatorAccountStatus'] <= 1) {
      pivc = creatorInfo['vc'] ?? pivc;
    }
    picreatorAccountStatus = creatorInfo['creatorAccountStatus'] ?? 0;
    pinotificationHistory = creatorInfo['notificationHistory'] ?? [];
    pipaymentMethod = creatorInfo['paymentMethod'] ?? [];
    pipayoutHistory = creatorInfo['payoutHistory'] ?? [];
    piprocessingPayout = creatorInfo['processingPayout'] ?? false;
  }
}

Future<void> getCreatorInfo() async {
  print('+++++++++++++++++++++++++++++++++++++++++++++++++++CI');
  if (isGettingCreatorInfo == false) {
    isGettingCreatorInfo = true;
    getCreatorInfoData() async {
      try {
        await firestore
            .collection('user')
            .doc(myAuthUID)
            .collection('private')
            .doc('creatorData')
            .get()
            .then((doc) async {
          creatorInfo = doc.data();
          await setCreatorInfo();
          print(creatorInfo);
          isGettingCreatorInfo = false;
        }).onError((error, stackTrace) {
          isGettingCreatorInfo = false;
        });
      } catch (e) {
        isGettingCreatorInfo = false;
      }
    }

    var creatorInfoData = FirebaseFunctions.instanceFor(region: 'asia-south1')
        .httpsCallable('creatorData');
    try {
      creatorInfoData().then((value) async {
        print(value.data);
        print('++++++++++++++++++++++++++++++++++++++++++++++++++++');
        if (value.data == 'Successful') {
          await getCreatorInfoData();
        }
      }).onError((error, stackTrace) {
        isGettingCreatorInfo = false;
      });
    } catch (e) {
      print(e);
      isGettingCreatorInfo = false;
    }
  }
}

setPivateData() async {
  print('+++++++++++++++++++++++++++++++++++++++++++++++++++SPI01');
  // initial private information
  // pi -> privateInfo
  if (privateInfo != null) {
    print('+++++++++++++++++++++++++++++++++++++++++++++++++++SPI02');
    favouriteCollectionData = privateInfo['favouriteCollection'] ?? [];
    platformPriority = privateInfo['platformListPriority'] ?? [];
    piPlatform = privateInfo['platformList'] ?? {};
    piuserID = privateInfo['userID'] ?? '';
    if (piuserID == '') {
      piuserID = 'Add User ID';
    }
    piCategory = privateInfo['category'] ?? '';
    pifirstName = privateInfo['firstName'] ?? '';
    if (pifirstName == '') {
      pifirstName = 'Add Name';
    }
    pimiddleName = privateInfo['middleName'] ?? '';
    pilastName = privateInfo['lastName'] ?? '';
    if (privateInfo['dobDD'] != null) {
      pidobDD = privateInfo['dobDD'] != ''
          ? privateInfo['dobDD']
          : DateTime.now().day.toString();
    }
    if (privateInfo['dobMM'] != null) {
      pidobMM = privateInfo['dobMM'] != ''
          ? privateInfo['dobMM']
          : DateTime.now().month.toString();
    }
    if (privateInfo['dobYYYY'] != null) {
      pidobYYYY = privateInfo['dobYYYY'] != ''
          ? privateInfo['dobYYYY']
          : DateTime.now().year.toString();
    }

    pibusinessMail = privateInfo['businessMail'] ?? '';
    pishowBM = privateInfo['showBM'] ?? false;
    pishowWAN = privateInfo['showWAN'] ?? false;
    // ignore: non_constant_identifier_names
    // _WACountryCode,
    // ignore: non_constant_identifier_names
    piWANumber = privateInfo['WANumber'] ?? '';
    picountryCode = privateInfo['countryCode'] ?? '91';
    if (privateInfo['topOnlinePresence'] != null) {
      if (privateInfo['topOnlinePresence'].length == 1) {
        pitop1 = privateInfo['topOnlinePresence'][0];
      } else if (privateInfo['topOnlinePresence'].length == 2) {
        pitop1 = privateInfo['topOnlinePresence'][0];
        pitop2 = privateInfo['topOnlinePresence'][1];
      } else if (privateInfo['topOnlinePresence'].length == 3) {
        pitop1 = privateInfo['topOnlinePresence'][0];
        pitop2 = privateInfo['topOnlinePresence'][1];
        pitop3 = privateInfo['topOnlinePresence'][2];
      }
    }

    pivc = privateInfo['vc'] ?? 0;
    picc = privateInfo['cc'] ?? 0;

    isCreatorAccountActive = privateInfo['isCreatorAccountActive'] ?? false;
    print(
        '+++++++++++++++++++++++++++++++++++++++++++++++++++SPI02$isCreatorAccountActive');
    if (isCreatorAccountActive == true) {
      print('+++++++++++++++++++++++++++++++++++++++++++++++++++SPI03');
      getCreatorInfo();
    }
    // MAnage dpGram
    dpGramAccountStatus = privateInfo['dpGramAccountStatus'] ?? false;
    await prefs.setBool('dpGramAccountStatus', dpGramAccountStatus);
  }

  print('+++++++++++++++++++++++++++++++++++++++++++++++++++SPI04');
}

Future<void> userDataTemplateStatusTest() async {
  print('---------------------------Testing userDataTemplateStatusTest');
  var _test = FirebaseFunctions.instanceFor(region: 'asia-south1')
      .httpsCallable('userDataTemplateStatusTest');
  await _test().then((value) {
    if (value.data == 'User Added') {
      getPrivateInfo();
    } else {
      isGettingPrivateInfo = false;
      isCreatingAccount = false;
    }
  }).catchError((error) {
    print('Failed to update: $error');
    isGettingPrivateInfo = false;
    isCreatingAccount = false;
  });
}

getPrivateInfo() async {
  print('----------------------------------------------npi - get1');
  var _gotNewValue = false;
  // Request only if request is not pending
  if (isGettingPrivateInfo == false || isCreatingAccount == true) {
    isCreatingAccount = false;
    print('----------------------------------------------npi - get2');
    isGettingPrivateInfo = true;
    // Initialy Requested from homeScreen.dart (init)
    try {
      var _newPrivateInfo = await firestore
          .collection('user')
          .doc(myAuthUID)
          .collection('private')
          .doc('privateData')
          .get();
      //     .then(
      //   (doc) {
      //     privateInfo = doc.data();
      //     setPivateData();
      //     print('----------------------------------------------');
      //     print(doc.data());
      //     _gotNewValue = true;
      //     isGettingPrivateInfo = false;
      //   },
      // );
      print('----------------------------------------------npi - get3');
      if (_newPrivateInfo.exists) {
        isGettingPrivateInfo = false;
        privateInfo = _newPrivateInfo.data();
        setPivateData();
        _gotNewValue = true;
        print('----------------------------------------------npi - exist');
        if (_newPrivateInfo.data()!['userDataTemplateStatus'] != true) {
          print(
              '----------------------------------------------npi - par - exist');
          userDataTemplateStatusTest();
        }
      } else {
        print('----------------------------------------------npi - not exist');
        isCreatingAccount = true;
        userDataTemplateStatusTest();
      }
    } catch (e) {
      print(e);
      isGettingPrivateInfo = false;
      isCreatingAccount = false;
    }
    print('-------------$_gotNewValue');
  }
  if (_gotNewValue) {
    return true;
  } else {
    return false;
  }
}

Future getDownloadLink(profileLocation) async {
  // if (profileLocation == null || profileLocation == '') {
  //   return '';
  // }
  var resizedImage = profileLocation;
  List<String> temp = resizedImage.split('.');
  temp.insert(temp.length - 1, '_100x100.');
  temp.join();
  print(
      '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^1 ${profileLocation == ''} 1');
  try {
    return await FirebaseStorage.instance
        .ref(resizedImage)
        .getDownloadURL()
        .onError((error, stackTrace) {
      return '';
    });
  } catch (e) {
    return '';
  }
}

// For checking and Displaying Update Notification and initial Data

var isUpdateAvailable = false;

final FirebaseFirestore _firestore = Fire().getInstance;

checkForUpdate(context, mounted) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String currentVersion = packageInfo.version;
  try {
    _firestore.collection('initial').doc('initial').get().then(
      (doc) async {
        initialInfo = doc.data();
        // ----------------------------------------------------------------
        rateMessage = initialInfo['rateMessage'] ?? 'Total views ( Realtime )';
        minimumCashOut = initialInfo['minimumCashOut'] ?? 0;
        earlyAccessInvite = initialInfo['earlyAccessInvite'] ?? false;
        additionalMessage = initialInfo['additionalMessage'] ?? '';
        bonusProgram = initialInfo['bonusProgram'] ?? false;
        // ----------------------------------------------------------------
        // Join Trend Type
        var tempPreviewUserList = <Map>[];
        initialInfo['previewUserList'].forEach((element) {
          tempPreviewUserList.add(element);
        });
        previewUserList = tempPreviewUserList;

        // ----------------------------------------------------------------previewUserList
        // Join Trend Type
        var tempJoinTrendType = <String>[];
        initialInfo['joinTrendType'].forEach((element) {
          tempJoinTrendType.add(element);
        });
        joinTrendType = tempJoinTrendType;
        await prefs.setStringList('joinTrendType', tempJoinTrendType);

        print(
            '======================================== ${initialInfo["version"]}');
        // -----------------------------------------------------------------
        // Update Platform List
        // List<dynamics to List<String>
        var tempListPL = <String>[];
        initialInfo['platformList'].forEach((element) {
          tempListPL.add(element);
        });
        await prefs.setStringList('platformList', tempListPL..sort());
        // -----------------------------------------------------------------

        // -----------------------------------------------------------------
        // Update Platform List
        // List<dynamics to List<String>
        var tempListCL = <String>[];
        initialInfo['categoryList'].forEach((element) {
          tempListCL.add(element);
        });

        // Notice that sort() does not return a value. It sorts the list without creating a new list.
        // If we want to sort and print in the same line, we can use method cascades:

        await prefs.setStringList('categoryList', tempListCL..sort());
        // -----------------------------------------------------------------

        var updatedVersion = '${initialInfo["version"]}';
        var notice = '${initialInfo["notice"]}';
        setAdsData(initialInfo);
        // End - Ads Controller Data
        print(
            'Its verion 00000000000000000000000000000 $updatedVersion $currentVersion');
        print('Its notice ------------------------------- $notice');
        if (initialInfo['underMaintenance']) {
          if (!mounted) return;
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UnderMaintenance(initialInfo);
          }));
        }
        if (updatedVersion != currentVersion) {
          // pageNumberSelector(1);
          if (!mounted) return;
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UpdateApp(initialInfo, currentVersion);
          }));
        }
      },
    );
  } catch (error) {
    print('Update check Error');
  }
}

// ----------- Only for first time --------------

eraseCurrentUserDataToLogout() async {
  myAuthUID = '';
  currentSoundType = '';
  soundSource = '';
  dpgramPlatformList = [];
  accountProfileImage = null;
  privateInfo = null;
  creatorInfo = null;
  favouriteCollectionData = [];
  platformPriority = [];
  piPlatform = {};
  piuserID = 'Add User ID';
  piCategory = '';
  pifirstName = 'Add Name';
  pimiddleName = '';
  pilastName = '';
  pidobDD = DateTime.now().day.toString();
  pidobMM = DateTime.now().month.toString();
  pidobYYYY = DateTime.now().year.toString();
  pibusinessMail = '';
  piWANumber = '';
  pishowBM = false;
  pishowWAN = false;
  picountryCode = '91';
  pitop1 = '';
  pitop2 = '';
  pitop3 = '';
  dpGramAccountStatus = false;
  pivc = 0;
  picc = 0;
  isCreatorAccountActive = false;
  isCreatingAccount = false;

  await prefs.remove('dpGramAccountStatus');
  await prefs.remove('emailVerfied');
  await prefs.remove('resendMailCounter');
  await prefs.remove('lastResendAfter');
  await prefs.remove('categoryList');
  await prefs.remove('platformList');
  await prefs.remove('countryCode');
  await prefs.remove('dayFilterdpGramAnalyticsViews');
  await prefs.remove('dayFilterAnalyticsViews');
  await prefs.remove('dayFilterAnalyticsEarning');
  await prefs.remove('dayFilterAnalytics');
}

Future<void> makeRequest(context, url) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult != ConnectivityResult.none) {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
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
  }
}

Future<void> makeRequestExternal(context, url) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult != ConnectivityResult.none) {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        print('Can\'t lauch now !!!');
      }
    } catch (e) {
      print(e);
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
  }
}

getPlatformImageLink(name) {
  switch (name) {
    case 'Amazon':
      return 'assets/socialImage/amazon.png';
    case 'Amazon Music':
      return 'assets/socialImage/amazonmusic.png';
    case 'Apple Podcasts':
      return 'assets/socialImage/applepodcasts.png';
    case 'Badoo':
      return 'assets/socialImage/badoo.png';
    case 'Chingari':
      return 'assets/socialImage/chingari.png';
    case 'CodeChef':
      return 'assets/socialImage/codechef.png';
    case 'Discord':
      return 'assets/socialImage/discord.png';
    case 'Email':
      return 'assets/socialImage/email.png';
    case 'Facebook':
      return 'assets/socialImage/facebook.png';
    case 'Fb Group':
      return 'assets/socialImage/facebook.png';
    case 'Fb Page':
      return 'assets/socialImage/facebook.png';
    case 'GitHub':
      return 'assets/socialImage/github.png';
    case 'HackerRank':
      return 'assets/socialImage/hackerrank.png';
    case 'Hipi':
      return 'assets/socialImage/hipi.png';
    case 'Instagram':
      return 'assets/socialImage/instagram.png';
    case 'Josh':
      return 'assets/socialImage/josh.png';
    case 'Koo':
      return 'assets/socialImage/koo.png';
    case 'LeetCode':
      return 'assets/socialImage/leetcode.png';
    case 'Linkedin':
      return 'assets/socialImage/linkedin.png';
    case 'Medium':
      return 'assets/socialImage/medium.png';
    case 'Moj':
      return 'assets/socialImage/moj.png';
    case 'Pinterest':
      return 'assets/socialImage/pinterest.png';
    case 'QQ':
      return 'assets/socialImage/qq.png';
    case 'Qzone':
      return 'assets/socialImage/qzone.png';
    case 'Reddit':
      return 'assets/socialImage/reddit.png';
    case 'Shorts':
      return 'assets/socialImage/shorts.png';
    case 'Shop':
      return 'assets/socialImage/shop.png';
    case 'Sina Weibo':
      return 'assets/socialImage/sinaweibo.png';
    case 'Snapchat':
      return 'assets/socialImage/snapchat.png';
    case 'Spotify':
      return 'assets/socialImage/spotify.png';
    case 'Stack Overflow':
      return 'assets/socialImage/stackoverflow.png';
    case 'TakaTak':
      return 'assets/socialImage/takatak.png';
    case 'Telegram Channel':
      return 'assets/socialImage/telegram.png';
    case 'Telegram Group':
      return 'assets/socialImage/telegram.png';
    case 'Tiki':
      return 'assets/socialImage/tiki.png';
    case 'TikTok':
      return 'assets/socialImage/tiktok.png';
    case 'Tumblr':
      return 'assets/socialImage/tumblr.png';
    case 'Twitch':
      return 'assets/socialImage/twitch.png';
    case 'Twitter':
      return 'assets/socialImage/twitter.png';
    case 'Vigo Video':
      return 'assets/socialImage/vigovideo.png';
    case 'Website':
      return 'assets/socialImage/website.png';
    case 'WhatsApp':
      return 'assets/socialImage/whatsapp.png';
    case 'WhatsApp Group':
      return 'assets/socialImage/whatsapp.png';
    case 'YouTube':
      return 'assets/socialImage/youtube.png';
    case 'YouTube Video':
      return 'assets/socialImage/youtube.png';
    case 'Zili':
      return 'assets/socialImage/zili.png';
    default:
      return '';
  }
}

needHelp(context, url) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Need Help ?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Signika',
            color: Color.fromRGBO(230, 0, 0, 1),
            fontWeight: FontWeight.w700,
            fontSize: 26,
            letterSpacing: 1,
          ),
        ),
        content: Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Text(
            'Sorry to see you in trouble. Please let us know your problem.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'Signika',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              letterSpacing: 0.5,
              height: 1.5,
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromRGBO(255, 255, 255, 1),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 0.5),
                  blurRadius: 0.5,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    var connectivityResult =
                        await (Connectivity().checkConnectivity());
                    if (connectivityResult != ConnectivityResult.none) {
                      var _uri = Uri.parse(url);
                      if (await canLaunchUrl(_uri)) {
                        await launchUrl(_uri);
                        Future.delayed(Duration(milliseconds: 250), () {
                          Navigator.pop(context);
                        });
                      } else {
                        print('Can\'t lauch now !!!');
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
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 9, 20, 10),
                    child: Text(
                      'help@dpGram.com  >',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 0, 0, 1),
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

// Country Code
var countryDetails = [
  ['Afghanistan', 'AF', '93'],
  ['Aland Islands', 'AX', '358'],
  ['Albania', 'AL', '355'],
  ['Algeria', 'DZ', '213'],
  ['American Samoa', 'AS', '1684'],
  ['Andorra', 'AD', '376'],
  ['Angola', 'AO', '244'],
  ['Anguilla', 'AI', '1264'],
  ['Antarctica', 'AQ', '672'],
  ['Antigua and Barbuda', 'AG', '1268'],
  ['Argentina', 'AR', '54'],
  ['Armenia', 'AM', '374'],
  ['Aruba', 'AW', '297'],
  ['Australia', 'AU', '61'],
  ['Austria', 'AT', '43'],
  ['Azerbaijan', 'AZ', '994'],
  ['Bahamas', 'BS', '1242'],
  ['Bahrain', 'BH', '973'],
  ['Bangladesh', 'BD', '880'],
  ['Barbados', 'BB', '1246'],
  ['Belarus', 'BY', '375'],
  ['Belgium', 'BE', '32'],
  ['Belize', 'BZ', '501'],
  ['Benin', 'BJ', '229'],
  ['Bermuda', 'BM', '1441'],
  ['Bhutan', 'BT', '975'],
  ['Bolivia', 'BO', '591'],
  ['Bonaire, Sint Eustatius and Saba', 'BQ', '599'],
  ['Bosnia and Herzegovina', 'BA', '387'],
  ['Botswana', 'BW', '267'],
  ['Bouvet Island', 'BV', '55'],
  ['Brazil', 'BR', '55'],
  ['British Indian Ocean Territory', 'IO', '246'],
  ['Brunei Darussalam', 'BN', '673'],
  ['Bulgaria', 'BG', '359'],
  ['Burkina Faso', 'BF', '226'],
  ['Burundi', 'BI', '257'],
  ['Cambodia', 'KH', '855'],
  ['Cameroon', 'CM', '237'],
  ['Canada', 'CA', '1'],
  ['Cape Verde', 'CV', '238'],
  ['Cayman Islands', 'KY', '1345'],
  ['Central African Republic', 'CF', '236'],
  ['Chad', 'TD', '235'],
  ['Chile', 'CL', '56'],
  ['China', 'CN', '86'],
  ['Christmas Island', 'CX', '61'],
  ['Cocos (Keeling) Islands', 'CC', '672'],
  ['Colombia', 'CO', '57'],
  ['Comoros', 'KM', '269'],
  ['Congo', 'CG', '242'],
  ['Congo, Democratic Republic of the Congo', 'CD', '242'],
  ['Cook Islands', 'CK', '682'],
  ['Costa Rica', 'CR', '506'],
  ["Cote D'Ivoire", 'CI', '225'],
  ['Croatia', 'HR', '385'],
  ['Cuba', 'CU', '53'],
  ['Curacao', 'CW', '599'],
  ['Cyprus', 'CY', '357'],
  ['Czech Republic', 'CZ', '420'],
  ['Denmark', 'DK', '45'],
  ['Djibouti', 'DJ', '253'],
  ['Dominica', 'DM', '1767'],
  ['Dominican Republic', 'DO', '1809'],
  ['Ecuador', 'EC', '593'],
  ['Egypt', 'EG', '20'],
  ['El Salvador', 'SV', '503'],
  ['Equatorial Guinea', 'GQ', '240'],
  ['Eritrea', 'ER', '291'],
  ['Estonia', 'EE', '372'],
  ['Ethiopia', 'ET', '251'],
  ['Falkland Islands (Malvinas)', 'FK', '500'],
  ['Faroe Islands', 'FO', '298'],
  ['Fiji', 'FJ', '679'],
  ['Finland', 'FI', '358'],
  ['France', 'FR', '33'],
  ['French Guiana', 'GF', '594'],
  ['French Polynesia', 'PF', '689'],
  ['French Southern Territories', 'TF', '262'],
  ['Gabon', 'GA', '241'],
  ['Gambia', 'GM', '220'],
  ['Georgia', 'GE', '995'],
  ['Germany', 'DE', '49'],
  ['Ghana', 'GH', '233'],
  ['Gibraltar', 'GI', '350'],
  ['Greece', 'GR', '30'],
  ['Greenland', 'GL', '299'],
  ['Grenada', 'GD', '1473'],
  ['Guadeloupe', 'GP', '590'],
  ['Guam', 'GU', '1671'],
  ['Guatemala', 'GT', '502'],
  ['Guernsey', 'GG', '44'],
  ['Guinea', 'GN', '224'],
  ['Guinea-Bissau', 'GW', '245'],
  ['Guyana', 'GY', '592'],
  ['Haiti', 'HT', '509'],
  ['Heard Island and Mcdonald Islands', 'HM', '0'],
  ['Holy See (Vatican City State)', 'VA', '39'],
  ['Honduras', 'HN', '504'],
  ['Hong Kong', 'HK', '852'],
  ['Hungary', 'HU', '36'],
  ['Iceland', 'IS', '354'],
  ['India', 'IN', '91'],
  ['Indonesia', 'ID', '62'],
  ['Iran, Islamic Republic of', 'IR', '98'],
  ['Iraq', 'IQ', '964'],
  ['Ireland', 'IE', '353'],
  ['Isle of Man', 'IM', '44'],
  ['Israel', 'IL', '972'],
  ['Italy', 'IT', '39'],
  ['Jamaica', 'JM', '1876'],
  ['Japan', 'JP', '81'],
  ['Jersey', 'JE', '44'],
  ['Jordan', 'JO', '962'],
  ['Kazakhstan', 'KZ', '7'],
  ['Kenya', 'KE', '254'],
  ['Kiribati', 'KI', '686'],
  ["Korea, Democratic People's Republic of", 'KP', '850'],
  ['Korea, Republic of', 'KR', '82'],
  ['Kosovo', 'XK', '381'],
  ['Kuwait', 'KW', '965'],
  ['Kyrgyzstan', 'KG', '996'],
  ["Lao People's Democratic Republic", 'LA', '856'],
  ['Latvia', 'LV', '371'],
  ['Lebanon', 'LB', '961'],
  ['Lesotho', 'LS', '266'],
  ['Liberia', 'LR', '231'],
  ['Libyan Arab Jamahiriya', 'LY', '218'],
  ['Liechtenstein', 'LI', '423'],
  ['Lithuania', 'LT', '370'],
  ['Luxembourg', 'LU', '352'],
  ['Macao', 'MO', '853'],
  ['Macedonia, the Former Yugoslav Republic of', 'MK', '389'],
  ['Madagascar', 'MG', '261'],
  ['Malawi', 'MW', '265'],
  ['Malaysia', 'MY', '60'],
  ['Maldives', 'MV', '960'],
  ['Mali', 'ML', '223'],
  ['Malta', 'MT', '356'],
  ['Marshall Islands', 'MH', '692'],
  ['Martinique', 'MQ', '596'],
  ['Mauritania', 'MR', '222'],
  ['Mauritius', 'MU', '230'],
  ['Mayotte', 'YT', '269'],
  ['Mexico', 'MX', '52'],
  ['Micronesia, Federated States of', 'FM', '691'],
  ['Moldova, Republic of', 'MD', '373'],
  ['Monaco', 'MC', '377'],
  ['Mongolia', 'MN', '976'],
  ['Montenegro', 'ME', '382'],
  ['Montserrat', 'MS', '1664'],
  ['Morocco', 'MA', '212'],
  ['Mozambique', 'MZ', '258'],
  ['Myanmar', 'MM', '95'],
  ['Namibia', 'NA', '264'],
  ['Nauru', 'NR', '674'],
  ['Nepal', 'NP', '977'],
  ['Netherlands', 'NL', '31'],
  ['Netherlands Antilles', 'AN', '599'],
  ['New Caledonia', 'NC', '687'],
  ['New Zealand', 'NZ', '64'],
  ['Nicaragua', 'NI', '505'],
  ['Niger', 'NE', '227'],
  ['Nigeria', 'NG', '234'],
  ['Niue', 'NU', '683'],
  ['Norfolk Island', 'NF', '672'],
  ['Northern Mariana Islands', 'MP', '1670'],
  ['Norway', 'NO', '47'],
  ['Oman', 'OM', '968'],
  ['Pakistan', 'PK', '92'],
  ['Palau', 'PW', '680'],
  ['Palestinian Territory, Occupied', 'PS', '970'],
  ['Panama', 'PA', '507'],
  ['Papua New Guinea', 'PG', '675'],
  ['Paraguay', 'PY', '595'],
  ['Peru', 'PE', '51'],
  ['Philippines', 'PH', '63'],
  ['Pitcairn', 'PN', '64'],
  ['Poland', 'PL', '48'],
  ['Portugal', 'PT', '351'],
  ['Puerto Rico', 'PR', '1787'],
  ['Qatar', 'QA', '974'],
  ['Reunion', 'RE', '262'],
  ['Romania', 'RO', '40'],
  ['Russian Federation', 'RU', '70'],
  ['Rwanda', 'RW', '250'],
  ['Saint Barthelemy', 'BL', '590'],
  ['Saint Helena', 'SH', '290'],
  ['Saint Kitts and Nevis', 'KN', '1869'],
  ['Saint Lucia', 'LC', '1758'],
  ['Saint Martin', 'MF', '590'],
  ['Saint Pierre and Miquelon', 'PM', '508'],
  ['Saint Vincent and the Grenadines', 'VC', '1784'],
  ['Samoa', 'WS', '684'],
  ['San Marino', 'SM', '378'],
  ['Sao Tome and Principe', 'ST', '239'],
  ['Saudi Arabia', 'SA', '966'],
  ['Senegal', 'SN', '221'],
  ['Serbia', 'RS', '381'],
  ['Serbia and Montenegro', 'CS', '381'],
  ['Seychelles', 'SC', '248'],
  ['Sierra Leone', 'SL', '232'],
  ['Singapore', 'SG', '65'],
  ['Sint Maarten', 'SX', '1'],
  ['Slovakia', 'SK', '421'],
  ['Slovenia', 'SI', '386'],
  ['Solomon Islands', 'SB', '677'],
  ['Somalia', 'SO', '252'],
  ['South Africa', 'ZA', '27'],
  ['South Georgia and the South Sandwich Islands', 'GS', '500'],
  ['South Sudan', 'SS', '211'],
  ['Spain', 'ES', '34'],
  ['Sri Lanka', 'LK', '94'],
  ['Sudan', 'SD', '249'],
  ['Suriname', 'SR', '597'],
  ['Svalbard and Jan Mayen', 'SJ', '47'],
  ['Swaziland', 'SZ', '268'],
  ['Sweden', 'SE', '46'],
  ['Switzerland', 'CH', '41'],
  ['Syrian Arab Republic', 'SY', '963'],
  ['Taiwan, Province of China', 'TW', '886'],
  ['Tajikistan', 'TJ', '992'],
  ['Tanzania, United Republic of', 'TZ', '255'],
  ['Thailand', 'TH', '66'],
  ['Timor-Leste', 'TL', '670'],
  ['Togo', 'TG', '228'],
  ['Tokelau', 'TK', '690'],
  ['Tonga', 'TO', '676'],
  ['Trinidad and Tobago', 'TT', '1868'],
  ['Tunisia', 'TN', '216'],
  ['Turkey', 'TR', '90'],
  ['Turkmenistan', 'TM', '7370'],
  ['Turks and Caicos Islands', 'TC', '1649'],
  ['Tuvalu', 'TV', '688'],
  ['Uganda', 'UG', '256'],
  ['Ukraine', 'UA', '380'],
  ['United Arab Emirates', 'AE', '971'],
  ['United Kingdom', 'GB', '44'],
  ['United States', 'US', '1'],
  ['United States Minor Outlying Islands', 'UM', '1'],
  ['Uruguay', 'UY', '598'],
  ['Uzbekistan', 'UZ', '998'],
  ['Vanuatu', 'VU', '678'],
  ['Venezuela', 'VE', '58'],
  ['Viet Nam', 'VN', '84'],
  ['Virgin Islands, British', 'VG', '1284'],
  ['Virgin Islands, U.s.', 'VI', '1340'],
  ['Wallis and Futuna', 'WF', '681'],
  ['Western Sahara', 'EH', '212'],
  ['Yemen', 'YE', '967'],
  ['Zambia', 'ZM', '260'],
  ['Zimbabwe', 'ZW', '263'],
];

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kingmaker/content/bonusRefralCheck.dart';
import 'package:kingmaker/content/globalVariable.dart';
import 'package:kingmaker/content/myWebView.dart';
import 'package:kingmaker/content/updateProfile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/AuthService.dart';

class Account extends StatefulWidget {
  final _pageNumberSelector;
  const Account(this._pageNumberSelector, {Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  var doingLogout = false;
  myGrid(myicon, title, fnc) {
    return InkWell(
      onTap: () {
        Future.delayed(Duration(milliseconds: 200), () {
          fnc();
        });
      },
      child: Container(
        // color: Color.fromRGBO(255, 255, 255, 1),
        height: 50,
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
          children: [
            myicon,

            SizedBox(
              width: 15,
            ),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Signika',
                fontWeight: FontWeight.w600,
                letterSpacing: 1.25,
              ),
            ),
            // Expanded(
            //   child: Align(
            //     alignment: Alignment.centerRight,
            //     child: Icon(
            //       Icons.arrow_forward_ios_rounded,
            //       size: 16,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Future _refresh() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
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
      accountProfileImage = null;
      getCreatorInfo();
      setState(() {});
      // It should be loaded because user mostly do only in the case of emergency
      getPrivateInfo();
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    if (privateInfo == null) {
      refresher100();
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

  @override
  Widget build(BuildContext context) {
    if (privateInfo == null) {
      return WillPopScope(
        onWillPop: () => widget._pageNumberSelector(1),
        child: RefreshIndicator(
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
                      ? isCreatingAccount
                          ? 'Welcome! Creating Your Account.'
                          : 'Please wait, fetching details.'
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
                                            color:
                                                Color.fromRGBO(36, 14, 123, 1),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 100,
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
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
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () => widget._pageNumberSelector(1),
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: [
            // SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 7 / 2,
              child: GestureDetector(
                onTap: () {
                  aboutInitialExpanderNumber = 3;
                  widget._pageNumberSelector(8);
                },
                child: Container(
                  // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(220, 255, 220, 1),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 0.5),
                        blurRadius: 0.25,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateProfile()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          // color: Colors.amber,
                          child: ClipOval(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  shape: BoxShape.circle,
                                ),
                                child: accountProfileImage != null
                                    ? Image(
                                        image: accountProfileImage,
                                        fit: BoxFit.cover,
                                      )
                                    : FutureBuilder(
                                        builder: (context, snapshot) {
                                          print(
                                              '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^C1 ${snapshot.data}');
                                          if (snapshot.data != null) {
                                            print(
                                                '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^C2 ${snapshot.data}');
                                            return CachedNetworkImage(
                                              imageUrl: '${snapshot.data}',
                                              imageBuilder:
                                                  (context, imageProvider) {
                                                accountProfileImage =
                                                    imageProvider;
                                                return Image(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                              placeholder: (context, url) =>
                                                  Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          255, 255, 255, 1),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                'assets/person.png',
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          }
                                          return Center(
                                            child: CupertinoActivityIndicator(
                                              radius: 15,
                                            ),
                                          );
                                        },
                                        future: getDownloadLink(
                                            privateInfo != null
                                                ? privateInfo['profile']
                                                : ''), // From global variables
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Row(
                                children: [
                                  Text(
                                    '$pifirstName $pimiddleName $pilastName',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Container(
                                    height: 25,
                                    width: 25,
                                    margin: EdgeInsets.only(left: 3, right: 3),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 0, 0, 0.05),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      size: 14,
                                      color: Color.fromRGBO(35, 15, 123, 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FittedBox(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 2),
                                    child: Text(
                                      '@',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Signika',
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.5,
                                        color: Color.fromRGBO(0, 0, 0, 0.5),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Text(
                                    piuserID,
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 255, 1),
                                      fontSize: 16,
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            (bonusProgram && !isCreatorAccountActive)
                ? Container(
                    height: 60,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.35),
                          blurRadius: 0.5,
                          offset: Offset(0, 0.5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 36,
                                    width: 36,
                                    alignment: Alignment.center,
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 140, 0, 1),
                                      border: Border.all(
                                        color: Color.fromRGBO(255, 140, 0, 1),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        colors: const [
                                          Color.fromRGBO(255, 155, 0, 1),
                                          Color.fromRGBO(255, 100, 0, 1),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Text(
                                      '₹',
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Signika',
                                        fontSize: 28,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Join Bonus Program',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 8),
                                alignment: Alignment.center,
                                child: Icon(Icons.arrow_forward_ios_rounded),
                              ),
                            ],
                          ),
                          onTap: () {
                            Future.delayed(Duration(milliseconds: 300), () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return BonusReferralCheck(
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
                          },
                        ),
                      ),
                    ),
                  )
                : Container(),
            isCreatorAccountActive
                ? Container(
                    height: 60,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.35),
                          blurRadius: 0.5,
                          offset: Offset(0, 0.5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Padding(
                                  //   padding: EdgeInsets.only(left: 10),
                                  //   child: Icon(
                                  //     Icons.monetization_on,
                                  //     color: Colors.deepOrange,
                                  //     size: 40,
                                  //   ),
                                  // ),
                                  Container(
                                    height: 36,
                                    width: 36,
                                    alignment: Alignment.center,
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 140, 0, 1),
                                      border: Border.all(
                                        color: Color.fromRGBO(255, 140, 0, 1),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        colors: const [
                                          Color.fromRGBO(255, 155, 0, 1),
                                          Color.fromRGBO(255, 100, 0, 1),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Text(
                                      '₹',
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Signika',
                                        fontSize: 28,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    picc == 0
                                        ? '0.0'
                                        : '${picc / 10000}'.trim(),
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 8),
                                alignment: Alignment.center,
                                child: Icon(Icons.arrow_forward_ios_rounded),
                              ),
                            ],
                          ),
                          onTap: () {
                            Future.delayed(
                              Duration(milliseconds: 200),
                              () {
                                widget._pageNumberSelector(6);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : Container(),
            Container(
              height: 60,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.35),
                    blurRadius: 0.5,
                    offset: Offset(0, 0.5),
                  ),
                ],
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
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontSize: 16,
                                          fontFamily: 'Signika',
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      TextSpan(
                                        text: piuserID,
                                        style: TextStyle(
                                          color: Color.fromRGBO(230, 0, 0, 1),
                                          fontSize: 16,
                                          fontFamily: 'Signika',
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
                            ClipboardData(text: 'https://dpGram.com/$piuserID'),
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
                      child: Container(
                        height: 60,
                        width: 50,
                        alignment: Alignment.center,
                        child: Icon(Icons.copy),
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

            Container(
              margin: EdgeInsets.fromLTRB(
                15,
                20,
                15,
                15,
              ),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.35),
                    blurRadius: 0.5,
                    offset: Offset(0, 0.5),
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      try {
                        if (await canLaunchUrl(Uri.parse(
                            'https://dpgram.com/en/HowToUse/Kingmaker'))) {
                          await launchUrl(
                            Uri.parse(
                                'https://dpgram.com/en/HowToUse/Kingmaker'),
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          print('Can\'t lauch now !!!');
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: SizedBox(
                      height: 72,
                      child: Row(
                        children: [
                          Image.asset('assets/KingmakerGuide.png'),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width -
                                40 -
                                128 -
                                15,
                            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                            child: Text(
                              'How To Use Kingmaker And Setup dpGram Account.',
                              softWrap: true,
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Divider(),
            // myGrid(
            //   Icons.link_rounded,
            //   'dpGram Profile',
            //   () async {
            //     try {
            //       if (!(piuserID == '' ||
            //           piuserID == 'Add User ID' ||
            //           pifirstName == '' ||
            //           pifirstName == 'Add Name')) {
            //         try {
            //           if (await canLaunchUrl(
            //               Uri.parse('https://dpgram.com/$piuserID'))) {
            //             await launchUrl(
            //               Uri.parse('https://dpgram.com/$piuserID'),
            //               mode: LaunchMode.externalApplication,
            //             );
            //           } else {
            //             print('Can\'t lauch now !!!');
            //           }
            //         } catch (e) {
            //           print(e);
            //         }
            //       } else {
            //         showDialog(
            //           context: context,
            //           builder: (BuildContext context) {
            //             return AlertDialog(
            //               title: Text(
            //                 'Please add "User ID" and "Name" to access your account.', // imported from AuthService.dart
            //                 textAlign: TextAlign.center,
            //                 style: TextStyle(
            //                   color: Color.fromRGBO(230, 0, 0, 1),
            //                   fontWeight: FontWeight.w600,
            //                   fontFamily: 'Signika',
            //                   fontSize: 18,
            //                   letterSpacing: 1,
            //                   height: 1.25,
            //                 ),
            //               ),
            //               backgroundColor: Color.fromRGBO(255, 255, 255, 1),
            //               actionsAlignment: MainAxisAlignment.spaceBetween,
            //               actions: [
            //                 OutlinedButton(
            //                   child: Text(
            //                     'Close',
            //                     style: TextStyle(
            //                       color: Color.fromRGBO(255, 0, 0, 1),
            //                       fontWeight: FontWeight.w500,
            //                       fontFamily: 'Signika',
            //                       fontSize: 18,
            //                     ),
            //                   ),
            //                   onPressed: () {
            //                     Navigator.of(context).pop();
            //                   },
            //                 ),
            //                 OutlinedButton(
            //                   style: ButtonStyle(
            //                     backgroundColor: MaterialStateProperty.all(
            //                       Color.fromRGBO(230, 0, 0, 1),
            //                     ),
            //                   ),
            //                   child: Text(
            //                     'Update now',
            //                     style: TextStyle(
            //                       color: Color.fromRGBO(255, 255, 255, 1),
            //                       fontWeight: FontWeight.w500,
            //                       fontFamily: 'Signika',
            //                       fontSize: 18,
            //                     ),
            //                   ),
            //                   onPressed: () {
            //                     Navigator.of(context).pop();
            //                     widget._pageNumberSelector(8);
            //                   },
            //                 ),
            //               ],
            //             );
            //           },
            //         );
            //       }
            //     } catch (e) {
            //       print(e);
            //     }
            //   },
            // ),
            // Divider(),
            myGrid(
                Icon(
                  Icons.manage_accounts_rounded,
                  size: 24,
                ),
                'Account Settings', () {
              aboutInitialExpanderNumber = 0;
              accountSettingRedirectNumber = 4;
              widget._pageNumberSelector(8);
            }),
            // isCreatorAccountActive
            //     ? myGrid(Icons.payment_rounded, 'Payout Settings', () {
            //         widget._pageNumberSelector(5);
            //       })
            //     : Container(),
            // myGrid(Icons.question_answer_rounded, 'FAQ', () {}),
            // myGrid(Icons.help_rounded, 'Help', () {}),

            // myGrid(
            //   Icons.library_books_rounded,
            //   'How to use ?',
            //   () async {
            //     try {
            //       if (await canLaunchUrl(
            //           Uri.parse('https://dpgram.com/en/HowToUse/Kingmaker'))) {
            //         await launchUrl(
            //           Uri.parse('https://dpgram.com/en/HowToUse/Kingmaker'),
            //           mode: LaunchMode.externalApplication,
            //         );
            //       } else {
            //         print('Can\'t lauch now !!!');
            //       }
            //     } catch (e) {
            //       print(e);
            //     }
            //   },
            // ),
            // Divider(),
            Divider(),
            myGrid(
                Icon(
                  Icons.privacy_tip_rounded,
                  size: 24,
                ),
                'Privacy Policy', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return MyWebView('https://icyindia.com/en/privacy');
                }),
              );
            }),
            myGrid(
                Icon(
                  Icons.assignment_rounded,
                  size: 24,
                ),
                'Terms of Use', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return MyWebView('https://icyindia.com/en/termsofuse');
                }),
              );
              // showDialog(
              //     context: context,
              //     builder: (context) {
              //       return WillPopScope(
              //           onWillPop: () async {
              //             Navigator.pop(context);
              //             return false;
              //           },
              //           child: MyWebView('https://icyindia.com'));
              //     });
            }),

            myGrid(
                Icon(
                  Icons.mail_rounded,
                  size: 24,
                ),
                'Contact', () {
              // From Global variable
              needHelp(context, 'mailto:help@dpgram.com');
            }),

            Divider(),

            myGrid(
              Icon(
                Icons.share_rounded,
                size: 24,
              ),
              'Share App with friends',
              () {
                Share.share(
                  // '*Hello !*\n\n*Create dpGram.com profile and get one link for everything.*\n\n*Get guide to trend Reels, Shorts, Snap and many more.*\n\n\nDownload *Kingmaker* from Playstore.\n\nhttps://play.google.com/store/apps/details?id=com.icyindia.kingmaker', //3z4mkze
                  '*Hello !*\n\nTry the most advanced *App Opener* and *Bio Tool* like me -\n\n👉  Interconnect all social profiles\n👉  Open every link in the app\n👉  Create one *Bio Link* to connect and share everything.\n\n*Check my Bio Link :*\n👉  dpgram.com/$piuserID\n\n- - - - - - - - - - - - - - - - - - -\n\n*Create your Bio Link :*\n👉  https://play.google.com/store/apps/details?id=com.icyindia.kingmaker\n\n*Tutorial links :*\n👉  https://dpgram.com/en/HowToUse/Kingmaker\n\n- - - - - - - - - - - - - - - - - - -\n\n*Additional Features :*\n\n*Latest trending Hashtag, Audio, Reels, Shorts, Snap, Memes and many more.*',
                );
              },
            ),
            Divider(),

            myGrid(
              Icon(
                Icons.logout_rounded,
                size: 24,
              ),
              doingLogout ? 'Hold On. Logging out.' : 'Logout',
              () async {
                invokeLogout() {
                  if (doingLogout == false) {
                    setState(() {
                      doingLogout = !doingLogout;
                    });
                    // Data will be erased by signout funtion after signout
                    AuthService().signOut();
                  }
                }

                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Logout ?',
                          style: TextStyle(
                            color: Color.fromRGBO(230, 0, 0, 1),
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                        content: Text(
                          'Are you sure to logout?',
                          style: TextStyle(
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 1,
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
                                invokeLogout();
                              },
                            ),
                          ),
                        ],
                      );
                    });
              },
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

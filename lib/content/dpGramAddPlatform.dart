import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kingmaker/content/globalVariable.dart';
import 'package:kingmaker/services/googleAds.dart';

class DpGramAddPlatForm extends StatefulWidget {
  final Function _pageNumberSelector;

  const DpGramAddPlatForm(this._pageNumberSelector, {Key? key})
      : super(key: key);

  @override
  State<DpGramAddPlatForm> createState() => _DpGramAddPlatFormState();
}

class _DpGramAddPlatFormState extends State<DpGramAddPlatForm> {
  var _platform;
  var _platformList = <String>[];
  var isUpdatingData = false;
  var _username = '';
  var _url = '';
  var usernameLabelText = 'Username / id / title';
  var profileLinkLabelText = 'Link';
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerProfileLink = TextEditingController();
  final TextEditingController _controllerOtherPlatformName =
      TextEditingController();

  Future<void> _addPlatform() async {
    if (isUpdatingData == true) {
      print('----------------------------In progress');
      return;
    }
    print('-----------------------------------------');
    print(_username);
    var asd = _username;
    print(asd);
    var isErrorFound = false;
    if (_platform == null) {
      isErrorFound = true;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Platform ?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(230, 0, 0, 1),
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              'Please select appropriate platform.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Signika',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 1,
                // color: Color.fromRGBO(36, 14, 123, 1),
                height: 1.5,
              ),
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
          );
        },
      );
      return;
    }

    if (_platform == '— Other') {
      if (_controllerOtherPlatformName.text.isEmpty ||
          _controllerOtherPlatformName.text.length > 32) {
        isErrorFound = true;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Invalid Length',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(230, 0, 0, 1),
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: Text(
                'Platform name must be 1 to 32 characters long.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 1,
                  // color: Color.fromRGBO(36, 14, 123, 1),
                  height: 1.5,
                ),
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
            );
          },
        );
        return;
      }
    }

    if (_username == '') {
      isErrorFound = true;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              '$usernameLabelText ?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(230, 0, 0, 1),
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              'Please add appropriate $usernameLabelText.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Signika',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 1,
                // color: Color.fromRGBO(36, 14, 123, 1),
                height: 1.5,
              ),
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
          );
        },
      );
      return;
    }

    if (_url == '' || _url.length < 4) {
      isErrorFound = true;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              '$profileLinkLabelText ?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(230, 0, 0, 1),
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              'Please add appropriate $profileLinkLabelText.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Signika',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 1,
                // color: Color.fromRGBO(36, 14, 123, 1),
                height: 1.5,
              ),
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
          );
        },
      );
      return;
    }

    if (asd.length < 3 || asd.length > 128) {
      isErrorFound = true;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Invalid Length',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(230, 0, 0, 1),
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              '$usernameLabelText must be 3 to 128 characters long.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Signika',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 1,
                // color: Color.fromRGBO(36, 14, 123, 1),
                height: 1.5,
              ),
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
          );
        },
      );
      return;
    }

    showInvalidCharacterNotification(value) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(230, 0, 0, 1),
                letterSpacing: 1.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            content: Text(
              'Please use only:\n- Capital Letter (A-Z)\n- Small Letter (a-z)\n- Underscore ( _ )\n- Dot ( . )\n-Space ( )',
              style: TextStyle(
                fontFamily: 'Signika',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 1,
                // color: Color.fromRGBO(36, 14, 123, 1),
                height: 1.5,
              ),
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
          );
        },
      );
    }

    if (isErrorFound == false) {
      for (var i = 0; i < asd.length; i++) {
        if ((asd.codeUnitAt(i) >= 48 && asd.codeUnitAt(i) <= 57) || // Number
                (asd.codeUnitAt(i) >= 65 && asd.codeUnitAt(i) <= 90) || // A-Z
                (asd.codeUnitAt(i) >= 97 && asd.codeUnitAt(i) <= 122) || // a-z
                asd.codeUnitAt(i) == 46 || // .
                asd.codeUnitAt(i) == 95 || // _
                asd.codeUnitAt(i) == 32 // Space
            ) {
          continue;
        } else {
          isErrorFound = true;
          showInvalidCharacterNotification('Invalid\n$usernameLabelText');
          break;
        }
      }

      var opn = _controllerOtherPlatformName.text;
      for (var i = 0; i < opn.length; i++) {
        if ((opn.codeUnitAt(i) >= 48 && opn.codeUnitAt(i) <= 57) || // Number
                (opn.codeUnitAt(i) >= 65 && opn.codeUnitAt(i) <= 90) || // A-Z
                (opn.codeUnitAt(i) >= 97 && opn.codeUnitAt(i) <= 122) || // a-z
                opn.codeUnitAt(i) == 46 || // .
                opn.codeUnitAt(i) == 95 || // _
                opn.codeUnitAt(i) == 32 // Space
            ) {
          continue;
        } else {
          isErrorFound = true;
          showInvalidCharacterNotification('Invalid Plaform Name');
          break;
        }
      }
    }
    if (isErrorFound == false) {
      showInterstitialAd();
      setState(() {
        isUpdatingData = true;
      });
      var addActivePlatform =
          FirebaseFunctions.instanceFor(region: 'asia-south1')
              .httpsCallable('addActivePlatform');
      await addActivePlatform({
        'platform': _platform == '— Other'
            ? _controllerOtherPlatformName.text.toString().trim()
            : _platform,
        'username': _username,
        'url': _url
      }).then((value) {
        print('----------------------------------------');
        print('------------${value.data}');
        print('----------------------------------------');
        setState(() {
          isUpdatingData = false;
        });
        if (value.data[0] == 'Successful') {
          platformPriority.add(value.data[1]);
          // update platform list localy
          piPlatform[value.data[1]] = {
            'platform': (_platform == '— Other')
                ? _controllerOtherPlatformName.text.toString().trim()
                : _platform,
            'username': _username,
            'url': _url,
            'referenceID': value.data[1],
          };

          setState(() {
            // For other platform
            if (_controllerOtherPlatformName.text != '') {
              _controllerOtherPlatformName.text = '';
            }
            // For all platform
            _platform = null;
            _controllerUsername.text = '';
            _controllerProfileLink.text = '';
          });

          // piusername = _username;

          ScaffoldMessenger.of(context).clearSnackBars();
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     duration: Duration(seconds: 1),
          //     content: Text(
          //       'New Platform Added ...',
          //       textAlign: TextAlign.justify,
          //       style: TextStyle(
          //         fontFamily: 'Signika',
          //         fontSize: 16,
          //         fontWeight: FontWeight.w600,
          //         letterSpacing: 2,
          //       ),
          //     ),
          //   ),
          // );
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Successful!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(230, 0, 0, 1),
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                content: Text(
                  'New platform has been added successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Signika',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 1,
                    // color: Color.fromRGBO(36, 14, 123, 1),
                    height: 1.5,
                  ),
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
              );
            },
          );
        } else if (value.data == 'Unknown Error') {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Unkown Error',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(230, 0, 0, 1),
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                content: Text(
                  'Unknown error found. Please try after sometime.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Signika',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 1,
                    // color: Color.fromRGBO(36, 14, 123, 1),
                    height: 1.5,
                  ),
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
              );
            },
          );
        }
      }).catchError((error) {
        print('Failed to update: $error');
        isUpdatingData = false;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Unkown Error',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(230, 0, 0, 1),
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: Text(
                'Unknown error found. Please try after sometime.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 1,
                  // color: Color.fromRGBO(36, 14, 123, 1),
                  height: 1.5,
                ),
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
            );
          },
        );
      });
    }
  }

  showLoadingPlatformNotificaiton() {
    Future.delayed(Duration(milliseconds: 100), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Loading platform list. Please wait.\nOr, Restart App.',
            style: TextStyle(
              fontFamily: 'Signika',
              letterSpacing: 1,
            ),
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    var _storedPlatfromList = prefs.getStringList('platformList');
    if (_storedPlatfromList == null) {
      _platformList = ['Facebook', 'Instagram', 'Koo', 'Twitter', 'Youtube'];
      checkForUpdate(context, mounted);
      showLoadingPlatformNotificaiton();
    } else {
      _platformList.addAll(_storedPlatfromList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).clearSnackBars();
        widget._pageNumberSelector(11);
        return false;
      },
      child: Container(
        color: Color.fromRGBO(255, 255, 255, 1),
        child: ListView(
          children: [
            // Container(
            //   height: MediaQuery.of(context).size.width * 0.75,
            //   width: MediaQuery.of(context).size.width * 0.75,
            //   padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: const [
            //         Colors.black,
            //         Colors.black,
            //         Colors.white,
            //       ],
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       // stops: const [0, 0.25, 0.5],
            //     ),
            //   ),
            //   child: Image(
            //     image: AssetImage(
            //       'assets/dpgram-motto.png',
            //     ),
            //     fit: BoxFit.contain,
            //   ),
            // ),
            isAdsAvailableB1
                ? Container(
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 0.5),
                          blurRadius: 0.25,
                        ),
                      ],
                    ),
                    child: AdWidget(
                      ad: banner1!,
                    ),
                  )
                : Container(),
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 0.25,
                    offset: Offset(0, 0.5),
                  ),
                ],
                border: Border.all(
                  color: Color.fromRGBO(100, 100, 100, 1),
                  width: 1,
                ),
              ),
              margin: EdgeInsets.fromLTRB(15, 30, 15, 15),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),

              child: DropdownButton<String>(
                // menuMaxHeight: MediaQuery.of(context).size.height * 0.65,
                value: _platform,
                isExpanded: true,
                dropdownColor: Colors.amber,
                elevation: 1,
                borderRadius: BorderRadius.circular(5),
                iconSize: 40,
                hint: Text('  Platform'),
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Signika',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),

                items: _platformList.map(
                  (String value) {
                    return DropdownMenuItem<String>(
                      alignment: Alignment.center,
                      value: value,
                      child: Container(
                        width: double.infinity,
                        height: 42,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(6, 0, 10, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            getPlatformImageLink(value) != ''
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: SizedBox(
                                      height: 34,
                                      width: 34,
                                      child: Image(
                                        image: AssetImage(
                                          getPlatformImageLink(value),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 34,
                                    width: 34,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: const [
                                          Color.fromRGBO(0, 0, 0, 0.8),
                                          Color.fromRGBO(0, 0, 0, 1),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Text(
                                      value[0],
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Signika',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              value,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Signika',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),

                underline: Container(),
                // selectedItemBuilder: (BuildContext context) {
                //   return <String>['Paytm', 'PhonePe', 'GooglePay']
                //       .map<Widget>((String item) {
                //     return Text(item);
                //   }).toList();
                // },
                onChanged: (value) {
                  setState(() {
                    _platform = value;
                    // --------------------
                    print(initialInfo);
                    if (initialInfo != null &&
                        initialInfo['platformListMessage'] != null) {
                      if (initialInfo['platformListMessage'][value] != null) {
                        if (initialInfo['platformListMessage'][value]
                                ['usernameLabelText'] !=
                            null) {
                          setState(() {
                            usernameLabelText =
                                initialInfo['platformListMessage'][value]
                                    ['usernameLabelText'];
                          });
                        } else {
                          if (usernameLabelText != 'Username / id / title') {
                            setState(() {
                              usernameLabelText = 'Username / id / title';
                            });
                          }
                        }
                        if (initialInfo['platformListMessage'][value]
                                ['profileLinkLabelText'] !=
                            null) {
                          setState(() {
                            profileLinkLabelText =
                                initialInfo['platformListMessage'][value]
                                    ['profileLinkLabelText'];
                          });
                        } else {
                          if (profileLinkLabelText != 'Link') {
                            setState(() {
                              profileLinkLabelText = 'Link';
                            });
                          }
                        }
                      } else {
                        if (usernameLabelText != 'Username / id / title' ||
                            profileLinkLabelText != 'Link') {
                          setState(() {
                            usernameLabelText = 'Username / id / title';
                            profileLinkLabelText = 'Link';
                          });
                        }
                      }
                    }
                    // switch (value) {

                    //   case 'Instagram':
                    //     usernameLabelText = 'Username';
                    //     profileLinkLabelText = 'Profile link';
                    //     break;
                    //   case 'Koo':
                    //     usernameLabelText = 'Username';
                    //     profileLinkLabelText = 'Profile link';
                    //     break;
                    //   case 'Twitter':
                    //     usernameLabelText = 'Username';
                    //     profileLinkLabelText = 'Profile link';
                    //     break;
                    //   case 'Pinterest':
                    //     usernameLabelText = 'Username';
                    //     profileLinkLabelText = 'Profile link';
                    //     break;
                  });
                },
              ),
              // child: DropdownButtonFormField(
              //   value: 3,
              //   items: [
              //     DropdownMenuItem(
              //       enabled: true,
              //       child: Text('Test'),
              //       value: 1,
              //       onTap: () {},
              //     ),
              //     DropdownMenuItem(
              //       enabled: true,
              //       child: Text('Test'),
              //       onTap: () {},
              //       value: 2,
              //     ),
              //   ],
              // ),
            ),
            // _platform == '— Other'
            //     ? Container(
            //         padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            //         child: Text(
            //           'Avoid using Platform Names longer than 12 characters.',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             color: Color.fromRGBO(230, 0, 0, 1),
            //             fontWeight: FontWeight.w500,
            //             letterSpacing: 1,
            //           ),
            //         ),
            //       )
            //     : Container(),
            _platform == '— Other'
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 0.25,
                          offset: Offset(0, 0.5),
                        ),
                      ],
                    ),
                    // padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                    child: TextFormField(
                      controller: _controllerOtherPlatformName,
                      decoration: InputDecoration(
                        labelText: 'Platform/Website name',
                        labelStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          // borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color.fromRGBO(255, 255, 255, 1),
                        // It also override default padding
                        contentPadding: EdgeInsets.only(
                          top: 20,
                          right: 20,
                          bottom: 15,
                          left: 15,
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      style: TextStyle(
                        fontFamily: 'Signika',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        fontSize: 20,
                      ),
                      onChanged: (_) {
                        _username = _controllerOtherPlatformName.text;
                      },
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                    ),
                  )
                : Container(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 0.25,
                    offset: Offset(0, 0.5),
                  ),
                ],
              ),
              // padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              child: TextFormField(
                controller: _controllerUsername,
                decoration: InputDecoration(
                  labelText: usernameLabelText,

                  labelStyle: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    // borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(255, 255, 255, 1),
                  // It also override default padding
                  contentPadding: EdgeInsets.only(
                    top: 20,
                    right: 20,
                    bottom: 15,
                    left: 15,
                  ),
                ),
                keyboardType: TextInputType.name,
                style: TextStyle(
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  fontSize: 20,
                ),
                onChanged: (_) {
                  _username = _controllerUsername.text;
                },
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 0.25,
                    offset: Offset(0, 0.5),
                  ),
                ],
              ),
              // padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              child: TextFormField(
                controller: _controllerProfileLink,
                decoration: InputDecoration(
                  labelText: profileLinkLabelText,
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    // borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(255, 255, 255, 1),
                  // It also override default padding
                  contentPadding: EdgeInsets.only(
                    top: 20,
                    right: 20,
                    bottom: 15,
                    left: 15,
                  ),
                ),
                keyboardType: TextInputType.name,
                style: TextStyle(
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  fontSize: 20,
                ),
                onChanged: (_) {
                  _url = _controllerProfileLink.text;
                },
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(255, 0, 0, 1)),
                      fixedSize: MaterialStateProperty.all(Size.fromWidth(170)),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.fromLTRB(40, 8, 40, 8)),
                    ),
                    child: isUpdatingData
                        ? CupertinoActivityIndicator(
                            radius: 15,
                            color: Color.fromRGBO(0, 0, 0, 1),
                          )
                        : Text(
                            'Save',
                            style: TextStyle(
                              fontFamily: 'Signika',
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                    onPressed: () async {
                      _username = _username.trim();
                      _url = _url.trim();
                      // if (_platform != null &&
                      //     _username != '' &&
                      //     _url != '') {
                      //   setState(() {
                      //     isUpdatingData = !isUpdatingData;
                      //   });
                      //   print({
                      //     'Platform': _platform,
                      //     'Username': _username,
                      //     'Profile Link': _url,
                      //   });
                      // } else {
                      // ScaffoldMessenger.of(context).clearSnackBars();
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       duration: Duration(milliseconds: 700),
                      //       content: Text(
                      //         'Error input.',
                      //         textAlign: TextAlign.justify,
                      //         style: TextStyle(
                      //           fontFamily: 'Signika',
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w600,
                      //           letterSpacing: 2,
                      //         ),
                      //       ),
                      //     ),
                      //   );
                      // }
                      FocusManager.instance.primaryFocus?.unfocus();
                      _addPlatform();
                    },
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

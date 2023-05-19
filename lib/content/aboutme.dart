import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kingmaker/content/globalVariable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kingmaker/content/updateProfile.dart';

class AboutMe extends StatefulWidget {
  final pageNumberSelector;

  const AboutMe(this.pageNumberSelector, {Key? key}) : super(key: key);

  @override
  _AboutMeState createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  var _categoryList = <String>[];
  var _selectedCategory;

  // ________________ Start - Input Controller _________________

  var _firstName = pifirstName,
      _middleName = pimiddleName,
      _lastName = pilastName,
      _dobDD = pidobDD,
      _dobMM = pidobMM,
      _dobYYYY = pidobYYYY,
      _businessMail = pibusinessMail,
      // ignore: non_constant_identifier_names
      _WANumber = piWANumber,
      _countryCode = picountryCode,
      _top1 = pitop1,
      _top2 = pitop2,
      _top3 = pitop3,
      // ignore: prefer_final_fields
      _userID = piuserID,
      _showBM = pishowBM,
      _showWAN = pishowWAN;

  // _otherCategory = '';

  // ________________ End - Input Controller _________________

  var isSavingCategory = false;
  var isSavingName = false;
  var isSavingDOB = false;
  var isSavingTOP = false;
  var isSavingBM = false;
  var isSavingBWA = false;
  var isSavingUID = false;

  // ---------------- Start - Cloud Funtions -------------------

  Future<void> _updateuserID() async {
    _userID = _userID.trim();
    _userID = _userID.replaceAll(' ', '');
    var asd = _userID;
    var invalidSymbol;
    var isErrorFound = false;
    if (asd.length < 5 || asd.length > 32) {
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
              'User ID must be 5 to 32 characters long.',
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

    if (isErrorFound == false) {
      for (var i = 0; i < asd.length; i++) {
        if ((asd.codeUnitAt(i) >= 48 && asd.codeUnitAt(i) <= 57) || // Number
                (asd.codeUnitAt(i) >= 65 && asd.codeUnitAt(i) <= 90) || // A-Z
                (asd.codeUnitAt(i) >= 97 && asd.codeUnitAt(i) <= 122) || // a-z
                asd.codeUnitAt(i) == 46 || // .
                asd.codeUnitAt(i) == 95 // _
            ) {
          continue;
        } else {
          invalidSymbol = asd[i];
          isErrorFound = true;
          break;
        }
      }
    }
    if (isErrorFound == false) {
      setState(() {
        isSavingUID = true;
      });
      var aboutUID = FirebaseFunctions.instanceFor(region: 'asia-south1')
          .httpsCallable('about_checkUID');
      await aboutUID({
        'userID': _userID.trim(),
      }).then((value) {
        print('----------------------------------------');
        print(value.data);
        print('----------------------------------------');
        setState(() {
          isSavingUID = false;
        });
        if (value.data == 'Successful') {
          piuserID = _userID;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 1),
              content: Text(
                'User ID Updated ...',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Signika',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ),
          );
        } else if (value.data == 'UserID Not Available') {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Not available',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(230, 0, 0, 1),
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                content: Text(
                  'This user ID is taken by someone else. Please try another one.',
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
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.center,
                  child: FittedBox(
                    child: Row(
                      children: [
                        Text(
                          'Invalid Character ( ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(230, 0, 0, 1),
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '$invalidSymbol',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          ' )',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(230, 0, 0, 1),
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  'Allowed characters:',
                  style: TextStyle(
                    fontFamily: 'Signika',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 1,
                    color: Color.fromRGBO(36, 14, 123, 1),
                    height: 1.5,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '- Capital Letter (A-Z)\n- Small Letter (a-z)\n- Numbers (0-9)\n- Underscore ( _ )\n- Dot ( . )',
                  style: TextStyle(
                    fontFamily: 'Signika',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    letterSpacing: 1,
                    color: Color.fromRGBO(36, 14, 123, 1),
                    height: 1.5,
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
  }

  Future<void> _updateCategory() async {
    if (_selectedCategory == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Invalid Category Name',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(230, 0, 0, 1),
                letterSpacing: 1.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            content: Text(
              'Please select appropriate category to proceed.',
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
    // var asd = _otherCategory;
    // var isErrorFound = false;
    // if (asd.length > 32 && _selectedCategory == '— Other') {
    //   isErrorFound = true;
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: Text(
    //           'Invalid Length',
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //             color: Color.fromRGBO(230, 0, 0, 1),
    //             letterSpacing: 1.5,
    //             fontWeight: FontWeight.w700,
    //           ),
    //         ),
    //         content: Text(
    //           'Category length should not exceed 32 characters.',
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //             fontFamily: 'Signika',
    //             fontWeight: FontWeight.w600,
    //             fontSize: 16,
    //             letterSpacing: 1,
    //             // color: Color.fromRGBO(36, 14, 123, 1),
    //             height: 1.5,
    //           ),
    //         ),
    //         actions: <Widget>[
    //           Container(
    //             width: double.infinity,
    //             decoration: BoxDecoration(
    //               color: Color.fromRGBO(255, 0, 0, 1),
    //               borderRadius: BorderRadius.circular(5),
    //             ),
    //             // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //             child: TextButton(
    //               child: Text(
    //                 'OK',
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(
    //                   fontFamily: 'Signika',
    //                   fontWeight: FontWeight.w600,
    //                   fontSize: 22,
    //                   letterSpacing: 2,
    //                   color: Color.fromRGBO(255, 255, 255, 1),
    //                 ),
    //               ),
    //               onPressed: () async {
    //                 Navigator.of(context).pop();
    //               },
    //             ),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    //   return;
    // }

    // if (isErrorFound == false) {
    //   for (var i = 0; i < asd.length; i++) {
    //     if ((asd.codeUnitAt(i) >= 48 && asd.codeUnitAt(i) <= 57) || // Number
    //             (asd.codeUnitAt(i) >= 65 && asd.codeUnitAt(i) <= 90) || // A-Z
    //             (asd.codeUnitAt(i) >= 97 && asd.codeUnitAt(i) <= 122) || // a-z
    //             asd.codeUnitAt(i) == 38 || // &
    //             asd.codeUnitAt(i) == 44 || // ,
    //             asd.codeUnitAt(i) == 46 || // .
    //             asd.codeUnitAt(i) == 32 // For space
    //         ) {
    //       continue;
    //     } else {
    //       isErrorFound = true;
    //       break;
    //     }
    //   }
    // }
    // if (isErrorFound == false) {
    setState(() {
      isSavingCategory = true;
    });
    var aboutCategory = FirebaseFunctions.instanceFor(region: 'asia-south1')
        .httpsCallable('about_category');
    // await aboutCategory({
    //   'category': _selectedCategory == '— Other'
    //       ? _otherCategory.trim()
    //       : _selectedCategory.toString().trim()
    await aboutCategory({'category': _selectedCategory.toString().trim()})
        .then((value) {
      print(value.data);
      piCategory = _selectedCategory;
      setState(() {
        isSavingCategory = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            'Category Updated ...',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'Signika',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
        ),
      );
    }).catchError((error) {
      print('Failed to update: $error');
    });
    // } else {
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: Text(
    //           'Invalid Category Name',
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //             color: Color.fromRGBO(230, 0, 0, 1),
    //             letterSpacing: 1.5,
    //             fontWeight: FontWeight.w800,
    //           ),
    //         ),
    //         content: Text(
    //           'Please use only:\n- Capital Letter (A-Z)\n- Small Letter (a-z)\n- Numbers (0-9)\n- Dot ( . )\n- Comma ( , )\n- Ampersand ( & )\n- Space',
    //           style: TextStyle(
    //             fontFamily: 'Signika',
    //             fontWeight: FontWeight.w600,
    //             fontSize: 16,
    //             letterSpacing: 1,
    //             // color: Color.fromRGBO(36, 14, 123, 1),
    //             height: 1.5,
    //           ),
    //         ),
    //         actions: <Widget>[
    //           Container(
    //             width: double.infinity,
    //             decoration: BoxDecoration(
    //               color: Color.fromRGBO(255, 0, 0, 1),
    //               borderRadius: BorderRadius.circular(5),
    //             ),
    //             // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //             child: TextButton(
    //               child: Text(
    //                 'OK',
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(
    //                   fontFamily: 'Signika',
    //                   fontWeight: FontWeight.w600,
    //                   fontSize: 22,
    //                   letterSpacing: 2,
    //                   color: Color.fromRGBO(255, 255, 255, 1),
    //                 ),
    //               ),
    //               onPressed: () async {
    //                 Navigator.of(context).pop();
    //               },
    //             ),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }

  Future<void> _updateAuthenticName() async {
    setState(() {
      isSavingName = true;
    });
    var aboutName = FirebaseFunctions.instanceFor(region: 'asia-south1')
        .httpsCallable('about_name');
    await aboutName({
      'firstName': _firstName.trim(),
      'middleName': _middleName.trim(),
      'lastName': _lastName.trim()
    }).then((value) {
      print(value.data);
      pifirstName = _firstName;
      pimiddleName = _middleName;
      pilastName = _lastName;
      setState(() {
        isSavingName = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            'Name Updated ...',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'Signika',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
        ),
      );
    }).catchError((error) {
      print('Failed to update: $error');
    });
  }

  Future<void> _updateDateOfBirth() async {
    // Below setState done before invoking this funtions.
    // setState(() {
    //   isSavingDOB = true;
    // });
    var aboutdob = FirebaseFunctions.instanceFor(region: 'asia-south1')
        .httpsCallable('about_dob');
    await aboutdob({'dobDD': _dobDD, 'dobMM': _dobMM, 'dobYYYY': _dobYYYY})
        .then((value) {
      print(value.data);
      pidobDD = _dobDD;
      pidobMM = _dobMM;
      pidobYYYY = _dobYYYY;
      setState(() {
        isSavingDOB = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            'DoB Updated ...',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'Signika',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
        ),
      );
    }).catchError((error) {
      print('Failed to update: $error');
    });
  }

  Future<void> _updateBusinessMail() async {
    _businessMail = _businessMail.replaceAll(' ', '');
    setState(() {
      isSavingBM = true;
    });
    var aboutBM = FirebaseFunctions.instanceFor(region: 'asia-south1')
        .httpsCallable('about_businessEmail');
    await aboutBM({
      'businessMail': _businessMail.trim(),
      'showBM': _showBM,
    }).then((value) {
      print(value.data);
      pibusinessMail = _businessMail;
      pishowBM = _showBM;
      setState(() {
        isSavingBM = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            'Business Mail Updated ...',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'Signika',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
        ),
      );
    }).catchError((error) {
      print('Failed to update: $error');
    });
  }

  Future<void> _updateBusinessWhatsApp() async {
    setState(() {
      isSavingBWA = true;
    });
    var aboutBWA = FirebaseFunctions.instanceFor(region: 'asia-south1')
        .httpsCallable('about_wanumber');
    await aboutBWA({
      'WACountryCode': _countryCode,
      'WANumber': _WANumber.trim(),
      'showWAN': _showWAN
    }).then((value) {
      print(value.data);
      picountryCode = _countryCode;
      piWANumber = _WANumber;
      pishowWAN = _showWAN;
      setState(() {
        isSavingBWA = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            'Business WhatsApp Number Updated ...',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'Signika',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
        ),
      );
    }).catchError((error) {
      print('Failed to update: $error');
    });
  }

  // Future<void> _updateTOP() async {
  //   setState(() {
  //     isSavingTOP = true;
  //   });
  //   var abouttop = FirebaseFunctions.instanceFor(region: 'asia-south1')
  //       .httpsCallable('about_topOnlinePresence');
  //   await abouttop({
  //     'topOnlinePresence': [_top1.trim(), _top2.trim(), _top3.trim()]
  //   }).then((value) {
  //     print(value.data);
  //     pitop1 = _top1;
  //     pitop2 = _top2;
  //     pitop3 = _top3;
  //     setState(() {
  //       isSavingTOP = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         duration: Duration(seconds: 1),
  //         content: Text(
  //           'Top Online Presence Updated ...',
  //           textAlign: TextAlign.justify,
  //           style: TextStyle(
  //             fontFamily: 'Signika',
  //             fontSize: 16,
  //             fontWeight: FontWeight.w600,
  //             letterSpacing: 2,
  //           ),
  //         ),
  //       ),
  //     );
  //   }).catchError((error) {
  //     print('Failed to update: $error');
  //   });
  // }

  // ---------------- End - Cloud Funtions -------------------

  // to control expanded of group
  final _expansionState = [
    piuserID == 'Add User ID' ||
            piuserID == '' ||
            aboutInitialExpanderNumber == 1
        ? true
        : false,
    aboutInitialExpanderNumber == 2 ? true : false,
    aboutInitialExpanderNumber == 3 ? true : false,
    aboutInitialExpanderNumber == 4 ? true : false,
    aboutInitialExpanderNumber == 5 ? true : false,
    aboutInitialExpanderNumber == 6 ? true : false,
    aboutInitialExpanderNumber == 7 ? true : false
  ];

  // to cotrol date of birth
  // var d = 0, m = 0, y = 0;

  inputfield(labelText, icon, textStorage) {
    var tempValue;
    switch (textStorage) {
      case 'u':
        tempValue = _userID;
        break;
      case 'f':
        tempValue = _firstName;
        break;
      case 'm':
        tempValue = _middleName;
        break;
      case 'l':
        tempValue = _lastName;
        break;
      case 't1':
        tempValue = _top1;
        break;
      case 't2':
        tempValue = _top2;
        break;
      case 't3':
        tempValue = _top3;
        break;
      case '_businessMail':
        tempValue = _businessMail;
        break;
      case '_WANumber':
        tempValue = _WANumber;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Colors.grey,
        //     blurRadius: 0.25,
        //     offset: Offset(0, 0.5),
        //   ),
        // ],
      ),
      // padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      child: TextFormField(
        initialValue: tempValue,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: icon,
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
        inputFormatters: textStorage == 'u'
            ? [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\.\_]')),
              ]
            : textStorage == '_businessMail'
                ? [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9\.\_\-@]')),
                  ]
                : [],
        onChanged: (value) {
          switch (textStorage) {
            case 'u':
              _userID = value;
              break;
            case 'f':
              _firstName = value;
              break;
            case 'm':
              _middleName = value;
              break;
            case 'l':
              _lastName = value;
              break;
            case 't1':
              _top1 = value;
              break;
            case 't2':
              _top2 = value;
              break;
            case 't3':
              _top3 = value;
              break;
            case '_businessMail':
              _businessMail = value;
              break;
            case '_WANumber':
              _WANumber = value;
              break;
            // case 'oc':
            //   _otherCategory = value;
            //   break;
            default:
              print('Invalid Variable');
          }
        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
      if (privateInfo == null) {
        getPrivateInfo();
      }
      setState(() {});
    }
    return true;
  }

  showLoadingCategoryNotificaiton() {
    Future.delayed(Duration(milliseconds: 100), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Loading category list. Please wait.\nOr, Restart App.',
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
    var _storedPlatfromList = prefs.getStringList('categoryList');
    if (_storedPlatfromList == null) {
      _categoryList = ['Digital Creator'];
      checkForUpdate(context, mounted);
      showLoadingCategoryNotificaiton();
    } else {
      _categoryList.addAll(_storedPlatfromList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).clearSnackBars();
        aboutInitialExpanderNumber = 0;
        widget.pageNumberSelector(accountSettingRedirectNumber);
        return false;
      },
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: [
            AspectRatio(
              aspectRatio: 7 / 2,
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
                                              child: CircularProgressIndicator(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                backgroundColor: Color.fromRGBO(
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateProfile()));
                      },
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            child: Text(
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
                          ),
                          Row(
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
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  for (int i = 0; i < _expansionState.length; i++) {
                    if (index != i) {
                      _expansionState[i] = false;
                    }
                  }
                  _expansionState[index] = !_expansionState[index];
                });
              },
              animationDuration: Duration(
                microseconds: 250,
              ),
              children: [
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              // 'User ID',
                              'Username',
                              style: TextStyle(
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          if (isExpanded)
                            Container(
                              height: 20,
                              width: 65,
                              margin: EdgeInsets.only(left: 15),
                              padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0.025),
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                ),
                              ),
                              child: GestureDetector(
                                child: Text(
                                  '{ Help }',
                                  style: TextStyle(
                                    color: Color.fromRGBO(230, 0, 0, 1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 20),
                                              alignment: Alignment.center,
                                              child: FittedBox(
                                                child: Text(
                                                  'Allowed Characters',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        230, 0, 0, 1),
                                                    letterSpacing: 1.5,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '- Capital Letter (A-Z)\n- Small Letter (a-z)\n- Numbers (0-9)\n- Underscore ( _ )\n- Dot ( . )',
                                              style: TextStyle(
                                                fontFamily: 'Signika',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                letterSpacing: 1,
                                                color: Color.fromRGBO(
                                                    36, 14, 123, 1),
                                                height: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
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
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                      // isThreeLine: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 0,
                      ),
                      iconColor: Colors.amber,
                    );
                  },
                  canTapOnHeader: true,
                  body: Column(
                    children: [
                      inputfield(
                        'User ID',
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          child: Text(
                                            'Allowed Characters',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(230, 0, 0, 1),
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '- Capital Letter (A-Z)\n- Small Letter (a-z)\n- Numbers (0-9)\n- Underscore ( _ )\n- Dot ( . )',
                                        style: TextStyle(
                                          fontFamily: 'Signika',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          letterSpacing: 1,
                                          color: Color.fromRGBO(36, 14, 123, 1),
                                          height: 1.5,
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
                                );
                              },
                            );
                          },
                          child: Icon(
                            Icons.help,
                            size: 24,
                            color: Color.fromRGBO(255, 0, 0, 1),
                          ),
                        ),
                        'u',
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(255, 0, 0, 1)),
                                fixedSize: MaterialStateProperty.all(
                                    Size.fromHeight(45)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.fromLTRB(40, 0, 40, 0)),
                              ),
                              child: isSavingUID
                                  ? CupertinoActivityIndicator(
                                      radius: 14,
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
                              onPressed: () {
                                if (!isSavingUID) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (piuserID.toString() !=
                                      _userID.toString()) {
                                    _updateuserID();
                                  } else if (_userID == '' ||
                                      _userID == 'Add User ID') {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Invalid User ID',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(230, 0, 0, 1),
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          content: Text(
                                            'Please choose appropriate user_ID to proceed.',
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
                                        );
                                      },
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text(
                                          'User ID already updated.',
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontFamily: 'Signika',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  isExpanded: _expansionState[0],
                  backgroundColor: Color.fromRGBO(230, 255, 230, 1),
                ),
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(
                        'Category',
                        style: TextStyle(
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          fontSize: 22,
                        ),
                      ),
                      // isThreeLine: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 0,
                      ),
                      iconColor: Colors.amber,
                    );
                  },
                  canTapOnHeader: true,
                  body: Column(
                    children: [
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
                        margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: DropdownButton<String>(
                          menuMaxHeight:
                              MediaQuery.of(context).size.height * 0.65,
                          value: _selectedCategory,
                          isExpanded: true,
                          dropdownColor: Colors.amber,
                          hint: Text(piCategory == ''
                              ? '  Choose Category'
                              : '  $piCategory'),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Signika',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                          items: _categoryList.map(
                            (String value) {
                              return DropdownMenuItem<String>(
                                alignment: Alignment.center,
                                value: value,
                                child: Container(
                                  width: double.infinity,
                                  height: 44,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    value,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Signika',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                          underline: Container(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                            print(value);
                          },
                        ),
                      ),
                      // _selectedCategory == '— Other'
                      //     ? inputfield(
                      //         'Other Category',
                      //         Icon(
                      //           Icons.perm_identity,
                      //           size: 24,
                      //           color: Color.fromRGBO(255, 0, 0, 1),
                      //         ),
                      //         'oc',
                      //       )
                      //     : Container(),
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(255, 0, 0, 1)),
                                fixedSize: MaterialStateProperty.all(
                                    Size.fromHeight(45)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.fromLTRB(40, 0, 40, 0)),
                              ),
                              child: isSavingCategory
                                  ? CupertinoActivityIndicator(
                                      radius: 14,
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
                              onPressed: () {
                                if (!isSavingCategory) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (_selectedCategory != piCategory) {
                                    _updateCategory();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text(
                                          'Category already updated.',
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontFamily: 'Signika',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  isExpanded: _expansionState[1],
                  backgroundColor: Color.fromRGBO(230, 255, 230, 1),
                ),
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(
                        'Authentic Name',
                        style: TextStyle(
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          fontSize: 22,
                        ),
                      ),
                      // isThreeLine: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 0,
                      ),
                      iconColor: Colors.amber,
                    );
                  },
                  canTapOnHeader: true,
                  body: Column(
                    children: [
                      inputfield(
                          'First Name',
                          Icon(
                            Icons.text_format_rounded,
                            size: 28,
                            color: Color.fromRGBO(255, 0, 0, 1),
                          ),
                          'f'),
                      inputfield(
                          'Middle Name',
                          Icon(
                            Icons.text_format_rounded,
                            size: 28,
                            color: Color.fromRGBO(255, 0, 0, 1),
                          ),
                          'm'),
                      inputfield(
                          'Last Name',
                          Icon(
                            Icons.text_format_rounded,
                            size: 28,
                            color: Color.fromRGBO(255, 0, 0, 1),
                          ),
                          'l'),
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(255, 0, 0, 1)),
                                fixedSize: MaterialStateProperty.all(
                                    Size.fromHeight(45)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.fromLTRB(40, 0, 40, 0)),
                              ),
                              child: isSavingName
                                  ? CupertinoActivityIndicator(
                                      radius: 14,
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
                              onPressed: () {
                                if (!isSavingName) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (_firstName.isNotEmpty &&
                                      (_firstName != pifirstName ||
                                          _middleName != pimiddleName ||
                                          _lastName != pilastName)) {
                                    _updateAuthenticName();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text(
                                          _firstName.isEmpty
                                              ? 'Missing "First Name" ?'
                                              : 'Profile already updated.',
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontFamily: 'Signika',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  isExpanded: _expansionState[2],
                  backgroundColor: Color.fromRGBO(230, 255, 230, 1),
                ),
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(
                        'Date of Birth',
                        style: TextStyle(
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          fontSize: 22,
                        ),
                      ),
                      // isThreeLine: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 0,
                      ),
                      iconColor: Colors.amber,
                    );
                  },
                  canTapOnHeader: true,
                  body: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Column(
                      children: [
                        // DatePickerDialog(
                        //   initialDate: DateTime.now(),
                        //   firstDate: DateTime(01, 01, 1900),
                        //   lastDate: DateTime.now(),
                        //   confirmText: 'OK',
                        //   // initialEntryMode: DatePickerEntryMode.input,
                        //   errorFormatText: 'Invalid Date',
                        //   helpText: 'Date of Birth',
                        //   initialCalendarMode: DatePickerMode.year,
                        // ),
                        // ElevatedButton(
                        //     onPressed: () async {
                        //       showDatePicker(
                        //           context: context,
                        //           initialDate: DateTime.now(),
                        //           firstDate: DateTime(01, 01, 1900),
                        //           lastDate: DateTime.now(),
                        //           confirmText: 'OK',
                        //           // initialEntryMode: DatePickerEntryMode.input,
                        //           errorFormatText: 'Invalid Date',
                        //           helpText: 'Date of Birth',
                        //           errorInvalidText: 'Invalid Text',
                        //           initialDatePickerMode: DatePickerMode.year);
                        //     },
                        //     child: Text(_dobDD)),
                        SizedBox(
                          height: 200,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            initialDateTime: DateTime(int.parse(_dobYYYY),
                                int.parse(_dobMM), int.parse(_dobDD)),
                            maximumDate: DateTime.now(),
                            // dateOrder: DatePickerDateOrder.dmy,
                            onDateTimeChanged: (DateTime newDateTime) {
                              setState(() {
                                _dobDD = newDateTime.day.toString();
                                _dobMM = newDateTime.month.toString();
                                _dobYYYY = newDateTime.year.toString();
                              });
                            },
                            // backgroundColor: Color.fromRGBO(245, 255, 245, 1),
                          ),
                        ),

                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Container(
                        //         decoration: BoxDecoration(
                        //           color: Color.fromRGBO(255, 255, 255, 1),
                        //           borderRadius: BorderRadius.circular(10),
                        //         ),
                        //         // color: Colors.tealAccent,
                        //         margin: EdgeInsets.only(
                        //           top: 10,
                        //           right: 20,
                        //           left: 20,
                        //         ),
                        //         padding: EdgeInsets.symmetric(
                        //           horizontal: 5,
                        //         ),
                        //         child: TextFormField(
                        //           inputFormatters: [
                        //             FilteringTextInputFormatter.digitsOnly,
                        //           ],
                        //           onChanged: (value) {
                        //             _dobDD = int.parse(value);
                        //             print(_dobDD);
                        //           },
                        //           maxLength: 2,
                        //           style: TextStyle(
                        //             fontSize: 32,
                        //             fontFamily: 'Signika',
                        //             fontWeight: FontWeight.w700,
                        //           ),
                        //           textAlign: TextAlign.center,
                        //           cursorColor: Colors.red,
                        //           decoration: InputDecoration(
                        //             contentPadding: EdgeInsets.all(10),
                        //             // labelText: "01",
                        //             // hintText: 'DD',
                        //             // helperText: "Pankj",
                        //             counterText: 'DD',
                        //             counterStyle: TextStyle(
                        //                 fontWeight: FontWeight.w600,
                        //                 color: Color.fromRGBO(255, 0, 0, 1),
                        //                 letterSpacing: 1,
                        //                 fontSize: 20,
                        //                 fontFamily: 'Signika'),
                        //           ),
                        //           keyboardType: TextInputType.number,
                        //         ),
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: Container(
                        //         decoration: BoxDecoration(
                        //           color: Color.fromRGBO(255, 255, 255, 1),
                        //           borderRadius: BorderRadius.circular(10),
                        //         ),
                        //         // color: Colors.tealAccent,
                        //         margin: EdgeInsets.only(
                        //           top: 10,
                        //           right: 25,
                        //           left: 15,
                        //         ),
                        //         padding: EdgeInsets.symmetric(
                        //           horizontal: 5,
                        //         ),
                        //         child: TextFormField(
                        //           inputFormatters: [
                        //             FilteringTextInputFormatter.digitsOnly,
                        //           ],
                        //           onChanged: (value) {
                        //             _dobMM = int.parse(value);
                        //             print(_dobMM);
                        //           },
                        //           maxLength: 2,
                        //           style: TextStyle(
                        //             fontSize: 32,
                        //             fontFamily: 'Signika',
                        //             fontWeight: FontWeight.w700,
                        //           ),
                        //           textAlign: TextAlign.center,
                        //           cursorColor: Colors.red,
                        //           decoration: InputDecoration(
                        //             contentPadding: EdgeInsets.all(10),
                        //             // labelText: "01",
                        //             // hintText: 'MM',
                        //             // helperText: "Pankj",
                        //             counterText: 'MM',
                        //             counterStyle: TextStyle(
                        //               fontWeight: FontWeight.w600,
                        //               color: Color.fromRGBO(255, 0, 0, 1),
                        //               letterSpacing: 1,
                        //               fontSize: 20,
                        //               fontFamily: 'Signika',
                        //             ),
                        //           ),
                        //           keyboardType: TextInputType.number,
                        //         ),
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: Container(
                        //         decoration: BoxDecoration(
                        //           color: Color.fromRGBO(255, 255, 255, 1),
                        //           borderRadius: BorderRadius.circular(10),
                        //         ),
                        //         // color: Colors.tealAccent,
                        //         margin: EdgeInsets.only(
                        //           top: 10,
                        //           right: 20,
                        //           left: 10,
                        //         ),
                        //         padding: EdgeInsets.symmetric(
                        //           horizontal: 5,
                        //         ),
                        //         child: TextFormField(
                        //           inputFormatters: [
                        //             FilteringTextInputFormatter.digitsOnly,
                        //           ],
                        //           onChanged: (value) {
                        //             _dobYYYY = int.parse(value);
                        //             print(_dobYYYY);
                        //           },
                        //           maxLength: 4,
                        //           style: TextStyle(
                        //             fontSize: 32,
                        //             fontFamily: 'Signika',
                        //             fontWeight: FontWeight.w700,
                        //           ),
                        //           textAlign: TextAlign.center,
                        //           cursorColor: Colors.red,
                        //           decoration: InputDecoration(
                        //             contentPadding: EdgeInsets.all(10),
                        //             // labelText: '01',
                        //             counterText: 'YYYY',
                        //             counterStyle: TextStyle(
                        //               fontWeight: FontWeight.w600,
                        //               color: Color.fromRGBO(255, 0, 0, 1),
                        //               letterSpacing: 1,
                        //               fontSize: 20,
                        //               fontFamily: 'Signika',
                        //             ),
                        //           ),
                        //           keyboardType: TextInputType.number,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(0, 40, 0, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromRGBO(255, 0, 0, 1)),
                                  fixedSize: MaterialStateProperty.all(
                                      Size.fromHeight(45)),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.fromLTRB(40, 0, 40, 0)),
                                ),
                                child: isSavingDOB
                                    ? CupertinoActivityIndicator(
                                        radius: 14,
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
                                  if (!isSavingDOB) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(milliseconds: 750),
                                        content: Text(
                                          'Wait ...',
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontFamily: 'Signika',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                    if (_dobDD != pidobDD ||
                                        _dobMM != pidobMM ||
                                        _dobYYYY != pidobYYYY) {
                                      setState(() {
                                        isSavingDOB = true;
                                      });
                                      Future.delayed(Duration(seconds: 1), () {
                                        var tempMaxDate = DateTime.now().day +
                                            DateTime.now().month * 12 +
                                            DateTime.now().year * 365;
                                        var tempSelectedDate =
                                            int.parse(_dobDD) +
                                                int.parse(_dobMM) * 12 +
                                                int.parse(_dobYYYY) * 365;
                                        print('$tempMaxDate$tempSelectedDate');
                                        if (tempMaxDate > tempSelectedDate) {
                                          _updateDateOfBirth();
                                        }
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 1),
                                          content: Text(
                                            'DoB already updated.',
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              fontFamily: 'Signika',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  isExpanded: _expansionState[3],
                  backgroundColor: Color.fromRGBO(230, 255, 230, 1),
                ),
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              'Business Mail',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          if (isExpanded)
                            Container(
                              height: 20,
                              width: 65,
                              margin: EdgeInsets.only(left: 15),
                              padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0.025),
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                ),
                              ),
                              child: GestureDetector(
                                child: FittedBox(
                                  child: Text(
                                    '{ Help }',
                                    style: TextStyle(
                                      color: Color.fromRGBO(230, 0, 0, 1),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 20),
                                              alignment: Alignment.center,
                                              child: FittedBox(
                                                child: Text(
                                                  'Allowed Characters',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        230, 0, 0, 1),
                                                    letterSpacing: 1.5,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '- Capital Letter (A-Z)\n- Small Letter (a-z)\n- Numbers (0-9)\n- Underscore ( _ )\n- Dash ( - )\n- Dot ( . )',
                                              style: TextStyle(
                                                fontFamily: 'Signika',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                letterSpacing: 1,
                                                color: Color.fromRGBO(
                                                    36, 14, 123, 1),
                                                height: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
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
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                      // isThreeLine: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 0,
                      ),
                      iconColor: Colors.amber,
                    );
                  },
                  canTapOnHeader: true,
                  body: Column(
                    children: [
                      inputfield(
                        'Business Email',
                        Icon(
                          Icons.email,
                          size: 24,
                          color: Color.fromRGBO(255, 0, 0, 1),
                        ),
                        '_businessMail',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            activeColor: Color.fromRGBO(35, 15, 123, 1),
                            value: _showBM,
                            onChanged: (value) {
                              setState(() {
                                _showBM = value!;
                              });
                            },
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 65,
                            child: Text(
                              // 'Allow viewer to see your business email.',
                              'Add to dpGram.com',
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: Color.fromRGBO(35, 15, 123, 1),
                                fontSize: 15,
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.75,
                                height: 1.25,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(255, 0, 0, 1)),
                                fixedSize: MaterialStateProperty.all(
                                    Size.fromHeight(45)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.fromLTRB(40, 0, 40, 0)),
                              ),
                              child: isSavingBM
                                  ? CupertinoActivityIndicator(
                                      radius: 14,
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
                              onPressed: () {
                                if (!isSavingBM) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  print(
                                      '*$pibusinessMail* and *$_businessMail*${pibusinessMail == _businessMail}');
                                  if (pibusinessMail.toString() !=
                                          _businessMail.toString() ||
                                      pishowBM != _showBM) {
                                    _updateBusinessMail();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text(
                                          'Business Mail already updated.',
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontFamily: 'Signika',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  isExpanded: _expansionState[4],
                  backgroundColor: Color.fromRGBO(230, 255, 230, 1),
                ),
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(
                        'Business WhatsApp',
                        style: TextStyle(
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          fontSize: 22,
                        ),
                      ),
                      // isThreeLine: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 0,
                      ),
                      iconColor: Colors.amber,
                    );
                  },
                  canTapOnHeader: true,
                  body: Column(
                    children: [
                      // inputfield(
                      //   'WhatsApp Number',
                      //   Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       Container(
                      //         height: 20,
                      //         width: 20,
                      //         margin: EdgeInsets.only(right: 13),
                      //         decoration: BoxDecoration(
                      //           image: DecorationImage(
                      //             image: AssetImage('assets/wa.png'),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      //   _WANumber,
                      // ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                // width: (MediaQuery.of(context).size.width - 45) * 0.3,
                                alignment: Alignment.center,
                                // color: Color.fromRGBO(0, 0, 0, 0.5),
                                margin: EdgeInsets.fromLTRB(15, 0, 7.5, 0),
                                child: GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Color.fromRGBO(90, 90, 90, 1),
                                        width: 1,
                                      ),
                                    ),
                                    height: 58,
                                    width: (MediaQuery.of(context).size.width -
                                            45) *
                                        0.3,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '+ $_countryCode',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontFamily: 'Signika',
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    showCountryPicker(
                                      context: context,
                                      //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                                      // exclude: <String>['KN', 'MF'],
                                      //Optional. Shows phone code before the country name.
                                      showPhoneCode: true,
                                      onSelect: (Country country) async {
                                        print(
                                            'Select country: ${country.displayName}');
                                        _countryCode = country.phoneCode;
                                        setState(() {});
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Container(
                                // width: (MediaQuery.of(context).size.width - 45) * 0.7,
                                height: 58,
                                decoration: BoxDecoration(
                                  // color: Colors.tealAccent,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Color.fromRGBO(90, 90, 90, 1),
                                    width: 1,
                                  ),
                                ),
                                margin: EdgeInsets.fromLTRB(7.5, 0, 15, 0),
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: TextFormField(
                                    initialValue: _WANumber,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'\d')),
                                    ],
                                    onChanged: (value) {
                                      _WANumber = value;
                                      print(_WANumber);
                                    },
                                    // maxLength: 15,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2,
                                    ),
                                    textAlign: TextAlign.left,
                                    cursorColor: Colors.red,
                                    decoration: InputDecoration(
                                      hintText: 'WhatsApp Number',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Signika',
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(0, 0, 0, 0.25),
                                      ),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      // contentPadding: EdgeInsets.fromLTRB(15, 20, 11, 0),
                                      isCollapsed: true,
                                      isDense: false,
                                    ),
                                    keyboardType: TextInputType.number,
                                    // toolbarOptions: ToolbarOptions(
                                    //   copy: true,
                                    //   cut: true,
                                    //   paste: true,
                                    //   selectAll: true,
                                    // ),
                                    cursorWidth: 3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              activeColor: Color.fromRGBO(35, 15, 123, 1),
                              value: _showWAN,
                              onChanged: (value) {
                                setState(() {
                                  _showWAN = value!;
                                });
                              },
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 65,
                              child: Text(
                                // 'Allow viewer to see your BWA Number.',
                                'Add to dpGram.com',
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  color: Color.fromRGBO(35, 15, 123, 1),
                                  fontSize: 15,
                                  fontFamily: 'Signika',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.75,
                                  height: 1.25,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(255, 0, 0, 1)),
                                fixedSize: MaterialStateProperty.all(
                                    Size.fromHeight(45)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.fromLTRB(40, 0, 40, 0)),
                              ),
                              child: isSavingBWA
                                  ? CupertinoActivityIndicator(
                                      radius: 14,
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
                              onPressed: () {
                                if (!isSavingBWA) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (piWANumber != _WANumber ||
                                      picountryCode != _countryCode ||
                                      pishowWAN != _showWAN) {
                                    _updateBusinessWhatsApp();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text(
                                          'Business WhatsApp Number already updated.',
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontFamily: 'Signika',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  isExpanded: _expansionState[5],
                  backgroundColor: Color.fromRGBO(230, 255, 230, 1),
                ),
                // ExpansionPanel(
                //   headerBuilder: (BuildContext context, bool isExpanded) {
                //     return ListTile(
                //       title: Text(
                //         'Top 3 Online Presence',
                //         overflow: TextOverflow.ellipsis,
                //         style: TextStyle(
                //           fontFamily: 'Signika',
                //           fontWeight: FontWeight.w700,
                //           letterSpacing: 1.5,
                //           fontSize: 22,
                //         ),
                //       ),
                //       // isThreeLine: true,
                //       contentPadding: EdgeInsets.symmetric(
                //         horizontal: 15,
                //         vertical: 0,
                //       ),
                //       iconColor: Colors.amber,
                //     );
                //   },
                //   canTapOnHeader: true,
                //   body: Column(
                //     children: [
                //       Container(
                //         width: double.infinity,
                //         margin: EdgeInsets.fromLTRB(20, 0, 20, 30),
                //         // color: Colors.amber,
                //         child: Text(
                //           'Ex - https://instagram.com/nasa\nEx - https://facebook.com/nasa\nEx - https://youtube.com/nasa',
                //           overflow: TextOverflow.ellipsis,
                //           style: TextStyle(
                //             color: Color.fromRGBO(230, 0, 0, 1),
                //             fontSize: 16,
                //             fontFamily: 'Signika',
                //             fontWeight: FontWeight.w500,
                //             letterSpacing: 1.5,
                //             height: 1.5,
                //           ),
                //         ),
                //       ),
                //       inputfield(
                //         'Profile URL - 1',
                //         Icon(
                //           Icons.link_rounded,
                //           size: 28,
                //           color: Color.fromRGBO(255, 0, 0, 1),
                //         ),
                //         't1',
                //       ),
                //       inputfield(
                //         'Profile URL - 2',
                //         Icon(
                //           Icons.link_rounded,
                //           size: 28,
                //           color: Color.fromRGBO(255, 0, 0, 1),
                //         ),
                //         't2',
                //       ),
                //       inputfield(
                //         'Profile URL - 3',
                //         Icon(
                //           Icons.link_rounded,
                //           size: 28,
                //           color: Color.fromRGBO(255, 0, 0, 1),
                //         ),
                //         't3',
                //       ),
                //       Container(
                //         alignment: Alignment.center,
                //         width: double.infinity,
                //         margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             ElevatedButton(
                //               style: ButtonStyle(
                //                 backgroundColor: MaterialStateProperty.all(
                //                     Color.fromRGBO(255, 0, 0, 1)),
                //                 fixedSize: MaterialStateProperty.all(
                //                     Size.fromHeight(45)),
                //                 padding: MaterialStateProperty.all(
                //                     EdgeInsets.fromLTRB(40, 0, 40, 0)),
                //               ),
                //               child: isSavingTOP
                //                   ? CupertinoActivityIndicator(
                //                       radius: 14,
                //                     )
                //                   : Text(
                //                       'Save',
                //                       style: TextStyle(
                //                         fontFamily: 'Signika',
                //                         fontSize: 24,
                //                         fontWeight: FontWeight.w500,
                //                         letterSpacing: 2,
                //                       ),
                //                     ),
                //               onPressed: () {
                //                 if (!isSavingTOP) {
                //                   FocusManager.instance.primaryFocus?.unfocus();
                //                   if (_top1 != pitop1 ||
                //                       _top2 != pitop2 ||
                //                       _top3 != pitop3) {
                //                     _updateTOP();
                //                   } else {
                //                     ScaffoldMessenger.of(context).showSnackBar(
                //                       SnackBar(
                //                         duration: Duration(seconds: 1),
                //                         content: Text(
                //                           'Top Online Presence already updated.',
                //                           style: TextStyle(
                //                             fontFamily: 'Signika',
                //                             fontSize: 16,
                //                             fontWeight: FontWeight.w600,
                //                             letterSpacing: 2,
                //                           ),
                //                         ),
                //                       ),
                //                     );
                //                   }
                //                 }
                //               },
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                //   isExpanded: _expansionState[6],
                //   backgroundColor: Color.fromRGBO(230, 255, 230, 1),
                // ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Container(
                    height: 48,
                    margin: EdgeInsets.fromLTRB(15, 40, 15, 50),
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.35),
                          offset: Offset(0, 1),
                          blurRadius: 1,
                        ),
                      ],
                      border: Border.all(
                        color: Color.fromRGBO(230, 0, 0, 1),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Color.fromRGBO(230, 0, 0, 1),
                          fontSize: 18,
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    widget.pageNumberSelector(1);
                  },
                ),
                GestureDetector(
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.fromLTRB(15, 40, 15, 50),
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(230, 0, 0, 1),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.35),
                          offset: Offset(0, 1),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 18,
                              fontFamily: 'Signika',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    widget.pageNumberSelector(11);
                  },
                ),
              ],
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

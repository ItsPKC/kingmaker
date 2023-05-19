import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kingmaker/content/globalVariable.dart';

class BonusReferralCheck extends StatefulWidget {
  final Function _pageNumberSelector;
  BonusReferralCheck(this._pageNumberSelector, {Key? key}) : super(key: key);

  @override
  State<BonusReferralCheck> createState() => _BonusReferralCheckState();
}

class _BonusReferralCheckState extends State<BonusReferralCheck> {
  var isProcessingCode = false;
  final TextEditingController _controller = TextEditingController();
  Future<String> _checkReferralCode() async {
    print(
        '+++++++++++++++++++++++++++++++++++++++++++++${_controller.text.toString().trim()}');
    var returnMessage = '';
    HttpsCallable checkReferralCode =
        FirebaseFunctions.instanceFor(region: 'asia-south1')
            .httpsCallable('bonusReferralCode');
    await checkReferralCode(
            {'referralCode': _controller.text.toString().trim()})
        .then((value) => {
              returnMessage = value.data,
              print(returnMessage),
              setState(() {
                isProcessingCode = false;
              }),
            })
        .catchError((error) {
      setState(() {
        isProcessingCode = false;
      });
      // print(error);
      // print('Failed to update: $error');
      return error;
    });
    return returnMessage;
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
                          child: Image(
                            image: AssetImage(
                              'assets/dpgram-motto.png',
                            ),
                          ),
                        ),
                        Text(
                          'Enter Your Referral Code',
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            letterSpacing: 2,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
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
                          child: TextFormField(
                            controller: _controller,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'XXXXXXXX',
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.15),
                                letterSpacing: 2,
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
                              letterSpacing: 2,
                              fontSize: 24,
                              decoration: TextDecoration.none,
                            ),
                            onChanged: (value) {},
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
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
                              color: Color.fromRGBO(255, 255, 255, 1),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 1),
                                  blurRadius: 0.5,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  if (_controller.text.length < 5 ||
                                      _controller.text.length > 32) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Invalid Length',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(230, 0, 0, 1),
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          content: Text(
                                            'Referral Code must be 5 to 32 characters long.',
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
                                    return;
                                  }
                                  setState(() {
                                    isProcessingCode = true;
                                  });
                                  var result = await _checkReferralCode();
                                  if (result == 'Creator Account Activated') {
                                    dpGramAccountStatus = true;
                                    await prefs.setBool(
                                        'dpGramAccountStatus', true);
                                    if (!mounted) return;
                                    isCreatorAccountActive = true;
                                    getPrivateInfo();
                                    Navigator.pop(context);
                                    widget._pageNumberSelector(6);
                                  }
                                  if (result ==
                                      'Please update name to continue.') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Name not updated', // imported from AuthService.dart
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(230, 0, 0, 1),
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Signika',
                                              fontSize: 22,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          content: Text(
                                            'Please update name to activate creator account.',
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              fontSize: 18,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          backgroundColor:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          actionsAlignment:
                                              MainAxisAlignment.center,
                                          actions: [
                                            OutlinedButton(
                                              // borderSide: BorderSide(
                                              //   width: 1.5,
                                              //   color: Color.fromRGBO(255, 0, 0, 1),
                                              // ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  Color.fromRGBO(230, 0, 0, 1),
                                                ),
                                              ),
                                              child: Text(
                                                'Update Now',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Signika',
                                                  fontSize: 18,
                                                ),
                                              ),
                                              onPressed: () {
                                                aboutInitialExpanderNumber = 3;
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                                widget._pageNumberSelector(8);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                  if (result == 'Invalid Code' ||
                                      result == 'Code Expired') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            result, // imported from AuthService.dart
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(230, 0, 0, 1),
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Signika',
                                              fontSize: 22,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          content: Text(
                                            result == 'Invalid Code'
                                                ? 'Don\'t use random code(s). It may result in your account being disabled.'
                                                : 'Thanks for showing interest. Hope you get another one very soon.',
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              fontSize: 18,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          backgroundColor:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          actionsAlignment:
                                              MainAxisAlignment.end,
                                          actions: [
                                            OutlinedButton(
                                              // borderSide: BorderSide(
                                              //   width: 1.5,
                                              //   color: Color.fromRGBO(255, 0, 0, 1),
                                              // ),
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
                                          ],
                                        );
                                      },
                                    );
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
                                      isProcessingCode
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    'Sorry, Limited Availability.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(230, 0, 0, 1),
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  content: Text(
                                    'As of now you must have a referral code to join Bonus Program.\n\nKeep your account active and stay tuned. We\'ll increase limit soon.',
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
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 3, 0, 3),
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                              child: Text(
                                'I don\'t have referral code.',
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontFamily: 'Signika',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ),
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

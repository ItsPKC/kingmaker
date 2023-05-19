import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kingmaker/content/globalVariable.dart';

import '../services/AuthService.dart';

class UpdatePaymentDetails extends StatefulWidget {
  final Function pageNumberSelector;
  UpdatePaymentDetails(this.pageNumberSelector, {Key? key}) : super(key: key);

  @override
  _UpdatePaymentDetailsState createState() => _UpdatePaymentDetailsState();
}

class _UpdatePaymentDetailsState extends State<UpdatePaymentDetails> {
  var _addingPayoutSettings = false;
  String? _paymentOption;
  final TextEditingController _controller = TextEditingController();

  var _fullName =
      '$pifirstName${pimiddleName != '' ? ' ' : ''}$pimiddleName${pilastName != '' ? ' ' : ''}$pilastName' !=
              'Add Name'
          ? '$pifirstName${pimiddleName != '' ? ' ' : ''}$pimiddleName${pimiddleName != '' ? ' ' : ''}$pilastName'
          : '';

  var _email = currentUserCredential.email;
  var _waNumber = piWANumber;
  var _paymentID = '';

  _updatePayoutSettings() async {
    var payoutSettings = {
      'fullName': _fullName,
      'email': _email,
      'waNumber': _waNumber,
      'platform': _paymentOption,
      'paymentID': _paymentID,
    };
    print('=======================================');
    print(payoutSettings);

    if (_fullName != '' &&
        _email != '' &&
        _waNumber != '' &&
        _paymentOption != null &&
        _paymentOption != '' &&
        _paymentID != '') {
      if (_addingPayoutSettings == false) {
        setState(() {
          _addingPayoutSettings = true;
        });
        var _cashout = FirebaseFunctions.instanceFor(region: 'asia-south1')
            .httpsCallable('payoutSettings');
        await _cashout(payoutSettings).then((value) {
          setState(() {
            _addingPayoutSettings = false;
          });
          if (value.data == 'Successful') {
            refreshCreatorData();
          }
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(
                value.data == 'Successful'
                    ? 'Saved successfully !'
                    : '${value.data}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(35, 15, 123, 1),
                  fontFamily: 'Signika',
                  fontSize: 18,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontFamily: 'Signika',
                      letterSpacing: 1,
                      color: Color.fromRGBO(230, 0, 0, 1),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).catchError((e) {
          print(e);
          setState(() {
            _addingPayoutSettings = false;
          });
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            'Please provide all data.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(35, 15, 123, 1),
              fontFamily: 'Signika',
              fontSize: 18,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'Signika',
                  letterSpacing: 1,
                  color: Color.fromRGBO(230, 0, 0, 1),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  refreshCreatorData() {
    // It helps to refresh just after getCreatorInfo Invoked
    _refresher() {
      setState(() {
        setInitialData();
      });
      if (isGettingCreatorInfo) {
        Future.delayed(Duration(milliseconds: 100), () {
          _refresher();
        });
      }
    }

    getCreatorInfo();

    _refresher();
  }

  setInitialData() {
    if (creatorInfo != null) {
      if (creatorInfo['paymentMethod'].isNotEmpty) {
        _fullName = creatorInfo['paymentMethod']
            [creatorInfo['paymentMethod'].length - 1]['fullName'];
        _email = creatorInfo['paymentMethod']
            [creatorInfo['paymentMethod'].length - 1]['email'];
        _waNumber = creatorInfo['paymentMethod']
            [creatorInfo['paymentMethod'].length - 1]['waNumber'];
        _paymentID = creatorInfo['paymentMethod']
            [creatorInfo['paymentMethod'].length - 1]['paymentID'];
        _paymentOption = creatorInfo['paymentMethod']
            [creatorInfo['paymentMethod'].length - 1]['platform'];
        _controller.text = _paymentID;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => widget.pageNumberSelector(6),
      child: Container(
        color: Color.fromRGBO(247, 247, 247, 1),
        child: Stack(
          children: [
            ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 0.5,
                        offset: Offset(0, 0.5),
                      ),
                    ],
                  ),
                  // padding: EdgeInsets.all(10),
                  margin: EdgeInsets.fromLTRB(20, 100, 20, 10),
                  child: TextFormField(
                    initialValue: _fullName,
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      suffixIcon: Icon(
                        Icons.person_rounded,
                        size: 30,
                        color: Color.fromRGBO(255, 0, 0, 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
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
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      fontSize: 20,
                    ),
                    onChanged: (value) {
                      _fullName = value;
                    },
                    // onEditingComplete: () =>
                    //     FocusScope.of(context).nextFocus(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 0.5,
                        offset: Offset(0, 0.5),
                      ),
                    ],
                  ),
                  // padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    initialValue: _email,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      suffixIcon: Icon(
                        Icons.email,
                        size: 24,
                        color: Color.fromRGBO(255, 0, 0, 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
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
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      fontSize: 20,
                    ),
                    onChanged: (value) {
                      _email = value;
                    },
                    // onEditingComplete: () =>
                    //     FocusScope.of(context).nextFocus(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 0.5,
                        offset: Offset(0, 0.5),
                      ),
                    ],
                  ),
                  // padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    initialValue: _waNumber,
                    decoration: InputDecoration(
                      hintText: 'WhatsApp Number',
                      // suffixIcon: Icon(
                      //   Icons.phone_rounded,
                      //   size: 24,
                      //   color: Color.fromRGBO(255, 0, 0, 1),
                      // ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            margin: EdgeInsets.only(right: 13),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/wa.png'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
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
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      fontSize: 20,
                    ),
                    onChanged: (value) {
                      _waNumber = value;
                    },
                    // onEditingComplete: () =>
                    //     FocusScope.of(context).nextFocus(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 0.5,
                        offset: Offset(0, 0.5),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: DropdownButton<String>(
                    value: _paymentOption,
                    isExpanded: true,
                    dropdownColor: Color.fromRGBO(230, 255, 230, 1),
                    hint: Text('  Platform'),
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Signika',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                    items:
                        <String>['Paytm', 'PayPal', 'PhonePe', 'GooglePay'].map(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            padding: EdgeInsets.only(left: 13),
                            child: Text(
                              value,
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
                    // selectedItemBuilder: (BuildContext context) {
                    //   return <String>['Paytm', 'PhonePe', 'GooglePay']
                    //       .map<Widget>((String item) {
                    //     return Text(item);
                    //   }).toList();
                    // },
                    onChanged: (value) {
                      setState(() {
                        if (_paymentOption != value) {
                          _paymentID = '';
                          _controller.text = '';
                          _paymentOption = value;
                        }
                      });
                    },
                  ),
                  // child: DropdownButtonFormField(
                  //   value: 3,
                  //   items: [
                  //     DropdownMenuItem(
                  //       enabled: true,
                  //       child: Text('Pankaj'),
                  //       value: 1,
                  //       onTap: () {},
                  //     ),
                  //     DropdownMenuItem(
                  //       enabled: true,
                  //       child: Text('Pankaj'),
                  //       onTap: () {},
                  //       value: 2,
                  //     ),
                  //   ],
                  // ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 0.5,
                        offset: Offset(0, 0.5),
                      ),
                    ],
                  ),
                  // padding: EdgeInsets.all(10),
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 30),
                  child: TextFormField(
                    controller: _controller,
                    // initialValue: _paymentID,
                    decoration: InputDecoration(
                      hintText: _paymentOption == 'Paytm' ||
                              _paymentOption == 'PhonePe' ||
                              _paymentOption == 'GooglePay'
                          ? 'UPI ID'
                          : _paymentOption == 'PayPal'
                              ? 'PayPal ID'
                              : 'Payment ID',
                      suffixIcon: Icon(
                        Icons.link_rounded,
                        size: 28,
                        color: Color.fromRGBO(255, 0, 0, 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
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
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      fontSize: 20,
                    ),
                    onChanged: (value) {
                      _paymentID = value;
                    },
                    // onEditingComplete: () =>
                    //     FocusScope.of(context).nextFocus(),
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(right: 20),
                //   alignment: Alignment.centerRight,
                //   child: OutlinedButton(
                //     style: ButtonStyle(
                //       backgroundColor:
                //           MaterialStateProperty.all(Color.fromRGBO(255, 0, 0, 1)),
                //       fixedSize: MaterialStateProperty.all(Size.fromHeight(45)),
                //       padding: MaterialStateProperty.all(
                //         EdgeInsets.fromLTRB(40, 8, 40, 8),
                //       ),
                //     ),
                //     onPressed: () {},
                //     child: Text(
                //       'Save',
                //       style: TextStyle(
                //         color: Color.fromRGBO(255, 255, 255, 1),
                //         fontFamily: 'Signika',
                //         fontWeight: FontWeight.w600,
                //         letterSpacing: 2,
                //         fontSize: 22,
                //       ),
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    if (_addingPayoutSettings == false) {
                      _updatePayoutSettings();
                    }
                  },
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 40),
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
                    child: Center(
                      child: _addingPayoutSettings || isGettingCreatorInfo
                          ? CupertinoActivityIndicator()
                          : Text(
                              'Save Payout Details',
                              style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 18,
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 20, 50),
                  child: Text(
                    'Note : We only use public identity for payments, i.e, UPI ID, PayPal ID.\n\nWe never ask for any sensitive details like OTP, ATM PIN, UPI PIN, Card details, Bank details, etc. Never disclose such details and be safe.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: 'Signika',
                      letterSpacing: 0.5,
                      color: Color.fromRGBO(35, 15, 123, 1),
                    ),
                  ),
                )
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
                      widget.pageNumberSelector(6);
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
                      child: Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Payout Settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Signika',
                        fontSize: 22,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(230, 0, 0, 1),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 15),
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 56,
                      child: Icon(
                        Icons.settings,
                        size: 34,
                        color: Color.fromRGBO(35, 15, 123, 1),
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

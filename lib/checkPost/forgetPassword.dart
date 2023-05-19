import 'package:flutter/material.dart';

import '../services/AuthService.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => ForgetPasswordState();
}

class ForgetPasswordState extends State<ForgetPassword> {
  var email, password;
  var progressIndicatorValue = false;

  _signUpActionButton() async {
    setState(() {
      progressIndicatorValue = true;
    });
    await AuthService().resetPassword(email).then((value) {
      print('_________________________________________');
      print(value);
      if (value == null) {
        setState(() {
          progressIndicatorValue = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                authStatusHeading, // imported from AuthService.dart
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(230, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Signika',
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
              content: Text(
                authStatusMessage, // imported from AuthService.dart
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Signika',
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
              backgroundColor: Color.fromRGBO(255, 255, 255, 1),
              actions: [
                OutlinedButton(
                  // borderSide: BorderSide(
                  //   width: 1.5,
                  //   color: Color.fromRGBO(255, 0, 0, 1),
                  // ),
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
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Password Reset Link\nSent Successfuly', // imported from AuthService.dart
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(255, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Signika',
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
              content: Text(
                'Please check your register email and reset your password.', // imported from AuthService.dart
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Signika',
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
              backgroundColor: Color.fromRGBO(255, 255, 255, 1),
              actions: [
                OutlinedButton(
                  // borderSide: BorderSide(
                  //   width: 1.5,
                  //   color: Color.fromRGBO(255, 0, 0, 1),
                  // ),
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
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (progressIndicatorValue)
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_reset_rounded,
                      size: 120,
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Text(
                        'Don\'t Worry !\nEnter your email address linked to your account.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          fontFamily: 'Signika',
                          // fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 2,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            blurRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      // padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'eMail Address',
                          suffixIcon: Icon(
                            Icons.mail_rounded,
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
                            left: 20,
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
                          email = value;
                        },
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.height * 0.25,
                        margin: EdgeInsets.fromLTRB(0, 40, 0, 60),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Color.fromRGBO(255, 255, 255, 1),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 24,
                            // fontFamily: 'Signika',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.25,
                            color: Color.fromRGBO(255, 0, 0, 1),
                          ),
                        ),
                      ),
                      onTap: () {
                        _signUpActionButton();
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

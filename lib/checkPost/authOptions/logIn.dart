import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kingmaker/checkPost/forgetPassword.dart';
import 'package:kingmaker/services/AuthService.dart';

class LogIn extends StatefulWidget {
  final pageNumberSelector;
  LogIn(this.pageNumberSelector, {Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  var email, password;
  var progressIndicatorValue = false;
  _logInButtonAction() async {
    if (email == '' || password == '' || email == null || password == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Invalid Input', // imported from AuthService.dart
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
              'Please add correct\nEmail and Password', // imported from AuthService.dart
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Signika',
                fontSize: 18,
                letterSpacing: 1,
                height: 1.5,
              ),
            ),
            backgroundColor: Color.fromRGBO(255, 255, 255, 1),
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              OutlinedButton(
                child: Text(
                  'Retry',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 0, 0, 1),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Signika',
                    fontSize: 18,
                    letterSpacing: 1.5,
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
      return;
    }
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      print(email);
      print(password);
      setState(() {
        progressIndicatorValue = true;
      });
      print(
          '##################################################### $email $password');
      var _result = await AuthService()
          .logInWithEmailandPassword(email.trim(), password.trim());
      print('#####################################################');
      print(_result);
      if (_result == null) {
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
              actionsAlignment: authStatusHeading != 'User Not Found'
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.spaceBetween,
              actions: [
                OutlinedButton(
                  // borderSide: BorderSide(
                  //   width: 1.5,
                  //   color: Color.fromRGBO(255, 0, 0, 1),
                  // ),
                  child: Text(
                    'Retry',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 0, 0, 1),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Signika',
                      letterSpacing: 1.5,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                if (authStatusHeading == 'User Not Found')
                  OutlinedButton(
                    // borderSide: BorderSide(
                    //   width: 1.5,
                    //   color: Color.fromRGBO(255, 0, 0, 1),
                    // ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(230, 0, 0, 1),
                      ),
                    ),
                    child: Text(
                      'Sign Up Now',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Signika',
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.pageNumberSelector(2);
                    },
                  ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text('GECA'),
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
              GestureDetector(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 0, 0, 1),
                    border: Border.all(
                      color: Color.fromRGBO(255, 0, 0, 1),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
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
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.pageNumberSelector(5);
        return false;
      },
      child: (progressIndicatorValue)
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(255, 255, 255, 1)),
              ),
            )
          : Scaffold(
              // resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Form(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.15,
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Email Field
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
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9\.\_\-@]')),
                            ],
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
                              email = value.trim();
                            },
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                          ),
                        ),

                        // Password Field
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
                          margin: EdgeInsets.only(
                            top: 20,
                            right: 20,
                            left: 20,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Password',
                              suffixIcon: Icon(
                                Icons.lock_rounded,
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
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 17,
                                horizontal: 20,
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            style: TextStyle(
                              fontFamily: 'Signika',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.5,
                              fontSize: 20,
                            ),
                            onChanged: (value) {
                              password = value.trim();
                            },
                            onFieldSubmitted: (_) => _logInButtonAction(),
                          ),
                        ),

                        // LogIn Button
                        GestureDetector(
                          onTap: _logInButtonAction,
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.height * 0.25,
                            margin: EdgeInsets.fromLTRB(0, 50, 0, 60),
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
                              'Login',
                              style: TextStyle(
                                color: Color.fromRGBO(230, 0, 0, 1),
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              color: Colors.black,
                              height: 1.5,
                              width:
                                  MediaQuery.of(context).size.width * 0.5 - 45,
                              margin: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(2),
                              width: 50,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Text(
                                'OR',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Signika',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.black,
                              height: 1.5,
                              width:
                                  MediaQuery.of(context).size.width * 0.5 - 45,
                              margin: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 20,
                          ),
                          child: TextButton(
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(40),
                            // ),
                            child: Text(
                              'Forget Password ?',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontFamily: 'Signika',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                                shadows: const [
                                  BoxShadow(
                                    color: Colors.brown,
                                    spreadRadius: 10,
                                    blurRadius: 10,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () async {
                              // showDialog(
                              //     context: context,
                              //     builder: (context) {
                              //       return AlertDialog(
                              //         content: Text(
                              //           'Unstable network connection, retry after some time.',
                              //           textAlign: TextAlign.center,
                              //           style: TextStyle(
                              //             fontWeight: FontWeight.w400,
                              //             letterSpacing: 1.5,
                              //             height: 1.25,
                              //           ),
                              //         ),
                              //       );
                              //     });
                              showDialog(
                                  context: context,
                                  builder: (context) => ForgetPassword());
                            },
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
}

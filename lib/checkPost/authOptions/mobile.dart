import 'package:flutter/material.dart';

class Mobile extends StatefulWidget {
  @override
  _MobileState createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  var email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Form(
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
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.75),
                      blurRadius: 10,
                      spreadRadius: 1,
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
                    hintText: 'Mobile Number',
                    suffixIcon: Icon(
                      Icons.mail_rounded,
                      size: 28,
                      color: Color.fromRGBO(0, 0, 255, 1),
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
                  keyboardType: TextInputType.number,
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

              // Password Field
              Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.75),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                margin: EdgeInsets.only(
                  top: 20,
                  right: 20,
                  bottom: 50,
                  left: 20,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: Icon(
                      Icons.lock_rounded,
                      size: 28,
                      color: Color.fromRGBO(0, 0, 255, 1),
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
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    fontSize: 20,
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ),
              // SignUp Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Color.fromRGBO(255, 255, 255, 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: Offset(10, 0),
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: Offset(-10, 0),
                    ),
                  ],
                ),
                child: OutlinedButton(
                  // padding: EdgeInsets.fromLTRB(40, 12, 40, 12),
                  // color: Color.fromRGBO(255, 255, 255, 1),
                  // splashColor: Colors.white,
                  // highlightColor: Colors.white,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(40),
                  // ),
                  child: Text(
                    'SignUp',
                    style: TextStyle(
                      fontSize: 24,
                      // fontFamily: 'Signika',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.25,
                      color: Color.fromRGBO(255, 0, 0, 1),
                    ),
                  ),
                  onPressed: () {
                    print(email);
                    print(password);
                    // AuthService(email, password).signInAnon();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

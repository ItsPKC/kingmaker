import 'package:flutter/material.dart';
import 'package:kingmaker/checkPost/myAppAuthOptions.dart';
import 'authOptions/emailAndPass.dart';
import 'authOptions/logIn.dart';
import 'authOptions/mobile.dart';

class AuthCenter extends StatefulWidget {
  @override
  _AuthCenterState createState() => _AuthCenterState();
}

class _AuthCenterState extends State<AuthCenter> {
  var pageNumber = 5;

  // var pageList = [
  //   LogIn(pageNumberSelector),
  //   EmailAndPass(),
  //   Mobile(),
  //   // EmailAndPass(),
  //   Mobile(),
  // ];

  pageNumberSelector(asd) {
    setState(() {
      pageNumber = asd;
    });
  }

  pageList(pn) {
    switch (pn) {
      case 1:
        return LogIn(pageNumberSelector);
      case 2:
        return EmailAndPass(pageNumberSelector);
      case 3:
        return Mobile();
      case 4:
        return Mobile();
      case 5:
        return MyAppAuthOptions(pageNumberSelector);
    }
  }

  var imageList = [
    'assets/LeatherTexture/L103.jpg',
    'assets/LeatherTexture/L103.jpg',
    // 'assets/GeneralTexture/image23.jpg',
    // 'assets/GeneralTexture/image19.jpg',
    // 'assets/GeneralTexture/image2.jpg',
    // 'assets/GeneralTexture/image23.jpg',
    'assets/GeneralTexture/image221.jpeg',
    'assets/GeneralTexture/image1.jpg',
    'assets/LeatherTexture/L103.jpg',
    // 'assets/GeneralTexture/image111.jpg',
  ];

  // Future<UserCredential> _onLoginButtonPressedEvent() async {
  //   print('------------ 01');
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn(signInOption: SignInOption.standard,).signIn();
  //
  //   print('------------ 02');
  //   print(googleUser);
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;
  //
  //   print('------------ 03');
  //   print(googleAuth);
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   print('------------ 04');
  //   print(credential);
  //
  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: WillPopScope(
          onWillPop: () => pageNumberSelector(5),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imageList[pageNumber - 1]),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                pageList(pageNumber),
                // (pageNumber == 1)
                //     ? Container(
                //         height: MediaQuery.of(context).size.height,
                //         margin: EdgeInsets.only(bottom: 20),
                //         alignment: Alignment.bottomCenter,
                //         width: double.infinity,
                //         // decoration: BoxDecoration(
                //         //   gradient: SweepGradient(
                //         //     colors: [
                //         //       Colors.red,
                //         //       Colors.blue,
                //         //       Colors.tealAccent,
                //         //     ],
                //         //     stops: [0.25, 0.6, 0.8],
                //         //   ),
                //         // ),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             OutlinedButton(
                //               // shape: RoundedRectangleBorder(
                //               //   borderRadius: BorderRadius.circular(40),
                //               // ),
                //               // color: Color.fromRGBO(255, 255, 255, 1),
                //               // elevation: 5,
                //               style: ButtonStyle(
                //                 backgroundColor: MaterialStateProperty.all(
                //                   Color.fromRGBO(50, 50, 50, 0.5),
                //                 ),
                //               ),
                //               child: Text(
                //                 'Create New Account',
                //                 style: TextStyle(
                //                   color: Color.fromRGBO(255, 255, 255, 1),
                //                   fontSize: 15,
                //                   fontFamily: 'Signika',
                //                   fontWeight: FontWeight.w400,
                //                   letterSpacing: 1.25,
                //                 ),
                //               ),
                //               onPressed: () {
                //                 setState(() {
                //                   pageNumber = 2;
                //                 });
                //                 // AuthService().logInWithGmail();
                //               },
                //             ),
                //             Container(
                //               margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                //               height: 36,
                //               width: 36,
                //               // padding: EdgeInsets.all(15),
                //               alignment: Alignment.center,
                //               decoration: BoxDecoration(
                //                 color: Color.fromRGBO(50, 50, 50, 0.5),
                //                 borderRadius: BorderRadius.circular(4),
                //                 border: Border.all(
                //                   color: Color.fromRGBO(0, 0, 0, 0.1),
                //                 ),
                //               ),
                //               child: InkWell(
                //                 onTap: () {
                //                   needHelp(context,
                //                       'mailto:help@dpgram.com?subject=Login issue : I need help');
                //                 },
                //                 child: Icon(
                //                   Icons.help_center,
                //                   size: 34,
                //                   color: Color.fromRGBO(255, 255, 255, 0.5),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       )
                //     : Container(
                //         alignment: Alignment.bottomCenter,
                //         width: double.infinity,
                //         height: MediaQuery.of(context).size.height,
                //         child: Row(
                //           // crossAxisAlignment: CrossAxisAlignment.baseline,
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             // (pageNumber != 4)
                //             //     ? Button41(() => pageNumberSelector(4))
                //             //     : Button42(),
                //             // (pageNumber != 3)
                //             //     ? Button31(() => pageNumberSelector(3))
                //             //     : Button32(),
                //             // (pageNumber != 2)
                //             //     ? Button21(() => pageNumberSelector(2))
                //             //     : Button22(),
                //             // (pageNumber != 1)
                //             //     ? Button11(() => pageNumberSelector(1))
                //             //     : Button12(),
                //             Container(
                //               margin: EdgeInsets.only(bottom: 20),
                //               child: OutlinedButton(
                //                 style: ButtonStyle(
                //                   backgroundColor: MaterialStateProperty.all(
                //                     Color.fromRGBO(50, 50, 50, 0.5),
                //                   ),
                //                 ),
                //                 onPressed: () {
                //                   pageNumberSelector(1);
                //                 },
                //                 child: Text(
                //                   'Go to Login !',
                //                   style: TextStyle(
                //                     color: Color.fromRGBO(255, 255, 255, 1),
                //                     fontSize: 15,
                //                     fontFamily: 'Signika',
                //                     fontWeight: FontWeight.w400,
                //                     letterSpacing: 1.25,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //             Container(
                //               margin: EdgeInsets.fromLTRB(15, 0, 0, 20),
                //               height: 36,
                //               width: 36,
                //               // padding: EdgeInsets.all(15),
                //               alignment: Alignment.center,
                //               decoration: BoxDecoration(
                //                 color: Color.fromRGBO(50, 50, 50, 0.5),
                //                 borderRadius: BorderRadius.circular(4),
                //                 border: Border.all(
                //                   color: Color.fromRGBO(0, 0, 0, 0.1),
                //                 ),
                //               ),
                //               child: InkWell(
                //                 onTap: () {
                //                   needHelp(context,
                //                       'mailto:help@dpgram.com?subject=Signup issue :  I need help');
                //                 },
                //                 child: Icon(
                //                   Icons.help_center,
                //                   size: 34,
                //                   color: Color.fromRGBO(255, 255, 255, 0.5),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

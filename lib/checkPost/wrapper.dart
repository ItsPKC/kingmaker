import 'package:flutter/material.dart';
import 'package:kingmaker/checkPost/emailVerify.dart';
import 'package:kingmaker/content/globalVariable.dart';
import 'package:kingmaker/navigation/myHome.dart';
import 'package:provider/provider.dart';
import '../services/myUser.dart';
import 'authCenter.dart';

class Wrapper extends StatefulWidget {
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    var userValidatorState;
    userValidatorState = Provider.of<MyUser>(context);
    print(userValidatorState);
    print('.............');
    print(userValidatorState.uid);

    if (userValidatorState.uid == null) {
      print('Please LogIn/ SignUp');
    } else {
      myAuthUID = userValidatorState.uid; // In Gobal Variable
    }

    forceSetState() {
      setState(() {
        emailVerfied;
      });
    }

    // return (userValidatorState.uid != null)
    // changes to '==' to bypass login screen while development
    return (userValidatorState.uid != null)
        // ? MyHome()
        ? emailVerfied
            ? MyHome()
            : EmailVerify(forceSetState)
        : AuthCenter();
  }
}

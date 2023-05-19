import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kingmaker/content/globalVariable.dart';

import 'myUser.dart';

var authStatusMessage = '';
var authStatusHeading = '';
var currentUserCredential;

class AuthService {
  var email, pass;

  // AuthService(this.email, this.pass);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _userFromFireBaseUser(user) {
    return (user != null) ? MyUser(uid: user.uid) : null;
  }

  manageEmailVerificationStatus(user) async {
    emailVerfied = user!.emailVerified;
    await prefs.setBool('emailVerfied', user!.emailVerified);
  }

  Stream<MyUser> get userValidator {
    return _auth.authStateChanges().map((user) {
      print(user);
      if (user != null) {
        manageEmailVerificationStatus(user);
      }
      currentUserCredential = user;
      return _userFromFireBaseUser(user);
    });
    // .map((user) => _userFromFireBaseUser(user)) can be also be written as
    // .map(_userFromFireBaseUser)
  }

  // To SignIN Anonymously
  // Future signInAnon() async {
  //   try {
  //     var result = await _auth.signInAnonymously();
  //     print(result.user!.uid);
  //     return _userFromFireBaseUser(result.user);
  //   } catch (e) {
  //     print('Not Signed Yet');
  //     return null;
  //   }
  // }

  Future<void> setUserDataTemplate() async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'asia-south1')
            .httpsCallable('userDataTemplate');
    await callable().then(
      (value) => getPrivateInfo(),
    );
  }

  // SignUp/Register with Email and Password
  Future registerWithEmailandPassword(email, pass) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      setUserDataTemplate();
      emailVerfied = result.user!.emailVerified;
      await prefs.setBool('emailVerfied', result.user!.emailVerified);
      await result.user!.sendEmailVerification();
      return _userFromFireBaseUser(result.user);
    } on FirebaseAuthException catch (e) {
      print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
      print(e);
      var _status = AuthExceptionHandler.handleAuthException(e);
      authStatusMessage = AuthExceptionHandler.generateErrorMessage(_status);
    }
    //  catch (e) {
    //   print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
    //   print(e);
    // }
  }

  Future logInWithEmailandPassword(email, pass) async {
    try {
      print('#####################################################1');
      final result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      print('#####################################################2');
      print(result);

      return _userFromFireBaseUser(result.user);
    } on FirebaseAuthException catch (e) {
      print('#####################################################3');
      print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
      print(e.code);
      var _status = AuthExceptionHandler.handleAuthException(e);
      authStatusMessage = AuthExceptionHandler.generateErrorMessage(_status);
    } catch (e) {
      print('#####################################################4');
      print(e.toString());
    }
  }

  Future logInWithGmail() async {
    // Future<void> logInWithGmail() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signIn().catchError((error) {
        print('#####################################################0');
        // print(error);
        return error;
      });

      print('#####################################################1');
      if (googleUser == null) {
        return 'Canceled';
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential

      print('#####################################################1');
      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print('#####################################################2');
      print(result);

      return _userFromFireBaseUser(result.user);
    } on FirebaseAuthException catch (e) {
      print('#####################################################3');
      print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
      print(e.code);
      var _status = AuthExceptionHandler.handleAuthException(e);
      authStatusMessage = AuthExceptionHandler.generateErrorMessage(_status);
    } catch (e) {
      print('#####################################################4');
      print(e.toString());
    }
  }

  // SignOut
  Future signOut() async {
    try {
      print('You are Signed Out');
      await _auth.signOut();
      await GoogleSignIn().signOut();
      await eraseCurrentUserDataToLogout();
    } catch (e) {
      print(e.toString());
      print('Error!');
      return null;
    }
  }

  // Reset Password
  Future resetPassword(resetValue) async {
    try {
      await _auth.sendPasswordResetEmail(email: resetValue);
      return 'Great ----------';
    } on FirebaseAuthException catch (e) {
      print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
      print(e.code);
      var _status = AuthExceptionHandler.handleAuthException(e);
      authStatusMessage = AuthExceptionHandler.generateErrorMessage(_status);
    }
  }

  Future resendVerificationMail() async {
    try {
      await currentUserCredential.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  Future reloadAuthenticationToken() async {
    var dataToPass;
    try {
      print('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');
      print(_auth.currentUser);
      await _auth.currentUser!.reload();
      print('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');
      dataToPass = _auth.currentUser;
      print(dataToPass);
    } catch (e) {
      print(e.toString());
    }
    return dataToPass;
  }
}

// Additional Classes

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  usernotfound,
  userdisabled,
  unknown,
}

class AuthExceptionHandler {
  static handleAuthException(FirebaseAuthException e) {
    AuthStatus status;
    switch (e.code) {
      case 'invalid-email':
        status = AuthStatus.invalidEmail;
        break;
      case 'wrong-password':
        status = AuthStatus.wrongPassword;
        break;
      case 'weak-password':
        status = AuthStatus.weakPassword;
        break;
      case 'email-already-in-use':
        status = AuthStatus.emailAlreadyExists;
        break;
      case 'user-not-found':
        status = AuthStatus.usernotfound;
        break;
      case 'user-disabled':
        status = AuthStatus.userdisabled;
        break;
      default:
        status = AuthStatus.unknown;
    }
    return status;
  }

  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case AuthStatus.invalidEmail:
        authStatusHeading = 'Invalid Email';
        errorMessage = 'Your email address appears to be malformed.';
        break;
      case AuthStatus.weakPassword:
        authStatusHeading = 'Weak Password';
        errorMessage = 'Your password should be at least 6 characters.';
        break;
      case AuthStatus.wrongPassword:
        authStatusHeading = 'Wrong Password';
        errorMessage = 'Your password is incorrect.';
        break;
      case AuthStatus.emailAlreadyExists:
        authStatusHeading = 'Email Already Exists';
        errorMessage =
            'The email address is already in use by another account.';
        break;
      case AuthStatus.usernotfound:
        authStatusHeading = 'User Not Found';
        errorMessage =
            'There is no user record corresponding to this email address.';
        break;
      case AuthStatus.userdisabled:
        authStatusHeading = 'Account Disabled';
        errorMessage = 'Your account has been disabled.';
        break;
      default:
        authStatusHeading = 'Unknown Error Found';
        errorMessage = 'An error occured. Please try again later.';
    }
    return errorMessage;
  }
}

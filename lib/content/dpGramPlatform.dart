import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:kingmaker/content/dpGramEditPlatform.dart';
import 'package:kingmaker/content/globalVariable.dart';
import 'package:url_launcher/url_launcher.dart';

class DpGramPlatform extends StatefulWidget {
  final Function _pageNumberSelector, _refresh;
  const DpGramPlatform(this._pageNumberSelector, this._refresh, {Key? key})
      : super(key: key);

  @override
  State<DpGramPlatform> createState() => _DpGramPlatformState();
}

class _DpGramPlatformState extends State<DpGramPlatform> {
  var tempSignList = [];
  var isRemovingData = false;
  var platformInQueueToRemove = '';

  Future<void> _removePlatform(referenceID) async {
    if (isRemovingData == true) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            'Please Wait ...',
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
      return;
    }
    if (mounted) {
      setState(() {
        isRemovingData = true;
        platformInQueueToRemove = referenceID;
      });
    }
    var aboutUID = FirebaseFunctions.instanceFor(region: 'asia-south1')
        .httpsCallable('removeActivePlatform');
    await aboutUID({'removeActivePlatformName': referenceID}).then((value) {
      if (mounted) {
        setState(() {
          isRemovingData = false;
        });
      }
      if (value.data == 'Successful') {
        platformPriority.remove(referenceID);

        if (mounted) {
          setState(() {
            platformPriority;
          });
        }
        // piusername = _username;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              '${piPlatform[referenceID]['platform']} Removed ...',
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
      if (mounted) {
        setState(() {
          isRemovingData = false;
        });
      }
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
    return;
  }

  @override
  void initState() {
    super.initState();
    tempSignList = platformPriority;
  }

  myTile(element, index) {
    return GestureDetector(
      key: Key('$index'),
      onTap: () {
        var _usernameToDisplay = '';
        var _urlToDisplay = '';
        var platformDetails = '';
        if (piPlatform[element] != null) {
          if (piPlatform[element]['username'] != '' &&
              piPlatform[element]['url'] != '') {
            // platformDetails =
            // '${piPlatform[element]['username']}\n\n${piPlatform[element]['url']}';
            _usernameToDisplay = piPlatform[element]['username'];
            _urlToDisplay = piPlatform[element]['url'];
          } else {
            platformDetails = 'Data not available at the moment.';
          }
        } else {
          platformDetails = 'Data not available at the moment.';
        }

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(6),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(255, 255, 255, 1),
                        border: Border.all(
                          color: Color.fromRGBO(0, 0, 0, 0.2),
                          width: 0.5,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            offset: Offset(0, 0),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: getPlatformImageLink(
                                  '${piPlatform[element]['platform']}') !=
                              ''
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: SizedBox(
                                height: 36,
                                width: 36,
                                child: Image(
                                  image: AssetImage(
                                    getPlatformImageLink(
                                        '${piPlatform[element]['platform']}'),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 36,
                              width: 36,
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
                                '${piPlatform[element]['platform'][0]}',
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
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Container(
                        height: 25,
                        margin: EdgeInsets.only(right: 6),
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          child: SelectableText(
                            '${piPlatform[element]['platform']}',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Color.fromRGBO(36, 14, 123, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Signika',
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (platformDetails != '')
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 15),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(6, 0, 6, 0),
                          padding: EdgeInsets.all(6),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(230, 0, 0, 0.035),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: SelectableText(
                            platformDetails,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontFamily: 'Signika',
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (platformDetails == '')
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 15),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(6, 0, 6, 6),
                          padding: EdgeInsets.all(6),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(230, 0, 0, 0.035),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            _usernameToDisplay,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontFamily: 'Signika',
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              height: 1.35,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTapUp: (_) async {
                            try {
                              if (!(piuserID == '' ||
                                  piuserID == 'Add User ID' ||
                                  pifirstName == '' ||
                                  pifirstName == 'Add Name')) {
                                try {
                                  if (await canLaunchUrl(Uri.parse(
                                      'https://dpgram.com/$piuserID'))) {
                                    await launchUrl(
                                      Uri.parse('https://dpgram.com/$piuserID'),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else {
                                    print('Can\'t lauch now !!!');
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Please add "User ID" and "Name" to access your account.', // imported from AuthService.dart
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color.fromRGBO(230, 0, 0, 1),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Signika',
                                          fontSize: 18,
                                          letterSpacing: 1,
                                          height: 1.25,
                                        ),
                                      ),
                                      backgroundColor:
                                          Color.fromRGBO(255, 255, 255, 1),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      actions: [
                                        OutlinedButton(
                                          child: Text(
                                            'Close',
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(255, 0, 0, 1),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              fontSize: 18,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        OutlinedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Color.fromRGBO(230, 0, 0, 1),
                                            ),
                                          ),
                                          child: Text(
                                            'Update now',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              fontSize: 18,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            widget._pageNumberSelector(8);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(6, 0, 6, 0),
                            padding: EdgeInsets.all(6),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(230, 0, 0, 0.035),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              _urlToDisplay,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontFamily: 'Signika',
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            actionsPadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.all(0),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              Padding(
                padding: EdgeInsets.only(left: 6),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(36, 14, 123, 1),
                    ),
                  ),
                  child: Icon(Icons.close),
                  // child: Text(
                  //   'OK',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w500,
                  //     letterSpacing: 3,
                  //     fontSize: 17,
                  //   ),
                  // ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 6),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(36, 14, 123, 1),
                    ),
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => Scaffold(
                        body: SafeArea(
                          child: DpGramEditPlatForm(
                            element.toString(),
                            widget._refresh,
                          ), // element = refereanceID
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 1, 15, 1),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getPlatformImageLink('${piPlatform[element]['platform']}') != ''
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Image(
                        image: AssetImage(
                          getPlatformImageLink(
                              '${piPlatform[element]['platform']}'),
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 50,
                    width: 50,
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
                      '${piPlatform[element]['platform'][0]}',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Signika',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
            SizedBox(width: 20),
            Expanded(
              child: Container(
                height: 50,
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${piPlatform[element]['username']}',
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color.fromRGBO(230, 0, 0, 1),
                        fontFamily: 'Signika',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      '${piPlatform[element]['platform']}',
                      textAlign: TextAlign.justify,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.7),
                        fontFamily: 'Signika',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      contentPadding: EdgeInsets.all(0),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(244, 245, 255, 1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.all(6),
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    border: Border.all(
                                      color: Color.fromRGBO(0, 0, 0, 0.2),
                                      width: 0.5,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.2),
                                        offset: Offset(0, 0),
                                        blurRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: getPlatformImageLink(
                                              '${piPlatform[element]['platform']}') !=
                                          ''
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: SizedBox(
                                            height: 36,
                                            width: 36,
                                            child: Image(
                                              image: AssetImage(
                                                getPlatformImageLink(
                                                    '${piPlatform[element]['platform']}'),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 36,
                                          width: 36,
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
                                            '${piPlatform[element]['platform'][0]}',
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              fontFamily: 'Signika',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 25,
                                    margin: EdgeInsets.only(right: 6),
                                    alignment: Alignment.centerLeft,
                                    child: FittedBox(
                                      child: SelectableText(
                                        '${piPlatform[element]['platform']}',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          color: Color.fromRGBO(36, 14, 123, 1),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Signika',
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          'Remove ${piPlatform[element]['platform']} ?',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color.fromRGBO(230, 0, 0, 1),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Are you sure to remove ${piPlatform[element]['platform']} from Profile Book & dpGram.com\n',
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    36, 14, 123, 1),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                height: 1.35,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actionsPadding: EdgeInsets.all(0),
                                        contentPadding:
                                            EdgeInsets.fromLTRB(15, 25, 15, 25),
                                        actionsAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        actions: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 6),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  Color.fromRGBO(255, 0, 0, 1),
                                                ),
                                              ),
                                              child: Text(
                                                'No',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 1,
                                                  fontSize: 17,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: 8),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  Color.fromRGBO(255, 0, 0, 1),
                                                ),
                                              ),
                                              // child: Icon(Icons.done_rounded),
                                              child: Text(
                                                'Yes',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 1,
                                                  fontSize: 17,
                                                ),
                                              ),
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                await _removePlatform(element);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.delete_forever_rounded,
                                          size: 34,
                                          color: Color.fromRGBO(230, 0, 0, 1),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Color.fromRGBO(230, 0, 0, 1),
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (context) => Scaffold(
                                        body: SafeArea(
                                          child: DpGramEditPlatForm(
                                            element.toString(),
                                            widget._refresh,
                                          ), // element = refereanceID
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 27,
                                          width: 27,
                                          margin: EdgeInsets.only(
                                              bottom: 4, top: 4),
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(36, 14, 123, 1),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: Icon(
                                            Icons.edit_rounded,
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            size: 17,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Edit',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(36, 14, 123, 1),
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Clipboard.setData(
                                      ClipboardData(
                                          text:
                                              '${piPlatform[element]['url']}'),
                                    );
                                  },
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    // padding: EdgeInsets.only(top: 2),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.copy,
                                          size: 30,
                                          color: Color.fromRGBO(0, 165, 65, 1),
                                        ),
                                        SizedBox(
                                          height: 14,
                                        ),
                                        Text(
                                          'Copy link',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(0, 165, 65, 1),
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: isRemovingData && (element == platformInQueueToRemove)
                      ? CupertinoActivityIndicator()
                      : Icon(
                          Icons.more_vert_rounded,
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...tempSignList.mapIndexed(
          (index, element) => myTile(element, index),
        ),
        if (tempSignList.isEmpty)
          Container(
            key: Key('IfEmpty'),
            margin: EdgeInsets.only(top: 80),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  key: Key('iflenghtiszeroMessage'),
                  margin: EdgeInsets.only(bottom: 30),
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    'List your all links and online profiles at a single place.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(100, 100, 100, 1),
                      fontSize: 16,
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      height: 2,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.15),
                        blurRadius: 1.5,
                        offset: Offset(0, 0.5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () {
                          widget._pageNumberSelector(12);
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(12, 8, 15, 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.add_rounded,
                                size: 20,
                                color: Color.fromRGBO(230, 0, 35, 1),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0.75),
                                child: Text(
                                  'Connect link',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color.fromRGBO(230, 0, 35, 1),
                                    fontSize: 16,
                                    fontFamily: 'Signika',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

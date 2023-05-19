import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:kingmaker/content/globalVariable.dart';

class DpGramPlatformPriority extends StatefulWidget {
  final Function _pageNumberSelector;
  const DpGramPlatformPriority(this._pageNumberSelector, {Key? key})
      : super(key: key);

  @override
  State<DpGramPlatformPriority> createState() => _DpGramPlatformPriorityState();
}

class _DpGramPlatformPriorityState extends State<DpGramPlatformPriority> {
  var tempSignList = [];
  var isRemovingData = false;
  var platformInQueueToRemove = '';

  var isUpdatingPlatformPriority = false;
  Future<void> _managePlatformPriority() async {
    setState(() {
      isUpdatingPlatformPriority = true;
    });
    var managePlatformPriority =
        FirebaseFunctions.instanceFor(region: 'asia-south1')
            .httpsCallable('managePlatformPriority');
    await managePlatformPriority({'platformPriority': platformPriority})
        .then((value) {
      setState(
        () {
          isUpdatingPlatformPriority = false;
          platformPriorityChangeDetected = false;
        },
      );
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            'Platform Priority Updated ...',
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
      setState(() {
        isUpdatingPlatformPriority = false;
      });
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

  myTile(element, index) {
    return GestureDetector(
      key: Key('$index'),
      onTap: () {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 3000),
            content: Text(
              'Long press to hightlight then drag UP/DOWN to change the order of Platform(s).',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: 'Signika',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                height: 1.5,
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: index != 0
            ? EdgeInsets.fromLTRB(15, 0, 15, 0)
            : EdgeInsets.fromLTRB(15, 10, 15, 0),
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
              child: InkWell(
                borderRadius: BorderRadius.circular(5),
                // highlightColor: Colors.amber,
                child: Container(
                  height: 40,
                  width: 50,
                  decoration: BoxDecoration(
                    // color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    Icons.touch_app_rounded,
                    color: Color.fromRGBO(230, 0, 0, 1),
                  ),
                ),
                onTap: () {
                  // if (index != (widget.signList.length - 1)) {
                  //   Future.delayed(Duration(milliseconds: 150), () {
                  //     var temp = widget.signList[index + 1];
                  //     // Don't use only signList, because
                  //     // our mottom to edit main signList
                  //     widget.signList[index + 1] = widget.signList[index];
                  //     widget.signList[index] = temp;
                  //     combinedForceSetState();
                  //   });
                  // }
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(milliseconds: 1500),
                      content: Text(
                        'Long press to hightlight then drag UP/DOWN to change the order of Platform(s).',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: 'Signika',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          height: 1.5,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    tempSignList = platformPriority;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget._pageNumberSelector(11);
        return false;
      },
      child: Column(
        children: [
          Container(
            height: 55,
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 0.5),
                  blurRadius: 0.5,
                )
              ],
              // gradient: LinearGradient(
              //   colors: const [
              //     Color.fromRGBO(0, 0, 0, 0.8),
              //     Color.fromRGBO(0, 0, 0, 1)
              //   ],
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              // ),
              gradient: LinearGradient(
                colors: const [
                  Colors.blue,
                  Color.fromRGBO(175, 6, 175, 1),
                  Color.fromRGBO(255, 60, 0, 1),
                  Colors.orange,
                  Color.fromRGBO(255, 102, 0, 1)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      child: Text(
                        'Re-ORDER PROFILE BOOK',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 16,
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Material(
                  color: platformPriorityChangeDetected
                      ? Color.fromRGBO(1, 31, 40, 1)
                      : Color.fromRGBO(1, 31, 40, 0.05),
                  borderRadius: BorderRadius.circular(5),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: platformPriorityChangeDetected
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(255, 255, 255, 0.25),
                          width: platformPriorityChangeDetected ? 0.5 : 1,
                        ),
                      ),
                      child: isUpdatingPlatformPriority
                          ? CupertinoActivityIndicator(
                              color: Color.fromRGBO(255, 255, 255, 1),
                            )
                          : Text(
                              platformPriorityChangeDetected ? 'Save' : 'Saved',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 16,
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2,
                              ),
                            ),
                    ),
                    onTap: () async {
                      await _managePlatformPriority();
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              proxyDecorator: (child, index, animation) => Container(
                color: Colors.amber,
                child: child,
              ),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  var temp = tempSignList[oldIndex];
                  if (newIndex < oldIndex) {
                    // To avoid slip
                    tempSignList.removeAt(oldIndex);
                    tempSignList.insert(newIndex, temp);
                  } else {
                    tempSignList.insert(newIndex, temp);
                    tempSignList.removeAt(oldIndex);
                  }
                  platformPriority = tempSignList;
                });
                platformPriorityChangeDetected = true;
              },
              children: [
                ...tempSignList.mapIndexed(
                  (index, element) => myTile(element, index),
                ),
                if (tempSignList.isEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 100),
                    key: Key('IfEmpty'),
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
                            'You can change the order of your links but you have not added any links.\n\nStart listing now!',
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
                                            color:
                                                Color.fromRGBO(230, 0, 35, 1),
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
            ),
          ),
        ],
      ),
    );
  }
}

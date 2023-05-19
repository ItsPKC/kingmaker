import 'dart:math';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:kingmaker/content/previewSoundController.dart';
import 'package:kingmaker/content/soundTile.dart';

import 'globalVariable.dart';

class FavouriteCollection extends StatefulWidget {
  final Function _pageNumberSelector;
  const FavouriteCollection(this._pageNumberSelector, {Key? key})
      : super(key: key);

  @override
  _FavouriteCollectionState createState() => _FavouriteCollectionState();
}

class _FavouriteCollectionState extends State<FavouriteCollection> {
  final ScrollController _scrollController = ScrollController();
  var changingFavouriteCollectionList = false;
  var _isSoundOn = false;
  var _activeSoundIndex = -1;
  var keyVal = '';
  var _isLoadingData = false;

  setActiveSoundIndex(val) {
    setState(() {
      keyVal = '${Random().nextDouble()}';
      _activeSoundIndex = val;
    });
  }

  setIsSoundOn(wantToKill) {
    setState(() {
      if (wantToKill) {
        _isSoundOn = false;
      } else {
        _isSoundOn = true;
      }
    });
  }

  Future getFavouriteItems(_tempSoundID) async {
    var _data;
    // If data will delivered then it will send or "Error will send."
    try {
      // Using document Path

      // await firestore.doc(docReference).get().then((doc) {
      //   if (doc.exists) {
      //     _data = doc;
      //   } else {
      //     print('-----Not Exist');
      //     _data = 'Error';
      //   }

      // Using soundID
      await firestore
          .collection('sound')
          .where('soundID', isEqualTo: _tempSoundID)
          .get()
          .then((qs) {
        var doc = qs.docs[0];
        if (doc.exists) {
          _data = doc;
        } else {
          print('-----Not Exist');
          _data = 'Error';
        }
        // print('__________________________________');
        // print(qs.docs[0]);
      }).onError((error, stackTrace) {
        print('-----Not Internet');
        print(error.toString());
        _data = 'Error';
      });
    } catch (e) {
      print('-----Not Exist');
      print(e);
      _data = 'Error';
    }
    return _data;
  }

  Future _refreshLocalGallery() async {
    setState(() {
      _isLoadingData = true;
    });
    print('Refreshing...');
    if (await getPrivateInfo()) {
      setState(() {
        favouriteCollectionData;
        _isLoadingData = false;
      });
    } else {
      setState(() {
        _isLoadingData = false;
      });
    }
  }

  Future<void> manageRemoveNotFoundFromFavourite(soundID) async {
    setState(() {
      changingFavouriteCollectionList = true;
    });
    print('___________________________________');
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'asia-south1')
            .httpsCallable('fr');
    var results = await callable(<String, dynamic>{'docRef': soundID});
    print('__________________________________${results.data}');
    if (results.data == 'Removed') {
      setState(() {
        favouriteCollectionData.remove(soundID);
      });
    }
    setState(() {
      changingFavouriteCollectionList = false;
    });
  }

  refresher100() {
    print('.....Refresher');
    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {});
      }
      if (privateInfo == null) {
        refresher100();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      print(_scrollController.position.maxScrollExtent);
      print(_scrollController.offset);
      // Write Pagination Code for 1250 Offset-Max Gap
    });
    if (privateInfo == null) {
      refresher100();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (privateInfo == null) {
      return RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Container(
          padding: EdgeInsets.all(15),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                isGettingPrivateInfo
                    ? 'Please wait, fetching details.'
                    : 'Failed to fetch data',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Signika',
                  fontSize: 18,
                  letterSpacing: 1.5,
                  height: 2,
                  // fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              isGettingPrivateInfo
                  ? CupertinoActivityIndicator(
                      radius: 20,
                    )
                  : OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Color.fromRGBO(230, 0, 0, 1),
                        ),
                      ),
                      onPressed: () async {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult != ConnectivityResult.none) {
                          if (!isGettingPrivateInfo) {
                            getPrivateInfo();
                            setState(() {});
                          } else {
                            setState(() {});
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
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
                                    Container(
                                      height: 100,
                                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Icon(
                                        Icons.network_check,
                                        size: 48,
                                        color: Color.fromRGBO(36, 14, 123, 1),
                                      ),
                                    ),
                                  ],
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
                                        'Close',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Signika',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                          letterSpacing: 2,
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
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
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Text(
                          'Refresh',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(230, 0, 0, 1),
                            fontFamily: 'Signika',
                            fontSize: 16,
                            // fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      );
    }
    return WillPopScope(
      onWillPop: () => widget._pageNumberSelector(1),
      child: RefreshIndicator(
        onRefresh: _refreshLocalGallery,
        child: Container(
          color: Color.fromRGBO(247, 247, 247, 1),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),

                      // Below bracket is necessary to highlight those comolex variable as list.

                      ...(favouriteCollectionData).mapIndexed((index, element) {
                        // In this case data is collected from different point
                        return FutureBuilder(
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              if (snapshot.data == 'Error') {
                                return Container(
                                  height: 120,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0, 0.5),
                                        blurRadius: 0.25,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.centerRight,
                                    children: [
                                      Center(
                                        child: Text(
                                          'Not Found !!!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color.fromRGBO(230, 0, 0, 1),
                                            fontFamily: 'Signika',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            margin: EdgeInsets.only(right: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              shape: BoxShape.circle,
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(0, 0.5),
                                                  blurRadius: 1,
                                                )
                                              ],
                                            ),
                                            child:
                                                changingFavouriteCollectionList
                                                    ? CupertinoActivityIndicator(
                                                        radius: 16,
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .delete_forever_rounded,
                                                        color: Color.fromRGBO(
                                                            255, 0, 0, 1),
                                                        size: 30,
                                                      ),
                                          ),
                                          onTap: () {
                                            manageRemoveNotFoundFromFavourite(
                                                element);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return SoundTile(
                                  _activeSoundIndex,
                                  (index + 1),
                                  setActiveSoundIndex,
                                  setIsSoundOn,
                                  snapshot.data);
                            }
                            return Container(
                              height: 120,
                              width: double.infinity,
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 0.5),
                                    blurRadius: 0.25,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: CupertinoActivityIndicator(
                                radius: 12.5,
                              ),
                            );
                          },
                          future: getFavouriteItems(element),
                        );
                      }),
                      (favouriteCollectionData.isEmpty)
                          ? Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Icon(
                                    Icons.favorite_rounded,
                                    size: 150,
                                    color: Color.fromRGBO(255, 0, 0, 1),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    'You have not added any audio to your favorites list.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Signika',
                                      fontSize: 16,
                                      letterSpacing: 1.5,
                                      height: 2,
                                      // fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  _isLoadingData
                                      ? CupertinoActivityIndicator(radius: 20)
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(
                                                  color: Color.fromRGBO(
                                                      230, 0, 0, 1),
                                                ),
                                              ),
                                              onPressed: () {
                                                // Code For reload
                                                _refreshLocalGallery();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 8, 0, 8),
                                                // child: Text(
                                                //   'Refresh',
                                                //   textAlign: TextAlign.center,
                                                //   style: TextStyle(
                                                //     color: Color.fromRGBO(
                                                //         230, 0, 0, 1),
                                                //     fontFamily: 'Signika',
                                                //     fontSize: 16,
                                                //     // fontWeight: FontWeight.w600,
                                                //     letterSpacing: 2,
                                                //   ),
                                                // ),
                                                child: Icon(
                                                  Icons.replay_outlined,
                                                  color: Color.fromRGBO(
                                                      230, 0, 0, 1),
                                                ),
                                              ),
                                            ),
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(
                                                  color: Color.fromRGBO(
                                                      230, 0, 0, 1),
                                                ),
                                              ),
                                              onPressed: () {
                                                widget._pageNumberSelector(14);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 8, 0, 8),
                                                // child: Text(
                                                //   'Back',
                                                //   textAlign: TextAlign.center,
                                                //   style: TextStyle(
                                                //     color: Color.fromRGBO(
                                                //         230, 0, 0, 1),
                                                //     fontFamily: 'Signika',
                                                //     fontSize: 16,
                                                //     // fontWeight: FontWeight.w600,
                                                //     letterSpacing: 2,
                                                //   ),
                                                // ),
                                                child: Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Color.fromRGBO(
                                                      230, 0, 0, 1),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              Visibility(
                key: Key(keyVal),
                visible: _isSoundOn,
                child: PreviewSoundController(
                    soundSource, // Taken from global variable
                    setIsSoundOn,
                    setActiveSoundIndex,
                    _activeSoundIndex),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

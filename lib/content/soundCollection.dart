import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kingmaker/content/globalVariable.dart';
import 'package:kingmaker/content/previewSoundController.dart';
import 'package:kingmaker/content/soundTile.dart';
import 'package:collection/collection.dart';

import '../services/googleAds.dart';

class SoundCollection extends StatefulWidget {
  final Function _pageNumberSelector;
  const SoundCollection(this._pageNumberSelector, {Key? key}) : super(key: key);

  @override
  _SoundCollectionState createState() => _SoundCollectionState();
}

class _SoundCollectionState extends State<SoundCollection> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<int> _previewSoundControllernotifier = ValueNotifier(0);
  List<ValueNotifier<bool>> listOfSoundTileNotifier = [];
  var _isSoundOn = false;
  var _activeSoundIndex = -1;
  var keyVal = '';

  setActiveSoundIndex(val) {
    // setState(() {
    keyVal = '${Random().nextDouble()}';
    _activeSoundIndex = val;
    _previewSoundControllernotifier.value = _activeSoundIndex;
    // Add Notifier to manage state of sound tile and optimise
    listOfSoundTileNotifier.forEachIndexed((index, element) {
      if (index == _activeSoundIndex - 1) {
        if (element.value == false) {
          element.value = true;
        }
      } else {
        if (element.value == true) {
          element.value = false;
        }
      }
    });
    // });
  }

  setIsSoundOn(wantToKill) {
    // setState(() {
    if (wantToKill) {
      _isSoundOn = false;
    } else {
      _isSoundOn = true;
    }
    // });
  }

  final _data = [];
  var _isLoadingData = false;
  var _isContentAvailable = true;
  var lastDocument;

  getData() {
    // soundType Stored in globalVariable.dart
    if ((_isLoadingData == false) && (_isContentAvailable == true)) {
      setState(() {
        // Stop next round loading
        _isLoadingData = true;
      });
      print(
          '#######################################################Si - $_isLoadingData');

      try {
        firestore
            .collection('sound')
            // .doc(currentSoundType)
            // .collection(currentSoundType)
            .where('category', isEqualTo: currentSoundType)
            .orderBy('soundID',
                descending: currentSoundType == 'Global' ? false : true)
            .limit(20)
            .get()
            .then((QuerySnapshot qs) {
          print('----------------------------------------${qs.docs.length}');
          print(qs);

          if (qs.docs.isNotEmpty) {
            _data.addAll(qs.docs);

            for (var element in qs.docs) {
              print(element.data());
              // Add Notifier to manage state and optimise
              listOfSoundTileNotifier.add(ValueNotifier(false));
            }

            if (qs.docs.isNotEmpty) {
              lastDocument = qs.docs.last;
            }

            print('----------------------------------------${qs.docs.length}');

            print(qs.docs.length);
          }

          // To stop data request if more info is not available
          if (qs.docs.length < 20) {
            _isContentAvailable = false;
          }

          setState(() {
            // Allow next round loading
            _isLoadingData = false;
          });

          print(
              '#######################################################Si - $_isLoadingData');
        });
      } catch (e) {
        print(
            '#######################################################Si - Error');
        print(e);
        setState(() {
          // Allow next round loading
          _isLoadingData = false;
        });
      }
    }
  }

  getMoreData() async {
    // soundType Stored in globalVariable.dart
    if ((_isLoadingData == false) && (_isContentAvailable == true)) {
      setState(() {
        // Stop next round loading
        _isLoadingData = true;
      });

      print(
          '#######################################################Sr - $_isLoadingData');

      try {
        firestore
            .collection('sound')
            // .doc(currentSoundType)
            // .collection(currentSoundType)
            .where('category', isEqualTo: currentSoundType)
            .orderBy('soundID',
                descending: currentSoundType == 'Global' ? false : true)
            .startAfterDocument(lastDocument)
            .limit(20)
            .get()
            .then(
          (QuerySnapshot qs) {
            print(qs);

            if (qs.docs.isNotEmpty) {
              _data.addAll(qs.docs);

              for (var element in qs.docs) {
                print(element.data());
                // Add Notifier to manage state of sound tile and optimise
                listOfSoundTileNotifier.add(ValueNotifier(false));
              }
              lastDocument = qs.docs.last;

              print(qs.docs.length);
            }

            // To stop data request if more info is not available
            if (qs.docs.length < 20) {
              _isContentAvailable = false;
            }

            setState(() {
              // Allow next round loading
              _isLoadingData = false;
            });
            print(
                '#######################################################Sr - $_isLoadingData');
          },
        );
      } catch (e) {
        print(
            '#######################################################Sr - Error');
        print(e);
        setState(() {
          // Allow next round loading
          _isLoadingData = false;
        });
      }
    }
  }

  Future _refreshLocalGallery() async {
    // If _refreshLocalGallery call while data is loading for the first time then it may
    // Replicate same data twice.
    setState(() {
      _isLoadingData = false;
    });
    if (_data.isEmpty) {
      getData();
    } else {
      getMoreData();
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    // _previewSoundControllernotifier.dispose();
    _scrollController.addListener(() {
      // print(_scrollController.position.maxScrollExtent);
      // print(_scrollController.offset);
      // Write Pagination Code for 1250 Offset-Max Gap
      if (_scrollController.position.maxScrollExtent -
              _scrollController.offset <
          1250) {
        // Load more data
        getMoreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => widget._pageNumberSelector(14),
      child: RefreshIndicator(
        onRefresh: _refreshLocalGallery,
        child: Container(
          color: Color.fromRGBO(247, 247, 247, 1),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  child: Column(
                    children: [
                      isAdsAvailableB1
                          ? Container(
                              height: 90,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 0.5),
                                    blurRadius: 0.25,
                                  ),
                                ],
                              ),
                              child: AdWidget(
                                ad: banner1!,
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 20,
                      ),
                      ..._data.mapIndexed(
                        (index, element) {
                          print(
                              '#####################################################3');
                          print(element.data());
                          print(element.data()['soundSource']);
                          return ValueListenableBuilder(
                            valueListenable: listOfSoundTileNotifier[index],
                            builder: (context, value, child) {
                              return SoundTile(
                                  _activeSoundIndex,
                                  (index + 1),
                                  setActiveSoundIndex,
                                  setIsSoundOn,
                                  element.data());
                            },
                          );
                        },
                      ),
                      Visibility(
                        visible: _isLoadingData,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                          width: double.infinity,
                          height: 200,
                          // color: Colors.amber,
                          child: CupertinoActivityIndicator(
                            radius: 20,
                            color: Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _data.isEmpty && _isContentAvailable == false,
                        child: Container(
                          height: 150,
                          alignment: Alignment.center,
                          child: Text(
                            '***  No Data Available  ***',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !_isContentAvailable &&
                            _data.isNotEmpty, // When all is over
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                          width: double.infinity,
                          alignment: Alignment.center,
                          height: 150,
                          // color: Colors.amber,
                          child: Text(
                            '***  You\'re all caught up.  ***',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: _previewSoundControllernotifier,
                  builder: (context, val, child) {
                    return Visibility(
                      key: Key(keyVal),
                      visible: _isSoundOn,
                      child: PreviewSoundController(
                          soundSource, // Taken from global variable
                          setIsSoundOn,
                          setActiveSoundIndex,
                          _activeSoundIndex),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}

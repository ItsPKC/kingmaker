import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kingmaker/content/globalVariable.dart';
// import 'package:kingmaker/content/webViewHome.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../services/googleAds.dart';

class PreviewSound extends StatefulWidget {
  final data;
  PreviewSound(this.data, {Key? key}) : super(key: key);

  @override
  _PreviewSoundState createState() => _PreviewSoundState();
}

class _PreviewSoundState extends State<PreviewSound> {
// Ads
  // final _mrecsAdsUnitId = Platform.isAndroid ? '' : '';
  var showdescription = false;
  var changingFavouriteCollectionList = false;
  var isSoundSourceAvailable = false;
  var localSoundSource = '';
  getTrendingCountry(countryCode) {
    var nameIndex = countryDetails.lastIndexWhere(
        (element) => element.contains(countryCode.toUpperCase()));
    var flag = countryCode.toUpperCase().replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) =>
              String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
        );
    // return '$flag    ${countryCode.toUpperCase()}    ${countryDetails[nameIndex][0]}';
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
      child: Row(
        children: [
          SelectableText(
            flag,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'Signika',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          Container(
            width: 40,
            // color: Colors.amber,
            margin: EdgeInsets.fromLTRB(20, 0, 12, 0),
            child: SelectableText(
              countryCode.toUpperCase(),
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: 'Signika',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
          Expanded(
            child: Text(
              countryDetails[nameIndex][0],
              textAlign: TextAlign.justify,
              softWrap: true,
              style: TextStyle(
                fontFamily: 'Signika',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  topPerformance(hightlightVal) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.amber,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 0.5),
                blurRadius: 1,
              )
            ],
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: CircleAvatar(
              minRadius: 20,
              maxRadius: 40,
              backgroundColor: Color.fromRGBO(255, 255, 255, 1),
              child: Stack(
                // mainAxisAlignment: MainAxisAlignment.center,
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.play_arrow_rounded,
                    color: (widget.data['topPerformingContentLink'].length >=
                            int.parse(hightlightVal))
                        ? Color.fromRGBO(0, 0, 0, 1)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                    size: 72,
                  ),
                  Text(
                    hightlightVal,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: 14,
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          print('-------------------------------------');
          print(widget.data['topPerformingContentLink']);
          if (widget.data['topPerformingContentLink'].length >=
              int.parse(hightlightVal)) {
            // It cousing suspecious activity error
            // showDialog(
            //   context: context,
            //   builder: (context) => WebViewHome(
            //       widget.data['topPerformingContentLink']
            //           [int.parse(hightlightVal) - 1]),
            // );
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => WebViewHome(
            //             widget.data['topPerformingContentLink']
            //                 [int.parse(hightlightVal) - 1])));
            _makeRequest(Uri.parse(widget.data['topPerformingContentLink']
                [int.parse(hightlightVal) - 1]));
          }
        },
      ),
    );
  }

  // Future<void> _makeRequest2(url) async {
  //   try {
  //     if (await canLaunchUrl(url)) {
  //       await launchUrl(url, mode: LaunchMode.inAppWebView);
  //     } else {
  //       print('Can\'t lauch now !!!');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Start :Open link in instagram --------------------------------
  Future<void> _makeRequest(url) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        print(url);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
        } else {
          print('Can\'t lauch now !!!');
        }
      } catch (e) {
        print(e);
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
  // End : Open link in instagram ---------------------------------

  // Start of Sound Control ------------------------------------------------------------

  // final AudioPlayer _player = AudioPlayer();
  // var soundMaxDuration = 0.0;
  // var currentPosition = 0.0;
  // var playerState = PlayerState.STOPPED;

  // setSoundUrl() async {
  //   await _player
  //       .setUrl('http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1xtra_mf_p');
  //   await _player.setReleaseMode(ReleaseMode.STOP);
  // }

  // play() async {
  //   int result = await _player.play(
  //       // 'https://sf16-ies-music-va.tiktokcdn.com/obj/musically-maliva-obj/7063427040543771398.mp3'
  //       // 'https://luan.xyz/files/audio/ambient_c_motion.mp3',
  //       'http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1xtra_mf_p');
  //   if (result == 1) {
  //     print('Started Playing');
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   setSoundUrl();
  //   _player.onDurationChanged.listen((Duration d) {
  //     print('Max duration: $d');
  //     setState(() => soundMaxDuration = d.inSeconds.toDouble());
  //   });
  //   _player.onAudioPositionChanged.listen(
  //     (Duration p) {
  //       setState(() {
  //         if (p.inSeconds >= currentPosition + 0.1 ||
  //             soundMaxDuration - p.inSeconds <= 1 ||
  //             currentPosition == soundMaxDuration) {
  //           print('Current position: $p');
  //           currentPosition = p.inSeconds.toDouble();
  //         }
  //       });
  //     },
  //   );
  //   _player.onPlayerStateChanged.listen(
  //     (PlayerState s) {
  //       print('Current player state: $s');
  //       setState(() => playerState = s);
  //     },
  //   );
  //   _player.onPlayerError.listen((msg) {
  //     print('audioPlayer error : $msg');
  //     setState(() {
  //       playerState = PlayerState.STOPPED;
  //       soundMaxDuration = 0;
  //       currentPosition = 0;
  //     });
  //   });
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _player.dispose();
  // }

  AudioPlayer _player = AudioPlayer();
  var _currentPosition = 0.0;
  var _bufferedPosition = 0.0;
  var _isErrorFound = false;
  // var _maxDuration = 0.0;
  // var _proccessingState = ProcessingState.idle;

  _getSoundSource() async {
    // --------------------- For Firebase Storage  ------------------

    // try {
    //   await storageRef
    //       .child(widget.data['fileLocation'])
    //       .getDownloadURL()
    //       .then((value) {
    //     localSoundSource = value;
    //     _setSound(0);
    //     setState(() {
    //       isSoundSourceAvailable = true;
    //     });
    //   });
    // } catch (e) {
    //   print('Error in fetching sound source link');
    // }

    // --------------------- For Hostinger Storage / Direct Source -------------------

    localSoundSource = widget.data['fileLocation'];
    _setSound(0);
    setState(() {
      isSoundSourceAvailable = true;
    });
  }

  Future<void> _setSound(initialValue) async {
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('>> A stream error occurred: $e --${_player.position.inSeconds}');
      _isErrorFound = true;
    });

    // Try to load audio from a source and catch any errors.

    try {
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(
            // 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
            localSoundSource,
          ),
        ),
        initialPosition: Duration(seconds: initialValue),
      );
    } on PlayerException catch (e) {
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      // Linux/Windows: maps to PlayerErrorCode.index
      print('Error code: ${e.code}');
      // iOS/macOS: maps to NSError.localizedDescription
      // Android: maps to ExoPlaybackException.getMessage()
      // Web/Linux: a generic message
      // Windows: MediaPlayerError.message
      print('Error message: ${e.message}');
      _isErrorFound = true;
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      print('Connection aborted: ${e.message}');
      _isErrorFound = true;
    } catch (e) {
      // Fallback for all errors
      print('$e');
      _isErrorFound = true;
    }
  }

  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused) {
  //     // Release the player's resources when not in use. We use "stop" so that
  //     // if the app resumes later, it will still remember what position to
  //     // resume from.
  //     _player.stop();
  //   }
  // }

  Stream<AudioPlayer> myPlayerDetails() => Stream<AudioPlayer>.periodic(
        Duration(milliseconds: 200),
        (_) {
          if (_player.position.inSeconds > 0 &&
              _player.bufferedPosition.inSeconds > 0) {
            if (_currentPosition <= _bufferedPosition) {
              _currentPosition = _player.position.inSeconds.toDouble();
            }
            _bufferedPosition = _player.bufferedPosition.inSeconds.toDouble();
          }
          // _maxDuration = _player.duration!.inSeconds.toDouble();
          // _proccessingState = _player.processingState;
          return _player;
        },
      );

  Future<void> _onRefresh() async {
    _player.dispose();
    _player = AudioPlayer();
    _setSound(min(_bufferedPosition, _currentPosition).truncate());
    setState(() {
      _isErrorFound = false;
    });
    return Future.delayed(
      Duration(seconds: 1),
    );
  }

  // Future<void> manageAddToFavourite() async {
  //   var call = firebaseFunctions.httpsCallable('fa');
  //   var result = await call();
  // }

  Future<void> manageAddToFavourite() async {
    setState(() {
      changingFavouriteCollectionList = true;
    });
    print('___________________________________');
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'asia-south1')
            .httpsCallable('fa');
    var results =
        await callable(<String, dynamic>{'docRef': widget.data['soundID']});
    print('__________________________________${results.data}');
    if (results.data == 'Added') {
      setState(() {
        favouriteCollectionData.add(widget.data['soundID']);
      });
    }
    setState(() {
      changingFavouriteCollectionList = false;
    });
  }

  Future<void> manageRemoveFromFavourite() async {
    setState(() {
      changingFavouriteCollectionList = true;
    });
    print('___________________________________');
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'asia-south1')
            .httpsCallable('fr');
    var results =
        await callable(<String, dynamic>{'docRef': widget.data['soundID']});
    print('__________________________________${results.data}');
    if (results.data == 'Removed') {
      setState(() {
        favouriteCollectionData.remove(widget.data['soundID']);
      });
    }
    setState(() {
      changingFavouriteCollectionList = false;
    });
  }

  // End For Sound Controls ------------------------------------------------------------

  // -----------------------------------

  Future fileDownloader(url) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Starting Download !!!',
        ),
      ),
    );

    var status = await Permission.storage.status;
    if (status.isGranted) {
      // var baseExtDirectory = await getExternalStorageDirectory();
      await FlutterDownloader.enqueue(
        url: url,
        // savedDir: baseExtDirectory!.path,
        savedDir: '/storage/emulated/0/Download',
        // Such date formate is used to simplify downloads
        // fileName:
        //     "kingmaker${DateFormat('yyyyMMdd').format(DateTime.now())}${DateTime.now()}.mp4",
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
        saveInPublicStorage: true,
      );
    }
  }

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    _getSoundSource();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      DownloadTaskStatus status = data[1];
      // String id = data[0];
      // int progress = data[2];

      if (status == DownloadTaskStatus.complete) {
        print('Download Completed');
      }
      // setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);

    // if (displayedFirstIntAds == false) {
    //   showInterstitialAd();
    // }
    // Main.dart se Line - 78 activate Karna hai. "createInterstitialAd();"

    if (displayedFirstIntAds == false) {
      if (interstitialAdsWaitingCounter > 1) {
        showInterstitialAd();
      } else {
        interstitialAdsWaitingCounter += 1;
        if (interstitialAdsWaitingCounter == 2) {
          createInterstitialAd();
        }
      }
    }
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();

    _player.dispose();
  }

  getMonthName(value) {
    switch (value) {
      case '01':
        return 'Jan';
      case '02':
        return 'Feb';
      case '03':
        return 'Mar';
      case '04':
        return 'Apr';
      case '05':
        return 'May';
      case '06':
        return 'Jun';
      case '07':
        return 'Jul';
      case '08':
        return 'Aug';
      case '09':
        return 'Sep';
      case '10':
        return 'Oct';
      case '11':
        return 'Nov';
      case '12':
        return 'Dec';
    }
  }

  // -----------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 0.5),
                    blurRadius: 0.25,
                  ),
                ],
                // borderRadius: BorderRadius.circular(5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), //58
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
                gradient: LinearGradient(
                  colors: [
                    // Colors.deepOrange,
                    showdescription == false ? Colors.deepOrange : Colors.blue,
                    // Colors.blue,
                    Color.fromRGBO(175, 6, 175, 1),
                    Color.fromRGBO(255, 60, 0, 1),
                    Colors.orange,
                    Color.fromRGBO(255, 102, 0, 1)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Container(
                      //   height: 100,
                      //   width: 100,
                      //   alignment: Alignment.center,
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.only(
                      //       topLeft: Radius.circular(50),
                      //       topRight: Radius.circular(50),
                      //       bottomRight: Radius.circular(50),
                      //     ),
                      //   ),
                      //   child: Text(
                      //     (widget.data['title'])[0],
                      //     style: TextStyle(
                      //       fontSize: 44,
                      //       fontWeight: FontWeight.w700,
                      //     ),
                      //   ),
                      // ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              offset: Offset(1, -1),
                              blurRadius: 4,
                            ),
                          ],
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
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                            bottomRight: Radius.circular(60),
                            bottomLeft: Radius.circular(2),
                          ),
                          border: Border.all(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            width: 0.5,
                          ),
                        ),
                        height: 100,
                        width: 100,
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: widget.data['thumbnailUrl'],
                              imageBuilder: (context, imageProvider) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(60),
                                    topRight: Radius.circular(60),
                                    bottomRight: Radius.circular(60),
                                    bottomLeft: Radius.circular(2),
                                  ),
                                  child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              placeholder: (context, url) => Center(
                                child: Text(
                                  (widget.data['title'])[0],
                                  style: TextStyle(
                                      fontSize: 44,
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                // To make background visible
                                color: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Center(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      widget.data['title'],
                                      textAlign: TextAlign.justify,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Signika',
                                        fontSize: 16,
                                        letterSpacing: 1,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontWeight: FontWeight.w600,
                                        shadows: const [
                                          Shadow(
                                            color: Color.fromRGBO(0, 0, 0, 0.5),
                                            blurRadius: 1,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      showdescription = !showdescription;
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    padding: EdgeInsets.only(right: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${widget.data['soundID'].substring(6, 8)} ${getMonthName(widget.data['soundID'].substring(4, 6))} , ${widget.data['soundID'].substring(0, 4)}',
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.9),
                                            fontSize: 15,
                                            fontFamily: 'Signika',
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.2),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Icon(
                                            showdescription
                                                ? Icons
                                                    .keyboard_arrow_up_rounded
                                                : Icons
                                                    .keyboard_arrow_down_rounded,
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.9),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: showdescription,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '***  Shared by  ***',
                                  style: TextStyle(
                                    fontFamily: 'Signika',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  widget.data['authorDetail'],
                                  maxLines: 5,
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    height: 1.3,
                                    letterSpacing: 0.7,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Signika',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          //   child: Text(
                          //     'This sound is shared by a instagram user @Test Kumar',
                          //     textAlign: TextAlign.justify,
                          //     style: TextStyle(
                          //       letterSpacing: 0.5,
                          //       fontFamily: 'Signika',
                          //       fontWeight: FontWeight.w500,
                          //       color: Color.fromRGBO(255, 255, 255, 1),
                          //       shadows: const [
                          //         Shadow(
                          //           color: Color.fromRGBO(0, 0, 0, 0.5),
                          //           blurRadius: 1,
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            height: 15,
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (widget.data['source'] != '') {
                                  _makeRequest(
                                      Uri.parse(widget.data['source']));
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 0.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Source -- ',
                                      style: TextStyle(
                                        fontFamily: 'Signika',
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          widget.data['source'] != ''
                                              ? 'View'
                                              : 'Not Confirm',
                                          style: TextStyle(
                                              // fontSize: 10,
                                              ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          widget.data['source'] != ''
                                              ? Icons.visibility_rounded
                                              : Icons.error_rounded,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: widget.data['soundID'],
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(milliseconds: 400),
                                    content:
                                        Text('Sound ID Copied Successfully 😀'),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 0.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sound ID -- ',
                                      style: TextStyle(
                                        fontFamily: 'Signika',
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          widget.data['soundID'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              // fontSize: 10,
                                              ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.copy_rounded,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(0, 10, 15, 10),
              margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 0.5),
                    blurRadius: 0.25,
                  ),
                ],
                // borderRadius: BorderRadius.circular(5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), //58
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
                gradient: LinearGradient(
                  colors: const [
                    // Colors.deepOrange,
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
              child: isSoundSourceAvailable
                  ? Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: StreamBuilder(
                            stream: myPlayerDetails(),
                            builder: (context, snapshot) {
                              return Slider.adaptive(
                                // value: currentPosition,
                                // value: _player.position.inSeconds.toDouble(),
                                value: _currentPosition,
                                onChanged: (val) {
                                  _player.seek(
                                    Duration(
                                      seconds: val.toInt(),
                                    ),
                                  );
                                },
                                activeColor: Colors.white,
                                min: 0.0,
                                // max: soundMaxDuration,
                                max: (_player.duration != null)
                                    ? _player.duration!.inSeconds.toDouble()
                                    : 1000000.0,
                                // thumbColor: Color.fromRGBO(0, 0, 0, 1),
                                inactiveColor:
                                    Color.fromRGBO(255, 255, 255, 0.6),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder<AudioPlayer>(
                              stream: myPlayerDetails(),
                              builder: (context, snapshot) {
                                localButton(icon, fnc) {
                                  return GestureDetector(
                                    onTap: fnc,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        // border: Border.all(
                                        //   color:
                                        //       Color.fromRGBO(0, 0, 0, 1),
                                        //   width: 1,
                                        // ),
                                      ),
                                      alignment: Alignment.center,
                                      child: icon,
                                    ),
                                  );
                                }

                                // if (_isErrorInLoading == true) {
                                //   _player = AudioPlayer();
                                //   // if issue happened then reload from last integral seconds
                                //   print('>> Error in loading');
                                //   _setSound(_bufferedPosition.truncate());
                                // }

                                final playerState = snapshot.data;
                                final processingState =
                                    playerState?.processingState;
                                final playing = playerState?.playing;
                                if (_isErrorFound == true) {
                                  return localButton(
                                    Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        Icon(
                                          // Icons.refresh,
                                          Icons.replay_circle_filled_rounded,
                                          size: 36,
                                          color: Color.fromRGBO(230, 0, 0, 1),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            Icons.error_outline_rounded,
                                            size: 18,
                                            color: Color.fromRGBO(230, 0, 0, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                    () {
                                      _player.dispose();
                                      _player = AudioPlayer();
                                      _setSound(min(_bufferedPosition,
                                              _currentPosition)
                                          .truncate());
                                      setState(() {
                                        _isErrorFound = false;
                                      });
                                    },
                                  );
                                } else {
                                  if (processingState ==
                                          ProcessingState.loading ||
                                      processingState ==
                                          ProcessingState.buffering) {
                                    return Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      alignment: Alignment.center,
                                      child: CupertinoActivityIndicator(
                                        radius: 15,
                                      ),
                                    );
                                  } else if (playing != true) {
                                    return localButton(
                                      Icon(
                                        Icons.play_arrow_rounded,
                                        size: 40,
                                      ),
                                      () {
                                        _player.play();
                                      },
                                    );
                                  } else if (processingState !=
                                      ProcessingState.completed) {
                                    return localButton(
                                      Icon(
                                        Icons.pause,
                                        size: 36,
                                      ),
                                      () {
                                        _player.pause();
                                      },
                                    );
                                  } else {
                                    return localButton(
                                      Icon(
                                        Icons.repeat_rounded,
                                        size: 32,
                                      ),
                                      () {
                                        _player.seek(Duration.zero);
                                      },
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        )
                      ],
                    )
                  : LinearProgressIndicator(),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(10, 30, 10, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(15, 5, 15, 7),
                      ),
                      fixedSize: MaterialStateProperty.all(
                        Size.fromHeight(60),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(36, 14, 123, 1),
                      ),
                      shadowColor: MaterialStateProperty.all(
                        Color.fromRGBO(230, 0, 0, 1),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.data['allowDownload'])
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Save Sound',
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 22,
                                  fontFamily: 'Signika',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Visibility(
                                visible: isRewardedAdsAvailable,
                                child: SizedBox(
                                  height: 5,
                                ),
                              ),
                              Visibility(
                                visible: isRewardedAdsAvailable,
                                child: Text(
                                  'For Free After Ads',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            'Save Sound',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 22,
                              fontFamily: 'Signika',
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        SizedBox(
                          width: 20,
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                          child: Icon(
                            (widget.data['allowDownload'])
                                ? Icons.save_alt_rounded
                                : Icons.file_download_off_outlined,
                            color: Color.fromRGBO(230, 0, 0, 1),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      // To avoid snakebar queing due to multiple hit
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      if (widget.data['allowDownload']) {
                        fileDownloader(widget.data['fileLocation']);
                        showInterstitialAd();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'This sound is NOT available for download !!!',
                              style: TextStyle(
                                letterSpacing: 1,
                              ),
                            ),
                            duration: Duration(
                              milliseconds: 1500,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: favouriteCollectionData
                                  .contains(widget.data['soundID'])
                              ? manageRemoveFromFavourite
                              : manageAddToFavourite,
                          child: Container(
                            height: 60,
                            width: 60,
                            padding: EdgeInsets.only(top: 3),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 0.5),
                                  blurRadius: 1,
                                )
                              ],
                            ),
                            child: changingFavouriteCollectionList
                                ? CupertinoActivityIndicator(
                                    radius: 16,
                                  )
                                : favouriteCollectionData
                                        .contains(widget.data['soundID'])
                                    ? Icon(
                                        Icons.favorite,
                                        color: Color.fromRGBO(255, 0, 0, 1),
                                        size: 30,
                                      )
                                    : Icon(
                                        Icons.favorite_outline,
                                        color: Color.fromRGBO(255, 0, 0, 1),
                                        size: 30,
                                      ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            height: 60,
                            width: 60,
                            padding: EdgeInsets.only(right: 2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 0.5),
                                  blurRadius: 1,
                                )
                              ],
                            ),
                            child: Icon(
                              Icons.share_rounded,
                              color: Color.fromRGBO(255, 0, 0, 1),
                              size: 30,
                            ),
                          ),
                          onTap: () {
                            Share.share(
                                '*Try this TRENDING sound with Reels, Shorts, Snap and many more*\n\n${widget.data['fileLocation']}\n\n\nFor more, download *Kingmaker* app.\n\nhttps://play.google.com/store/apps/details?id=com.icyindia.kingmaker'); //3z4mkze
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (widget.data['topPerformingContentLink'].length > 0)
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
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
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Top Performing Content',
                            style: TextStyle(
                              fontFamily: 'Signika',
                              fontSize: 20,
                              letterSpacing: 1.5,
                              color: Color.fromRGBO(36, 14, 123, 1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              topPerformance('1'),
                              SizedBox(
                                width: 20,
                              ),
                              topPerformance('2'),
                              SizedBox(
                                width: 20,
                              ),
                              topPerformance('3'),
                              SizedBox(
                                width: 20,
                              ),
                              topPerformance('4'),
                              // Expanded(
                              //   child: AspectRatio(
                              //     aspectRatio: 1,
                              //     child: CircleAvatar(
                              //       minRadius: 20,
                              //       maxRadius: 40,
                              //       child: Text('1'),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            // Container(
            //   width: double.infinity,
            //   margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
            //   decoration: BoxDecoration(
            //     color: Color.fromRGBO(255, 255, 255, 1),
            //     boxShadow: const [
            //       BoxShadow(
            //         color: Colors.grey,
            //         offset: Offset(0, 0.5),
            //         blurRadius: 0.25,
            //       ),
            //     ],
            //     borderRadius: BorderRadius.circular(5),
            //   ),
            //   child: Column(
            //     children: [
            //       Container(
            //         width: double.infinity,
            //         padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            //         alignment: Alignment.center,
            //         child: Text(
            //           'Ads',
            //           style: TextStyle(
            //             fontFamily: 'Signika',
            //             color: Color.fromRGBO(0, 0, 0, 0.35),
            //             letterSpacing: 2,
            //           ),
            //         ),
            //       ),
            //       MaxAdView(
            //           adUnitId: _mrecsAdsUnitId,
            //           adFormat: AdFormat.mrec,
            //           listener: AdViewAdListener(
            //               onAdLoadedCallback: (ad) {},
            //               onAdLoadFailedCallback: (adUnitId, error) {},
            //               onAdClickedCallback: (ad) {},
            //               onAdExpandedCallback: (ad) {},
            //               onAdCollapsedCallback: (ad) {})),
            //     ],
            //   ),
            // ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
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
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Hashtag',
                              style: TextStyle(
                                fontFamily: 'Signika',
                                fontSize: 20,
                                letterSpacing: 1.5,
                                color: Color.fromRGBO(36, 14, 123, 1),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(4),
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Icon(Icons.copy_rounded),
                              ),
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text: '${widget.data['hashtag']}'));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(milliseconds: 750),
                                    content:
                                        Text('Hashtag Copied Successfully 😀'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        child: SelectableText(
                          widget.data['hashtag'],
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontFamily: 'Signika',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
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
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Top Countries',
                              style: TextStyle(
                                fontFamily: 'Signika',
                                fontSize: 20,
                                letterSpacing: 1.5,
                                color: Color.fromRGBO(36, 14, 123, 1),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.flag_rounded,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...(widget.data['topCountries'] as List).mapIndexed(
                              (index, element) => Container(
                                color: (index % 2 != 0)
                                    ? Color.fromRGBO(255, 247, 247, 1)
                                    : Color.fromRGBO(255, 255, 255, 1),
                                child: getTrendingCountry(element),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            widget.data['intagramAudionUrl'] != ''
                ? Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(10, 30, 10, 50),
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
                    child: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(5),
                          // linear-gradient(135deg,blue,rgb(175, 6, 175),rgb(255, 60, 0),orange,rgb(255, 102, 0))
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text(
                              'Try on Instagram',
                              style: TextStyle(
                                fontFamily: 'Signika',
                                fontSize: 20,
                                letterSpacing: 1.5,
                                // color: Color.fromRGBO(36, 14, 123, 1),
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 1,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  )
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        _makeRequest(
                            Uri.parse(widget.data['intagramAudionUrl']));
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

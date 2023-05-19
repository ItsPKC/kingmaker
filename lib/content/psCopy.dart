// import 'dart:math';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:collection/collection.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:kingmaker/content/globalVariable.dart';
// import 'package:kingmaker/content/previewSoundController.dart';
// // import 'package:kingmaker/content/webViewHome.dart';

// class PreviewSound extends StatefulWidget {
//   const PreviewSound({Key? key}) : super(key: key);

//   @override
//   _PreviewSoundState createState() => _PreviewSoundState();
// }

// class _PreviewSoundState extends State<PreviewSound> {
//   var isRewarded = true;
//   var ccList = ['In', 'us', 'ua', 'ug', 'gb', 'il', 'um', 'pk'];
//   getTrendingCountry(countryCode) {
//     var nameIndex = countryDetails.lastIndexWhere(
//         (element) => element.contains(countryCode.toUpperCase()));
//     var flag = countryCode.toUpperCase().replaceAllMapped(
//           RegExp(r'[A-Z]'),
//           (match) =>
//               String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
//         );
//     // return '$flag    ${countryCode.toUpperCase()}    ${countryDetails[nameIndex][0]}';
//     return Padding(
//       padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
//       child: Row(
//         children: [
//           SelectableText(
//             flag,
//             textAlign: TextAlign.justify,
//             style: TextStyle(
//               fontFamily: 'Signika',
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 1,
//             ),
//           ),
//           Container(
//             width: 40,
//             // color: Colors.amber,
//             margin: EdgeInsets.fromLTRB(20, 0, 12, 0),
//             child: SelectableText(
//               countryCode.toUpperCase(),
//               textAlign: TextAlign.justify,
//               style: TextStyle(
//                 fontFamily: 'Signika',
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 1,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               countryDetails[nameIndex][0],
//               textAlign: TextAlign.justify,
//               softWrap: true,
//               style: TextStyle(
//                 fontFamily: 'Signika',
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 1,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   topPerformance(hightlightVal) {
//     return Expanded(
//       child: Container(
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: Colors.amber,
//           shape: BoxShape.circle,
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.grey,
//               offset: Offset(0, 0.5),
//               blurRadius: 1,
//             )
//           ],
//         ),
//         child: AspectRatio(
//           aspectRatio: 1,
//           child: CircleAvatar(
//             minRadius: 20,
//             maxRadius: 40,
//             backgroundColor: Color.fromRGBO(255, 255, 255, 1),
//             child: Stack(
//               // mainAxisAlignment: MainAxisAlignment.center,
//               alignment: Alignment.center,
//               children: [
//                 Icon(
//                   Icons.play_arrow_rounded,
//                   color: Color.fromRGBO(0, 0, 0, 1),
//                   size: 72,
//                 ),
//                 Text(
//                   hightlightVal,
//                   style: TextStyle(
//                     color: Color.fromRGBO(255, 255, 255, 1),
//                     fontSize: 14,
//                     fontFamily: 'Signika',
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // -----------------------------
//   // final AudioPlayer _player = AudioPlayer();
//   // var soundMaxDuration = 0.0;
//   // var currentPosition = 0.0;
//   // var playerState = PlayerState.STOPPED;

//   // setSoundUrl() async {
//   //   await _player
//   //       .setUrl('http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1xtra_mf_p');
//   //   await _player.setReleaseMode(ReleaseMode.STOP);
//   // }

//   // play() async {
//   //   int result = await _player.play(
//   //       // 'https://sf16-ies-music-va.tiktokcdn.com/obj/musically-maliva-obj/7063427040543771398.mp3'
//   //       // 'https://luan.xyz/files/audio/ambient_c_motion.mp3',
//   //       'http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1xtra_mf_p');
//   //   if (result == 1) {
//   //     print('Started Playing');
//   //   }
//   // }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   setSoundUrl();
//   //   _player.onDurationChanged.listen((Duration d) {
//   //     print('Max duration: $d');
//   //     setState(() => soundMaxDuration = d.inSeconds.toDouble());
//   //   });
//   //   _player.onAudioPositionChanged.listen(
//   //     (Duration p) {
//   //       setState(() {
//   //         if (p.inSeconds >= currentPosition + 0.1 ||
//   //             soundMaxDuration - p.inSeconds <= 1 ||
//   //             currentPosition == soundMaxDuration) {
//   //           print('Current position: $p');
//   //           currentPosition = p.inSeconds.toDouble();
//   //         }
//   //       });
//   //     },
//   //   );
//   //   _player.onPlayerStateChanged.listen(
//   //     (PlayerState s) {
//   //       print('Current player state: $s');
//   //       setState(() => playerState = s);
//   //     },
//   //   );
//   //   _player.onPlayerError.listen((msg) {
//   //     print('audioPlayer error : $msg');
//   //     setState(() {
//   //       playerState = PlayerState.STOPPED;
//   //       soundMaxDuration = 0;
//   //       currentPosition = 0;
//   //     });
//   //   });
//   // }

//   // @override
//   // void dispose() {
//   //   super.dispose();
//   //   _player.dispose();
//   // }

//   AudioPlayer _player = AudioPlayer();
//   var _currentPosition = 0.0;
//   var _bufferedPosition = 0.0;
//   var _isErrorFound = false;
//   // var _maxDuration = 0.0;
//   // var _proccessingState = ProcessingState.idle;

//   Future<void> _setSound(initialValue) async {
//     // Listen to errors during playback.
//     _player.playbackEventStream.listen((event) {},
//         onError: (Object e, StackTrace stackTrace) {
//       print('>> A stream error occurred: $e --${_player.position.inSeconds}');
//       _isErrorFound = true;
//     });

//     // Try to load audio from a source and catch any errors.

//     try {
//       await _player.setAudioSource(
//         AudioSource.uri(
//           Uri.parse(
//             // 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
//             'https://luan.xyz/files/audio/ambient_c_motion.mp3',
//           ),
//         ),
//         initialPosition: Duration(seconds: initialValue),
//       );
//     } on PlayerException catch (e) {
//       // iOS/macOS: maps to NSError.code
//       // Android: maps to ExoPlayerException.type
//       // Web: maps to MediaError.code
//       // Linux/Windows: maps to PlayerErrorCode.index
//       print('Error code: ${e.code}');
//       // iOS/macOS: maps to NSError.localizedDescription
//       // Android: maps to ExoPlaybackException.getMessage()
//       // Web/Linux: a generic message
//       // Windows: MediaPlayerError.message
//       print('Error message: ${e.message}');
//       _isErrorFound = true;
//     } on PlayerInterruptedException catch (e) {
//       // This call was interrupted since another audio source was loaded or the
//       // player was stopped or disposed before this audio source could complete
//       // loading.
//       print('Connection aborted: ${e.message}');
//       _isErrorFound = true;
//     } catch (e) {
//       // Fallback for all errors
//       print('$e');
//       _isErrorFound = true;
//     }
//   }

//   // void didChangeAppLifecycleState(AppLifecycleState state) {
//   //   if (state == AppLifecycleState.paused) {
//   //     // Release the player's resources when not in use. We use "stop" so that
//   //     // if the app resumes later, it will still remember what position to
//   //     // resume from.
//   //     _player.stop();
//   //   }
//   // }

//   Stream<AudioPlayer> myPlayerDetails() => Stream<AudioPlayer>.periodic(
//         Duration(milliseconds: 200),
//         (_) {
//           if (_player.position.inSeconds > 0 &&
//               _player.bufferedPosition.inSeconds > 0) {
//             if (_currentPosition <= _bufferedPosition) {
//               _currentPosition = _player.position.inSeconds.toDouble();
//             }
//             _bufferedPosition = _player.bufferedPosition.inSeconds.toDouble();
//           }
//           // _maxDuration = _player.duration!.inSeconds.toDouble();
//           // _proccessingState = _player.processingState;
//           return _player;
//         },
//       );

//   Future<void> _onRefresh() async {
//     _player.dispose();
//     _player = AudioPlayer();
//     _setSound(min(_bufferedPosition, _currentPosition).truncate());
//     setState(() {
//       _isErrorFound = false;
//     });
//     return Future.delayed(
//       Duration(seconds: 1),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _setSound(0);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _player.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(247, 247, 247, 1),
//       body: RefreshIndicator(
//         onRefresh: _onRefresh,
//         child: ListView(
//           children: [
//             PreviewSoundController(),
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(10),
//               margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(255, 0, 255, 1),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.grey,
//                     offset: Offset(0, 0.5),
//                     blurRadius: 0.25,
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               child: Row(
//                 children: [
//                   Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Container(
//                         color: Colors.amber,
//                         height: 100,
//                         width: 100,
//                         child: Text('j'),
//                       ),
//                       GestureDetector(
//                         child: Container(
//                           padding: EdgeInsets.all(10),
//                           child: Icon(
//                             Icons.pause_rounded,
//                             color: Colors.black,
//                             size: 48,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Expanded(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         StreamBuilder(
//                           stream: myPlayerDetails(),
//                           builder: (context, snapshot) {
//                             return Slider.adaptive(
//                               // value: currentPosition,
//                               // value: _player.position.inSeconds.toDouble(),
//                               value: _currentPosition,
//                               onChanged: (val) {
//                                 _player.seek(
//                                   Duration(
//                                     seconds: val.toInt(),
//                                   ),
//                                 );
//                               },
//                               activeColor: Colors.amber,
//                               min: 0.0,
//                               // max: soundMaxDuration,
//                               max: (_player.duration != null)
//                                   ? _player.duration!.inSeconds.toDouble()
//                                   : 1000000.0,
//                               // thumbColor: Color.fromRGBO(0, 0, 0, 0.25),
//                               inactiveColor: Colors.green,
//                             );
//                           },
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             StreamBuilder<AudioPlayer>(
//                               stream: myPlayerDetails(),
//                               builder: (context, snapshot) {
//                                 localButton(icon, fnc) {
//                                   return GestureDetector(
//                                     child: Container(
//                                       height: 40,
//                                       width: 40,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(5),
//                                       ),
//                                       alignment: Alignment.center,
//                                       child: icon,
//                                     ),
//                                     onTap: fnc,
//                                   );
//                                 }

//                                 // if (_isErrorInLoading == true) {
//                                 //   _player = AudioPlayer();
//                                 //   // if issue happened then reload from last integral seconds
//                                 //   print('>> Error in loading');
//                                 //   _setSound(_bufferedPosition.truncate());
//                                 // }

//                                 final playerState = snapshot.data;
//                                 final processingState =
//                                     playerState?.processingState;
//                                 final playing = playerState?.playing;
//                                 if (_isErrorFound == true) {
//                                   return localButton(
//                                     Stack(
//                                       alignment: Alignment.bottomLeft,
//                                       children: [
//                                         Icon(
//                                           // Icons.refresh,
//                                           Icons.replay_circle_filled_rounded,
//                                           size: 36,
//                                           color: Color.fromRGBO(230, 0, 0, 1),
//                                         ),
//                                         Container(
//                                           decoration: BoxDecoration(
//                                             color: Color.fromRGBO(
//                                                 255, 255, 255, 1),
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                           child: Icon(
//                                             Icons.error_outline_rounded,
//                                             size: 18,
//                                             color: Color.fromRGBO(230, 0, 0, 1),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     () {
//                                       _player.dispose();
//                                       _player = AudioPlayer();
//                                       _setSound(min(_bufferedPosition,
//                                               _currentPosition)
//                                           .truncate());
//                                       setState(() {
//                                         _isErrorFound = false;
//                                       });
//                                     },
//                                   );
//                                 } else {
//                                   if (processingState ==
//                                           ProcessingState.loading ||
//                                       processingState ==
//                                           ProcessingState.buffering) {
//                                     return Container(
//                                       height: 40,
//                                       width: 40,
//                                       decoration: BoxDecoration(
//                                         color: Color.fromRGBO(255, 255, 255, 1),
//                                         borderRadius: BorderRadius.circular(5),
//                                       ),
//                                       alignment: Alignment.center,
//                                       child: CupertinoActivityIndicator(
//                                         radius: 15,
//                                       ),
//                                     );
//                                   } else if (playing != true) {
//                                     return localButton(
//                                       Icon(
//                                         Icons.play_arrow_rounded,
//                                         size: 40,
//                                       ),
//                                       () {
//                                         _player.play();
//                                       },
//                                     );
//                                   } else if (processingState !=
//                                       ProcessingState.completed) {
//                                     return localButton(
//                                       Icon(
//                                         Icons.pause,
//                                         size: 36,
//                                       ),
//                                       () {
//                                         _player.pause();
//                                       },
//                                     );
//                                   } else {
//                                     return localButton(
//                                       Icon(
//                                         Icons.repeat_rounded,
//                                         size: 32,
//                                       ),
//                                       () {
//                                         _player.seek(Duration.zero);
//                                       },
//                                     );
//                                   }
//                                 }
//                               },
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Visibility(
//                     visible: isRewarded,
//                     child: Material(
//                       color: Colors.transparent,
//                       child: InkWell(
//                         borderRadius: BorderRadius.circular(30),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               height: 60,
//                               width: 60,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 color: Color.fromRGBO(255, 0, 0, 1),
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               child: Icon(
//                                 Icons.subscriptions_rounded,
//                                 color: Color.fromRGBO(255, 255, 255, 1),
//                                 size: 28,
//                               ),
//                             ),
//                             Icon(
//                               Icons.double_arrow,
//                               color: Color.fromRGBO(255, 0, 0, 1),
//                             ),
//                           ],
//                         ),
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               content: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: const [
//                                   CircleAvatar(
//                                     radius: 35,
//                                     backgroundColor:
//                                         Color.fromRGBO(255, 0, 0, 1),
//                                     child: Icon(
//                                       Icons.subscriptions_rounded,
//                                       color: Color.fromRGBO(255, 255, 255, 1),
//                                       size: 34,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 40,
//                                   ),
//                                   Text(
//                                     'Premium contents are available for FREE for limited period.',
//                                     textAlign: TextAlign.justify,
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontFamily: 'Signika',
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 30,
//                                   ),
//                                   Text(
//                                     'Enjoy  !!!',
//                                     textAlign: TextAlign.justify,
//                                     style: TextStyle(
//                                       fontSize: 24,
//                                       fontFamily: 'Signika',
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   OutlinedButton(
//                     style: ButtonStyle(
//                       padding: MaterialStateProperty.all(
//                         EdgeInsets.fromLTRB(15, 5, 15, 7),
//                       ),
//                       fixedSize: MaterialStateProperty.all(
//                         Size.fromHeight(60),
//                       ),
//                       backgroundColor: MaterialStateProperty.all(
//                         Color.fromRGBO(36, 14, 123, 1),
//                       ),
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               'Save Sound',
//                               style: TextStyle(
//                                 color: Color.fromRGBO(255, 255, 255, 1),
//                                 fontSize: 22,
//                                 fontFamily: 'Signika',
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             Visibility(
//                               visible: isRewarded,
//                               child: SizedBox(
//                                 height: 5,
//                               ),
//                             ),
//                             Visibility(
//                               visible: isRewarded,
//                               child: Text(
//                                 'For Free After Ads',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Color.fromRGBO(255, 255, 255, 1),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         CircleAvatar(
//                           radius: 20,
//                           backgroundColor: Color.fromRGBO(255, 255, 255, 1),
//                           child: Icon(
//                             Icons.save_alt_rounded,
//                             color: Color.fromRGBO(230, 0, 0, 1),
//                             size: 24,
//                           ),
//                         ),
//                       ],
//                     ),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(255, 255, 255, 1),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.grey,
//                     offset: Offset(0, 0.5),
//                     blurRadius: 0.25,
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               child: Column(
//                 children: [
//                   Column(
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.all(10.0),
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'Top Performance',
//                           style: TextStyle(
//                             fontFamily: 'Signika',
//                             fontSize: 20,
//                             letterSpacing: 1.5,
//                             color: Color.fromRGBO(36, 14, 123, 1),
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                         width: double.infinity,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             topPerformance('1'),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             topPerformance('2'),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             topPerformance('3'),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             topPerformance('4'),
//                             // Expanded(
//                             //   child: AspectRatio(
//                             //     aspectRatio: 1,
//                             //     child: CircleAvatar(
//                             //       minRadius: 20,
//                             //       maxRadius: 40,
//                             //       child: Text('1'),
//                             //     ),
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(255, 255, 255, 1),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.grey,
//                     offset: Offset(0, 0.5),
//                     blurRadius: 0.25,
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               child: Column(
//                 children: [
//                   Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.all(10.0),
//                             child: Text(
//                               'Hashtag',
//                               style: TextStyle(
//                                 fontFamily: 'Signika',
//                                 fontSize: 20,
//                                 letterSpacing: 1.5,
//                                 color: Color.fromRGBO(36, 14, 123, 1),
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                           Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               borderRadius: BorderRadius.circular(4),
//                               child: Padding(
//                                 padding: EdgeInsets.all(10.0),
//                                 child: Icon(Icons.copy_rounded),
//                               ),
//                               onTap: () {},
//                             ),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         padding: EdgeInsets.all(10),
//                         width: double.infinity,
//                         child: SelectableText(
//                           'Test it now',
//                           textAlign: TextAlign.justify,
//                           style: TextStyle(
//                             fontFamily: 'Signika',
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               margin: EdgeInsets.fromLTRB(10, 15, 10, 30),
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(255, 255, 255, 1),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.grey,
//                     offset: Offset(0, 0.5),
//                     blurRadius: 0.25,
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               child: Column(
//                 children: [
//                   Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: const [
//                           Padding(
//                             padding: EdgeInsets.all(10.0),
//                             child: Text(
//                               'Top Countries',
//                               style: TextStyle(
//                                 fontFamily: 'Signika',
//                                 fontSize: 20,
//                                 letterSpacing: 1.5,
//                                 color: Color.fromRGBO(36, 14, 123, 1),
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(10.0),
//                             child: Icon(
//                               Icons.flag_rounded,
//                               color: Colors.deepOrange,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
//                         width: double.infinity,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ...ccList.mapIndexed((index, element) => Container(
//                                   color: (index % 2 != 0)
//                                       ? Color.fromRGBO(255, 247, 247, 1)
//                                       : Color.fromRGBO(255, 255, 255, 1),
//                                   child: getTrendingCountry(element),
//                                 )),
//                           ],
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

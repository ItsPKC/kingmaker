import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:kingmaker/content/webViewHome.dart';

class PreviewSoundController extends StatefulWidget {
  final soundLink;
  final Function setIsSoundOn, setActiveSoundIndex;
  final _currentIndex;
  PreviewSoundController(this.soundLink, this.setIsSoundOn,
      this.setActiveSoundIndex, this._currentIndex,
      {Key? key})
      : super(key: key);

  @override
  _PreviewSoundControllerState createState() => _PreviewSoundControllerState();
}

class _PreviewSoundControllerState extends State<PreviewSoundController> {
  AudioPlayer _player = AudioPlayer();
  var _currentPosition = 0.0;
  var _bufferedPosition = 0.0;
  var _isErrorFound = false;
  // var _maxDuration = 0.0;
  // var _proccessingState = ProcessingState.idle;

  Future<void> _setSound(initialValue) async {
    print('Sound set !!!');
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('>> A stream error occurred: $e --${_player.position.inSeconds}');
      _isErrorFound = true;
    });

    // Try to load audio from a source and catch any errors.

    try {
      await _player
          .setAudioSource(
            AudioSource.uri(
              Uri.parse(
                // 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
                // 'https://luan.xyz/files/audio/ambient_c_motion.mp3',
                widget.soundLink,
              ),
            ),
            initialPosition: Duration(seconds: initialValue),
          )
          // Below 3 line are optional to auto play
          .then(
            (value) => _player.play(),
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

  @override
  void initState() {
    super.initState();
    _setSound(0);
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Container(
        margin: EdgeInsets.fromLTRB(4, 0, 4, 3.75),
        padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(125, 125, 125, 1),
          // color: Colors.tealAccent,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 0),
              blurRadius: 0.5,
            ),
          ],
          borderRadius: BorderRadius.circular(5),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.all(3),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.4),
                borderRadius: BorderRadius.circular(5),
              ),
              child: FittedBox(
                child: Text(
                  '${widget._currentIndex}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Signika',
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream: myPlayerDetails(),
              builder: (context, snapshot) {
                return Row(
                  children: [
                    Container(
                      height: 40,
                      // width: 40,
                      padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.4),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FittedBox(
                            child: Text(
                              '${_currentPosition.truncate()}',
                              style: TextStyle(
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            width: 18,
                            color: Color.fromRGBO(0, 0, 0, 1),
                          ),
                          FittedBox(
                            child: Text(
                              '${(_player.duration != null) ? _player.duration!.inSeconds : 0}',
                              style: TextStyle(
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Slider.adaptive(
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
                      activeColor: Color.fromRGBO(255, 255, 255, 1),
                      min: 0.0,
                      // max: soundMaxDuration,
                      max: (_player.duration != null)
                          ? _player.duration!.inSeconds.toDouble()
                          : 1000000.0,
                      // thumbColor: Color.fromRGBO(0, 0, 0, 0.25),
                      inactiveColor: Color.fromRGBO(255, 255, 255, 0.5),
                    ),
                  ],
                );
              },
            ),
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
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(5),
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
                final processingState = playerState?.processingState;
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
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(10),
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
                      _setSound(
                          min(_bufferedPosition, _currentPosition).truncate());
                      setState(() {
                        _isErrorFound = false;
                      });
                    },
                  );
                } else {
                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
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
                  } else if (processingState != ProcessingState.completed) {
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
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(5),
                // border: Border.all(
                //   color: Color.fromRGBO(255, 0, 0, 1),
                //   width: 1.5,
                // ),
              ),
              child: GestureDetector(
                child: Icon(
                  Icons.close_rounded,
                  size: 32,
                  color: Color.fromRGBO(255, 0, 0, 1),
                ),
                onTap: () {
                  widget.setActiveSoundIndex(-1);
                  widget.setIsSoundOn(true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

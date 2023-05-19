import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  // final Function pageNumberSelector;
  final initialUrl;
  MyWebView(this.initialUrl);

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  var shouldProgressIndicatorDisplay = true;
  var resetLoadingState = true;
  late double currentProgressValue = 0.0;
  late WebViewController _controller;

  var shouldDisplayExpandedDraggable = false;
  var floatingX = 15.0;
  var floatingY = 15.0;

  Future<void> _makeRequest2(url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        print('Can\'t lauch now !!!');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _makeRequest(url) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
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
            title: Text('Kingmaker'),
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
  }

  // Future downloader(url) async {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         'Starting Download !!!',
  //       ),
  //     ),
  //   );

  //   var status = await Permission.storage.status;
  //   if (status.isGranted) {
  //     // var baseExtDirectory = await getExternalStorageDirectory();
  //     await FlutterDownloader.enqueue(
  //       url: url,
  //       // savedDir: baseExtDirectory!.path,
  //       savedDir: '/storage/emulated/0/Download',
  //       // Such date formate is used to simplify downloads
  //       // fileName:
  //       //     "waassist${DateFormat('yyyyMMdd').format(DateTime.now())}${DateTime.now()}.mp4",
  //       showNotification:
  //           true, // show download progress in status bar (for Android)
  //       openFileFromNotification:
  //           true, // click on notification to open downloaded file (for Android)
  //       saveInPublicStorage: true,
  //     );
  //   }
  // }

  // final ReceivePort _port = ReceivePort();

  // @override
  // void initState() {
  //   super.initState();
  //   // Enable hybrid composition.
  //   if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  //   IsolateNameServer.registerPortWithName(
  //       _port.sendPort, 'downloader_send_port');
  //   _port.listen((dynamic data) {
  //     DownloadTaskStatus status = data[1];
  //     // String id = data[0];
  //     // int progress = data[2];

  //     if (status == DownloadTaskStatus.complete) {
  //       print('Download Completed');
  //     }
  //     // setState(() {});
  //   });

  //   FlutterDownloader.registerCallback(downloadCallback);
  // }

  // static void downloadCallback(
  //     String id, DownloadTaskStatus status, int progress) {
  //   final SendPort? send =
  //       IsolateNameServer.lookupPortByName('downloader_send_port');
  //   send!.send([id, status, progress]);
  // }

  @override
  void dispose() {
    // IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            var temp = await _controller.canGoBack();
            if (temp && await _controller.currentUrl() != widget.initialUrl) {
              _controller.goBack();
            } else {
              if (mounted) {
                Navigator.pop(context);
              }
              // return true; // No need of navigator, it will pop the top layer anyway.
            }
            // Back functions were listed above
            // return is necessary So,
            // This return FALSE is used to just stop app from closing
            // TRUE is used to close app
            return false;
          },
          child: Container(
            color: Color.fromRGBO(255, 255, 255, 1),
            child: Stack(
              children: [
                Column(
                  children: [
                    (shouldProgressIndicatorDisplay == true)
                        ? Center(
                            child: LinearProgressIndicator(
                              value: currentProgressValue,
                              backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromRGBO(255, 0, 0, 1),
                              ),
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: WebView(
                        initialUrl: widget.initialUrl,
                        javascriptMode: JavascriptMode.unrestricted,
                        allowsInlineMediaPlayback: true,
                        // navigationDelegate: (navigation) async {
                        //   print(navigation.url);
                        //   if (navigation.url.endsWith('.mp4') ||
                        //       navigation.url.endsWith('.pdf') ||
                        //       navigation.url.endsWith('.doc') ||
                        //       navigation.url.endsWith('.docx') ||
                        //       navigation.url.endsWith('.ppt') ||
                        //       navigation.url.endsWith('.pptx') ||
                        //       navigation.url.endsWith('.xls') ||
                        //       navigation.url.endsWith('.xlsx')) {
                        //     // downloader(navigation.url);
                        //     return NavigationDecision.prevent;
                        //   }
                        //   return NavigationDecision.navigate;
                        // },

                        onWebResourceError:
                            (WebResourceError webResourceError) async {
                          print('Failed to load');
                          print(webResourceError);
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.none) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  // title: Text('WA Assist'),
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
                                            color:
                                                Color.fromRGBO(36, 14, 123, 1),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 100,
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                          ),
                                        ),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          print(
                                              '....................${await _controller.currentUrl()}');
                                          // await _controller.reload();
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        onWebViewCreated: (WebViewController controller) {
                          _controller = controller;
                        },
                        onProgress: (progress) async {
                          print('......................$progress');
                          print(currentProgressValue);
                          setState(() {
                            currentProgressValue = progress / 100;
                          });
                          var _currentUrl = await _controller.currentUrl();
                          if (_currentUrl!.endsWith('.pdf') ||
                              _currentUrl.endsWith('.mp4') ||
                              _currentUrl.endsWith('.doc') ||
                              _currentUrl.endsWith('.docx') ||
                              _currentUrl.endsWith('.ppt') ||
                              _currentUrl.endsWith('.pptx') ||
                              _currentUrl.endsWith('.xls') ||
                              _currentUrl.endsWith('.xlsx')) {
                            _makeRequest(_currentUrl);
                          }
                          if (progress > 0) {
                            if (_currentUrl.contains('youtube.com') ||
                                _currentUrl.contains('youtu.be')) {
                              _makeRequest2(Uri.encodeFull(_currentUrl));
                              // This reload is used to reload back and cancel youtube loading
                              _controller.reload();
                            }
                          }
                        },
                        // onPageStarted: (_) async {
                        //   var _currentUrl = await _controller.currentUrl();
                        //   print(_currentUrl);
                        //   if (_currentUrl!.isNotEmpty &&
                        //       _currentUrl.endsWith('.mp4')) {
                        //     _makeRequest2("https://www.statuslagao.com/$_currentUrl");
                        //   }
                        // },
                      ),
                    ),
                  ],
                ),
                // Draggable Button Area
                Positioned(
                  width: 60,
                  height: (shouldDisplayExpandedDraggable == true) ? 210 : 60,
                  // In this Appbar height is fixed at 52
                  bottom: (floatingY != 15)
                      ? (MediaQuery.of(context).size.height - 60 - floatingY)
                      : 15,
                  right: (floatingX != 15)
                      ? (MediaQuery.of(context).size.width - 60 - floatingX)
                      : 15,
                  child: Draggable(
                    feedback: FloatingActionButton(
                        child: Icon(Icons.dashboard_rounded), onPressed: () {}),
                    childWhenDragging: Container(),
                    // onDragStarted: () {
                    //   setState(() {
                    //     shouldDisplayExpandedDraggable = false;
                    //     floatingY -= 120;
                    //   });
                    // },
                    onDragUpdate: (_) {
                      if (shouldDisplayExpandedDraggable == true) {
                        setState(() {
                          shouldDisplayExpandedDraggable = false;
                          floatingY -= 120;
                        });
                      }
                    },
                    onDragEnd: (details) {
                      print('${details.offset.dx} ${details.offset.dy}');
                      setState(() {
                        floatingX = details.offset.dx;
                        floatingY = details.offset.dy;
                      });
                    },
                    child: Column(
                      children: [
                        (shouldDisplayExpandedDraggable == true)
                            ? GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.only(
                                    bottom: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  padding: EdgeInsets.all(2),
                                  child: CircleAvatar(
                                    radius: 28,
                                    backgroundColor:
                                        Color.fromRGBO(36, 14, 123, 1),
                                    child: Icon(
                                      Icons.open_in_browser_rounded,
                                      size: 34,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  var url = await _controller.currentUrl();
                                  var connectivityResult = await (Connectivity()
                                      .checkConnectivity());
                                  if (connectivityResult !=
                                      ConnectivityResult.none) {
                                    try {
                                      if (await canLaunchUrl(Uri.parse(url!))) {
                                        await launchUrl(
                                          Uri.parse(url),
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
                                      builder: (context) {
                                        return AlertDialog(
                                          // title: Text('GECA'),
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
                                                    color: Color.fromRGBO(
                                                        36, 14, 123, 1),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 100,
                                                margin: EdgeInsets.fromLTRB(
                                                    10, 0, 10, 0),
                                                child: Icon(
                                                  Icons.network_check,
                                                  size: 48,
                                                  color: Color.fromRGBO(
                                                      36, 14, 123, 1),
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            GestureDetector(
                                              child: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 5, 0, 5),
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 0, 0, 1),
                                                  border: Border.all(
                                                    color: Color.fromRGBO(
                                                        255, 0, 0, 1),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                  'Close',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Signika',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 22,
                                                    letterSpacing: 2,
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
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
                                  // Duration used to stop button flash off before launching in web
                                  Future.delayed(Duration(seconds: 1))
                                      .then((value) {
                                    setState(() {
                                      shouldDisplayExpandedDraggable = false;
                                    });
                                  });
                                },
                              )
                            : Container(),
                        (shouldDisplayExpandedDraggable == true)
                            ? GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.only(
                                    bottom: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  padding: EdgeInsets.all(2),
                                  child: CircleAvatar(
                                    radius: 28,
                                    backgroundColor:
                                        Color.fromRGBO(36, 14, 123, 1),
                                    child: Icon(
                                      Icons.home_rounded,
                                      size: 34,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  // widget.pageNumberSelector(1);
                                  Navigator.pop(context);
                                },
                              )
                            : Container(),
                        (shouldDisplayExpandedDraggable == false)
                            ? GestureDetector(
                                child: Container(
                                  // alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(60),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(2),
                                  child: CircleAvatar(
                                    radius: 28,
                                    backgroundColor:
                                        Color.fromRGBO(255, 255, 255, 1),
                                    backgroundImage:
                                        AssetImage('assets/logoWebView.png'),
                                    // child: Image(
                                    //   image: AssetImage(widget.logo_edge),
                                    // ),
                                  ),
                                ),
                                onLongPress: () {
                                  // This website should change if other sites will use

                                  // if ((widget.initialUrl ==
                                  //     'https://www.ecajmer.ac.in')) {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => MyHome(),
                                  //     ),
                                  //   );
                                  // } else {
                                  Navigator.of(context).pop();
                                  // }
                                },
                                onTap: () {
                                  setState(() {
                                    shouldDisplayExpandedDraggable = true;
                                  });
                                },
                                onDoubleTap: () async {
                                  var connectivityResult = await (Connectivity()
                                      .checkConnectivity());
                                  if (connectivityResult !=
                                      ConnectivityResult.none) {
                                    _controller.reload();
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          // title: Text('GECA'),
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
                                                    color: Color.fromRGBO(
                                                        36, 14, 123, 1),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 100,
                                                margin: EdgeInsets.fromLTRB(
                                                    10, 0, 10, 0),
                                                child: Icon(
                                                  Icons.network_check,
                                                  size: 48,
                                                  color: Color.fromRGBO(
                                                      36, 14, 123, 1),
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            GestureDetector(
                                              child: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 5, 0, 5),
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 0, 0, 1),
                                                  border: Border.all(
                                                    color: Color.fromRGBO(
                                                        255, 0, 0, 1),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                  'Close',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Signika',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 22,
                                                    letterSpacing: 2,
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
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
                                },
                                // onLongPress: () {
                              )
                            : GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  padding: EdgeInsets.all(2),
                                  child: CircleAvatar(
                                    radius: 28,
                                    backgroundColor:
                                        Color.fromRGBO(255, 0, 0, 1),
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 34,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    shouldDisplayExpandedDraggable = false;
                                  });
                                },
                              ),
                      ],
                    ),
                  ),
                ),

                // Refresh Area
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    // child: Container(
                    //   color: Color.fromRGBO(0, 0, 0, 0.2),
                    //   height: MediaQuery.of(context).size.height * 0.25,
                    //   width: 500,
                    // ),
                    // onTapDown: (_) {
                    //   print("................");
                    // },
                    onVerticalDragEnd: (details) {
                      print('vert.............${details.primaryVelocity}');
                      // > 3500
                      if (details.primaryVelocity! > 1500) {
                        _controller.reload();
                      }
                    },
                    onVerticalDragUpdate: (details) {
                      // print('vert.............${details.delta}');
                      // print('vert.............${details.globalPosition}');
                      // print('vert.............${details.globalPosition.dy}');
                    },
                    // onVerticalDragDown: (details) {
                    //   print(
                    //       'vert.............${details.globalPosition}');
                    // },
                    onVerticalDragDown: (details) {
                      print('asd ${details.globalPosition}');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

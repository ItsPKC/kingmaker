import 'package:flutter/material.dart';

// import 'package:google_fonts/google_fonts.dart';
class IntroScreen extends StatefulWidget {
  final Function performAction;
  const IntroScreen(this.performAction, {super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  var currentPageNumber = 0.0;
  final _colorList = const [
    Color.fromRGBO(100, 0, 255, 1),
    Color.fromARGB(255, 210, 6, 210),
    Color.fromRGBO(255, 60, 0, 1),
    Color.fromRGBO(255, 102, 0, 1),
    Color.fromRGBO(230, 0, 35, 1),
  ];
  final Shader linearColorTemplate = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: const [
      Color.fromRGBO(100, 0, 255, 1),
      Color.fromARGB(255, 210, 6, 210),
      Color.fromRGBO(255, 60, 0, 1),
      Color.fromRGBO(255, 102, 0, 1),
      Color.fromRGBO(230, 0, 35, 1),
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 225.0, 45.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 70),
          child: PageView(
            controller: _controller,
            onPageChanged: (value) {
              setState(() {
                currentPageNumber = value.toDouble();
                print(currentPageNumber);
                print(value);
              });
            },
            children: [
              Container(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 1),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: double.infinity,
                                width: double.infinity,
                                child: Opacity(
                                  opacity: 0.2,
                                  child: Image.asset(
                                    'assets/JoinTrendSquare.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: const [
                                    Color.fromRGBO(100, 0, 255, 1),
                                    Color.fromARGB(255, 210, 6, 210),
                                    Color.fromRGBO(255, 60, 0, 1),
                                    Color.fromRGBO(255, 102, 0, 1),
                                    Color.fromRGBO(230, 0, 35, 1),
                                  ],
                                ).createShader(
                                    Rect.fromLTWH(0.0, 0.0, 225.0, 45.0)),
                                child: Icon(
                                  Icons.trending_up_rounded,
                                  size: 200,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ClipPath(
                          clipper: BottomWaveClipper(),
                          child: Container(
                            padding: EdgeInsets.only(top: 10),
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              // borderRadius: BorderRadius.only(
                              //   topLeft: Radius.elliptical(
                              //     MediaQuery.of(context).size.width,
                              //     50,
                              //   ),
                              //   topRight: Radius.elliptical(
                              //     MediaQuery.of(context).size.width,
                              //     50,
                              //   ),
                              // ),
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Get Trending\n',
                                    style: TextStyle(
                                      // color: Color.fromRGBO(36, 14, 123, 1),
                                      fontSize: 36,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                      fontFamily: 'Kalam',
                                      fontFamilyFallback: const ['Signika'],
                                      foreground: Paint()
                                        ..shader = linearColorTemplate,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '\n#hashtag #audio #reels\n#shorts #snap #memes\nand many more',
                                    style: TextStyle(
                                      // color: Color.fromRGBO(230, 0, 0, 1),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      letterSpacing: 1,
                                      fontFamily: 'Kalam',
                                      fontFamilyFallback: const ['Signika'],
                                      foreground: Paint()
                                        ..shader = linearColorTemplate,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 1),
                          ),
                          child: Image.asset(
                              'assets/gif/InterconnectAllYourProfiles.gif'),
                        ),
                      ),
                      Expanded(
                        child: ClipPath(
                          clipper: BottomWaveClipper(),
                          child: Container(
                            padding: EdgeInsets.only(top: 10),
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              // borderRadius: BorderRadius.only(
                              //   topLeft: Radius.elliptical(
                              //     MediaQuery.of(context).size.width,
                              //     50,
                              //   ),
                              //   topRight: Radius.elliptical(
                              //     MediaQuery.of(context).size.width,
                              //     50,
                              //   ),
                              // ),
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Interconnect\n',
                                    style: TextStyle(
                                      // color: Color.fromRGBO(36, 14, 123, 1),
                                      fontSize: 36,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                      fontFamily: 'Kalam',
                                      fontFamilyFallback: const ['Signika'],
                                      foreground: Paint()
                                        ..shader = linearColorTemplate,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'All Your Links',
                                    style: TextStyle(
                                      // color: Color.fromRGBO(230, 0, 0, 1),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      letterSpacing: 1,
                                      fontFamily: 'Kalam',
                                      fontFamilyFallback: const ['Signika'],
                                      foreground: Paint()
                                        ..shader = linearColorTemplate,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Image.asset(
                              'assets/gif/OpenEveryLinkInTheApp.gif'),
                        ),
                      ),
                      Expanded(
                        child: ClipPath(
                          clipper: BottomWaveClipper(),
                          child: Container(
                            padding: EdgeInsets.only(top: 10),
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              // borderRadius: BorderRadius.only(
                              //   topLeft: Radius.elliptical(
                              //     MediaQuery.of(context).size.width,
                              //     50,
                              //   ),
                              //   topRight: Radius.elliptical(
                              //     MediaQuery.of(context).size.width,
                              //     50,
                              //   ),
                              // ),
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Open Links\n',
                                    style: TextStyle(
                                      // color: Color.fromRGBO(36, 14, 123, 1),
                                      fontSize: 36,
                                      fontFamily: 'Kalam',
                                      fontFamilyFallback: const ['Signika'],
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                      foreground: Paint()
                                        ..shader = linearColorTemplate,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'In The App',
                                    style: TextStyle(
                                      // color: Color.fromRGBO(230, 0, 35, 1),
                                      fontSize: 20,
                                      fontFamily: 'Kalam',
                                      fontFamilyFallback: const ['Signika'],
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                      foreground: Paint()
                                        ..shader = linearColorTemplate,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child:
                              Image.asset('assets/gif/MergeYourAudience.gif'),
                        ),
                      ),
                      Expanded(
                        child: ClipPath(
                          clipper: BottomWaveClipper(),
                          child: Container(
                            padding: EdgeInsets.only(top: 10),
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              // borderRadius: BorderRadius.only(
                              //   topLeft: Radius.elliptical(
                              //     MediaQuery.of(context).size.width,
                              //     50,
                              //   ),
                              //   topRight: Radius.elliptical(
                              //     MediaQuery.of(context).size.width,
                              //     50,
                              //   ),
                              // ),
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'MERGE\n',
                                    style: TextStyle(
                                      // color: Color.fromRGBO(36, 14, 123, 1),
                                      fontSize: 36,
                                      fontFamily: 'Kalam',
                                      fontFamilyFallback: const ['Signika'],
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                      foreground: Paint()
                                        ..shader = linearColorTemplate,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Your Audience',
                                    style: TextStyle(
                                      // color: Color.fromRGBO(230, 0, 0, 1),
                                      fontSize: 20,
                                      fontFamily: 'Kalam',
                                      fontFamilyFallback: const ['Signika'],
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                      foreground: Paint()
                                        ..shader = linearColorTemplate,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Screen4(),
            ],
          ),
        ),
      ),
      bottomSheet: BottomSheet(
          onClosing: () {},
          enableDrag: false,
          builder: (context) {
            return Container(
              height: 70,
              color: Color.fromRGBO(247, 247, 247, 1),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // if (currentPageNumber != 0) {
                        _controller.previousPage(
                          duration: Duration(
                            milliseconds: 400,
                          ),
                          curve: Curves.easeOut,
                        );
                        // }
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                        color: Colors.transparent, // To activate touch
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.keyboard_double_arrow_left_rounded,
                              color: Color.fromRGBO(36, 14, 123, 1),
                              size: 18,
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(36, 14, 123, 1),
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Signika',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 16,
                        alignment: Alignment.center,
                        child: Container(
                          height: 7,
                          width: (currentPageNumber == 0) ? 14 : 7,
                          decoration: BoxDecoration(
                            color: (currentPageNumber == 0)
                                ? Color.fromRGBO(36, 14, 123, 1)
                                : Color.fromRGBO(190, 190, 190, 1),
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                              colors: _colorList,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 16,
                        alignment: Alignment.center,
                        child: Container(
                          height: 7,
                          width: (currentPageNumber == 1) ? 17 : 7,
                          decoration: BoxDecoration(
                            color: (currentPageNumber == 1)
                                ? Color.fromRGBO(36, 14, 123, 1)
                                : Color.fromRGBO(190, 190, 190, 1),
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                              colors: _colorList,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 16,
                        alignment: Alignment.center,
                        child: Container(
                          height: 7,
                          width: (currentPageNumber == 2) ? 14 : 7,
                          decoration: BoxDecoration(
                            color: (currentPageNumber == 2)
                                ? Color.fromRGBO(36, 14, 123, 1)
                                : Color.fromRGBO(190, 190, 190, 1),
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                              colors: _colorList,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 16,
                        alignment: Alignment.center,
                        child: Container(
                          height: 7,
                          width: (currentPageNumber == 3) ? 14 : 7,
                          decoration: BoxDecoration(
                            color: (currentPageNumber == 3)
                                ? Color.fromRGBO(36, 14, 123, 1)
                                : Color.fromRGBO(190, 190, 190, 1),
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                              colors: _colorList,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (currentPageNumber != 3) {
                          _controller.nextPage(
                            duration: Duration(
                              milliseconds: 400,
                            ),
                            curve: Curves.easeOut,
                          );
                        } else {
                          widget.performAction();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 15),
                        alignment: Alignment.centerRight,
                        color: Colors.transparent, // To activate touch
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              currentPageNumber == 3 ? 'Finish' : 'Next',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(36, 14, 123, 1),
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Signika',
                              ),
                            ),
                            SizedBox(width: 3),
                            if (currentPageNumber != 3)
                              Icon(
                                Icons.keyboard_double_arrow_right_rounded,
                                color: Color.fromRGBO(36, 14, 123, 1),
                                size: 18,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

// class Screen1 extends StatefulWidget {
//   const Screen1({super.key});

//   @override
//   State<Screen1> createState() => _Screen1State();
// }

// class _Screen1State extends State<Screen1> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//   var initialAppDemo = prefs.getInt('initialAppDemo') ?? 0;
//   Future getValue() async {
//     return Future.delayed(Duration(milliseconds: 5000), () {
//       var value = '5';
//       return value;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset('assets/KingmakerGuidePromo.mp4');
//     _initializeVideoPlayerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     // Ensure disposing of the VideoPlayerController to free up resources.
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               Container(
//                 color: Colors.white,
//                 child: AspectRatio(
//                   aspectRatio: 9 / 16,
//                   child: FutureBuilder(
//                     future: _initializeVideoPlayerFuture,
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.done) {
//                         _controller.play();
//                         // If the VideoPlayerController has finished initialization, use
//                         // the data it provides to limit the aspect ratio of the video.
//                         return AspectRatio(
//                           aspectRatio: _controller.value.aspectRatio,
//                           // Use the VideoPlayer widget to display the video.
//                           child: VideoPlayer(_controller),
//                         );
//                       } else {
//                         // If the VideoPlayerController is still initializing, show a
//                         // loading spinner.
//                         return const Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   _controller.play();
//                 },
//                 child: Container(
//                   margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Color.fromRGBO(255, 255, 255, 1),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Color.fromRGBO(0, 0, 0, 0.35),
//                         offset: Offset(0, 1),
//                         blurRadius: 1,
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Icon(
//                       Icons.replay_rounded,
//                       size: 42,
//                       color: Color.fromRGBO(36, 14, 123, 1),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, 40.0);
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 40.0);

    // for (int i = 0; i < 4; i++) {
    // if (i % 2 == 0) {
    //   path.quadraticBezierTo(
    //       size.width - (size.width / 16) - (i * size.width / 8),
    //       0.0,
    //       size.width - ((i + 1) * size.width / 8),
    //       size.height - 160);
    // } else {
    //   path.quadraticBezierTo(
    //       size.width - (size.width / 16) - (i * size.width / 8),
    //       size.height - 120,
    //       size.width - ((i + 1) * size.width / 8),
    //       size.height - 160);
    // }
    // }

    path.quadraticBezierTo(size.width * 5 / 6, 40, size.width * 4 / 6, 20);
    path.quadraticBezierTo(size.width / 2, 0, size.width * 2 / 6, 20);
    path.quadraticBezierTo(size.width * 1 / 6, 40, 0, 40);
    path.lineTo(0.0, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

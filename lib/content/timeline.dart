import 'package:flutter/material.dart';

class Timeline extends StatefulWidget {
  final Function _pageNumberSelector;
  Timeline(this._pageNumberSelector);
  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  myGrid(imageAddress, blockTitle, navRoute) {
    return GestureDetector(
      onTap: navRoute,
      child: AspectRatio(
        aspectRatio: 7 / 3,
        child: Container(
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
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 0.75,
                child: Container(
                  alignment: Alignment.center,
                  color: Color.fromRGBO(0, 0, 0, 0.0),
                  child: Text('f'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                    // color: Colors.amber,
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Share Video Post.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        height: 1.25,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: const [
                        Icon(
                          // Icons.timer_rounded,
                          // Icons.access_time_filled_rounded,
                          // Icons.access_time_rounded,
                          Icons.task_alt_rounded,
                          color: Colors.deepOrange,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '27/11/2022',
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('12:00 PM'),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Row(
                          children: [
                            Icon(
                              Icons.monetization_on_rounded,
                              // size: 22,
                              color: Colors.deepOrange,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '0.1',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            )
                          ],
                        ),
                        Text(
                          'Pending',
                          // 'Rejected',
                          // 'Paid'
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                            color: Color.fromRGBO(0, 0, 255, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => widget._pageNumberSelector(1),
      // child: Container(
      //   color: Color.fromRGBO(247, 247, 247, 1),
      //   child: ListView(
      //     keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      //     children: [
      //       AspectRatio(
      //         aspectRatio: 7 / 2,
      //         child: Container(
      //           padding: EdgeInsets.all(10),
      //           decoration: BoxDecoration(
      //             color: Color.fromRGBO(220, 255, 220, 1),
      //             // color: Color.fromRGBO(0, 0, 0, 1),
      //             borderRadius: BorderRadius.only(
      //               bottomLeft: Radius.circular(8),
      //               bottomRight: Radius.circular(8),
      //             ),
      //             boxShadow: const [
      //               BoxShadow(
      //                 color: Colors.grey,
      //                 offset: Offset(0, 0.5),
      //                 blurRadius: 0.25,
      //               ),
      //             ],
      //             // gradient: LinearGradient(
      //             //   colors: const [
      //             //     Color.fromRGBO(0, 0, 0, 1),
      //             //     Color.fromRGBO(0, 0, 0, 0.8),
      //             //   ],
      //             //   begin: Alignment.topCenter,
      //             //   end: Alignment.bottomCenter,
      //             // ),
      //           ),
      //           child: Row(
      //             children: [
      //               Expanded(
      //                 child: Container(
      //                   margin: EdgeInsets.only(right: 5),
      //                   padding: EdgeInsets.only(bottom: 10),
      //                   decoration: BoxDecoration(
      //                     // color: Color.fromRGBO(255, 255, 255, 1),
      //                     // color: Color.fromRGBO(0, 255, 0, 0.1),
      //                     borderRadius: BorderRadius.circular(5),
      //                   ),
      //                   child: Column(
      //                     children: const [
      //                       Expanded(
      //                         child: Center(
      //                           child: Text(
      //                             '1240',
      //                             style: TextStyle(
      //                               color: Color.fromRGBO(255, 0, 0, 1),
      //                               fontSize: 24,
      //                               fontFamily: 'Signika',
      //                               fontWeight: FontWeight.w600,
      //                               letterSpacing: 2,
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                       Text(
      //                         'Completed',
      //                         style: TextStyle(
      //                           color: Color.fromRGBO(255, 0, 0, 1),
      //                           fontSize: 15,
      //                           fontWeight: FontWeight.w500,
      //                           letterSpacing: 1.5,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               Expanded(
      //                 child: Container(
      //                   margin: EdgeInsets.symmetric(horizontal: 5),
      //                   padding: EdgeInsets.only(bottom: 10),
      //                   decoration: BoxDecoration(
      //                     // color: Color.fromRGBO(255, 255, 255, 1),
      //                     // color: Color.fromRGBO(0, 255, 0, 0.1),
      //                     borderRadius: BorderRadius.circular(5),
      //                   ),
      //                   child: Column(
      //                     children: const [
      //                       Expanded(
      //                         child: Center(
      //                           child: Text(
      //                             '1232',
      //                             style: TextStyle(
      //                               color: Color.fromRGBO(255, 0, 0, 1),
      //                               fontSize: 24,
      //                               fontFamily: 'Signika',
      //                               fontWeight: FontWeight.w600,
      //                               letterSpacing: 2,
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                       Text(
      //                         'Accepted',
      //                         style: TextStyle(
      //                           color: Color.fromRGBO(255, 0, 0, 1),
      //                           fontSize: 15,
      //                           fontWeight: FontWeight.w500,
      //                           letterSpacing: 1.5,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               Expanded(
      //                 child: Container(
      //                   margin: EdgeInsets.only(left: 5),
      //                   padding: EdgeInsets.only(bottom: 10),
      //                   decoration: BoxDecoration(
      //                     // color: Color.fromRGBO(255, 255, 255, 1),
      //                     // color: Color.fromRGBO(0, 255, 0, 0.1),
      //                     borderRadius: BorderRadius.circular(5),
      //                   ),
      //                   child: Column(
      //                     children: const [
      //                       Expanded(
      //                         child: Center(
      //                           child: Text(
      //                             '15',
      //                             style: TextStyle(
      //                               color: Color.fromRGBO(255, 0, 0, 1),
      //                               fontSize: 24,
      //                               fontFamily: 'Signika',
      //                               fontWeight: FontWeight.w600,
      //                               letterSpacing: 2,
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                       Text(
      //                         'Pending',
      //                         style: TextStyle(
      //                           color: Color.fromRGBO(255, 0, 0, 1),
      //                           fontSize: 15,
      //                           fontWeight: FontWeight.w500,
      //                           letterSpacing: 1.5,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       SizedBox(
      //         height: 20,
      //       ),
      //       myGrid(
      //         'assets/LeatherTexture/L53.jpg',
      //         'Survey',
      //         () {
      //           // Navigator.of(context).push(
      //           //   MaterialPageRoute(
      //           //     builder: (_) => Survey(),
      //           //   ),
      //           // );
      //         },
      //       ),
      //       myGrid(
      //         'assets/LeatherTexture/L73.jpg',
      //         'Daily Challenge',
      //         () {
      //           // Navigator.of(context).push(
      //           //   MaterialPageRoute(
      //           //     builder: (_) => WithImageProof(),
      //           //   ),
      //           // );
      //         },
      //       ),
      //       myGrid(
      //         'assets/LeatherTexture/L73.jpg',
      //         'Video Proof',
      //         () {
      //           // Navigator.of(context).push(
      //           //   MaterialPageRoute(
      //           //     builder: (_) => WithVideoProof(),
      //           //   ),
      //           // );
      //         },
      //       ),
      //       myGrid(
      //         'assets/LeatherTexture/L73.jpg',
      //         'Video Proof',
      //         () {
      //           // Navigator.of(context).push(
      //           //   MaterialPageRoute(
      //           //     builder: (_) => WithVideoProof(),
      //           //   ),
      //           // );
      //         },
      //       ),
      //       myGrid(
      //         'assets/LeatherTexture/L73.jpg',
      //         'Video Proof',
      //         () {
      //           // Navigator.of(context).push(
      //           //   MaterialPageRoute(
      //           //     builder: (_) => WithVideoProof(),
      //           //   ),
      //           // );
      //         },
      //       ),
      //       myGrid(
      //         'assets/LeatherTexture/L73.jpg',
      //         'Video Proof',
      //         () {
      //           // Navigator.of(context).push(
      //           //   MaterialPageRoute(
      //           //     builder: (_) => WithVideoProof(),
      //           //   ),
      //           // );
      //         },
      //       ),
      //       SizedBox(
      //         height: 30,
      //       )
      //     ],
      //   ),
      // ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(),
            Icon(
              Icons.timeline_rounded,
              color: Colors.grey,
              size: 48,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'No data found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

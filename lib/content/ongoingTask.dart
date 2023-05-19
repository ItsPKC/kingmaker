import 'package:flutter/material.dart';
import 'package:kingmaker/task/sharePost.dart';

class OngoingTask extends StatefulWidget {
  final Function _pageNumberSelector;
  OngoingTask(this._pageNumberSelector);
  @override
  State<OngoingTask> createState() => _OngoingTaskState();
}

class _OngoingTaskState extends State<OngoingTask> {
  myGrid(imageAddress, blockTitle, navRoute) {
    return GestureDetector(
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
                          Icons.access_time_rounded,
                          color: Colors.deepOrange,
                          size: 18,
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
                              // Icons.local_fire_department_outlined,
                              Icons.whatshot,
                              // size: 22,
                              color: Colors.deepOrange,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '10',
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
                          'View',
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
      // onTap: navRoute,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SharePost(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => widget._pageNumberSelector(1),
      child: Container(
        color: Color.fromRGBO(247, 247, 247, 1),
        child: ListView(
          // reverse: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          // padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //   crossAxisCount: 1,
          //   crossAxisSpacing: 15,
          //   mainAxisSpacing: 15,
          //   childAspectRatio: 5 / 2,
          // ),
          children: [
            SizedBox(
              height: 20,
            ),
            myGrid(
              'assets/LeatherTexture/L53.jpg',
              'Survey',
              () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => Survey(),
                //   ),
                // );
              },
            ),
            myGrid(
              'assets/LeatherTexture/L73.jpg',
              'Daily Challenge',
              () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => WithImageProof(),
                //   ),
                // );
              },
            ),
            myGrid(
              'assets/LeatherTexture/L73.jpg',
              'Video Proof',
              () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => WithVideoProof(),
                //   ),
                // );
              },
            ),
            myGrid(
              'assets/LeatherTexture/L73.jpg',
              'Video Proof',
              () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => WithVideoProof(),
                //   ),
                // );
              },
            ),
            myGrid(
              'assets/LeatherTexture/L73.jpg',
              'Video Proof',
              () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => WithVideoProof(),
                //   ),
                // );
              },
            ),
            myGrid(
              'assets/LeatherTexture/L73.jpg',
              'Video Proof',
              () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => WithVideoProof(),
                //   ),
                // );
              },
            ),
            myGrid(
              'assets/LeatherTexture/L73.jpg',
              'Video Proof',
              () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => WithVideoProof(),
                //   ),
                // );
              },
            ),
            myGrid(
              'assets/LeatherTexture/L73.jpg',
              'Video Proof',
              () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => WithVideoProof(),
                //   ),
                // );
              },
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

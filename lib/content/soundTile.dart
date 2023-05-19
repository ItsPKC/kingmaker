import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kingmaker/content/globalVariable.dart';
import 'package:kingmaker/content/previewSound.dart';

class SoundTile extends StatefulWidget {
  final _activeSoundIndex, _currentIndex;
  final Function setActiveSoundIndex, setIsSoundOn;
  final data;
  SoundTile(this._activeSoundIndex, this._currentIndex,
      this.setActiveSoundIndex, this.setIsSoundOn, this.data,
      {Key? key})
      : super(key: key);

  @override
  _SoundTileState createState() => _SoundTileState();
}

class _SoundTileState extends State<SoundTile> {
  var isSoundSourceFetching = false;
  playSoundPreview() async {
    // --------------------- For Firebase Storage  ------------------

    // Display loading indicator while loading download link
    // setState(() {
    //   isSoundSourceFetching = true;
    // });

    // try {
    //   final soundRef = storageRef.child(widget.data['fileLocation']);
    //   await soundRef.getDownloadURL().then((value) {
    //     soundSource = value;
    //     widget.setActiveSoundIndex(widget._currentIndex);
    //     widget.setIsSoundOn(false);
    //     setState(() {
    //       isSoundSourceFetching = false;
    //     });
    //   });
    // } catch (e) {
    //   print('Error');
    //   setState(() {
    //     isSoundSourceFetching = false;
    //   });
    // }

    // --------------------- For Hostinger Storage / Direct Source -------------------

    soundSource = widget.data['fileLocation'];
    widget.setActiveSoundIndex(widget._currentIndex);
    widget.setIsSoundOn(false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
      decoration: BoxDecoration(
        color: (widget._activeSoundIndex == widget._currentIndex)
            ? Color.fromRGBO(200, 255, 200, 1)
            : Color.fromRGBO(255, 255, 255, 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 0.5),
            blurRadius: 0.25,
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return Scaffold(
                  body: PreviewSound(widget.data),
                );
              },
            );
            Future.delayed(Duration(milliseconds: 50), () {
              widget.setActiveSoundIndex(-1);
              widget.setIsSoundOn(true);
            });
          },
          // Here padding is used to have splash on the whole tile including padding area
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
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
                          child: Container(
                            // To make background visible
                            color: Colors.transparent,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          // To make background visible
                          color: Colors.transparent,
                        ),
                      ),
                      isSoundSourceFetching
                          ? Container(
                              height: 35,
                              width: 35,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator())
                          : (widget._activeSoundIndex == widget._currentIndex)
                              ? GestureDetector(
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    color: Colors.transparent,
                                    child: Icon(
                                      Icons.pause_circle_rounded,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    widget.setActiveSoundIndex(-1);
                                    widget.setIsSoundOn(true);
                                  },
                                )
                              : GestureDetector(
                                  onTap: playSoundPreview,
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    color: Colors.transparent,
                                    child: Icon(
                                      Icons.volume_up_rounded,
                                      size: 32,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        // color: Colors.amber,
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.data['title'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.25,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.data['authorDetail'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.25,
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.emoji_events_rounded,
                                size: 20,
                                color: Colors.deepOrange,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                '${widget._currentIndex}',
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
                            '# ${'#'.allMatches(widget.data['hashtag']).length}',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Signika',
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 1),
                                child: Icon(
                                  Icons.arrow_circle_up_rounded,
                                  size: 16,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              Text(
                                ' ${widget.data['topCountries'][0]}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Signika',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.double_arrow_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class _SoundTileState extends State<SoundTile> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: AspectRatio(
//         aspectRatio: 7 / 3,
//         child: Container(
//           margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
//           decoration: BoxDecoration(
//             color: Color.fromRGBO(255, 255, 255, 1),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.grey,
//                 offset: Offset(0, 0.5),
//                 blurRadius: 0.25,
//               ),
//             ],
//             borderRadius: BorderRadius.circular(5),
//           ),
//           child: Row(
//             children: [
//               AspectRatio(
//                 aspectRatio: 0.75,
//                 child: Container(
//                   alignment: Alignment.center,
//                   color: Color.fromRGBO(255, 255, 255, 1),
//                   child: Column(
//                     children: [
//                       AspectRatio(
//                         aspectRatio: 1,
//                         child: Container(
//                           alignment: Alignment.center,
//                           color: Colors.greenAccent,
//                           child: Text('f'),
//                         ),
//                       ),
//                       Expanded(
//                         child: Container(
//                           margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
//                           color: Color.fromRGBO(240, 255, 240, 1),
//                           child: Text('Rank - 001'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                   child: Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
//                     // color: Colors.amber,
//                     alignment: Alignment.topLeft,
//                     child: Text(
//                       'Share Video Post.',
//                       textAlign: TextAlign.justify,
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 1.5,
//                         height: 1.25,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Row(
//                       children: const [
//                         Icon(
//                           // Icons.timer_rounded,
//                           // Icons.access_time_filled_rounded,
//                           // Icons.access_time_rounded,
//                           Icons.task_alt_rounded,
//                           color: Colors.deepOrange,
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Text(
//                           '27/11/2022',
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Text('12:00 PM'),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: const [
//                             Icon(
//                               Icons.monetization_on_rounded,
//                               // size: 22,
//                               color: Colors.deepOrange,
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Text(
//                               '0.1',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontFamily: 'Signika',
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.deepOrange,
//                               ),
//                             )
//                           ],
//                         ),
//                         // Text(
//                         //   'Pending',
//                         //   // 'Rejected',
//                         //   // 'Paid'
//                         //   style: TextStyle(
//                         //     fontSize: 18,
//                         //     fontFamily: 'Signika',
//                         //     fontWeight: FontWeight.w600,
//                         //     letterSpacing: 1,
//                         //     color: Color.fromRGBO(0, 0, 255, 1),
//                         //   ),
//                         // ),
//                         Icon(
//                           Icons.double_arrow_rounded,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ))
//             ],
//           ),
//         ),
//       ),
//       onTap: () {},
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoPermissionDenied extends StatefulWidget {
  const VideoPermissionDenied({super.key});

  @override
  State<VideoPermissionDenied> createState() => _VideoPermissionDeniedState();
}

class _VideoPermissionDeniedState extends State<VideoPermissionDenied> {
  isAccessGranted(context) async {
    var _status = await Permission.storage.status;
    if (_status.isGranted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            isAccessGranted(context);
            return false;
          },
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 40),
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.2,
                  child: Image.asset('assets/fileImage.png'),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 40, 20, 40),
                height: 25,
                child: FittedBox(
                  child: Text(
                    '{{  Video Permission Denied  }}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Signika',
                      fontSize: 20,
                      letterSpacing: 1,
                      color: Color.fromRGBO(255, 110, 0, 1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Divider(
              //   height: 50,
              //   endIndent: 5,
              //   indent: 5,
              //   thickness: 0.75,
              // ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 110, 0, 0.93),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0, 0.5),
                      blurRadius: 1,
                    )
                  ],
                ),
                margin: EdgeInsets.fromLTRB(15, 0, 15, 40),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'You may need to access and store media files like image, audio etc. Allow "KingMaker" to access the "Files & Media" on your device.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: 'Signika',
                          fontSize: 15,
                          height: 1.75,
                          // fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(255, 255, 255, 1),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(10),
                      // margin: EdgeInsets.all(2),
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Step 1  ::  Open Settings\nStep 2  ::  Permissions\nStep 3  ::  Photos and videos\nStep 4  ::  Allow\nStep 5  ::  Restart App',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 15,
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(25, 11, 25, 11),
                    // backgroundColor: Color.fromRGBO(37, 200, 102, 1)
                    // ,
                    side: BorderSide(
                      color: Color.fromRGBO(230, 0, 0, 1),
                    ),
                  ),
                  child: Text(
                    'Open Settings',
                    style: TextStyle(
                      fontFamily: 'Signika',
                      fontSize: 16,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(230, 0, 0, 1),
                      shadows: const [
                        Shadow(
                          color: Color.fromRGBO(0, 0, 0, 0.2),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    openAppSettings();
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

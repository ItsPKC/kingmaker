import 'package:flutter/material.dart';

class SharePost extends StatefulWidget {
  const SharePost({Key? key}) : super(key: key);

  @override
  _SharePostState createState() => _SharePostState();
}

class _SharePostState extends State<SharePost> {
  final _controller = TextEditingController();
  var showGuideVideo = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return false;
          },
          child: ListView(
            children: [
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  margin: (showGuideVideo == false)
                      ? EdgeInsets.fromLTRB(15, 20, 15, 20)
                      : EdgeInsets.fromLTRB(15, 20, 15, 0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(235, 235, 235, 1),
                    borderRadius: (showGuideVideo == true)
                        ? BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          )
                        : BorderRadius.circular(5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Task Guide',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Signika',
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      Text(
                        (showGuideVideo == false) ? 'view' : 'close',
                        style: TextStyle(
                          color: (showGuideVideo == false)
                              ? Color.fromRGBO(0, 0, 255, 1)
                              : Color.fromRGBO(255, 0, 0, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Signika',
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      (showGuideVideo == false)
                          ? Icon(
                              Icons.visibility_rounded,
                              color: Color.fromRGBO(0, 0, 255, 1),
                            )
                          : Icon(
                              Icons.visibility_off_rounded,
                              color: Color.fromRGBO(255, 0, 0, 1),
                            )
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    showGuideVideo = !showGuideVideo;
                  });
                },
              ),
              (showGuideVideo == true)
                  ? Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 20),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: Colors.amber,
                          child: Center(
                            child: Text(
                              'Pa-----',
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              // Divider(),

              // Details of Task
              Container(
                margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
                // color: Colors.pink,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share Video of facebook',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: 20,
                        fontFamily: 'Signika',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Step 1: S1\nStep 2: S2\nStep 3: S3',
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 1,
                        height: 1.5,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // gradient: LinearGradient(
                        //   colors: const [
                        //     Color.fromRGBO(255, 255, 255, 1),
                        //     Color.fromRGBO(245, 245, 245, 1)
                        //   ],
                        // ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'https://dpgram.com',
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(245, 245, 245, 1),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.copy),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // End of details of Task

              Divider(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      blurRadius: 0.25,
                      offset: Offset(0, 0.5),
                    ),
                  ],
                ),
                // padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: TextFormField(
                  controller: _controller,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Reference',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color.fromRGBO(255, 255, 255, 1),
                    // It also override default padding
                    contentPadding: EdgeInsets.only(
                      top: 20,
                      right: 20,
                      bottom: 15,
                      left: 15,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontFamily: 'Signika',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    fontSize: 20,
                  ),
                  // onChanged: (value) {
                  //   answer = value;
                  // },
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, right: 20),
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color.fromRGBO(255, 0, 0, 1)),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.fromLTRB(30, 8, 30, 8),
                    ),
                  ),
                  onPressed: () {
                    print(_controller.text);
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

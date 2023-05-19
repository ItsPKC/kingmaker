import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kingmaker/content/globalVariable.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({Key? key}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final _storage = FirebaseStorage.instance;
  final _db = FirebaseFirestore.instance;
  var isUploadingFile = false;
  XFile? result;
  File? _file;
  final _filePath = '';
  var croppedImage;
  var uploadProgress = 0;

  Future<void> _cropImage() async {
    croppedImage = await ImageCropper().cropImage(
      sourcePath: _file!.path,
      aspectRatioPresets: [
        // CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        // CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    setState(() {
      print('Cropped...');
      croppedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 0, 1),
        automaticallyImplyLeading: true,
        // leading: Icon(Icons.close),
        title: Text(
          'Update Profile',
          style: TextStyle(
            fontFamily: 'Signika',
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_file != null)
                GestureDetector(
                  child: Container(
                    height: min(300, MediaQuery.of(context).size.width * 0.8),
                    width: min(300, MediaQuery.of(context).size.width * 0.8),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(
                        min(150, MediaQuery.of(context).size.width * 0.4),
                      ),
                      image: DecorationImage(
                          // It not possible to add "Cropped file" in "File"
                          // So Get the path of "Cropped File" and put in File() will work.
                          image: FileImage(croppedImage != null
                              ? File(croppedImage.path)
                              : _file!),
                          fit: BoxFit.cover),
                    ),
                  ),
                  onTap: () async {
                    final ImagePicker _picker = ImagePicker();
                    result =
                        await _picker.pickImage(source: ImageSource.gallery);

                    if (result != null) {
                      setState(() {
                        // Reset Cropped Image if new image is selected
                        croppedImage = null;
                        _file = File(result!.path);
                      });
                      // _filePath = file.path;
                      print('######################################');
                      print(_file);
                      print(_filePath);
                    }
                  },
                )
              else
                GestureDetector(
                  child: ClipOval(
                    child: Container(
                      height: min(300, MediaQuery.of(context).size.width * 0.8),
                      width: min(300, MediaQuery.of(context).size.width * 0.8),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        // borderRadius: BorderRadius.circular(
                        //   min(150, MediaQuery.of(context).size.width * 0.4),
                        // ),
                      ),
                      child: (accountProfileImage != null)
                          ? ClipOval(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                  ),
                                  child: Image(
                                    image: accountProfileImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : FutureBuilder(
                              builder: (context, snapshot) {
                                print(
                                    '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^C1 ${snapshot.data}');
                                if (snapshot.data != null) {
                                  print(
                                      '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^C2 ${snapshot.data}');
                                  return CachedNetworkImage(
                                    imageUrl: '${snapshot.data}',
                                    imageBuilder: (context, imageProvider) {
                                      accountProfileImage = imageProvider;
                                      return Image(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        backgroundColor:
                                            Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/fileImage.png',
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }
                                return Center(
                                  child: CupertinoActivityIndicator(
                                    radius: 15,
                                  ),
                                );
                              },
                              future: getDownloadLink(privateInfo != null
                                  ? privateInfo['profile']
                                  : ''), // From global variables
                            ),
                    ),
                  ),
                  onTap: () async {
                    final ImagePicker _picker = ImagePicker();
                    result =
                        await _picker.pickImage(source: ImageSource.gallery);

                    if (result != null) {
                      setState(() {
                        _file = File(result!.path);
                      });
                      // _filePath = file.path;
                      print('######################################');
                      print(_file);
                      print(_filePath);
                    }
                  },
                ),
              _file != null
                  ? OutlinedButton(
                      onPressed: _cropImage, child: Icon(Icons.edit))
                  : Container(),
              OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    isUploadingFile
                        ? Color.fromRGBO(215, 255, 215, 1)
                        : Color.fromARGB(255, 255, 255, 255),
                  ),
                  fixedSize: MaterialStateProperty.all(
                    Size.fromWidth(
                      min(250, MediaQuery.of(context).size.width * 0.5),
                    ),
                  ),
                ),
                child: isUploadingFile
                    ? CupertinoActivityIndicator(
                        color: Color.fromRGBO(255, 0, 0, 1),
                        radius: 12,
                      )
                    : Text(
                        'Save',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 0, 0, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Signika',
                          letterSpacing: 1.5,
                        ),
                      ),
                onPressed: () {
                  if (isUploadingFile == false && _file != null) {
                    setState(() {
                      isUploadingFile = true;
                    });

                    var profilePath =
                        'users/$myAuthUID/profileImage/${_file!.path.split('/').last}'; // myAuthUID from globalVariable.dart

                    // It not possible to add  "Cropped file" in "File"
                    // So Get the path of "Cropped File" and put in File() will work.
                    final uploadTask = _storage
                        .ref()
                        .child(profilePath)
                        .putFile(croppedImage != null
                            ? File(croppedImage.path)
                            : _file!);
                    // Listen for state changes, errors, and completion of the upload.
                    uploadTask.snapshotEvents.listen(
                      (TaskSnapshot taskSnapshot) {
                        switch (taskSnapshot.state) {
                          case TaskState.running:
                            final progress = 100.0 *
                                (taskSnapshot.bytesTransferred /
                                    taskSnapshot.totalBytes);

                            if (progress == 100) {
                              _db
                                  .collection('user')
                                  .doc(
                                      myAuthUID) // myAuthUID from globalVariable.dart
                                  .collection('private')
                                  .doc('privateData')
                                  .update({
                                'profile': profilePath,
                                'profilehistory':
                                    FieldValue.arrayUnion([profilePath])
                              }).then((value) {
                                print('------------------------');
                                accountProfileImage = null;
                                getPrivateInfo();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Profile Image updated successfully.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Signika',
                                        fontSize: 15,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 2000),
                                  ),
                                );

                                Future.delayed(Duration(milliseconds: 500), () {
                                  setState(() {
                                    isUploadingFile = false;
                                  });
                                  Navigator.of(context).pop();
                                });

                                // var asd = await _db
                                //     .collection("forum")
                                //     .doc(myAuthUID)
                                //     .collection("response")
                                //     .doc(_responseID)
                                //     .get();
                                // print(asd.data()!["discription"]);
                              }).onError((error, stackTrace) {
                                setState(() {
                                  isUploadingFile = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        Color.fromRGBO(230, 0, 0, 1),
                                    content: Text(
                                      'Failed to update.',
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Signika',
                                        fontSize: 15,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                );
                                print('Error');
                              });
                            }
                            setState(() {
                              setState(() {
                                uploadProgress = progress.truncate();
                              });
                            });
                            print('Upload is $progress% complete.');
                            break;
                          case TaskState.paused:
                            print('Upload is paused.');
                            break;
                          case TaskState.canceled:
                            print('Upload was canceled');
                            break;
                          case TaskState.error:
                            // Handle unsuccessful uploads
                            break;
                          case TaskState.success:
                            // Handle successful uploads on complete
                            // ...
                            break;
                        }
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

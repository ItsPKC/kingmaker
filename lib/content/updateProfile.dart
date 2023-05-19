import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kingmaker/content/globalVariable.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _storage = FirebaseStorage.instance;
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

  Future<void> updateImage(profilePath, dpGramProfile) async {
    print('---------------------------------------------$profilePath');
    var _updateImage = FirebaseFunctions.instanceFor(region: 'asia-south1')
        .httpsCallable('update_profile_image');
    await _updateImage(
            {'profilePath': profilePath, 'dpGramProfile': dpGramProfile})
        .then((value) {
      print('------------------------');
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
    }).onError((error, stackTrace) {
      setState(() {
        isUploadingFile = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromRGBO(230, 0, 0, 1),
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
      print('Data Not Uploaded - Error Found');
    }).catchError((error) {
      print('Failed to update: $error');
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
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: (_file != null)
                        ? Container(
                            height: min(
                                300, MediaQuery.of(context).size.width * 0.8),
                            width: min(
                                300, MediaQuery.of(context).size.width * 0.8),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              border: Border.all(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(
                                min(150,
                                    MediaQuery.of(context).size.width * 0.4),
                              ),
                              image: DecorationImage(
                                  // It not possible to add "Cropped file" in "File"
                                  // So Get the path of "Cropped File" and put in File() will work.
                                  image: FileImage(croppedImage != null
                                      ? File(croppedImage.path)
                                      : _file!),
                                  fit: BoxFit.cover),
                            ),
                          )
                        : ClipOval(
                            child: Container(
                              height: min(
                                  300, MediaQuery.of(context).size.width * 0.8),
                              width: min(
                                  300, MediaQuery.of(context).size.width * 0.8),
                              padding: EdgeInsets.all(
                                  3), // To compensete border of previous case
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
                                            imageBuilder:
                                                (context, imageProvider) {
                                              accountProfileImage =
                                                  imageProvider;
                                              return Image(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                            placeholder: (context, url) =>
                                                Center(
                                              child: CircularProgressIndicator(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                backgroundColor: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
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
                                      future: getDownloadLink(
                                          privateInfo != null
                                              ? privateInfo['profile']
                                              : ''), // From global variables
                                    ),
                            ),
                          ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker _picker = ImagePicker();
                      // Pick an image
                      result =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (result != null) {
                        setState(() {
                          _file = File(result!.path);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(milliseconds: 750),
                              content: Text(
                                'Please Wait ...',
                                style: TextStyle(letterSpacing: 1),
                              ),
                            ),
                          );
                        });
                        // _filePath = file.path;
                        print('######################################');
                        print(_file);
                        print(_filePath);
                      }
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 0.5),
                            blurRadius: 2,
                          )
                        ],
                      ),
                      child: Icon(
                        Icons.add_a_photo_rounded,
                        size: 24,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  (_file != null && isUploadingFile)
                      ? Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Center(
                            child: LinearProgressIndicator(
                              value: uploadProgress.toDouble() / 100,
                              backgroundColor:
                                  Color.fromRGBO(255, 255, 255, 0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromRGBO(255, 0, 0, 1),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (_file != null)
                        OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                          onPressed: _cropImage,
                          child: Icon(
                            Icons.crop_rounded,
                            size: 24,
                            color: Color.fromRGBO(230, 0, 0, 1),
                          ),
                        ),
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
                                'Update',
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
                                      var tempProfileName =
                                          _file!.path.split('/').last;
                                      // Resized image of 300x300 will be used their.
                                      updateImage(profilePath,
                                          '${tempProfileName.split('.').first}_300x300.${tempProfileName.split('.').last}');
                                      // _db
                                      //     .collection('user')
                                      //     .doc(
                                      //         myAuthUID) // myAuthUID from globalVariable.dart
                                      //     .collection('private')
                                      //     .doc('privateData')
                                      //     .update({
                                      //   'profile': profilePath,
                                      //   'profileHistory':
                                      //       FieldValue.arrayUnion([profilePath])
                                      // })
                                      // .then((value) {
                                      //   print('------------------------');
                                      //   accountProfileImage = null;
                                      //   getPrivateInfo();
                                      //   ScaffoldMessenger.of(context).showSnackBar(
                                      //     SnackBar(
                                      //       content: Text(
                                      //         'Profile Image updated successfully.',
                                      //         style: TextStyle(
                                      //           fontWeight: FontWeight.w500,
                                      //           fontFamily: 'Signika',
                                      //           fontSize: 15,
                                      //           letterSpacing: 1.5,
                                      //         ),
                                      //       ),
                                      //       duration: Duration(milliseconds: 2000),
                                      //     ),
                                      //   );

                                      //   Future.delayed(Duration(milliseconds: 500),
                                      //       () {
                                      //     setState(() {
                                      //       isUploadingFile = false;
                                      //     });
                                      //     Navigator.of(context).pop();
                                      //   });
                                      // }).onError((error, stackTrace) {
                                      //   setState(() {
                                      //     isUploadingFile = false;
                                      //   });
                                      //   ScaffoldMessenger.of(context).showSnackBar(
                                      //     SnackBar(
                                      //       backgroundColor:
                                      //           Color.fromRGBO(230, 0, 0, 1),
                                      //       content: Text(
                                      //         'Failed to update.',
                                      //         style: TextStyle(
                                      //           color: Color.fromRGBO(
                                      //               255, 255, 255, 1),
                                      //           fontWeight: FontWeight.w500,
                                      //           fontFamily: 'Signika',
                                      //           fontSize: 15,
                                      //           letterSpacing: 1.5,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   );
                                      //   print('Error');
                                      // });
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
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please select new profile image.',
                                  style: TextStyle(letterSpacing: 1),
                                ),
                                duration: Duration(milliseconds: 750),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

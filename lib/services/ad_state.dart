import 'dart:core';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;
  AdState(this.initialization);
  String get bannerAdUnitId1 => 'ca-app-pub-4788716700673911/1053589345';
  String get bannerAdUnitId2 => 'ca-app-pub-4788716700673911/9738443319';
  // Interstitials Ads
  String get intersAdUnitId1 => 'ca-app-pub-4788716700673911/4486116639';
  String get intersAdUnitId2 => 'ca-app-pub-4788716700673911/1859953295';
  BannerAdListener get adListener => _adListener;
  final BannerAdListener _adListener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression is recorded for a NativeAd.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );
}

class GetDeviceSize {
  static int get myWidth {
    return ((window.physicalSize.width / window.devicePixelRatio) -
            (window.physicalSize.width / window.devicePixelRatio) % 20)
        .truncate();
  }
}

class Fire {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseFirestore get getInstance {
    return _firestore;
  }
}

// class TakePermission {
//   var context;
//   TakePermission(context) {
//     context = context;
//   }
//   Future<bool> get storage async {
//     var status = Permission.storage.status;
//     if (await status.isGranted) {
//       return true;
//     }
//     if (await status.isDenied) {
//       Permission.storage.request();
//     }
//     if (!(await status.isGranted)) {
//       Permission.storage.request();
//       return false;
//     }
//     if (await status.isPermanentlyDenied) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) {
//             return StoragePermissionDenied();
//           },
//         ),
//       );
//       return false;
//     }
//     return false;
//   }
// }

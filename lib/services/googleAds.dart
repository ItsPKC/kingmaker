import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// Ads Started -------------------------------

import '../content/globalVariable.dart';

// is Rewarded Ads Available
var isRewardedAdsAvailable = false;
var displayedFirstIntAds = false;

BannerAd? banner1;
var isAdsAvailableB1 = false;
int numBanner1Attempts = 0;
BannerAd? banner2;
var isAdsAvailableB2 = false;
int numBanner2Attempts = 0;

InterstitialAd? interstitialAd;
var isInterstitialAdsLoadingAttemped = false;
var interstitialAdsWaitingCounter = 0;

// Ads Refresh timing
var bAds1 = 90;
var bAds2 = 90;
var iAds1 = 120;
var iAds2 = 120;
var iAds3 = 120;
var iAds4 = 120;
// These two variable are used to control the visiblity of banner ads
var showBanner1 = 1;
var showBanner2 = 1;
intAdsRefreshTime(adsIndex) {
  switch (adsIndex) {
    case 1:
      return iAds1;
    case 2:
      return iAds2;
    case 3:
      return iAds3;
    case 4:
      return iAds4;
  }
}

setAdsData(doc) async {
  try {
    bAds1 = doc['bAds1'];
    await prefs.setInt('bAds1', bAds1);

    bAds2 = doc['bAds2'];
    await prefs.setInt('bAds2', bAds2);

    iAds1 = doc['iAds1'];
    await prefs.setInt('iAds1', iAds1);

    iAds2 = doc['iAds2'];
    await prefs.setInt('iAds2', iAds2);

    iAds3 = doc['iAds3'];
    await prefs.setInt('iAds3', iAds3);

    iAds4 = doc['iAds4'];
    await prefs.setInt('iAds4', iAds4);

    showBanner1 = doc['showBanner1'];
    await prefs.setInt('showBanner1', showBanner1);

    showBanner2 = doc['showBanner2'];
    await prefs.setInt('showBanner2', showBanner2);
    // print('My name is pankaj');
    // print(doc['bAds1']);
    // print(doc['bAds2']);
    // print(doc['iAds1']);
    // print(doc['iAds2']);
    // print(doc['iAds3']);
    // print(doc['iAds4']);
    // print(doc['appName']);
    // print(doc['date']);
    // print(doc['showBanner1']);
    // print(doc['showBanner2']);
  } catch (error) {
    print('Error in ads Reload time mapping');
  }
}

initialiseAdsData() {
  bAds1 = prefs.getInt('bAds1') ?? bAds1;

  bAds2 = prefs.getInt('bAds2') ?? bAds2;

  iAds1 = prefs.getInt('iAds1') ?? iAds1;

  iAds2 = prefs.getInt('iAds2') ?? iAds2;

  iAds3 = prefs.getInt('iAds3') ?? iAds3;

  iAds4 = prefs.getInt('iAds4') ?? iAds4;

  showBanner1 = prefs.getInt('showBanner1') ?? showBanner1;

  showBanner2 = prefs.getInt('showBanner2') ?? showBanner2;
}

// Interstitial Ads
int _numInterstitialLoadAttempts = 0;
var adUnitIdList = [
  'ca-app-pub-4788716700673911/4486116639',
  'ca-app-pub-4788716700673911/1859953295',
  'ca-app-pub-4788716700673911/9698166432',
  'ca-app-pub-4788716700673911/9589521078',
];
var adUnitIdIndex = 0;

void createInterstitialAd() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult != ConnectivityResult.none) {
    InterstitialAd.load(
      adUnitId: adUnitIdList[adUnitIdIndex],
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('Int ads $ad loaded');
          interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          interstitialAd = null;
          if (_numInterstitialLoadAttempts <= 3) {
            Future.delayed(Duration(seconds: intAdsRefreshTime(adUnitIdIndex)),
                () {
              createInterstitialAd();
            });
          }
        },
      ),
    );
    if (adUnitIdIndex == 3) {
      adUnitIdIndex = 0;
    } else {
      adUnitIdIndex += 1;
    }
  } else {
    if (_numInterstitialLoadAttempts <= 3) {
      print('Int ads recheck for load');
      Future.delayed(Duration(seconds: 2), () {
        createInterstitialAd();
      });
    }
  }
}

void showInterstitialAd() {
  if (interstitialAd == null) {
    print('Warning: attempt to show interstitial before loaded.');
    return;
  }
  displayedFirstIntAds = true;
  interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) =>
        print('Int ads onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print('Int ads $ad onAdDismissedFullScreenContent.');
      ad.dispose();
      Future.delayed(
        Duration(seconds: intAdsRefreshTime(adUnitIdIndex)),
        () {
          print('Waiting for Inters ............');
          createInterstitialAd();
          print('Waiting for Inters ............Finished');
        },
      );
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      print('Int ads $ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      Future.delayed(
        Duration(seconds: intAdsRefreshTime(adUnitIdIndex)),
        () {
          print('Waiting for Inters ............');
          createInterstitialAd();
          print('Waiting for Inters ............Finished');
        },
      );
    },
  );
  interstitialAd!.show();
  interstitialAd = null;
}

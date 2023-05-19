// import 'dart:io';
// import 'dart:math';

// import 'package:applovin_max/applovin_max.dart';

// Map? sdkConfiguration;

// String _interstitialAdUnitId =
//     Platform.isAndroid ? 'ANDROID_INTER_AD_UNIT_ID' : 'IOS_INTER_AD_UNIT_ID';

// var _interstitialRetryAttempt = 0;

// void initializeInterstitialAds() {
//   AppLovinMAX.setInterstitialListener(InterstitialListener(
//     onAdLoadedCallback: (ad) {
//       // Interstitial ad is ready to be shown. AppLovinMAX.isInterstitialReady(_interstitialAdUnitId) will now return 'true'
//       print('Interstitial ad loaded from ' + ad.networkName);

//       // Reset retry attempt
//       _interstitialRetryAttempt = 0;
//     },
//     onAdLoadFailedCallback: (adUnitId, error) {
//       // Interstitial ad failed to load
//       // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
//       _interstitialRetryAttempt = _interstitialRetryAttempt + 1;

//       int retryDelay = pow(2, min(6, _interstitialRetryAttempt)).toInt();

//       print('Interstitial ad failed to load with code ' +
//           error.code.toString() +
//           ' - retrying in ' +
//           retryDelay.toString() +
//           's');

//       Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
//         AppLovinMAX.loadInterstitial(_interstitialAdUnitId);
//       });
//     },
//     onAdDisplayedCallback: (ad) {},
//     onAdDisplayFailedCallback: (ad, error) {},
//     onAdClickedCallback: (ad) {},
//     onAdHiddenCallback: (ad) {},
//   ));

//   // Load the first interstitial
//   AppLovinMAX.loadInterstitial(_interstitialAdUnitId);
// }

// final String _rewardedAdUnitId = Platform.isAndroid
//     ? 'ANDROID_REWARDED_AD_UNIT_ID'
//     : 'IOS_REWARDED_AD_UNIT_ID';

// var _rewardedAdRetryAttempt = 0;

// void initializeRewardedAds() {
//   AppLovinMAX.setRewardedAdListener(RewardedAdListener(
//       onAdLoadedCallback: (ad) {
//         // Rewarded ad is ready to be shown. AppLovinMAX.isRewardedAdReady(_rewardedAdUnitId) will now return 'true'
//         print('Rewarded ad loaded from ' + ad.networkName);

//         // Reset retry attempt
//         _rewardedAdRetryAttempt = 0;
//       },
//       onAdLoadFailedCallback: (adUnitId, error) {
//         // Rewarded ad failed to load
//         // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
//         _rewardedAdRetryAttempt = _rewardedAdRetryAttempt + 1;

//         int retryDelay = pow(2, min(6, _rewardedAdRetryAttempt)).toInt();
//         print('Rewarded ad failed to load with code ' +
//             error.code.toString() +
//             ' - retrying in ' +
//             retryDelay.toString() +
//             's');

//         Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
//           AppLovinMAX.loadRewardedAd(_rewardedAdUnitId);
//         });
//       },
//       onAdDisplayedCallback: (ad) {},
//       onAdDisplayFailedCallback: (ad, error) {},
//       onAdClickedCallback: (ad) {},
//       onAdHiddenCallback: (ad) {},
//       onAdReceivedRewardCallback: (ad, reward) {}));
// }

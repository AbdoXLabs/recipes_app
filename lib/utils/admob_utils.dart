
import 'package:firebase_admob/firebase_admob.dart';
import 'package:recipes_app/configs/config.dart';



class AdmobUtils {

  static const String _testDevice = null; // change it with

  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: _testDevice != null ? <String>[_testDevice] : null,
    childDirected: false,
    designedForFamilies: true,
  );

  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: Config.bannerID, // change it with real one
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  static InterstitialAd createInterstitialAd() {
      return InterstitialAd(
        adUnitId: Config.interstitial,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("InterstitialAd event is $event");
        },
      )..load()..show();
  }
}
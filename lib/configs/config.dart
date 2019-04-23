import 'package:firebase_admob/firebase_admob.dart';

class Config {
  static final String base_url = 'http://ios.fasipro.com';
  static final String terms_url = 'http://www.google.com';
  static final String about_us_url = 'http://www.google.com';

  static final String appName = 'Recipes App';

  static final String iosAppId = "";
  static final String androidAppId = "";

  static final String admobAppID = 'ca-app-pub-8630423092275079~2611649187';

//  static final String bannerID = 'ca-app-pub-8630423092275079/7071614852';
//  static final String interstitial = 'ca-app-pub-8630423092275079/4024926917';
static final String bannerID = BannerAd.testAdUnitId;
  static final String interstitial = InterstitialAd.testAdUnitId;

  static bool personalizedAds = true;
}
class Config {

  static final String base_url = 'http://ios.fasipro.com';
  static final String terms_url = 'http://www.google.com';
  static final String about_us_url = 'http://www.google.com';

  static final String appName = 'Recipes App'; // name of the app

  static final String iosAppId = "ma.yalabs.recipesApp";
  static final String androidAppId = "ma.yalabs.recipes_app";

  static final String admobAppID = 'ca-app-pub-2670899878941270~1391084475'; // app id => admobe

  static final String bannerID = 'ca-app-pub-2670899878941270/2129451077'; // banner id => admob
  static final String interstitial = 'ca-app-pub-2670899878941270/3606184279'; // interstitial is => admob
//  static final String bannerID = BannerAd.testAdUnitId;
//  static final String interstitial = InterstitialAd.testAdUnitId;

  static bool personalizedAds = true;

  static int nClicksBeforeShowInterstitialAd = 2;
  static int recipeDetailsShowAdsCounter = 0;
  static int recipesPageShowAdsCounter = 0;

}
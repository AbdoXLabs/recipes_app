import 'package:url_launcher/url_launcher.dart';
import 'package:recipes_app/models/item_recipes.dart';
import 'package:recipes_app/configs/config.dart';

import 'package:html/parser.dart' show parse;
import 'dart:io';

class WebUtils {

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static String getShareText(ItemRecipes recipe) {
    var document = parse(recipe.news_description);
    String description = parse(document.body.text).documentElement.text;
    String message = '';
    if(Platform.isAndroid) {
      message = 'I Would like to share this with you. Here You Can Download This Application from PlayStore : https://play.google.com/store/apps/details?id=${Config.androidAppId}';
    } else if(Platform.isIOS) {
      message = 'I Would like to share this with you. Here You Can Download This Application from AppStore : https://itunes.apple.com/app/${Config.iosAppId}';
    }
    String text = '${recipe.news_heading} \n $description \n $message';
    print(text);
    return text;
  }


}
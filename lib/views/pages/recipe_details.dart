import 'dart:convert';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/configs/config.dart';
import 'package:recipes_app/models/item_recipes.dart';
import 'package:recipes_app/utils/admob_utils.dart';
import 'package:recipes_app/utils/lang.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipes_app/utils/web_utils.dart';
import 'package:share/share.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_html/flutter_html.dart';

class RecipeDetails extends StatefulWidget {
  RecipeDetails({Key key, this.recipe}) : super(key: key);

  final ItemRecipes recipe;

  @override
  _RecipeDetailsState createState() => new _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  final double expandedHeight = 200.0;
  final String favoritesKey = 'favorites';
  List<ItemRecipes> favoriteRecipes = [];
  bool _favorite = false;

  InterstitialAd _interstitialAd;

  _updateFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(favoritesKey, json.encode(favoriteRecipes));
  }

  _getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> temp = json.decode(prefs.getString(favoritesKey));
    if (temp.length != 0) {
      favoriteRecipes = temp.map((p) => ItemRecipes.fromMap(p)).toList();
      for (ItemRecipes recipe in favoriteRecipes) {
        if (recipe.news_heading == widget.recipe.news_heading) {
          setState(() {
            _favorite = true;
          });
          return;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getFavorites();

    Config.recipeDetailsShowAdsCounter ++;
    if(Config.recipeDetailsShowAdsCounter % Config.nClicksBeforeShowInterstitialAd == 0)
      _interstitialAd = AdmobUtils.createInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {

    String text = "<!DOCTYPE html><html dir=${Lang.isArabic(widget.recipe.news_description) ? 'rtl' : 'ltr'}><head>" +
        "<style type=\"text/css\">body{color: #525252; font-size: 30px;}" +
        "</style></head>" +
        "<body>" +
        widget.recipe.news_description +
        "</body></html>";

    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: expandedHeight,
                floating: false,
                pinned: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      _favorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_favorite) {
                        Iterator<ItemRecipes> it = favoriteRecipes.iterator;
                        while (it.moveNext()) {
                          ItemRecipes recipe = it.current;
                          if (recipe.news_heading ==
                              widget.recipe.news_heading) {
                            favoriteRecipes.remove(recipe);
                            return;
                          }
                        }
                      } else {
                        favoriteRecipes.add(widget.recipe);
                      }
                      _updateFavorites();
                      setState(() {
                        _favorite = !_favorite;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Share.share(WebUtils.getShareText(widget.recipe));
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    title: Text(widget.recipe.news_heading,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        )),
                    background: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.network(
                          Config.base_url +
                              '/upload/thumbs/' +
                              widget.recipe.news_image,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment(0.0, 0.0),
                              // 10% of the width, so there are ten blinds.
                              colors: [
                                const Color(0xAA000000),
                                const Color(0x66000000),
                                const Color(0x00FFFFEE)
                              ], // whitish to gray
                              //tileMode: TileMode.repeated, // repeats the gradient over the canvas
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 85, left: 8, right: 8),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Directionality(
                  textDirection: Lang.isArabic(text) ? TextDirection.rtl : TextDirection.ltr,
                  child: Html(
                    data: text,
                    //Optional parameters:
                    padding: EdgeInsets.all(8.0),
                    backgroundColor: Colors.white,
                    defaultTextStyle: TextStyle(fontFamily: 'serif'),
                    linkStyle: const TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
            )),
    ));
  }
}

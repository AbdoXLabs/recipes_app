import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipes_app/configs/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipes_app/models/item_recipes.dart';
import 'package:recipes_app/utils/admob_utils.dart';
import 'package:recipes_app/views/items/recipe_list_item.dart';

class FavoritesPage extends StatefulWidget {
  FavoritesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FavoritesPageState createState() => new _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {

  final String favoritesKey = 'favorites';
  List<Widget> items = [];


  @override
  void dispose() {
    super.dispose();
  }

  getRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> temp = json.decode(prefs.getString(favoritesKey));
    List<ItemRecipes> recipes =
        temp.map((p) => ItemRecipes.fromMap(p)).toList();

    List<Widget> widgets = new List<Widget>();
    recipes.forEach((recipe) {
      widgets.add(RecipeListItem(itemRecipes: recipe));
    });

    setState(() {
      items = widgets.length != 0 ? widgets : [];
    });
  }

  @override
  Widget build(BuildContext context) {

    getRecipes();

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          centerTitle: true,
          title: Text(
            widget.title,
            style: TextStyle(
              fontFamily: 'Distant Galaxy',
            ),
          ),
        ),
        body: Container(
          child: GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this would produce 2 rows.
            crossAxisCount: 2,
            children: items,
          ),
        ));
  }
}

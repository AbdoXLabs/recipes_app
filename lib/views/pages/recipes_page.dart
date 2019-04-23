import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:recipes_app/utils/admob_utils.dart';

import 'package:flutter/material.dart';
import 'package:recipes_app/configs/config.dart';
import 'package:recipes_app/utils/admob_utils.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:recipes_app/models/item_category.dart';
import 'package:recipes_app/models/item_recipes.dart';
import 'package:recipes_app/services/reciepes_service.dart';
import 'package:recipes_app/view_models/main_page_view_model.dart';
import 'package:recipes_app/views/items/recipe_list_item.dart';
import 'package:recipes_app/views/widgets/no_internet_connection.dart';

class RecipesPage extends StatefulWidget {
  RecipesPage({Key key, this.category}) : super(key: key);

  final ItemCategory category;

  @override
  _RecipesPageState createState() => new _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {

  MainPageViewModel viewModel;

  InterstitialAd _interstitialAd;

  List<Widget> getRecipes(List<ItemRecipes> recipes) {
    List<Widget> widgets = new List<Widget>();
    recipes.forEach((recipe) {
      widgets.add(RecipeListItem(itemRecipes: recipe));
    });
    return widgets.length != 0 ? widgets : null;
  }

  Future loadData() async {
    await viewModel.setRecieps(widget.category.cid);
  }

  @override
  void initState() {
    super.initState();

    viewModel = MainPageViewModel(api: RecipesService());
    loadData();

    _interstitialAd = AdmobUtils.createInterstitialAd()..load();
  }

  @override
  Widget build(BuildContext context) {

    _interstitialAd..load()..show();

    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text(
          widget.category.category_name,
          style: TextStyle(
            fontFamily: 'Distant Galaxy',
          ),
        ),
      ),
      body: ScopedModel<MainPageViewModel>(
        model: viewModel,
        child: ScopedModelDescendant<MainPageViewModel>(
          builder: (context, child, model) {
            return FutureBuilder<List<ItemRecipes>>(
              future: model.recipes,
              builder: (_, AsyncSnapshot<List<ItemRecipes>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(child: const CircularProgressIndicator());
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      var recipes = snapshot.data;
                      return Container(
                        child: GridView.count(
                          // Create a grid with 2 columns. If you change the scrollDirection to
                          // horizontal, this would produce 2 rows.
                          crossAxisCount: 2,
                          children: getRecipes(recipes),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return NoInternetConnection(
                        action: () async {
                          await model.setRecieps(widget.category.cid);
                        },
                      );
                    }
                }
              },
            );
          },
        ),
      ),
    );
  }
}

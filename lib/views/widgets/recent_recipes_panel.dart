import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:recipes_app/models/item_recipes.dart';
import 'package:recipes_app/view_models/main_page_view_model.dart';
import 'package:recipes_app/views/items/recipe_list_item.dart';
import 'package:recipes_app/views/widgets/no_internet_connection.dart';

class RecentRecipesPanel extends StatelessWidget {

  String filter = '';
  RecentRecipesPanel({this.filter});

  List<Widget> get_recipes(List<ItemRecipes> recipes) {
    if (filter == '' || filter == null) {
      List<Widget> widgets = new List<Widget>();
      recipes.forEach((recipe) {
        widgets.add(RecipeListItem(itemRecipes: recipe));
      });
      return widgets.length != 0 ? widgets : [];
    } else {
      // init
      List<ItemRecipes> filteredRecipes = [];
      List<Widget> widgets = new List<Widget>();

      // filter
      recipes.forEach((recipe) {
        if (recipe
            .news_heading
            .toLowerCase()
            .contains(filter.toLowerCase())) {
          filteredRecipes.add(recipe);
        }
      });
      // build widgets
      filteredRecipes.forEach((recipe) {
        widgets.add(RecipeListItem(itemRecipes: recipe));
      });
      return widgets.length != 0 ? widgets : [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainPageViewModel>(
      builder: (context, child, model) {
        return FutureBuilder<List<ItemRecipes>>(
          future: model.recent_recipes,
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
                      children: get_recipes(recipes),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return NoInternetConnection(
                    action: () async {
                      await model.setRecentRecieps();
                      await model.setCategories();
                      await model.setFavorites();
                    },
                  );
                }
            }
          },
        );
      },
    );
  }

}

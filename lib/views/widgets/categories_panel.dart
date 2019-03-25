import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:recipes_app/models/item_category.dart';
import 'package:recipes_app/view_models/main_page_view_model.dart';
import 'package:recipes_app/views/items/category_list_item.dart';
import 'package:recipes_app/views/widgets/no_internet_connection.dart';

class CategoriesPanel extends StatelessWidget {

  String filter = '';
  CategoriesPanel({this.filter});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainPageViewModel>(
      builder: (context, child, model) {
        return FutureBuilder<List<ItemCategory>>(
          future: model.categories,
          builder: (_, AsyncSnapshot<List<ItemCategory>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: const CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasData) {
                  var categories = snapshot.data;
                  return ListView.builder(
                    itemCount: categories == null ? 0 : categories.length,
                    itemBuilder: (_, int index) {
                      var category = categories[index];
                      // filter
                      if(filter == null || filter == '') {
                        return CategoryListItem(itemCategory: category);
                      } else {
                        if(category.category_name.toLowerCase().contains(filter.toLowerCase())) {
                          return CategoryListItem(itemCategory: category);
                        } else {
                          return null;
                        }
                      }
                    },
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
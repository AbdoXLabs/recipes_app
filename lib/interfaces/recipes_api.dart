import 'dart:async';
import 'package:recipes_app/models/item_recipes.dart';
import 'package:recipes_app/models/item_favorite.dart';
import 'package:recipes_app/models/item_category.dart';

abstract class IRecipesApi {

  Future<List<ItemRecipes>> getRecipes(int cid);
  Future<List<ItemFavorite>> getFavorites();
  Future<List<ItemCategory>> getCategories();
  Future<List<ItemRecipes>> getRecentRecipes();

}
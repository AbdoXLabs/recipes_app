import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:recipes_app/interfaces/recipes_api.dart';
import 'package:recipes_app/models/item_category.dart';
import 'package:recipes_app/models/item_favorite.dart';
import 'package:recipes_app/models/item_recipes.dart';
import 'package:recipes_app/configs/config.dart';

class RecipesService implements IRecipesApi {

  static final RecipesService _internal = RecipesService.internal();
  factory RecipesService () => _internal;
  RecipesService.internal();

  Future<dynamic> _getData(String url) async {
    var response = await http.get(url);
    var data = json.decode(response.body);
    return data;
  }

  @override
  Future<List<ItemCategory>> getCategories() async {
    var data = await _getData('${Config.base_url}/api.php');
    List<dynamic> categoriesData = data['Json'];
    List<ItemCategory> categories = categoriesData.map((p) => ItemCategory.fromMap(p)).toList();

    return categories;
  }

  @override
  Future<List<ItemFavorite>> getFavorites() async {

    // Get favorites from local storage
    //var data = await _getData('${Config.base_url}/api.php?cat_id=$cid');
    //List<dynamic> recipesData = data['Json'];
    //List<ItemRecipes> recipes = recipesData.map((p) => ItemRecipes.fromMap(p)).toList();

    return null;
  }

  @override
  Future<List<ItemRecipes>> getRecipes(int cid) async {
    var data = await _getData('${Config.base_url}/api.php?cat_id=$cid');
    List<dynamic> recipesData = data['Json'];
    List<ItemRecipes> recipes = recipesData.map((p) => ItemRecipes.fromMap(p)).toList();

    return recipes;
  }

  @override
  Future<List<ItemRecipes>> getRecentRecipes() async {
    var data = await _getData('${Config.base_url}/api.php?latest_news=50');
    List<dynamic> recipesData = data['Json'];
    List<ItemRecipes> recipes = recipesData.map((p) => ItemRecipes.fromMap(p)).toList();

    return recipes;
  }

}
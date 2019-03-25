import 'dart:async';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:recipes_app/models/item_category.dart';
import 'package:recipes_app/models/item_favorite.dart';
import 'package:recipes_app/models/item_recipes.dart';
import 'package:recipes_app/interfaces/recipes_api.dart';

class MainPageViewModel extends Model {
  Future<List<ItemCategory>> _categories;
  Future<List<ItemCategory>> get categories => _categories;
  set categories(Future<List<ItemCategory>> value) {
    _categories = value;
    notifyListeners();
  }

  Future<List<ItemFavorite>> _favorites;
  Future<List<ItemFavorite>> get favorites => _favorites;
  set favorites(Future<List<ItemFavorite>> value) {
    _favorites = value;
    notifyListeners();
  }

  Future<List<ItemRecipes>> _recipes;
  Future<List<ItemRecipes>> get recipes => _recipes;
  set recipes(Future<List<ItemRecipes>> value) {
    _recipes = value;
    notifyListeners();
  }

  Future<List<ItemRecipes>> _recent_recipes;
  Future<List<ItemRecipes>> get recent_recipes => _recent_recipes;
  set recent_recipes(Future<List<ItemRecipes>> value) {
    _recent_recipes = value;
    notifyListeners();
  }


  final IRecipesApi api;
  MainPageViewModel({@required this.api});


  Future<bool> setCategories() async {
    categories = api?.getCategories();
    return categories != null;
  }

  Future<bool> setRecieps(int cid) async {
    recipes = api?.getRecipes(cid);
    return recipes != null;
  }

  Future<bool> setRecentRecieps() async {
    recent_recipes = api?.getRecentRecipes();
    return recent_recipes != null;
  }

  Future<bool> setFavorites() async {
    favorites = api?.getFavorites();
    return favorites != null;
  }

}
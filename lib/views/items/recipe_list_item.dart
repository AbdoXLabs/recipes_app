import 'package:flutter/material.dart';
import 'package:recipes_app/configs/config.dart';
import 'package:recipes_app/models/item_recipes.dart';
import 'package:recipes_app/views/pages/recipe_details.dart';


class RecipeListItem extends StatelessWidget {

  final ItemRecipes itemRecipes;
  double item_hight = 120.0;

  RecipeListItem({@required this.itemRecipes});

  @override
  Widget build(BuildContext context) {

    item_hight = (MediaQuery.of(context).size.width / 2);

    var image = Image.network(
      Config.base_url + '/upload/thumbs/' + itemRecipes?.news_image,
      height: item_hight,
      width: item_hight,
      fit: BoxFit.fitWidth,
    );

    var title = Text(
      itemRecipes?.news_heading,
      style: TextStyle(
        fontSize: 20.0,
        color: Colors.white,
      ),
    );

    int lines = (itemRecipes?.news_heading.length / 17).toInt() + 1;
    print('lien : $lines\nlength: ${itemRecipes?.news_heading.length}');

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkResponse(
        onTap: () => _itemClick(context, itemRecipes),
        child: Stack(
          children: <Widget>[
            image,
            Container(
              width: MediaQuery.of(context).size.width,
              height: item_hight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment(0.0, 0.0), // 10% of the width, so there are ten blinds.
                  colors: [const Color(0xAA000000), const Color(0x66000000),const Color(0x00FFFFEE)], // whitish to gray
                  //tileMode: TileMode.repeated, // repeats the gradient over the canvas
                ),
              ),
              child: title,
              padding: EdgeInsets.fromLTRB(16.0, item_hight - (32*lines), 0.0, 8.0),
            ),
          ],
        ),
      ),
    );
  }

  void _itemClick(BuildContext context, ItemRecipes recipe) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetails(recipe : recipe),
        )
    );
  }
}
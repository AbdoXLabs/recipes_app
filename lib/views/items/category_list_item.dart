import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/item_category.dart';
import 'package:recipes_app/configs/config.dart';
import 'package:recipes_app/utils/admob_utils.dart';
import 'package:recipes_app/utils/lang.dart';
import 'package:recipes_app/views/pages/recipes_page.dart';


class CategoryListItem extends StatelessWidget {

  final ItemCategory itemCategory;
  final double item_hight = 140.0;

  static int clicks = 0;

  CategoryListItem({@required this.itemCategory});

  @override
  Widget build(BuildContext context) {

    var image = Image.network(
      Config.base_url + '/upload/category/' + itemCategory?.category_image,
      height: item_hight,
      fit: BoxFit.fitWidth,
      width: MediaQuery.of(context).size.width,
    );

    var title = Text(
      itemCategory.category_name,
      style: TextStyle(
        fontSize: 20.0,
        color: Colors.white,
      ),
      textDirection: Lang.isArabic(itemCategory.category_name) ? TextDirection.rtl : TextDirection.ltr,
    );

    return InkResponse(
      onTap: () => _itemClick(context, itemCategory),
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
                colors: [const Color(0x88000000), const Color(0x55000000),const Color(0x00FFFFEE)], // whitish to gray
                //tileMode: TileMode.repeated, // repeats the gradient over the canvas
              ),
            ),
            child: title,
            padding: EdgeInsets.fromLTRB(16.0, item_hight - 32, 0.0, 8.0),
          ),
        ],
      ),
    );
  }
  
  _itemClick(BuildContext context, ItemCategory category) {

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RecipesPage(category: category),
      )
    );


    if (clicks % Config.nClicksBeforeShowInterstitialAd == 0) {
      AdmobUtils.createInterstitialAd()
        ..load()
        ..show(
          anchorType: AnchorType.bottom,
          anchorOffset: 0.0,
        );
      clicks ++;
    }

  }

}
class ItemRecipes {
  String cid, category_name, category_image, cat_id, news_heading, news_description, news_image, news_date;

  ItemRecipes({
    this.cid,
    this.category_name,
    this.category_image,
    this.cat_id,
    this.news_heading,
    this.news_description,
    this.news_image,
    this.news_date,
  });



  ItemRecipes.fromMap(Map<String, dynamic> map) {
    cid = map['cid'];
    category_name = map['category_name'];
    category_image = map['category_image'];
    cat_id = map['cat_id'];
    news_heading = map['news_heading'];
    news_description = map['news_description'];
    news_image = map['news_image'];
    news_date = map['news_date'];
  }

  Map<String, dynamic> toJson() => {
    'cid': cid,
    'category_name': category_name,
    'category_image': category_image,
    'cat_id': cat_id,
    'news_heading': news_heading,
    'news_description': news_description,
    'news_image': news_image,
    'news_date': news_date,
  };
}
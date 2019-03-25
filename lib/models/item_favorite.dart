class ItemFavorite {
  String cat_id, cid, category_name, news_heading, news_image, news_description, news_date;
  int id;

  ItemFavorite({
    this.id,
    this.cat_id,
    this.cid,
    this.category_name,
    this.news_heading,
    this.news_image,
    this.news_description,
    this.news_date,
  });

  ItemFavorite.fromMap(Map<String, dynamic> map) {
    id = int.parse(map['id']);
    cat_id = map['cat_id'];
    cid = map['cid'];
    category_name = map['category_name'];
    news_heading = map['news_heading'];
    news_image = map['news_image'];
    news_description = map['news_description'];
    news_date = map['news_date'];
  }
}
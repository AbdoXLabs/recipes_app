class ItemCategory{
  String category_name, category_image;
  int cid;

  ItemCategory({
    this.cid,
    this.category_name,
    this.category_image,
  });

  ItemCategory.fromMap(Map<String, dynamic> map) {
    cid = int.parse(map['cid']);
    category_name = map['category_name'];
    category_image = map['category_image'];
  }
}
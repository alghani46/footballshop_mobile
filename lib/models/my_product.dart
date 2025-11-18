import 'dart:convert';


List<MyProduct> myProductListFromJson(String str) =>
    List<MyProduct>.from(
      json.decode(str).map((x) => MyProduct.fromJson(x)),
    );

String myProductListToJson(List<MyProduct> data) =>
    json.encode(data.map((x) => x.toJson()).toList());

class MyProduct {
  int id;
  String name;
  int price;
  String description;
  String thumbnail;
  String category;
  bool isFeatured;

  MyProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.thumbnail,
    required this.category,
    required this.isFeatured,
  });

  factory MyProduct.fromJson(Map<String, dynamic> json) => MyProduct(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        description: json["description"],
        thumbnail: json["thumbnail"] ?? "",
        category: json["category"],
        isFeatured: json["is_featured"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "description": description,
        "thumbnail": thumbnail,
        "category": category,
        "is_featured": isFeatured,
      };
}

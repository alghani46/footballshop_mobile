import 'dart:convert';


// Parse a *list* of products from JSON string
List<ProductResponse> productResponseListFromJson(String str) =>
    List<ProductResponse>.from(
      json.decode(str).map((x) => ProductResponse.fromJson(x)),
    );

// Convert a list of products back to JSON string (optional, but nice to have)
String productResponseListToJson(List<ProductResponse> data) =>
    json.encode(data.map((x) => x.toJson()).toList());


class ProductResponse {
  String model;
  int pk;
  Fields fields;

  ProductResponse({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String name;
  int price;
  String description;
  String thumbnail;
  String category;
  bool isFeatured;
  int user;

  Fields({
    required this.name,
    required this.price,
    required this.description,
    required this.thumbnail,
    required this.category,
    required this.isFeatured,
    required this.user,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        price: json["price"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        category: json["category"],
        isFeatured: json["is_featured"],
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "description": description,
        "thumbnail": thumbnail,
        "category": category,
        "is_featured": isFeatured,
        "user": user,
      };
}

import 'package:flutter/cupertino.dart';

class HomeModel {
  late bool status;
  DataHome? data;
  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    data = DataHome.fromJson(json["data"]);
  }
}

class DataHome {
  List<BannerModel> banners = [];
  List<ProductsModel> products = [];
  DataHome.fromJson(Map<String, dynamic> json) {
    json['banners'].forEach((element) {
      banners.add(BannerModel.fromJson(element));
    });
    json['products'].forEach((element) {
      products.add(ProductsModel.fromJson(element));
    });
  }
}

class BannerModel {
  int? id;
  String? image;
  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }
}

class ProductsModel {
  late int id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;
  late  bool inFavorites;
  late  bool inCart;
  ProductsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json["old_price"];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    inFavorites = json["in_favorites"];
    inCart = json["in_cart"];
  }
}

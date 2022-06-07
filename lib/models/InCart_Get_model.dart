import 'package:flutter/cupertino.dart';

class InCartGetModel {
  bool? status;
  String? message;
  InCartData? data;

  InCartGetModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = InCartData.fromJson(json['data']);
  }
}

class InCartData {
  List<CartItemsData> cartItems = [];
  dynamic subTotal;
  dynamic total;

  InCartData.fromJson(Map<String, dynamic> json) {
    json['cart_items'].forEach((e) {
      cartItems.add(CartItemsData.fromJson(e));
    });

    subTotal = json['sub_total'];
    total = json['total'];
  }
}

class CartItemsData {
  int? id;
  int? quantity;
  ProductData? product;

  CartItemsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product = ProductData.fromJson(json['product']);
  }
}

class ProductData {
  int? id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
  }
}

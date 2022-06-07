class SearchModel {
  bool? status;
  DataFavorites? data;

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data =
        json['data'] != null ? new DataFavorites.fromJson(json['data']) : null;
  }
}

class DataFavorites {
  int? currentPage;
  List<ProductSearchData>? data = [];
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  Null nextPageUrl;
  String? path;
  int? perPage;
  Null prevPageUrl;
  int? to;
  int? total;

  DataFavorites.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];

    json['data'].forEach((e) {
      data!.add(ProductSearchData.fromJson(e));
    });

    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }
}



class ProductSearchData {
  int? id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;
  String? description;

  ProductSearchData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}

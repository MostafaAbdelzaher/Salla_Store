class AddOrderModel {
  bool? status;
  String? message;

  AddOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}

class CancelOrderModel {
  bool? status;
  String? message;

  CancelOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}

class GetOrdersModel {
  bool? status;
  String? message;
  DataOrders? data;

  GetOrdersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = DataOrders.fromJson(json['data']);
  }
}

class DataOrders {
  int? currentPage;
  List<Data> data = [];
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? path;
  int? perPage;
  int? to;
  int? total;

  DataOrders.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }
}

class Data {
  int? id;
  dynamic total;
  String? date;
  String? status;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    date = json['date'];
    status = json['status'];
  }
}

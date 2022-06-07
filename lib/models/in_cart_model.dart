class InCartChange {
  bool? status;
  String? message;
  InCartChange.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}

class DeleteAddress {
  bool? status;
  String? message;

  DeleteAddress.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}

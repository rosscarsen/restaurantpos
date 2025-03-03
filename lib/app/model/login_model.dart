// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginModel {
  Data? data;
  String? info;
  int? status;
  bool? twoVerify;

  LoginModel({this.data, this.info, this.status, this.twoVerify});

  LoginModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    info = json['info'];
    status = json['status'];
    twoVerify = json['twoVerify'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['info'] = info;
    data['status'] = status;
    data['twoVerify'] = twoVerify;
    return data;
  }

  @override
  String toString() {
    return 'LoginModel(data: $data, info: $info, status: $status, twoVerify: $twoVerify)';
  }
}

class Data {
  String? company;
  String? cashier;
  String? user;
  String? pwd;
  String? webSit;

  Data({this.company, this.cashier, this.user, this.pwd});

  Data.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    cashier = json['cashier'];
    user = json['user'];
    pwd = json['pwd'];
    webSit = json['webSit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company'] = company;
    data['cashier'] = cashier;
    data['user'] = user;
    data['pwd'] = pwd;
    data['webSit'] = webSit;
    return data;
  }

  @override
  String toString() {
    return 'Data(company: $company, cashier: $cashier, user: $user, pwd: $pwd, webSit: $webSit)';
  }
}

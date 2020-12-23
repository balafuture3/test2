class Model2List {
  final List<Model2> list;

  Model2List({
    this.list,
  });
  factory Model2List.fromJson(List<dynamic> parsedJson) {

    List<Model2> lists = new List<Model2>();
    lists = parsedJson.map((i)=>Model2.fromJson(i)).toList();

    return new Model2List(
        list: lists
    );
  }
}




class Model2 {
  int empID;
  String firstName;

  Model2({this.empID, this.firstName});

  Model2.fromJson(Map<String, dynamic> json) {
    empID = json['empID'];
    firstName = json['firstName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empID'] = this.empID;
    data['firstName'] = this.firstName;
    return data;
  }
}

class Model3List {
  final List<Model2> list;

  Model3List({
    this.list,
  });
  factory Model3List.fromJson(List<dynamic> parsedJson) {

    List<Model2> lists = new List<Model2>();
    lists = parsedJson.map((i)=>Model2.fromJson(i)).toList();

    return new Model3List(
        list: lists
    );
  }
}




class Model3 {
  int empID;
  String firstName;

  Model3({this.empID, this.firstName});

  Model3.fromJson(Map<String, dynamic> json) {
    empID = json['empID'];
    firstName = json['firstName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empID'] = this.empID;
    data['firstName'] = this.firstName;
    return data;
  }
}
class Person {
  int? index;
  String? name;
  String? value;

  Person({this.index, this.name, this.value});

  Person.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}
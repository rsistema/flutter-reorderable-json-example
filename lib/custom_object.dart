class CustomObject {
  int? index;
  String? name;
  String? value;
  String? icon;

  CustomObject({this.index, this.name, this.value, this.icon});

  CustomObject.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    name = json['name'];
    value = json['value'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['name'] = this.name;
    data['value'] = this.value;
    data['icon'] = this.icon;
    return data;
  }
}
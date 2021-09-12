class BarrelConfiguration {
  String? _name;
  String? _description;
  String? _version;
  String? _flavour;

  String? get name => _name;
  String? get description => _description;
  String? get version => _version;
  String? get flavour => _flavour;

  BarrelConfiguration({
      String? name, 
      String? description, 
      String? version, 
      String? flavour}){
    _name = name;
    _description = description;
    _version = version;
    _flavour = flavour;
}

  BarrelConfiguration.fromMap(dynamic json) {
    _name = json['name'];
    _description = json['description'];
    _version = json['version'];
    _flavour = json['flavour'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['name'] = _name;
    map['description'] = _description;
    map['version'] = _version;
    map['flavour'] = _flavour;
    return map;
  }
}
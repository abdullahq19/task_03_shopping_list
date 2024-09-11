import 'dart:convert';

class Item {
  int? id;
  String name;
  Item({
    this.id,
    required this.name,
  });
  static const tableName = 'Items';
  static const colId = 'Id';
  static const colName = 'Name';

  static const String CREATE_TABLE =
      'CREATE TABLE IF NOT EXISTS $tableName ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT)';

  Item copyWith({
    int? id,
    String? name,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['Id'] != null ? map['Id'] as int : null,
      name: map['Name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Item(id: $id, name: $name)';

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

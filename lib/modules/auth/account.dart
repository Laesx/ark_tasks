class Account {
  const Account({
    required this.id,
    required this.name,
  });

  factory Account.fromMap(Map<String, dynamic> map) => Account(
        id: map['id'],
        name: map['name'],
      );

  final int id;
  final String name;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };
}

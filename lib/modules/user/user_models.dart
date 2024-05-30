class UserItem {
  UserItem({required this.id, required this.name, required this.imageUrl});

  // factory UserItem(Map<String, dynamic> map) => UserItem._(
  //       id: map['id'],
  //       name: map['name'],
  //       imageUrl: map['avatar']['large'],
  //     );

  final int id;
  final String name;
  final String imageUrl;
}

class User {
  User({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.bannerUrl,
  });

  // factory User(Map<String, dynamic> map) {
  //   return User._(
  //     id: map['id'],
  //     name: map['name'],
  //     imageUrl: map['avatar']['large'],
  //     bannerUrl: map['bannerImage'],
  //   );
  // }

  final int id;
  final String name;
  final String imageUrl;
  final String? bannerUrl;
}

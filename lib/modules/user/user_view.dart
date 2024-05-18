import 'package:ark_jots/modules/user/user_header.dart';
import 'package:ark_jots/modules/user/user_models.dart';
import 'package:ark_jots/widgets/layouts/scaffolds.dart';
import 'package:flutter/material.dart';

class UserView extends StatelessWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = User(
        id: 15,
        name: "John Doe",
        imageUrl:
            "https://s4.anilist.co/file/anilistcdn/user/avatar/large/b460805-oF5QFTje80wf.png",
        bannerUrl:
            "https://s4.anilist.co/file/anilistcdn/user/banner/b460805-nGwZ2Mq22yDi.jpg");
    return PageScaffold(
      child: CustomScrollView(slivers: [
        UserHeader(id: user.id, user: user, imageUrl: user.imageUrl)
      ]),
    );
  }
}

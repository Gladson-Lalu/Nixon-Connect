import 'package:flutter/material.dart';

import 'Components/profile_header.dart';
import 'Components/user_info.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: CustomScrollView(
          clipBehavior: Clip.none,
          slivers: [
            SliverAppBar(
              title: const Text('Profile'),
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    Ink(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F1.jpg?alt=media'),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Ink(
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          bottom: 0.0, right: 0.0),
                      alignment: Alignment.bottomRight,
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MaterialButton(
                              color: Colors.white,
                              shape: const CircleBorder(),
                              elevation: 0,
                              child: const Icon(Icons.edit),
                              onPressed: () {},
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: ProfileHeader(
                avatar: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F1.jpg?alt=media',
                ),
                title: "Ramesh Mana",
                subtitle: "Manager",
              ),
            ),
            const SliverToBoxAdapter(
              child: UserInfo(),
            ),
            const SliverToBoxAdapter(
              child: UserInfo(),
            ),
          ],
        ));
  }
}

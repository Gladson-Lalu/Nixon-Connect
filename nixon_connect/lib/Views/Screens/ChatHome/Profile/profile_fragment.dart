import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Cubit/auth/auth_cubit.dart';
import '../../../../Models/user_model.dart';
import 'Components/profile_header.dart';
import 'Components/user_info.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel? _user =
        BlocProvider.of<AuthCubit>(context).user;
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
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              Uri.parse(_user!.profileUrl)
                                  .toString()),
                        ),
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
            SliverToBoxAdapter(
              child: ProfileHeader(
                  avatar: CachedNetworkImageProvider(
                      Uri.parse(_user.profileUrl)
                          .toString()),
                  title: _user.name),
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

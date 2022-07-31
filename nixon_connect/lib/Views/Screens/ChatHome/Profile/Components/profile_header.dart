import 'package:flutter/material.dart';

import 'avatar.dart';

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> avatar;
  final String title;
  final String? subtitle;

  const ProfileHeader({
    Key? key,
    required this.avatar,
    required this.title,
    this.subtitle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
          top: 4, left: 12, right: 12, bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Avatar(
              image: avatar,
              radius: 60,
              backgroundColor: Colors.white,
              borderColor: Colors.grey.shade300,
              borderWidth: 4.0,
            ),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 5.0),
              Text(
                subtitle!,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

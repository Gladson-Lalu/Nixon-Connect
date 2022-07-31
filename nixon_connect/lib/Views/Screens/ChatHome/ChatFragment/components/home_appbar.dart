import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Conversations",
        style: TextStyle(
            fontSize: 32, fontWeight: FontWeight.bold),
      ),
      actions: const [
        Icon(
          Icons.add,
          color: Colors.pink,
          size: 20,
        ),
        SizedBox(
          width: 2,
        ),
        Text(
          "Add New",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

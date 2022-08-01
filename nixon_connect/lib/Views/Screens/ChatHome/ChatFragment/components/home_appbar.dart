import 'package:flutter/material.dart';

AppBar homeAppBar() {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: const Text(
      "Conversations",
      style: TextStyle(
          color: Colors.black,
          fontSize: 32,
          fontWeight: FontWeight.bold),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              primary: Colors.pink[50]),
          onPressed: () => {},
          icon: const Icon(
            Icons.add,
            color: Colors.pink,
            size: 20,
          ),
          label: Text(
            "Add New",
            style: TextStyle(
                color: Colors.grey.shade900,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ),
      )
    ],
  );
}

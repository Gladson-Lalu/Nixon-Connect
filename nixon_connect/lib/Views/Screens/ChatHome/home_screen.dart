import 'package:flutter/material.dart';
import 'package:nixon_connect/Common/constant.dart';
import 'package:nixon_connect/Views/Screens/ChatHome/Channels/channel_fragment.dart';
import 'package:nixon_connect/Views/Screens/ChatHome/Profile/profile_fragment.dart';

import 'ChatFragment/chat_fragment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextStyle textStyle =
      const TextStyle(fontWeight: FontWeight.w600);

  int bottomNavBarIndex = 0;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) => {
          setState(() {
            bottomNavBarIndex = index;
          })
        },
        children: const [
          ChatPage(),
          ChannelPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => {
          setState(() {
            bottomNavBarIndex = index;
            pageController.animateToPage(index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease);
          })
        },
        currentIndex: bottomNavBarIndex,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: textStyle,
        unselectedLabelStyle: textStyle,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            label: "Channels",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

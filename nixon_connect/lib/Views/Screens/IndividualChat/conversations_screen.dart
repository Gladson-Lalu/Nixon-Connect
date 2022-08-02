import 'package:flutter/material.dart';
import 'package:nixon_connect/Common/constant.dart';
import 'package:nixon_connect/Views/Screens/IndividualChat/components/individual_chat_screen.dart';

import '../../../Models/conversation_drawer_menu.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  _ConversationScreenState createState() =>
      _ConversationScreenState();
}

class _ConversationScreenState
    extends State<ConversationScreen> {
  int selectedIndex = -1;
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Row(children: [
          SafeArea(
              child: isExpanded
                  ? blackIconTiles()
                  : blackIconMenu()),
          const Expanded(child: ChatDetailPage())
        ]));
  }

  Widget blackIconTiles() {
    return Container(
      width: 250,
      color: kDrawerColor,
      child: Column(
        children: [
          controlTile(),
          Expanded(
            child: ListView.builder(
              itemCount: cdms.length,
              itemBuilder:
                  (BuildContext context, int index) {
                DrawerMenu cdm = cdms[index];
                bool selected = selectedIndex == index;
                return ExpansionTile(
                    onExpansionChanged: (z) {
                      setState(() {
                        selectedIndex = z ? index : -1;
                      });
                    },
                    leading:
                        Icon(cdm.icon, color: Colors.white),
                    title: Text(cdm.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    trailing: cdm.submenus.isEmpty
                        ? null
                        : Icon(
                            selected
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                    children: cdm.submenus.map((subMenu) {
                      return sMenuButton(subMenu, false);
                    }).toList());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget controlTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListTile(
        leading: buildCircleAvatar(),
        title: const Text("Room Name",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        onTap: expandOrShrinkDrawer,
      ),
    );
  }

  buildCircleAvatar() {
    return const CircleAvatar(
      backgroundImage: NetworkImage(
          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1374&q=80"),
      backgroundColor: Colors.white,
      radius: 30,
    );
  }

  Widget blackIconMenu() {
    return Container(
      width: 80,
      color: kDrawerColor,
      child: Column(
        children: [
          controlButton(),
          Expanded(
            child: ListView.builder(
                itemCount: cdms.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Icon(cdms[index].icon,
                          color: Colors.white),
                    ),
                  );
                }),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 80,
              child: Icon(Icons.keyboard_arrow_left_sharp,
                  color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget controlButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: InkWell(
          onTap: expandOrShrinkDrawer,
          child: buildCircleAvatar()),
    );
  }

  Widget subMenuWidget(
      List<String> submenus, bool isValidSubMenu) {
    return Container(
      height: isValidSubMenu
          ? submenus.length.toDouble() * 37.5
          : 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: isValidSubMenu
              ? kDrawerColor.withAlpha(900)
              : Colors.transparent,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          )),
      child: ListView.builder(
          padding: const EdgeInsets.all(6),
          itemCount: isValidSubMenu ? submenus.length : 0,
          itemBuilder: (context, index) {
            String subMenu = submenus[index];
            return sMenuButton(subMenu, index == 0);
          }),
    );
  }

  Widget sMenuButton(String subMenu, bool isTitle) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(subMenu,
            style: TextStyle(
              fontSize: isTitle ? 17 : 14,
              color: isTitle ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }

  List<DrawerMenu> cdms = [
    DrawerMenu(Icons.grid_view, "Dashboard",
        ["HTML", "CSS", "JS"]),
    DrawerMenu(Icons.settings, "Setting", []),
  ];

  void expandOrShrinkDrawer() {
    setState(() {
      selectedIndex = -1;
      isExpanded = !isExpanded;
    });
  }
}

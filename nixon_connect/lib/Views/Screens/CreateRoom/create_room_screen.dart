import 'package:flutter/material.dart';
import 'package:nixon_connect/Common/constant.dart';
import 'package:nixon_connect/Views/components/rounded_button.dart';
import 'package:nixon_connect/Views/components/rounded_input_field.dart';
import 'package:nixon_connect/Views/components/rounded_password_field.dart';
import 'package:nixon_connect/Views/components/text_field_container.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({Key? key}) : super(key: key);

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final List<String> _roomTypes = [
    'Public',
    'Community',
    'Guided',
    'Friendzone'
  ];
  String? _chosenValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: kTextColor,
            size: 24,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Create Room",
            style: TextStyle(
                color: kTextColor,
                fontSize: 24,
                fontWeight: FontWeight.w500),
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.05),
                  RoundedInputField(
                      hintText: "Room Name",
                      icon: Icons.group,
                      onChanged: onChangedRoomName),
                  TextFieldContainer(
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list,
                            color: kPrimaryColor),
                        SizedBox(width: size.width * 0.04),
                        Expanded(
                          child:
                              DropdownButtonHideUnderline(
                                  child: dropDownList()),
                        ),
                      ],
                    ),
                  ),
                  _chosenValue != 'Public' &&
                          _chosenValue != null
                      ? RoundedPasswordField(
                          onChanged: onChangedPassword)
                      : const SizedBox(),
                  RoundedInputField(
                      hintText: "Room Perimeter",
                      onChanged: onChangedRoomPerimeter),
                  const TextFieldContainer(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Room Description",
                        border: InputBorder.none,
                        icon: Icon(Icons.description,
                            color: kPrimaryColor),
                      ),
                    ),
                  ),
                  RoundedButton(
                      isLoading: false,
                      text: "Create",
                      press: () => {})
                ]),
          ),
        ));
  }

  DropdownButton<String> dropDownList() {
    const TextStyle _style =
        TextStyle(color: Colors.black, fontSize: 15);
    return DropdownButton<String>(
      focusColor: Colors.white,
      value: _chosenValue,
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: Colors.black,
      items: _roomTypes
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: _style,
            ));
      }).toList(),
      hint: const Text(
        "Please select a room type",
        style: _style,
      ),
      onChanged: (value) {
        setState(() {
          _chosenValue = value;
        });
      },
    );
  }

  void onChangedPassword(String value) {
    print(value);
  }

  void onChangedRoomName(String value) {
    print(value);
  }

  void onChangedRoomPerimeter(String value) {}
}

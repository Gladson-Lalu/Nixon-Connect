import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/circle_image_picker.dart';

import '../../../Common/constant.dart';
import '../../../Cubit/auth/auth_cubit.dart';
import '../../../Cubit/create_room/create_room_cubit.dart';
import '../../../Models/user_model.dart';
import '../../components/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import '../../components/rounded_password_field.dart';
import '../../components/text_field_container.dart';
import '../IndividualChat/conversations_screen.dart';
import '../Login/login_screen.dart';

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
  File? _imageFile;
  String? _chosenValue;
  String _roomName = '';
  String _roomDescription = '';
  String _roomPassword = '';
  String _roomPerimeter = '';

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final UserModel? _user =
        BlocProvider.of<AuthCubit>(context).user;

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
                  SizedBox(height: _size.height * 0.05),
                  circleImagePicker(
                      context: context,
                      isProfile: false,
                      imageFile: _imageFile,
                      onImageChange: (image) {
                        setState(() {
                          _imageFile = image;
                        });
                      }),
                  RoundedInputField(
                      hintText: "Room Name",
                      textCapitalization:
                          TextCapitalization.words,
                      icon: Icons.group,
                      onChanged: onChangedRoomName),
                  TextFieldContainer(
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list,
                            color: kPrimaryColor),
                        SizedBox(width: _size.width * 0.04),
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
                      hintText: "Room Perimeter (Meters)",
                      textInputType: TextInputType.number,
                      onChanged: onChangedRoomPerimeter),
                  TextFieldContainer(
                    child: TextField(
                      onChanged: onChangedRoomDescription,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "Room Description",
                        border: InputBorder.none,
                        icon: Icon(Icons.description,
                            color: kPrimaryColor),
                      ),
                    ),
                  ),
                  BlocConsumer<CreateRoomCubit,
                      CreateRoomState>(
                    listener: (context, state) {
                      if (state is CreateRoomSuccess) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ConversationScreen(
                                        roomModel: state
                                            .roomModel)));
                      }
                    },
                    builder: (context, state) {
                      if (state is CreateRoomLoading) {
                        return RoundedButton(
                            isLoading: true,
                            text: '',
                            press: () {});
                      } else {
                        return RoundedButton(
                            isLoading: false,
                            text: "Create",
                            press: () => {
                                  if (_user != null)
                                    {
                                      BlocProvider.of<
                                                  CreateRoomCubit>(
                                              context)
                                          .createRoom(
                                              roomName:
                                                  _roomName,
                                              roomDescription:
                                                  _roomDescription,
                                              roomPassword:
                                                  _roomPassword,
                                              roomPerimeter:
                                                  _roomPerimeter,
                                              roomType:
                                                  _chosenValue,
                                              roomImage:
                                                  _imageFile,
                                              userToken:
                                                  _user
                                                      .token)
                                    }
                                  else
                                    {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const LoginScreen()),
                                          (route) => false)
                                    }
                                });
                      }
                    },
                  ),
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
    setState(() {
      _roomPassword = value;
    });
  }

  void onChangedRoomName(String value) {
    setState(() {
      _roomName = value;
    });
  }

  void onChangedRoomPerimeter(String value) {
    setState(() {
      _roomPerimeter = value;
    });
  }

  void onChangedRoomDescription(String value) {
    setState(() {
      _roomDescription = value;
    });
  }
}

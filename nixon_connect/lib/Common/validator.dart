//Show toast message
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      toastLength: Toast.LENGTH_SHORT);
}

//validate userID
//lowercase,number, underscore, and length of 6-10
bool validateUserID(String userID) {
  RegExp regex = RegExp(r'^[a-z0-9_]{6,10}$');
  if (regex.hasMatch(userID)) {
    return true;
  } else {
    showToast(
        'UserID should be lowercase, number, underscore and length of 6-10');
    return false;
  }
}

//validate email
validateEmail(String email) {
  if (email.isEmpty) {
    showToast("Email field is empty");
    return false;
  }
  bool validEmail = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  if (!validEmail) {
    showToast("Please enter a valid email");
    return false;
  }
  return true;
}

//validate password
validatePassword(String password) {
  if (password.isEmpty) {
    showToast("Password field is empty");
    return false;
  }
  bool validPassword =
      RegExp(r'^(?=.*?[a-z|A-Z])(?=.*?[0-9]).{8,}$')
          .hasMatch(password);
  if (!validPassword) {
    showToast(
        "Password should contain letters, numbers and must be 8 characters in length");
    return false;
  }
  return true;
}

//validate name
validateName(String name) {
  if (name.isEmpty) {
    showToast("Name field is empty");
    return false;
  }
  return true;
}

//validate confirm password
validateConfirmPassword(
    String password, String confirmPassword) {
  if (password != confirmPassword) {
    showToast(
        "Password and confirm password does not match");
    return false;
  }
  return true;
}

//validate room name
validateRoomName(String roomName) {
  if (roomName.isEmpty) {
    showToast("Room name field is empty");
    return false;
  }
  return true;
}

//validate room password having 5-8 characters without space
validateRoomPassword(
    String? roomType, String roomPassword) {
  if (roomType != null && roomType != 'Public') {
    if (roomPassword.isEmpty) {
      showToast("Room password field is empty");
      return false;
    }
    bool validPassword =
        RegExp(r'^(?=.*?[a-z|A-Z])(?=.*?[0-9]).{5,8}$')
            .hasMatch(roomPassword);
    if (!validPassword) {
      showToast(
          "Room password should contain letters, numbers and must be 5-8 characters in length");
      return false;
    }
  }
  return true;
}

//validate room perimeter
validateRoomPerimeter(String roomPerimeter) {
  if (roomPerimeter.isEmpty) {
    showToast("Room perimeter field is empty");
    return false;
  }
  return true;
}

validateRoomType(String? roomType) {
  if (roomType == null) {
    showToast("Select a room type");
    return false;
  }
  return true;
}

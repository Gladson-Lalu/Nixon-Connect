import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nixon_connect/Common/validator.dart';
import 'package:nixon_connect/Common/validator.dart';
import 'package:nixon_connect/Common/validator.dart';
import 'package:nixon_connect/Models/user_model.dart';
import 'package:nixon_connect/Services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  UserModel? user;
  AuthCubit(this._authService) : super(const AuthInitial());

  //get the user from the local storage
  Future<void> getUser() async {
    if (user == null) {
      final prefs = await SharedPreferences.getInstance();
      final _user = prefs.getString('current-user');
      if (_user != null) {
        user = UserModel.fromJson(json.decode(_user));
        emit(AuthSuccess(user: user!));
      } else {
        emit(const AuthInitial());
      }
    } else {
      emit(AuthSuccess(user: user!));
    }
  }

  //sign in
  Future<void> handleSignIn(
      {required String email,
      required String password}) async {
    try {
      emit(const AuthLoading());
      if (validateEmail(email) &&
          validatePassword(password)) {
        final response = await _authService.signIn(
          email: email,
          password: password,
        );
        if (response.statusCode == 200) {
          user = UserModel.fromJson(
              json.decode(response.body)['user']);
          emit(AuthSuccess(user: user!));
        } else {
          emit(const AuthError(error: ''));
          showToast(json.decode(response.body)['error']);
        }
      } else {
        emit(const AuthError(error: ''));
      }
    } catch (error) {
      emit(AuthError(error: error.toString()));
    }
  }

  //handle register
  Future<void> handleRegister(
      {required String email,
      required String password,
      required String name,
      required String userID,
      required String confirmPassword}) async {
    try {
      emit(const AuthLoading());
      if (validateEmail(email) &&
          validatePassword(password) &&
          validateName(name) &&
          validateUserID(userID) &&
          validateConfirmPassword(
              password, confirmPassword)) {
        final response = await _authService.register(
          name: name,
          email: email,
          userID: userID,
          password: password,
        );
        if (response.statusCode == 200) {
          showToast("Registration Successful");
          user = UserModel.fromJson(
              json.decode(response.body)['user']);
          saveUserData(user: user!);
          emit(AuthSuccess(user: user!));
        } else {
          emit(const AuthError(error: ''));
          showToast(json.decode(response.body)['error']);
        }
      } else {
        emit(const AuthError(error: ''));
      }
    } catch (error) {
      emit(const AuthError(error: ''));
    }
  }

  handleForgotPassword({required String email}) async {
    if (validateEmail(email)) {
      Response response =
          await _authService.forgotPassword(email);
      if (response.statusCode == 200) {
        showToast(
            "Password reset link has been sent to your email");
      } else {
        showToast(json.decode(response.body)['error']);
      }
    }
  }

//save user data to local storage
  saveUserData({required UserModel user}) async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance();
    prefs.setString(
        'current-user', user.toJson().toString());
  }
}

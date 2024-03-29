import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../Services/file_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Common/validator.dart';
import '../../Models/user_model.dart';
import '../../Services/auth_service.dart';
import '../../Services/socket_service.dart';
import '../../Services/sync_service.dart';
import '../channels/channels_cubit.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService = AuthService();
  final ChannelsCubit _channelCubit;
  final _socketService = SocketService.instance;
  UserModel? user;
  AuthCubit(this._channelCubit)
      : super(const AuthInitial());

  //get the user from the local storage
  Future<void> getUser() async {
    if (user != null) {
      initServices();
      emit(AuthSuccess(user: user!));
    } else {
      try {
        emit(const AuthLoading());
        SharedPreferences prefs =
            await SharedPreferences.getInstance();
        String? userString =
            prefs.getString('current-user');
        if (userString != null) {
          user = UserModel.fromJson(jsonDecode(userString));

          initServices();
          emit(AuthSuccess(user: user!));
        } else {
          emit(const AuthInitial());
        }
      } catch (_) {
        emit(const AuthInitial());
      }
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
          saveUserData(user: user!);
          initServices();
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
      required String confirmPassword,
      File? imageFile}) async {
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
          if (imageFile != null) {
            final String imageUrl = await FileService
                .instance
                .uploadFile(filePath: imageFile.path);
            final String token =
                jsonDecode(response.body)['user']['token'];
            final temp =
                await _authService.updateProfilePicture(
                    userToken: token,
                    profilePicture: imageUrl);
            user = UserModel.fromJson(
                json.decode(temp.body)['user']);
          } else {
            user = UserModel.fromJson(
                json.decode(response.body)['user']);
          }
          showToast("Registration Successful");
          saveUserData(user: user!);
          initServices();
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
        'current-user', jsonEncode(user.toJson()));
  }

  //initialize the socket service after Authentication is successful
  initServices() {
    SyncServer.instance.syncData(userToken: user!.token);
    _socketService.initSocket(token: user!.token);
    _channelCubit.initChannels();
  }

  //verify the token

}

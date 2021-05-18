import 'package:flutter/material.dart';

enum AuthErrorType {
  // signUp
  emailAlreadyUsed,
  phoneAlreadyUsed,
  // login
  userNotFound,
  invalidPassword,
  // general
  timeout,
  internalServerError,
  unknownError,
}

class AuthenticationResponse{}

class ErrorAuthenticationResponse extends AuthenticationResponse{
  final AuthErrorType errorType;

  ErrorAuthenticationResponse({@required this.errorType});
}

class SuccessAuthenticationResponse extends AuthenticationResponse {
  final String token;
  SuccessAuthenticationResponse({@required this.token});
}

abstract class AuthenticationInterface{
  Future<AuthenticationResponse> login({@required matricule, @required password});

  Future<AuthenticationResponse> signUp({@required firstName, @required lastName, @required email, @required phone, @required password});

  Future<bool> checkTokenValidity({@required token});

  Future<String> getToken();

  Future<bool> saveToken({@required token});

  Future<bool> deleteToken();
}
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const kPrimaryColor = Color(0xFFF28C00);
const kPrimaryLightColor = Color(0xFFFFECDF);

const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kOverlay10 = Color(0x1A000000);
const kOverlay20 = Color(0x33000000);
const kOverlay30 = Color(0x4D000000);
const kOverlay40 = Color(0x66000000);

const kGrey5 = Color(0xFFf2f2f2);
// const kSecondaryColor = Color(0xFF37474F);
// const kTextColor = Color(0xFF263238);
// const KAnimationDuration = Duration(microseconds: 200);

const KAnimationDuration = Duration(microseconds: 300);

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9.]+\.[a-zA-Z]+");
const kBaseUrl = "https://api.staging.livraison-express.net/api/v1.1/";
const kOrigin = "https://livraison-express.net";
const kAppName = 'SpeedEx';
const kSecureStorage = FlutterSecureStorage();

class ApiRoutes {
  static const login = 'login';
  static const register = 'register';
  static const createPost = 'posts/create';
  static const getPost = 'posts';
  static const getUser = 'getMyData';
}

class SecureStorageKeys {
  static const authToken = 'authToken';
}

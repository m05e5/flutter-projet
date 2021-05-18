import 'dart:io';

import 'package:IUT_Project/constants.dart';
import 'package:IUT_Project/repositories/authentication_interface.dart';
import 'package:dio/dio.dart';
import 'package:IUT_Project/repositories/authentication_interface.dart';
import 'package:IUT_Project/repositories/remote_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository extends RemoteRepository implements AuthenticationInterface{
  AuthenticationRepository(Dio client) : super(client);
  SharedPreferences sharedPreferences;
  @override
  Future<bool> deleteToken() async{
    try{
      await kSecureStorage.delete(key: SecureStorageKeys.authToken);
      return true;
    }catch(e){
      return false;
    }
  }

  @override
  Future<String> getToken() async{
    try{
       return await kSecureStorage.read(key: SecureStorageKeys.authToken);
    }catch(e){
      return null;
    }
  }

  @override
  Future<bool> saveToken({token}) async {
    try{
      await kSecureStorage.write(key: SecureStorageKeys.authToken, value: token);
      return true;
    }catch(e){
      return false;
    }
  }

  @override
  Future<AuthenticationResponse> login({matricule, password}) async{
    final _loginRoute = ApiRoutes.login;
    final data = {'matricule': matricule, 'password': password};
    print(data);
    try{
      final result = await client.post<Map<String, dynamic>>(_loginRoute, data: data);
      print(result);
      return SuccessAuthenticationResponse(token: result.data['access_token']);
    } catch(err){
      if(err is DioError){
        return ErrorAuthenticationResponse(errorType: AuthErrorType.userNotFound);
      }else{
        return ErrorAuthenticationResponse(errorType: AuthErrorType.unknownError);
      }
    }
  }

  @override
  Future<AuthenticationResponse> signUp({firstName, lastName, email, phone, password}) async{
    final _signUpRoute = ApiRoutes.register;
    final data = {
      'Origin': 'exspeedy',
      'firstname': firstName,
      'lastname': lastName,
      'email': "$firstName@$lastName.com",
      'username': phone,
      'password': password,
      'password_confirmation': password,
      'telephone': "+" + "237" + phone,
      'phone_country_code': "237",
      'telephone_alt': phone,
      'licence': "true"
    };

    try{
      final result = await client.post<Map<String, dynamic>>(_signUpRoute, data: data);
      return SuccessAuthenticationResponse(token: result.data['access_token']);
    } catch(err){
      if(err is DioError){
        return ErrorAuthenticationResponse(errorType: AuthErrorType.userNotFound);
      }else{
        return ErrorAuthenticationResponse(errorType: AuthErrorType.unknownError);
      }
    }
  }

  @override
  Future<bool> checkTokenValidity({token}) async{
    if(token == null){
      return false;
    }

    final _userRoute = ApiRoutes.getUser;
    final dioClient = Dio();
    dioClient.options.headers['Content-Type'] = 'application/json';
    dioClient.options.headers['Accept'] = 'application/json';
    dioClient.options.headers['Authorization'] = 'Bearer $token';
    dioClient.options.baseUrl = kBaseUrl;

    try{
      final result = await dioClient.get(_userRoute);
      return result.statusCode == HttpStatus.ok;
    }catch(e){
      return false;
    }
  }

}
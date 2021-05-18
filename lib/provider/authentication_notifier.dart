import 'package:IUT_Project/repositories/authentication_interface.dart';
import 'package:IUT_Project/services/client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthenticationState {
  const AuthenticationState();
}

class BaseAuthenticationState extends AuthenticationState {
  const BaseAuthenticationState();
}

class AuthenticationErrorState extends AuthenticationState {
  final AuthErrorType authError;
  const AuthenticationErrorState(this.authError);
}

class UserConnectedState extends AuthenticationState {
  const UserConnectedState();
}

class UserNotConnectedState extends AuthenticationState {
  const UserNotConnectedState();
}

class AuthenticationStateNotifier extends StateNotifier<AuthenticationState>{
  final AuthenticationInterface _authenticationInterface;
  final ClientStateNotifier _clientStateNotifier;

  AuthenticationStateNotifier(this._authenticationInterface, this._clientStateNotifier)
      : super(BaseAuthenticationState());

  Future<void> _handleAuthResponse(AuthenticationResponse response) async{
    if(response is SuccessAuthenticationResponse){
      final token = response.token;
      await _authenticationInterface.saveToken(token: token);
      _clientStateNotifier.setAuthenticatedClient(token);
      print('authenticated');
      state = UserConnectedState();
    }else if(response is ErrorAuthenticationResponse){
      print('unAuthenticated');
      state = AuthenticationErrorState(response.errorType);
    }
  }

  Future<void> loginWithPassword(String matricule, String password) async{
    print(matricule + ':' + password);
    final result = await _authenticationInterface.login(matricule: matricule, password: password);
    await _handleAuthResponse(result);
    
  }

  Future<void> loginWithToken() async{
    final token = await _authenticationInterface.getToken();

    final data = await Future.wait([
      _authenticationInterface.checkTokenValidity(token: token),
      Future.delayed(Duration(seconds: 1))
    ]);
    final isLoggedIn = data[0];

    if(isLoggedIn){
      _clientStateNotifier.setAuthenticatedClient(token);
      state = UserConnectedState();
    } else{
      await _authenticationInterface.deleteToken();
      _clientStateNotifier.setUnauthenticatedClient();
      state = UserNotConnectedState();
    }
  }

  Future<void> signUp(String firstName, String lastName, String phone, String password) async{
    final result = await _authenticationInterface.signUp(firstName: firstName, lastName: lastName, email: null, phone: phone, password: password);
    await _handleAuthResponse(result);
  }

  Future<void> logout() async {
    await _authenticationInterface.deleteToken();
    _clientStateNotifier.setUnauthenticatedClient();
    state = UserNotConnectedState();
  }
}
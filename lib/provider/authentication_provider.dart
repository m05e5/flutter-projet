import 'package:IUT_Project/provider/authentication_notifier.dart';
import 'package:IUT_Project/provider/authentication_repositories.dart';
import 'package:IUT_Project/repositories/authentication_interface.dart';
import 'package:IUT_Project/services/client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationRepositoryProvider = Provider<AuthenticationInterface>((ref){
  return AuthenticationRepository(ref.read(clientProvider.state));
});

final authenticationNotifierProvider = StateNotifierProvider<AuthenticationStateNotifier>((ref){
  final _authInterface = ref.read(authenticationRepositoryProvider);
  final _clientStateNotifier = ref.read(clientProvider);
  return AuthenticationStateNotifier(_authInterface, _clientStateNotifier);
});
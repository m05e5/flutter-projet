import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientStateNotifier extends StateNotifier<Dio> {
  ClientStateNotifier() : super(_initClient());

  static Dio _initClient() {
    final client = Dio();
    client.options.headers['Content-Type'] = 'application/json';
    client.options.headers['Accept'] = 'application/json';
    client.options.baseUrl = 'http://192.168.1.36:8000/api/';
    return client;
  }

  void setAuthenticatedClient(String token) {
    final client = _initClient();
    client.options.headers['Authorization'] = 'Bearer $token';
    state = client;
  }

  void setUnauthenticatedClient() {
    state = _initClient();
  }
}

final clientProvider = StateNotifierProvider<ClientStateNotifier>((ref) {
  return ClientStateNotifier();
});

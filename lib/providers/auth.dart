import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  late String? _token;
  late DateTime? _expiryDate;
  late String? _userId;
  late Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId!;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
    // final url = Uri.parse(
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=AIzaSyDi2ynzp-LIoXbF-7q9Rl88hvCLTFZ4U_A');

    // http.post(
    //   url,
    //   body: json.encode({
    //     'email': email,
    //     'password': password,
    //     'returnSecureToken': true,
    //   }),
    // );
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
    // final url = Uri.parse(
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDi2ynzp-LIoXbF-7q9Rl88hvCLTFZ4U_A');
    // http.post(
    //   url,
    //   body: json.encode({
    //     'email': email,
    //     'password': password,
    //     'returnSecureToken': true,
    //   }),
    // );
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDi2ynzp-LIoXbF-7q9Rl88hvCLTFZ4U_A');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(
          responseData['expiresIn'],
        ),
      ));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
  }

  void _autoLogout() {
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToExpiry), logout);
  }
}

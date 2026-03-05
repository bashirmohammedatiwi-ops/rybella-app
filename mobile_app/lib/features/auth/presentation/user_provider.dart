import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cosmatic_app/core/constants/api_constants.dart';
import 'package:cosmatic_app/core/network/api_client.dart';

class UserData {
  final int id;
  final String name;
  final String phone;
  final String? email;

  UserData({required this.id, required this.name, required this.phone, this.email});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
    );
  }
}

class UserProvider extends ChangeNotifier {
  static const _tokenKey = 'user_token';
  static const _userKey = 'user_data';

  String? _token;
  UserData? _user;
  bool _initialized = false;

  String? get token => _token;
  UserData? get user => _user;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;
  bool get initialized => _initialized;

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        _user = UserData.fromJson(Map<String, dynamic>.from(jsonDecode(userJson)));
      } catch (_) {
        _user = null;
      }
    }
    _initialized = true;
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String phone,
    String? email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final res = await ApiClient().post(ApiConstants.authRegister, body: {
        'name': name,
        'phone': phone,
        if (email != null && email.isNotEmpty) 'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });
      _token = res['token'] as String?;
      final userMap = res['user'] as Map<String, dynamic>?;
      if (userMap != null) {
        _user = UserData.fromJson(userMap);
      }
      if (_token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, _token!);
        if (_user != null) {
          await prefs.setString(_userKey, jsonEncode({'id': _user!.id, 'name': _user!.name, 'phone': _user!.phone, 'email': _user!.email}));
        }
      }
      notifyListeners();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> login({required String phone, required String password}) async {
    try {
      final res = await ApiClient().post(ApiConstants.authLogin, body: {
        'phone': phone,
        'password': password,
      });
      _token = res['token'] as String?;
      final userMap = res['user'] as Map<String, dynamic>?;
      if (userMap != null) {
        _user = UserData.fromJson(userMap);
      }
      if (_token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, _token!);
        if (_user != null) {
          await prefs.setString(_userKey, jsonEncode({'id': _user!.id, 'name': _user!.name, 'phone': _user!.phone, 'email': _user!.email}));
        }
      }
      notifyListeners();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    if (_token != null) {
      try {
        await ApiClient().post(ApiConstants.authLogout, token: _token);
      } catch (_) {}
    }
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    notifyListeners();
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cosmatic_app/core/constants/api_constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._();
  factory ApiClient() => _instance;

  ApiClient._();

  String get baseUrl => ApiConstants.baseUrl;

  Map<String, String> _headers({String? token, Map<String, String>? headers}) {
    final m = <String, String>{...?headers};
    if (token != null && token.isNotEmpty) m['Authorization'] = 'Bearer $token';
    return m;
  }

  Future<Map<String, dynamic>> get(String path, {String? token, Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$path');
    final res = await http.get(uri, headers: _headers(token: token, headers: headers));
    return _handleResponse(res);
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body, String? token, Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$path');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json', ..._headers(token: token, headers: headers)},
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(res);
  }

  Future<Map<String, dynamic>> delete(String path, {String? token, Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$path');
    final res = await http.delete(uri, headers: _headers(token: token, headers: headers));
    return _handleResponse(res);
  }

  Map<String, dynamic> _handleResponse(http.Response res) {
    final decoded = res.body.isNotEmpty ? jsonDecode(res.body) : <String, dynamic>{};
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
    }
    throw ApiException(
      statusCode: res.statusCode,
      message: decoded['message'] ?? 'حدث خطأ',
      errors: decoded['errors'],
    );
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic errors;

  ApiException({required this.statusCode, required this.message, this.errors});

  @override
  String toString() => message;
}

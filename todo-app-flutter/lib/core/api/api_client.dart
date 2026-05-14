import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../config/env.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';

class PinnedHttpClient {
  static HttpClient create() {
    final client = HttpClient(
      context: SecurityContext(withTrustedRoots: false),
    );

    client.badCertificateCallback = (cert, host, port) {
      if (cert == null) {
        return false;
      }

      final actualHash = sha256.convert(cert.der).toString();

      final isValid =
          host == Env.host &&
          actualHash == Env.sslFingerprint;

      return isValid;
    };

    return client;
  }
}

class ApiClient {
  static late http.Client _client;

  static void init() {
    _client = IOClient(PinnedHttpClient.create());
  }

  static Future<Map<String, String>> _headers({bool adminOnly = false}) async {
    final token = await TokenStorage.getToken();
    final payload = await TokenStorage.getPayload();
    final isAdmin = payload?['role'] == 'admin';

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      if (adminOnly && isAdmin) 'x-admin-token': 'supersecret',
    };
  }

  static dynamic _handle(http.Response res) {
    dynamic body;

    try {
      body = jsonDecode(res.body);
    } catch (_) {
      body = res.body;
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (body is Map && body['success'] == true) {
        return body;
      }
    }

    throw ApiException(
      body is Map && body['message'] != null
          ? body['message']
          : 'Request failed',
      res.statusCode,
      details: body,
    );
  }

  static Future<dynamic> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool adminOnly = false,
  }) async {
    final uri = Uri.parse('${Env.baseUrl}$path');
    final headers = await _headers(adminOnly: adminOnly);

    try {
      late http.Response res;

      switch (method) {
        case 'GET':
          res = await _client.get(uri, headers: headers);
          break;
        case 'POST':
          res = await _client.post(
            uri,
            headers: headers,
            body: jsonEncode(body ?? {}),
          );
          break;
        case 'PUT':
          res = await _client.put(
            uri,
            headers: headers,
            body: jsonEncode(body ?? {}),
          );
          break;
        case 'DELETE':
          res = await _client.delete(uri, headers: headers);
          break;
        default:
          throw ApiException('Invalid method', 0);
      }

      return _handle(res);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Network error',
        0,
        details: e.toString(),
      );
    }
  }

  static Future<dynamic> get(String path, {bool adminOnly = false}) {
    return _request('GET', path, adminOnly: adminOnly);
  }

  static Future<dynamic> post(
    String path,
    Map<String, dynamic> body, {
    bool adminOnly = false,
  }) {
    return _request('POST', path, body: body, adminOnly: adminOnly);
  }

  static Future<dynamic> put(
    String path,
    Map<String, dynamic> body, {
    bool adminOnly = false,
  }) {
    return _request('PUT', path, body: body, adminOnly: adminOnly);
  }

  static Future<dynamic> delete(String path, {bool adminOnly = false}) {
    return _request('DELETE', path, adminOnly: adminOnly);
  }
}
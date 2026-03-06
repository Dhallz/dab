import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'http://localhost:8080';

  // 1. Login
  final loginRes = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': 'test@example.com', 'password': 'password123'}),
  );

  if (loginRes.statusCode != 200) {
    print('Login failed: ${loginRes.body}');
    exit(1);
  }

  final token = jsonDecode(loginRes.body)['token'];
  print('Got token.');

  // 2. Search Activities
  final start = DateTime.now().subtract(Duration(days: 7)).toIso8601String();
  final end = DateTime.now().toIso8601String();

  final searchRes = await http.get(
    Uri.parse(
      '$baseUrl/activities/search?startDate=$start&endDate=$end&authoredOnly=true',
    ),
    headers: {'Authorization': 'Bearer $token'},
  );

  print('Search (authoredOnly=true) Status: ${searchRes.statusCode}');
  print(
    'Response body preview: ${searchRes.body.length > 500 ? "${searchRes.body.substring(0, 500)}..." : searchRes.body}',
  );

  final searchResFalse = await http.get(
    Uri.parse(
      '$baseUrl/activities/search?startDate=$start&endDate=$end&authoredOnly=false',
    ),
    headers: {'Authorization': 'Bearer $token'},
  );

  print('\nSearch (authoredOnly=false) Status: ${searchResFalse.statusCode}');
  print(
    'Response body preview: ${searchResFalse.body.length > 500 ? "${searchResFalse.body.substring(0, 500)}..." : searchResFalse.body}',
  );

  exit(0);
}

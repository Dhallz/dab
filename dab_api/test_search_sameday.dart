import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'http://localhost:9080';
  final email = 'tester_${DateTime.now().millisecondsSinceEpoch}@necs.com';
  final password = 'password123';

  print('Registering $email...');
  final regRes = await http.post(
    Uri.parse('$baseUrl/auth/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': 'Test User',
      'email': email,
      'password': password,
    }),
  );

  if (regRes.statusCode != 201 && regRes.statusCode != 200) {
    print('Registration failed: ${regRes.body}');
    exit(1);
  }

  print('Logging in...');
  final loginRes = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (loginRes.statusCode != 200) {
    print('Login failed: ${loginRes.body}');
    exit(1);
  }

  final body = jsonDecode(loginRes.body);
  final token =
      body['accessToken'] ??
      body['token'] ??
      (body['data'] != null
          ? (body['data']['accessToken'] ?? body['data']['token'])
          : null);

  if (token == null) {
    print('No token found in response: $body');
    exit(1);
  }

  print('Got token.');

  // 2. Search Activities - SAME DAY
  final today = DateTime.now().toIso8601String().split('T')[0];

  print('Testing same-day search for $today...');
  final searchRes = await http.get(
    Uri.parse(
      '$baseUrl/activities/search?startDate=$today&endDate=$today&authoredOnly=true',
    ),
    headers: {'Authorization': 'Bearer $token'},
  );

  print('Search Status: ${searchRes.statusCode}');

  if (searchRes.statusCode != 200) {
    print('Search failed: ${searchRes.body}');
    exit(1);
  }

  final searchBody = jsonDecode(searchRes.body);
  final data = searchBody['data'] as List;
  print('Found ${data.length} activities for $today.');

  if (data.isNotEmpty) {
    print('First activity: ${data[0]['title']} at ${data[0]['createdAt']}');
  } else {
    print('Note: No activities found, but the request was successful.');
  }

  exit(0);
}

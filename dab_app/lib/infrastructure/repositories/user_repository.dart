import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart' hide Group;

import '../../domain/core/failures.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/abs_i_user_repository.dart';
import '../core/remote/rest_api_client.dart';
import './core/repository.dart';

class UserRepository extends Repository implements IUserRepository {
  final RestApiClient _client;

  UserRepository(this._client);

  @override
  Future<Either<AppFailure, List<User>>> getUsers() async {
    return guardedCall(() async {
      final response = await _client.get('/users');
      final data = _getEnvelopeData(response);
      if (data is List) {
        return data
            .map((e) => UserMapper.fromMap(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    });
  }

  @override
  Future<Either<AppFailure, User>> getUser(String id) async {
    return guardedCall(() async {
      final response = await _client.get('/users/$id');
      final data = _getEnvelopeData(response);
      return UserMapper.fromMap(data as Map<String, dynamic>);
    });
  }

  @override
  Future<Either<AppFailure, List<Group>>> getGroups() async {
    return guardedCall(() async {
      final response = await _client.get('/groups');
      final data = _getEnvelopeData(response);
      if (data is List) {
        return data
            .map((e) => GroupMapper.fromMap(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    });
  }

  @override
  Future<Either<AppFailure, Group>> saveGroup(Group group) async {
    print('DEBUG: UserRepository.saveGroup entry: ${group.name}');
    return guardedCall(() async {
      print('DEBUG: UserRepository.saveGroup calling POST /groups');
      final response = await _client.dio.post('/groups', data: group.toMap());
      print('DEBUG: UserRepository.saveGroup response: ${response.statusCode}');
      final data = _getEnvelopeData(response);
      return GroupMapper.fromMap(data as Map<String, dynamic>);
    });
  }

  @override
  Future<Either<AppFailure, void>> deleteGroup(String id) async {
    return guardedCall(() async {
      await _client.dio.delete('/groups/$id');
    });
  }

  dynamic _getEnvelopeData(Response response) {
    if (response.statusCode == 304 || response.data == null) return null;

    final dynamic data = response.data;
    final Map<String, dynamic> map;

    if (data is Map<String, dynamic>) {
      map = data;
    } else {
      map = jsonDecode(data.toString());
    }

    return map['data'];
  }
}

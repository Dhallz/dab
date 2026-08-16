// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTableTable extends UsersTable
    with TableInfo<$UsersTableTable, UsersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Standard'),
  );
  static const VerificationMeta _phorgePhidMeta = const VerificationMeta(
    'phorgePhid',
  );
  @override
  late final GeneratedColumn<String> phorgePhid = GeneratedColumn<String>(
    'phorge_phid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phorgeUsernameMeta = const VerificationMeta(
    'phorgeUsername',
  );
  @override
  late final GeneratedColumn<String> phorgeUsername = GeneratedColumn<String>(
    'phorge_username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>(
        'created_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> updatedAt =
      GeneratedColumn<PgDateTime>(
        'updated_at',
        aliasedName,
        true,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    passwordHash,
    role,
    phorgePhid,
    phorgeUsername,
    createdAt,
    updatedAt,
    avatarUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('phorge_phid')) {
      context.handle(
        _phorgePhidMeta,
        phorgePhid.isAcceptableOrUnknown(data['phorge_phid']!, _phorgePhidMeta),
      );
    }
    if (data.containsKey('phorge_username')) {
      context.handle(
        _phorgeUsernameMeta,
        phorgeUsername.isAcceptableOrUnknown(
          data['phorge_username']!,
          _phorgeUsernameMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      phorgePhid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phorge_phid'],
      ),
      phorgeUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phorge_username'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}updated_at'],
      ),
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
    );
  }

  @override
  $UsersTableTable createAlias(String alias) {
    return $UsersTableTable(attachedDatabase, alias);
  }
}

class UsersTableData extends DataClass implements Insertable<UsersTableData> {
  final String id;
  final String name;
  final String email;
  final String passwordHash;
  final String role;
  final String? phorgePhid;
  final String? phorgeUsername;
  final PgDateTime createdAt;
  final PgDateTime? updatedAt;
  final String? avatarUrl;
  const UsersTableData({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.role,
    this.phorgePhid,
    this.phorgeUsername,
    required this.createdAt,
    this.updatedAt,
    this.avatarUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['password_hash'] = Variable<String>(passwordHash);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || phorgePhid != null) {
      map['phorge_phid'] = Variable<String>(phorgePhid);
    }
    if (!nullToAbsent || phorgeUsername != null) {
      map['phorge_username'] = Variable<String>(phorgeUsername);
    }
    map['created_at'] = Variable<PgDateTime>(
      createdAt,
      PgTypes.timestampWithTimezone,
    );
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<PgDateTime>(
        updatedAt,
        PgTypes.timestampWithTimezone,
      );
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    return map;
  }

  UsersTableCompanion toCompanion(bool nullToAbsent) {
    return UsersTableCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      passwordHash: Value(passwordHash),
      role: Value(role),
      phorgePhid: phorgePhid == null && nullToAbsent
          ? const Value.absent()
          : Value(phorgePhid),
      phorgeUsername: phorgeUsername == null && nullToAbsent
          ? const Value.absent()
          : Value(phorgeUsername),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
    );
  }

  factory UsersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      role: serializer.fromJson<String>(json['role']),
      phorgePhid: serializer.fromJson<String?>(json['phorgePhid']),
      phorgeUsername: serializer.fromJson<String?>(json['phorgeUsername']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<PgDateTime?>(json['updatedAt']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'role': serializer.toJson<String>(role),
      'phorgePhid': serializer.toJson<String?>(phorgePhid),
      'phorgeUsername': serializer.toJson<String?>(phorgeUsername),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
      'updatedAt': serializer.toJson<PgDateTime?>(updatedAt),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
    };
  }

  UsersTableData copyWith({
    String? id,
    String? name,
    String? email,
    String? passwordHash,
    String? role,
    Value<String?> phorgePhid = const Value.absent(),
    Value<String?> phorgeUsername = const Value.absent(),
    PgDateTime? createdAt,
    Value<PgDateTime?> updatedAt = const Value.absent(),
    Value<String?> avatarUrl = const Value.absent(),
  }) => UsersTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    passwordHash: passwordHash ?? this.passwordHash,
    role: role ?? this.role,
    phorgePhid: phorgePhid.present ? phorgePhid.value : this.phorgePhid,
    phorgeUsername: phorgeUsername.present
        ? phorgeUsername.value
        : this.phorgeUsername,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
  );
  UsersTableData copyWithCompanion(UsersTableCompanion data) {
    return UsersTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      role: data.role.present ? data.role.value : this.role,
      phorgePhid: data.phorgePhid.present
          ? data.phorgePhid.value
          : this.phorgePhid,
      phorgeUsername: data.phorgeUsername.present
          ? data.phorgeUsername.value
          : this.phorgeUsername,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('phorgePhid: $phorgePhid, ')
          ..write('phorgeUsername: $phorgeUsername, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('avatarUrl: $avatarUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    passwordHash,
    role,
    phorgePhid,
    phorgeUsername,
    createdAt,
    updatedAt,
    avatarUrl,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.passwordHash == this.passwordHash &&
          other.role == this.role &&
          other.phorgePhid == this.phorgePhid &&
          other.phorgeUsername == this.phorgeUsername &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.avatarUrl == this.avatarUrl);
}

class UsersTableCompanion extends UpdateCompanion<UsersTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> passwordHash;
  final Value<String> role;
  final Value<String?> phorgePhid;
  final Value<String?> phorgeUsername;
  final Value<PgDateTime> createdAt;
  final Value<PgDateTime?> updatedAt;
  final Value<String?> avatarUrl;
  final Value<int> rowid;
  const UsersTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.role = const Value.absent(),
    this.phorgePhid = const Value.absent(),
    this.phorgeUsername = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersTableCompanion.insert({
    required String id,
    required String name,
    required String email,
    required String passwordHash,
    this.role = const Value.absent(),
    this.phorgePhid = const Value.absent(),
    this.phorgeUsername = const Value.absent(),
    required PgDateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       email = Value(email),
       passwordHash = Value(passwordHash),
       createdAt = Value(createdAt);
  static Insertable<UsersTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? passwordHash,
    Expression<String>? role,
    Expression<String>? phorgePhid,
    Expression<String>? phorgeUsername,
    Expression<PgDateTime>? createdAt,
    Expression<PgDateTime>? updatedAt,
    Expression<String>? avatarUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (role != null) 'role': role,
      if (phorgePhid != null) 'phorge_phid': phorgePhid,
      if (phorgeUsername != null) 'phorge_username': phorgeUsername,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? email,
    Value<String>? passwordHash,
    Value<String>? role,
    Value<String?>? phorgePhid,
    Value<String?>? phorgeUsername,
    Value<PgDateTime>? createdAt,
    Value<PgDateTime?>? updatedAt,
    Value<String?>? avatarUrl,
    Value<int>? rowid,
  }) {
    return UsersTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      role: role ?? this.role,
      phorgePhid: phorgePhid ?? this.phorgePhid,
      phorgeUsername: phorgeUsername ?? this.phorgeUsername,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (phorgePhid.present) {
      map['phorge_phid'] = Variable<String>(phorgePhid.value);
    }
    if (phorgeUsername.present) {
      map['phorge_username'] = Variable<String>(phorgeUsername.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<PgDateTime>(
        createdAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<PgDateTime>(
        updatedAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('phorgePhid: $phorgePhid, ')
          ..write('phorgeUsername: $phorgeUsername, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivitiesTableTable extends ActivitiesTable
    with TableInfo<$ActivitiesTableTable, ActivitiesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderUserIdMeta = const VerificationMeta(
    'senderUserId',
  );
  @override
  late final GeneratedColumn<String> senderUserId = GeneratedColumn<String>(
    'sender_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _providerNameMeta = const VerificationMeta(
    'providerName',
  );
  @override
  late final GeneratedColumn<String> providerName = GeneratedColumn<String>(
    'provider_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorNameMeta = const VerificationMeta(
    'authorName',
  );
  @override
  late final GeneratedColumn<String> authorName = GeneratedColumn<String>(
    'author_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorAvatarUrlMeta = const VerificationMeta(
    'authorAvatarUrl',
  );
  @override
  late final GeneratedColumn<String> authorAvatarUrl = GeneratedColumn<String>(
    'author_avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _commentCountMeta = const VerificationMeta(
    'commentCount',
  );
  @override
  late final GeneratedColumn<int> commentCount = GeneratedColumn<int>(
    'comment_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>(
        'created_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    senderUserId,
    providerName,
    title,
    content,
    url,
    authorName,
    authorAvatarUrl,
    commentCount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivitiesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('sender_user_id')) {
      context.handle(
        _senderUserIdMeta,
        senderUserId.isAcceptableOrUnknown(
          data['sender_user_id']!,
          _senderUserIdMeta,
        ),
      );
    }
    if (data.containsKey('provider_name')) {
      context.handle(
        _providerNameMeta,
        providerName.isAcceptableOrUnknown(
          data['provider_name']!,
          _providerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_providerNameMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('author_name')) {
      context.handle(
        _authorNameMeta,
        authorName.isAcceptableOrUnknown(data['author_name']!, _authorNameMeta),
      );
    } else if (isInserting) {
      context.missing(_authorNameMeta);
    }
    if (data.containsKey('author_avatar_url')) {
      context.handle(
        _authorAvatarUrlMeta,
        authorAvatarUrl.isAcceptableOrUnknown(
          data['author_avatar_url']!,
          _authorAvatarUrlMeta,
        ),
      );
    }
    if (data.containsKey('comment_count')) {
      context.handle(
        _commentCountMeta,
        commentCount.isAcceptableOrUnknown(
          data['comment_count']!,
          _commentCountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivitiesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivitiesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      senderUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_user_id'],
      ),
      providerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_name'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      authorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_name'],
      )!,
      authorAvatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_avatar_url'],
      ),
      commentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}comment_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ActivitiesTableTable createAlias(String alias) {
    return $ActivitiesTableTable(attachedDatabase, alias);
  }
}

class ActivitiesTableData extends DataClass
    implements Insertable<ActivitiesTableData> {
  final String id;
  final String userId;
  final String? senderUserId;
  final String providerName;
  final String title;
  final String content;
  final String? url;
  final String authorName;
  final String? authorAvatarUrl;
  final int commentCount;
  final PgDateTime createdAt;
  const ActivitiesTableData({
    required this.id,
    required this.userId,
    this.senderUserId,
    required this.providerName,
    required this.title,
    required this.content,
    this.url,
    required this.authorName,
    this.authorAvatarUrl,
    required this.commentCount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || senderUserId != null) {
      map['sender_user_id'] = Variable<String>(senderUserId);
    }
    map['provider_name'] = Variable<String>(providerName);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    map['author_name'] = Variable<String>(authorName);
    if (!nullToAbsent || authorAvatarUrl != null) {
      map['author_avatar_url'] = Variable<String>(authorAvatarUrl);
    }
    map['comment_count'] = Variable<int>(commentCount);
    map['created_at'] = Variable<PgDateTime>(
      createdAt,
      PgTypes.timestampWithTimezone,
    );
    return map;
  }

  ActivitiesTableCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesTableCompanion(
      id: Value(id),
      userId: Value(userId),
      senderUserId: senderUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(senderUserId),
      providerName: Value(providerName),
      title: Value(title),
      content: Value(content),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      authorName: Value(authorName),
      authorAvatarUrl: authorAvatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(authorAvatarUrl),
      commentCount: Value(commentCount),
      createdAt: Value(createdAt),
    );
  }

  factory ActivitiesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivitiesTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      senderUserId: serializer.fromJson<String?>(json['senderUserId']),
      providerName: serializer.fromJson<String>(json['providerName']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      url: serializer.fromJson<String?>(json['url']),
      authorName: serializer.fromJson<String>(json['authorName']),
      authorAvatarUrl: serializer.fromJson<String?>(json['authorAvatarUrl']),
      commentCount: serializer.fromJson<int>(json['commentCount']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'senderUserId': serializer.toJson<String?>(senderUserId),
      'providerName': serializer.toJson<String>(providerName),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'url': serializer.toJson<String?>(url),
      'authorName': serializer.toJson<String>(authorName),
      'authorAvatarUrl': serializer.toJson<String?>(authorAvatarUrl),
      'commentCount': serializer.toJson<int>(commentCount),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
    };
  }

  ActivitiesTableData copyWith({
    String? id,
    String? userId,
    Value<String?> senderUserId = const Value.absent(),
    String? providerName,
    String? title,
    String? content,
    Value<String?> url = const Value.absent(),
    String? authorName,
    Value<String?> authorAvatarUrl = const Value.absent(),
    int? commentCount,
    PgDateTime? createdAt,
  }) => ActivitiesTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    senderUserId: senderUserId.present ? senderUserId.value : this.senderUserId,
    providerName: providerName ?? this.providerName,
    title: title ?? this.title,
    content: content ?? this.content,
    url: url.present ? url.value : this.url,
    authorName: authorName ?? this.authorName,
    authorAvatarUrl: authorAvatarUrl.present
        ? authorAvatarUrl.value
        : this.authorAvatarUrl,
    commentCount: commentCount ?? this.commentCount,
    createdAt: createdAt ?? this.createdAt,
  );
  ActivitiesTableData copyWithCompanion(ActivitiesTableCompanion data) {
    return ActivitiesTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      senderUserId: data.senderUserId.present
          ? data.senderUserId.value
          : this.senderUserId,
      providerName: data.providerName.present
          ? data.providerName.value
          : this.providerName,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      url: data.url.present ? data.url.value : this.url,
      authorName: data.authorName.present
          ? data.authorName.value
          : this.authorName,
      authorAvatarUrl: data.authorAvatarUrl.present
          ? data.authorAvatarUrl.value
          : this.authorAvatarUrl,
      commentCount: data.commentCount.present
          ? data.commentCount.value
          : this.commentCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('senderUserId: $senderUserId, ')
          ..write('providerName: $providerName, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('url: $url, ')
          ..write('authorName: $authorName, ')
          ..write('authorAvatarUrl: $authorAvatarUrl, ')
          ..write('commentCount: $commentCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    senderUserId,
    providerName,
    title,
    content,
    url,
    authorName,
    authorAvatarUrl,
    commentCount,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivitiesTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.senderUserId == this.senderUserId &&
          other.providerName == this.providerName &&
          other.title == this.title &&
          other.content == this.content &&
          other.url == this.url &&
          other.authorName == this.authorName &&
          other.authorAvatarUrl == this.authorAvatarUrl &&
          other.commentCount == this.commentCount &&
          other.createdAt == this.createdAt);
}

class ActivitiesTableCompanion extends UpdateCompanion<ActivitiesTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> senderUserId;
  final Value<String> providerName;
  final Value<String> title;
  final Value<String> content;
  final Value<String?> url;
  final Value<String> authorName;
  final Value<String?> authorAvatarUrl;
  final Value<int> commentCount;
  final Value<PgDateTime> createdAt;
  final Value<int> rowid;
  const ActivitiesTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.senderUserId = const Value.absent(),
    this.providerName = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.url = const Value.absent(),
    this.authorName = const Value.absent(),
    this.authorAvatarUrl = const Value.absent(),
    this.commentCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivitiesTableCompanion.insert({
    required String id,
    required String userId,
    this.senderUserId = const Value.absent(),
    required String providerName,
    required String title,
    required String content,
    this.url = const Value.absent(),
    required String authorName,
    this.authorAvatarUrl = const Value.absent(),
    this.commentCount = const Value.absent(),
    required PgDateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       providerName = Value(providerName),
       title = Value(title),
       content = Value(content),
       authorName = Value(authorName),
       createdAt = Value(createdAt);
  static Insertable<ActivitiesTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? senderUserId,
    Expression<String>? providerName,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? url,
    Expression<String>? authorName,
    Expression<String>? authorAvatarUrl,
    Expression<int>? commentCount,
    Expression<PgDateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (senderUserId != null) 'sender_user_id': senderUserId,
      if (providerName != null) 'provider_name': providerName,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (url != null) 'url': url,
      if (authorName != null) 'author_name': authorName,
      if (authorAvatarUrl != null) 'author_avatar_url': authorAvatarUrl,
      if (commentCount != null) 'comment_count': commentCount,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivitiesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String?>? senderUserId,
    Value<String>? providerName,
    Value<String>? title,
    Value<String>? content,
    Value<String?>? url,
    Value<String>? authorName,
    Value<String?>? authorAvatarUrl,
    Value<int>? commentCount,
    Value<PgDateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ActivitiesTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      senderUserId: senderUserId ?? this.senderUserId,
      providerName: providerName ?? this.providerName,
      title: title ?? this.title,
      content: content ?? this.content,
      url: url ?? this.url,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (senderUserId.present) {
      map['sender_user_id'] = Variable<String>(senderUserId.value);
    }
    if (providerName.present) {
      map['provider_name'] = Variable<String>(providerName.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (authorName.present) {
      map['author_name'] = Variable<String>(authorName.value);
    }
    if (authorAvatarUrl.present) {
      map['author_avatar_url'] = Variable<String>(authorAvatarUrl.value);
    }
    if (commentCount.present) {
      map['comment_count'] = Variable<int>(commentCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<PgDateTime>(
        createdAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('senderUserId: $senderUserId, ')
          ..write('providerName: $providerName, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('url: $url, ')
          ..write('authorName: $authorName, ')
          ..write('authorAvatarUrl: $authorAvatarUrl, ')
          ..write('commentCount: $commentCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityPhorgeTableTable extends ActivityPhorgeTable
    with TableInfo<$ActivityPhorgeTableTable, ActivityPhorgeTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityPhorgeTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _taskPhidMeta = const VerificationMeta(
    'taskPhid',
  );
  @override
  late final GeneratedColumn<String> taskPhid = GeneratedColumn<String>(
    'task_phid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revisionIdMeta = const VerificationMeta(
    'revisionId',
  );
  @override
  late final GeneratedColumn<String> revisionId = GeneratedColumn<String>(
    'revision_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    activityId,
    taskPhid,
    revisionId,
    tags,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_phorge';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityPhorgeTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('task_phid')) {
      context.handle(
        _taskPhidMeta,
        taskPhid.isAcceptableOrUnknown(data['task_phid']!, _taskPhidMeta),
      );
    }
    if (data.containsKey('revision_id')) {
      context.handle(
        _revisionIdMeta,
        revisionId.isAcceptableOrUnknown(data['revision_id']!, _revisionIdMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {activityId};
  @override
  ActivityPhorgeTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityPhorgeTableData(
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      taskPhid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_phid'],
      ),
      revisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_id'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
    );
  }

  @override
  $ActivityPhorgeTableTable createAlias(String alias) {
    return $ActivityPhorgeTableTable(attachedDatabase, alias);
  }
}

class ActivityPhorgeTableData extends DataClass
    implements Insertable<ActivityPhorgeTableData> {
  final String activityId;
  final String? taskPhid;
  final String? revisionId;
  final String? tags;
  const ActivityPhorgeTableData({
    required this.activityId,
    this.taskPhid,
    this.revisionId,
    this.tags,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['activity_id'] = Variable<String>(activityId);
    if (!nullToAbsent || taskPhid != null) {
      map['task_phid'] = Variable<String>(taskPhid);
    }
    if (!nullToAbsent || revisionId != null) {
      map['revision_id'] = Variable<String>(revisionId);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    return map;
  }

  ActivityPhorgeTableCompanion toCompanion(bool nullToAbsent) {
    return ActivityPhorgeTableCompanion(
      activityId: Value(activityId),
      taskPhid: taskPhid == null && nullToAbsent
          ? const Value.absent()
          : Value(taskPhid),
      revisionId: revisionId == null && nullToAbsent
          ? const Value.absent()
          : Value(revisionId),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
    );
  }

  factory ActivityPhorgeTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityPhorgeTableData(
      activityId: serializer.fromJson<String>(json['activityId']),
      taskPhid: serializer.fromJson<String?>(json['taskPhid']),
      revisionId: serializer.fromJson<String?>(json['revisionId']),
      tags: serializer.fromJson<String?>(json['tags']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'activityId': serializer.toJson<String>(activityId),
      'taskPhid': serializer.toJson<String?>(taskPhid),
      'revisionId': serializer.toJson<String?>(revisionId),
      'tags': serializer.toJson<String?>(tags),
    };
  }

  ActivityPhorgeTableData copyWith({
    String? activityId,
    Value<String?> taskPhid = const Value.absent(),
    Value<String?> revisionId = const Value.absent(),
    Value<String?> tags = const Value.absent(),
  }) => ActivityPhorgeTableData(
    activityId: activityId ?? this.activityId,
    taskPhid: taskPhid.present ? taskPhid.value : this.taskPhid,
    revisionId: revisionId.present ? revisionId.value : this.revisionId,
    tags: tags.present ? tags.value : this.tags,
  );
  ActivityPhorgeTableData copyWithCompanion(ActivityPhorgeTableCompanion data) {
    return ActivityPhorgeTableData(
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      taskPhid: data.taskPhid.present ? data.taskPhid.value : this.taskPhid,
      revisionId: data.revisionId.present
          ? data.revisionId.value
          : this.revisionId,
      tags: data.tags.present ? data.tags.value : this.tags,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityPhorgeTableData(')
          ..write('activityId: $activityId, ')
          ..write('taskPhid: $taskPhid, ')
          ..write('revisionId: $revisionId, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(activityId, taskPhid, revisionId, tags);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityPhorgeTableData &&
          other.activityId == this.activityId &&
          other.taskPhid == this.taskPhid &&
          other.revisionId == this.revisionId &&
          other.tags == this.tags);
}

class ActivityPhorgeTableCompanion
    extends UpdateCompanion<ActivityPhorgeTableData> {
  final Value<String> activityId;
  final Value<String?> taskPhid;
  final Value<String?> revisionId;
  final Value<String?> tags;
  final Value<int> rowid;
  const ActivityPhorgeTableCompanion({
    this.activityId = const Value.absent(),
    this.taskPhid = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityPhorgeTableCompanion.insert({
    required String activityId,
    this.taskPhid = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : activityId = Value(activityId);
  static Insertable<ActivityPhorgeTableData> custom({
    Expression<String>? activityId,
    Expression<String>? taskPhid,
    Expression<String>? revisionId,
    Expression<String>? tags,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (activityId != null) 'activity_id': activityId,
      if (taskPhid != null) 'task_phid': taskPhid,
      if (revisionId != null) 'revision_id': revisionId,
      if (tags != null) 'tags': tags,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityPhorgeTableCompanion copyWith({
    Value<String>? activityId,
    Value<String?>? taskPhid,
    Value<String?>? revisionId,
    Value<String?>? tags,
    Value<int>? rowid,
  }) {
    return ActivityPhorgeTableCompanion(
      activityId: activityId ?? this.activityId,
      taskPhid: taskPhid ?? this.taskPhid,
      revisionId: revisionId ?? this.revisionId,
      tags: tags ?? this.tags,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (taskPhid.present) {
      map['task_phid'] = Variable<String>(taskPhid.value);
    }
    if (revisionId.present) {
      map['revision_id'] = Variable<String>(revisionId.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityPhorgeTableCompanion(')
          ..write('activityId: $activityId, ')
          ..write('taskPhid: $taskPhid, ')
          ..write('revisionId: $revisionId, ')
          ..write('tags: $tags, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityGithubCommitTableTable extends ActivityGithubCommitTable
    with
        TableInfo<
          $ActivityGithubCommitTableTable,
          ActivityGithubCommitTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityGithubCommitTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _repoMeta = const VerificationMeta('repo');
  @override
  late final GeneratedColumn<String> repo = GeneratedColumn<String>(
    'repo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _branchMeta = const VerificationMeta('branch');
  @override
  late final GeneratedColumn<String> branch = GeneratedColumn<String>(
    'branch',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [activityId, repo, branch];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_github_commit';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityGithubCommitTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('repo')) {
      context.handle(
        _repoMeta,
        repo.isAcceptableOrUnknown(data['repo']!, _repoMeta),
      );
    }
    if (data.containsKey('branch')) {
      context.handle(
        _branchMeta,
        branch.isAcceptableOrUnknown(data['branch']!, _branchMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {activityId};
  @override
  ActivityGithubCommitTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityGithubCommitTableData(
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      repo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repo'],
      ),
      branch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch'],
      ),
    );
  }

  @override
  $ActivityGithubCommitTableTable createAlias(String alias) {
    return $ActivityGithubCommitTableTable(attachedDatabase, alias);
  }
}

class ActivityGithubCommitTableData extends DataClass
    implements Insertable<ActivityGithubCommitTableData> {
  final String activityId;
  final String? repo;
  final String? branch;
  const ActivityGithubCommitTableData({
    required this.activityId,
    this.repo,
    this.branch,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['activity_id'] = Variable<String>(activityId);
    if (!nullToAbsent || repo != null) {
      map['repo'] = Variable<String>(repo);
    }
    if (!nullToAbsent || branch != null) {
      map['branch'] = Variable<String>(branch);
    }
    return map;
  }

  ActivityGithubCommitTableCompanion toCompanion(bool nullToAbsent) {
    return ActivityGithubCommitTableCompanion(
      activityId: Value(activityId),
      repo: repo == null && nullToAbsent ? const Value.absent() : Value(repo),
      branch: branch == null && nullToAbsent
          ? const Value.absent()
          : Value(branch),
    );
  }

  factory ActivityGithubCommitTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityGithubCommitTableData(
      activityId: serializer.fromJson<String>(json['activityId']),
      repo: serializer.fromJson<String?>(json['repo']),
      branch: serializer.fromJson<String?>(json['branch']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'activityId': serializer.toJson<String>(activityId),
      'repo': serializer.toJson<String?>(repo),
      'branch': serializer.toJson<String?>(branch),
    };
  }

  ActivityGithubCommitTableData copyWith({
    String? activityId,
    Value<String?> repo = const Value.absent(),
    Value<String?> branch = const Value.absent(),
  }) => ActivityGithubCommitTableData(
    activityId: activityId ?? this.activityId,
    repo: repo.present ? repo.value : this.repo,
    branch: branch.present ? branch.value : this.branch,
  );
  ActivityGithubCommitTableData copyWithCompanion(
    ActivityGithubCommitTableCompanion data,
  ) {
    return ActivityGithubCommitTableData(
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      repo: data.repo.present ? data.repo.value : this.repo,
      branch: data.branch.present ? data.branch.value : this.branch,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityGithubCommitTableData(')
          ..write('activityId: $activityId, ')
          ..write('repo: $repo, ')
          ..write('branch: $branch')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(activityId, repo, branch);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityGithubCommitTableData &&
          other.activityId == this.activityId &&
          other.repo == this.repo &&
          other.branch == this.branch);
}

class ActivityGithubCommitTableCompanion
    extends UpdateCompanion<ActivityGithubCommitTableData> {
  final Value<String> activityId;
  final Value<String?> repo;
  final Value<String?> branch;
  final Value<int> rowid;
  const ActivityGithubCommitTableCompanion({
    this.activityId = const Value.absent(),
    this.repo = const Value.absent(),
    this.branch = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityGithubCommitTableCompanion.insert({
    required String activityId,
    this.repo = const Value.absent(),
    this.branch = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : activityId = Value(activityId);
  static Insertable<ActivityGithubCommitTableData> custom({
    Expression<String>? activityId,
    Expression<String>? repo,
    Expression<String>? branch,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (activityId != null) 'activity_id': activityId,
      if (repo != null) 'repo': repo,
      if (branch != null) 'branch': branch,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityGithubCommitTableCompanion copyWith({
    Value<String>? activityId,
    Value<String?>? repo,
    Value<String?>? branch,
    Value<int>? rowid,
  }) {
    return ActivityGithubCommitTableCompanion(
      activityId: activityId ?? this.activityId,
      repo: repo ?? this.repo,
      branch: branch ?? this.branch,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (repo.present) {
      map['repo'] = Variable<String>(repo.value);
    }
    if (branch.present) {
      map['branch'] = Variable<String>(branch.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityGithubCommitTableCompanion(')
          ..write('activityId: $activityId, ')
          ..write('repo: $repo, ')
          ..write('branch: $branch, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityGitlabCommitTableTable extends ActivityGitlabCommitTable
    with
        TableInfo<
          $ActivityGitlabCommitTableTable,
          ActivityGitlabCommitTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityGitlabCommitTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _projectMeta = const VerificationMeta(
    'project',
  );
  @override
  late final GeneratedColumn<String> project = GeneratedColumn<String>(
    'project',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _branchMeta = const VerificationMeta('branch');
  @override
  late final GeneratedColumn<String> branch = GeneratedColumn<String>(
    'branch',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [activityId, project, branch];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_gitlab_commit';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityGitlabCommitTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('project')) {
      context.handle(
        _projectMeta,
        project.isAcceptableOrUnknown(data['project']!, _projectMeta),
      );
    }
    if (data.containsKey('branch')) {
      context.handle(
        _branchMeta,
        branch.isAcceptableOrUnknown(data['branch']!, _branchMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {activityId};
  @override
  ActivityGitlabCommitTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityGitlabCommitTableData(
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      project: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project'],
      ),
      branch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch'],
      ),
    );
  }

  @override
  $ActivityGitlabCommitTableTable createAlias(String alias) {
    return $ActivityGitlabCommitTableTable(attachedDatabase, alias);
  }
}

class ActivityGitlabCommitTableData extends DataClass
    implements Insertable<ActivityGitlabCommitTableData> {
  final String activityId;

  /// Full project path (e.g. `group/project`).
  final String? project;
  final String? branch;
  const ActivityGitlabCommitTableData({
    required this.activityId,
    this.project,
    this.branch,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['activity_id'] = Variable<String>(activityId);
    if (!nullToAbsent || project != null) {
      map['project'] = Variable<String>(project);
    }
    if (!nullToAbsent || branch != null) {
      map['branch'] = Variable<String>(branch);
    }
    return map;
  }

  ActivityGitlabCommitTableCompanion toCompanion(bool nullToAbsent) {
    return ActivityGitlabCommitTableCompanion(
      activityId: Value(activityId),
      project: project == null && nullToAbsent
          ? const Value.absent()
          : Value(project),
      branch: branch == null && nullToAbsent
          ? const Value.absent()
          : Value(branch),
    );
  }

  factory ActivityGitlabCommitTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityGitlabCommitTableData(
      activityId: serializer.fromJson<String>(json['activityId']),
      project: serializer.fromJson<String?>(json['project']),
      branch: serializer.fromJson<String?>(json['branch']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'activityId': serializer.toJson<String>(activityId),
      'project': serializer.toJson<String?>(project),
      'branch': serializer.toJson<String?>(branch),
    };
  }

  ActivityGitlabCommitTableData copyWith({
    String? activityId,
    Value<String?> project = const Value.absent(),
    Value<String?> branch = const Value.absent(),
  }) => ActivityGitlabCommitTableData(
    activityId: activityId ?? this.activityId,
    project: project.present ? project.value : this.project,
    branch: branch.present ? branch.value : this.branch,
  );
  ActivityGitlabCommitTableData copyWithCompanion(
    ActivityGitlabCommitTableCompanion data,
  ) {
    return ActivityGitlabCommitTableData(
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      project: data.project.present ? data.project.value : this.project,
      branch: data.branch.present ? data.branch.value : this.branch,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityGitlabCommitTableData(')
          ..write('activityId: $activityId, ')
          ..write('project: $project, ')
          ..write('branch: $branch')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(activityId, project, branch);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityGitlabCommitTableData &&
          other.activityId == this.activityId &&
          other.project == this.project &&
          other.branch == this.branch);
}

class ActivityGitlabCommitTableCompanion
    extends UpdateCompanion<ActivityGitlabCommitTableData> {
  final Value<String> activityId;
  final Value<String?> project;
  final Value<String?> branch;
  final Value<int> rowid;
  const ActivityGitlabCommitTableCompanion({
    this.activityId = const Value.absent(),
    this.project = const Value.absent(),
    this.branch = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityGitlabCommitTableCompanion.insert({
    required String activityId,
    this.project = const Value.absent(),
    this.branch = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : activityId = Value(activityId);
  static Insertable<ActivityGitlabCommitTableData> custom({
    Expression<String>? activityId,
    Expression<String>? project,
    Expression<String>? branch,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (activityId != null) 'activity_id': activityId,
      if (project != null) 'project': project,
      if (branch != null) 'branch': branch,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityGitlabCommitTableCompanion copyWith({
    Value<String>? activityId,
    Value<String?>? project,
    Value<String?>? branch,
    Value<int>? rowid,
  }) {
    return ActivityGitlabCommitTableCompanion(
      activityId: activityId ?? this.activityId,
      project: project ?? this.project,
      branch: branch ?? this.branch,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (project.present) {
      map['project'] = Variable<String>(project.value);
    }
    if (branch.present) {
      map['branch'] = Variable<String>(branch.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityGitlabCommitTableCompanion(')
          ..write('activityId: $activityId, ')
          ..write('project: $project, ')
          ..write('branch: $branch, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityBitbucketCommitTableTable extends ActivityBitbucketCommitTable
    with
        TableInfo<
          $ActivityBitbucketCommitTableTable,
          ActivityBitbucketCommitTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityBitbucketCommitTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _repoMeta = const VerificationMeta('repo');
  @override
  late final GeneratedColumn<String> repo = GeneratedColumn<String>(
    'repo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _branchMeta = const VerificationMeta('branch');
  @override
  late final GeneratedColumn<String> branch = GeneratedColumn<String>(
    'branch',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [activityId, repo, branch];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_bitbucket_commit';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityBitbucketCommitTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('repo')) {
      context.handle(
        _repoMeta,
        repo.isAcceptableOrUnknown(data['repo']!, _repoMeta),
      );
    }
    if (data.containsKey('branch')) {
      context.handle(
        _branchMeta,
        branch.isAcceptableOrUnknown(data['branch']!, _branchMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {activityId};
  @override
  ActivityBitbucketCommitTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityBitbucketCommitTableData(
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      repo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repo'],
      ),
      branch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch'],
      ),
    );
  }

  @override
  $ActivityBitbucketCommitTableTable createAlias(String alias) {
    return $ActivityBitbucketCommitTableTable(attachedDatabase, alias);
  }
}

class ActivityBitbucketCommitTableData extends DataClass
    implements Insertable<ActivityBitbucketCommitTableData> {
  final String activityId;

  /// Full repository slug (e.g. `workspace/repo`).
  final String? repo;
  final String? branch;
  const ActivityBitbucketCommitTableData({
    required this.activityId,
    this.repo,
    this.branch,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['activity_id'] = Variable<String>(activityId);
    if (!nullToAbsent || repo != null) {
      map['repo'] = Variable<String>(repo);
    }
    if (!nullToAbsent || branch != null) {
      map['branch'] = Variable<String>(branch);
    }
    return map;
  }

  ActivityBitbucketCommitTableCompanion toCompanion(bool nullToAbsent) {
    return ActivityBitbucketCommitTableCompanion(
      activityId: Value(activityId),
      repo: repo == null && nullToAbsent ? const Value.absent() : Value(repo),
      branch: branch == null && nullToAbsent
          ? const Value.absent()
          : Value(branch),
    );
  }

  factory ActivityBitbucketCommitTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityBitbucketCommitTableData(
      activityId: serializer.fromJson<String>(json['activityId']),
      repo: serializer.fromJson<String?>(json['repo']),
      branch: serializer.fromJson<String?>(json['branch']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'activityId': serializer.toJson<String>(activityId),
      'repo': serializer.toJson<String?>(repo),
      'branch': serializer.toJson<String?>(branch),
    };
  }

  ActivityBitbucketCommitTableData copyWith({
    String? activityId,
    Value<String?> repo = const Value.absent(),
    Value<String?> branch = const Value.absent(),
  }) => ActivityBitbucketCommitTableData(
    activityId: activityId ?? this.activityId,
    repo: repo.present ? repo.value : this.repo,
    branch: branch.present ? branch.value : this.branch,
  );
  ActivityBitbucketCommitTableData copyWithCompanion(
    ActivityBitbucketCommitTableCompanion data,
  ) {
    return ActivityBitbucketCommitTableData(
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      repo: data.repo.present ? data.repo.value : this.repo,
      branch: data.branch.present ? data.branch.value : this.branch,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityBitbucketCommitTableData(')
          ..write('activityId: $activityId, ')
          ..write('repo: $repo, ')
          ..write('branch: $branch')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(activityId, repo, branch);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityBitbucketCommitTableData &&
          other.activityId == this.activityId &&
          other.repo == this.repo &&
          other.branch == this.branch);
}

class ActivityBitbucketCommitTableCompanion
    extends UpdateCompanion<ActivityBitbucketCommitTableData> {
  final Value<String> activityId;
  final Value<String?> repo;
  final Value<String?> branch;
  final Value<int> rowid;
  const ActivityBitbucketCommitTableCompanion({
    this.activityId = const Value.absent(),
    this.repo = const Value.absent(),
    this.branch = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityBitbucketCommitTableCompanion.insert({
    required String activityId,
    this.repo = const Value.absent(),
    this.branch = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : activityId = Value(activityId);
  static Insertable<ActivityBitbucketCommitTableData> custom({
    Expression<String>? activityId,
    Expression<String>? repo,
    Expression<String>? branch,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (activityId != null) 'activity_id': activityId,
      if (repo != null) 'repo': repo,
      if (branch != null) 'branch': branch,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityBitbucketCommitTableCompanion copyWith({
    Value<String>? activityId,
    Value<String?>? repo,
    Value<String?>? branch,
    Value<int>? rowid,
  }) {
    return ActivityBitbucketCommitTableCompanion(
      activityId: activityId ?? this.activityId,
      repo: repo ?? this.repo,
      branch: branch ?? this.branch,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (repo.present) {
      map['repo'] = Variable<String>(repo.value);
    }
    if (branch.present) {
      map['branch'] = Variable<String>(branch.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityBitbucketCommitTableCompanion(')
          ..write('activityId: $activityId, ')
          ..write('repo: $repo, ')
          ..write('branch: $branch, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityJiraIssueTableTable extends ActivityJiraIssueTable
    with TableInfo<$ActivityJiraIssueTableTable, ActivityJiraIssueTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityJiraIssueTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _issueKeyMeta = const VerificationMeta(
    'issueKey',
  );
  @override
  late final GeneratedColumn<String> issueKey = GeneratedColumn<String>(
    'issue_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectKeyMeta = const VerificationMeta(
    'projectKey',
  );
  @override
  late final GeneratedColumn<String> projectKey = GeneratedColumn<String>(
    'project_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusNameMeta = const VerificationMeta(
    'statusName',
  );
  @override
  late final GeneratedColumn<String> statusName = GeneratedColumn<String>(
    'status_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    activityId,
    issueKey,
    projectKey,
    statusName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_jira_issue';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityJiraIssueTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('issue_key')) {
      context.handle(
        _issueKeyMeta,
        issueKey.isAcceptableOrUnknown(data['issue_key']!, _issueKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_issueKeyMeta);
    }
    if (data.containsKey('project_key')) {
      context.handle(
        _projectKeyMeta,
        projectKey.isAcceptableOrUnknown(data['project_key']!, _projectKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_projectKeyMeta);
    }
    if (data.containsKey('status_name')) {
      context.handle(
        _statusNameMeta,
        statusName.isAcceptableOrUnknown(data['status_name']!, _statusNameMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {activityId};
  @override
  ActivityJiraIssueTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityJiraIssueTableData(
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      issueKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}issue_key'],
      )!,
      projectKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_key'],
      )!,
      statusName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status_name'],
      ),
    );
  }

  @override
  $ActivityJiraIssueTableTable createAlias(String alias) {
    return $ActivityJiraIssueTableTable(attachedDatabase, alias);
  }
}

class ActivityJiraIssueTableData extends DataClass
    implements Insertable<ActivityJiraIssueTableData> {
  final String activityId;
  final String issueKey;
  final String projectKey;
  final String? statusName;
  const ActivityJiraIssueTableData({
    required this.activityId,
    required this.issueKey,
    required this.projectKey,
    this.statusName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['activity_id'] = Variable<String>(activityId);
    map['issue_key'] = Variable<String>(issueKey);
    map['project_key'] = Variable<String>(projectKey);
    if (!nullToAbsent || statusName != null) {
      map['status_name'] = Variable<String>(statusName);
    }
    return map;
  }

  ActivityJiraIssueTableCompanion toCompanion(bool nullToAbsent) {
    return ActivityJiraIssueTableCompanion(
      activityId: Value(activityId),
      issueKey: Value(issueKey),
      projectKey: Value(projectKey),
      statusName: statusName == null && nullToAbsent
          ? const Value.absent()
          : Value(statusName),
    );
  }

  factory ActivityJiraIssueTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityJiraIssueTableData(
      activityId: serializer.fromJson<String>(json['activityId']),
      issueKey: serializer.fromJson<String>(json['issueKey']),
      projectKey: serializer.fromJson<String>(json['projectKey']),
      statusName: serializer.fromJson<String?>(json['statusName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'activityId': serializer.toJson<String>(activityId),
      'issueKey': serializer.toJson<String>(issueKey),
      'projectKey': serializer.toJson<String>(projectKey),
      'statusName': serializer.toJson<String?>(statusName),
    };
  }

  ActivityJiraIssueTableData copyWith({
    String? activityId,
    String? issueKey,
    String? projectKey,
    Value<String?> statusName = const Value.absent(),
  }) => ActivityJiraIssueTableData(
    activityId: activityId ?? this.activityId,
    issueKey: issueKey ?? this.issueKey,
    projectKey: projectKey ?? this.projectKey,
    statusName: statusName.present ? statusName.value : this.statusName,
  );
  ActivityJiraIssueTableData copyWithCompanion(
    ActivityJiraIssueTableCompanion data,
  ) {
    return ActivityJiraIssueTableData(
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      issueKey: data.issueKey.present ? data.issueKey.value : this.issueKey,
      projectKey: data.projectKey.present
          ? data.projectKey.value
          : this.projectKey,
      statusName: data.statusName.present
          ? data.statusName.value
          : this.statusName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityJiraIssueTableData(')
          ..write('activityId: $activityId, ')
          ..write('issueKey: $issueKey, ')
          ..write('projectKey: $projectKey, ')
          ..write('statusName: $statusName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(activityId, issueKey, projectKey, statusName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityJiraIssueTableData &&
          other.activityId == this.activityId &&
          other.issueKey == this.issueKey &&
          other.projectKey == this.projectKey &&
          other.statusName == this.statusName);
}

class ActivityJiraIssueTableCompanion
    extends UpdateCompanion<ActivityJiraIssueTableData> {
  final Value<String> activityId;
  final Value<String> issueKey;
  final Value<String> projectKey;
  final Value<String?> statusName;
  final Value<int> rowid;
  const ActivityJiraIssueTableCompanion({
    this.activityId = const Value.absent(),
    this.issueKey = const Value.absent(),
    this.projectKey = const Value.absent(),
    this.statusName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityJiraIssueTableCompanion.insert({
    required String activityId,
    required String issueKey,
    required String projectKey,
    this.statusName = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : activityId = Value(activityId),
       issueKey = Value(issueKey),
       projectKey = Value(projectKey);
  static Insertable<ActivityJiraIssueTableData> custom({
    Expression<String>? activityId,
    Expression<String>? issueKey,
    Expression<String>? projectKey,
    Expression<String>? statusName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (activityId != null) 'activity_id': activityId,
      if (issueKey != null) 'issue_key': issueKey,
      if (projectKey != null) 'project_key': projectKey,
      if (statusName != null) 'status_name': statusName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityJiraIssueTableCompanion copyWith({
    Value<String>? activityId,
    Value<String>? issueKey,
    Value<String>? projectKey,
    Value<String?>? statusName,
    Value<int>? rowid,
  }) {
    return ActivityJiraIssueTableCompanion(
      activityId: activityId ?? this.activityId,
      issueKey: issueKey ?? this.issueKey,
      projectKey: projectKey ?? this.projectKey,
      statusName: statusName ?? this.statusName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (issueKey.present) {
      map['issue_key'] = Variable<String>(issueKey.value);
    }
    if (projectKey.present) {
      map['project_key'] = Variable<String>(projectKey.value);
    }
    if (statusName.present) {
      map['status_name'] = Variable<String>(statusName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityJiraIssueTableCompanion(')
          ..write('activityId: $activityId, ')
          ..write('issueKey: $issueKey, ')
          ..write('projectKey: $projectKey, ')
          ..write('statusName: $statusName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityLinearIssueTableTable extends ActivityLinearIssueTable
    with
        TableInfo<
          $ActivityLinearIssueTableTable,
          ActivityLinearIssueTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityLinearIssueTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _identifierMeta = const VerificationMeta(
    'identifier',
  );
  @override
  late final GeneratedColumn<String> identifier = GeneratedColumn<String>(
    'identifier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teamKeyMeta = const VerificationMeta(
    'teamKey',
  );
  @override
  late final GeneratedColumn<String> teamKey = GeneratedColumn<String>(
    'team_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusNameMeta = const VerificationMeta(
    'statusName',
  );
  @override
  late final GeneratedColumn<String> statusName = GeneratedColumn<String>(
    'status_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    activityId,
    identifier,
    teamKey,
    statusName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_linear_issue';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityLinearIssueTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('identifier')) {
      context.handle(
        _identifierMeta,
        identifier.isAcceptableOrUnknown(data['identifier']!, _identifierMeta),
      );
    } else if (isInserting) {
      context.missing(_identifierMeta);
    }
    if (data.containsKey('team_key')) {
      context.handle(
        _teamKeyMeta,
        teamKey.isAcceptableOrUnknown(data['team_key']!, _teamKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_teamKeyMeta);
    }
    if (data.containsKey('status_name')) {
      context.handle(
        _statusNameMeta,
        statusName.isAcceptableOrUnknown(data['status_name']!, _statusNameMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {activityId};
  @override
  ActivityLinearIssueTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityLinearIssueTableData(
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      identifier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identifier'],
      )!,
      teamKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}team_key'],
      )!,
      statusName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status_name'],
      ),
    );
  }

  @override
  $ActivityLinearIssueTableTable createAlias(String alias) {
    return $ActivityLinearIssueTableTable(attachedDatabase, alias);
  }
}

class ActivityLinearIssueTableData extends DataClass
    implements Insertable<ActivityLinearIssueTableData> {
  final String activityId;
  final String identifier;
  final String teamKey;
  final String? statusName;
  const ActivityLinearIssueTableData({
    required this.activityId,
    required this.identifier,
    required this.teamKey,
    this.statusName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['activity_id'] = Variable<String>(activityId);
    map['identifier'] = Variable<String>(identifier);
    map['team_key'] = Variable<String>(teamKey);
    if (!nullToAbsent || statusName != null) {
      map['status_name'] = Variable<String>(statusName);
    }
    return map;
  }

  ActivityLinearIssueTableCompanion toCompanion(bool nullToAbsent) {
    return ActivityLinearIssueTableCompanion(
      activityId: Value(activityId),
      identifier: Value(identifier),
      teamKey: Value(teamKey),
      statusName: statusName == null && nullToAbsent
          ? const Value.absent()
          : Value(statusName),
    );
  }

  factory ActivityLinearIssueTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityLinearIssueTableData(
      activityId: serializer.fromJson<String>(json['activityId']),
      identifier: serializer.fromJson<String>(json['identifier']),
      teamKey: serializer.fromJson<String>(json['teamKey']),
      statusName: serializer.fromJson<String?>(json['statusName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'activityId': serializer.toJson<String>(activityId),
      'identifier': serializer.toJson<String>(identifier),
      'teamKey': serializer.toJson<String>(teamKey),
      'statusName': serializer.toJson<String?>(statusName),
    };
  }

  ActivityLinearIssueTableData copyWith({
    String? activityId,
    String? identifier,
    String? teamKey,
    Value<String?> statusName = const Value.absent(),
  }) => ActivityLinearIssueTableData(
    activityId: activityId ?? this.activityId,
    identifier: identifier ?? this.identifier,
    teamKey: teamKey ?? this.teamKey,
    statusName: statusName.present ? statusName.value : this.statusName,
  );
  ActivityLinearIssueTableData copyWithCompanion(
    ActivityLinearIssueTableCompanion data,
  ) {
    return ActivityLinearIssueTableData(
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      identifier: data.identifier.present
          ? data.identifier.value
          : this.identifier,
      teamKey: data.teamKey.present ? data.teamKey.value : this.teamKey,
      statusName: data.statusName.present
          ? data.statusName.value
          : this.statusName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLinearIssueTableData(')
          ..write('activityId: $activityId, ')
          ..write('identifier: $identifier, ')
          ..write('teamKey: $teamKey, ')
          ..write('statusName: $statusName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(activityId, identifier, teamKey, statusName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityLinearIssueTableData &&
          other.activityId == this.activityId &&
          other.identifier == this.identifier &&
          other.teamKey == this.teamKey &&
          other.statusName == this.statusName);
}

class ActivityLinearIssueTableCompanion
    extends UpdateCompanion<ActivityLinearIssueTableData> {
  final Value<String> activityId;
  final Value<String> identifier;
  final Value<String> teamKey;
  final Value<String?> statusName;
  final Value<int> rowid;
  const ActivityLinearIssueTableCompanion({
    this.activityId = const Value.absent(),
    this.identifier = const Value.absent(),
    this.teamKey = const Value.absent(),
    this.statusName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityLinearIssueTableCompanion.insert({
    required String activityId,
    required String identifier,
    required String teamKey,
    this.statusName = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : activityId = Value(activityId),
       identifier = Value(identifier),
       teamKey = Value(teamKey);
  static Insertable<ActivityLinearIssueTableData> custom({
    Expression<String>? activityId,
    Expression<String>? identifier,
    Expression<String>? teamKey,
    Expression<String>? statusName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (activityId != null) 'activity_id': activityId,
      if (identifier != null) 'identifier': identifier,
      if (teamKey != null) 'team_key': teamKey,
      if (statusName != null) 'status_name': statusName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityLinearIssueTableCompanion copyWith({
    Value<String>? activityId,
    Value<String>? identifier,
    Value<String>? teamKey,
    Value<String?>? statusName,
    Value<int>? rowid,
  }) {
    return ActivityLinearIssueTableCompanion(
      activityId: activityId ?? this.activityId,
      identifier: identifier ?? this.identifier,
      teamKey: teamKey ?? this.teamKey,
      statusName: statusName ?? this.statusName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (identifier.present) {
      map['identifier'] = Variable<String>(identifier.value);
    }
    if (teamKey.present) {
      map['team_key'] = Variable<String>(teamKey.value);
    }
    if (statusName.present) {
      map['status_name'] = Variable<String>(statusName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLinearIssueTableCompanion(')
          ..write('activityId: $activityId, ')
          ..write('identifier: $identifier, ')
          ..write('teamKey: $teamKey, ')
          ..write('statusName: $statusName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivitySlackMessageTableTable extends ActivitySlackMessageTable
    with
        TableInfo<
          $ActivitySlackMessageTableTable,
          ActivitySlackMessageTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitySlackMessageTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _threadTsMeta = const VerificationMeta(
    'threadTs',
  );
  @override
  late final GeneratedColumn<String> threadTs = GeneratedColumn<String>(
    'thread_ts',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _messageTsMeta = const VerificationMeta(
    'messageTs',
  );
  @override
  late final GeneratedColumn<String> messageTs = GeneratedColumn<String>(
    'message_ts',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    activityId,
    workspaceId,
    channelId,
    threadTs,
    messageTs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_slack_message';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivitySlackMessageTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    }
    if (data.containsKey('thread_ts')) {
      context.handle(
        _threadTsMeta,
        threadTs.isAcceptableOrUnknown(data['thread_ts']!, _threadTsMeta),
      );
    }
    if (data.containsKey('message_ts')) {
      context.handle(
        _messageTsMeta,
        messageTs.isAcceptableOrUnknown(data['message_ts']!, _messageTsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {activityId};
  @override
  ActivitySlackMessageTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivitySlackMessageTableData(
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      ),
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      ),
      threadTs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thread_ts'],
      ),
      messageTs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_ts'],
      ),
    );
  }

  @override
  $ActivitySlackMessageTableTable createAlias(String alias) {
    return $ActivitySlackMessageTableTable(attachedDatabase, alias);
  }
}

class ActivitySlackMessageTableData extends DataClass
    implements Insertable<ActivitySlackMessageTableData> {
  final String activityId;
  final String? workspaceId;
  final String? channelId;
  final String? threadTs;
  final String? messageTs;
  const ActivitySlackMessageTableData({
    required this.activityId,
    this.workspaceId,
    this.channelId,
    this.threadTs,
    this.messageTs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['activity_id'] = Variable<String>(activityId);
    if (!nullToAbsent || workspaceId != null) {
      map['workspace_id'] = Variable<String>(workspaceId);
    }
    if (!nullToAbsent || channelId != null) {
      map['channel_id'] = Variable<String>(channelId);
    }
    if (!nullToAbsent || threadTs != null) {
      map['thread_ts'] = Variable<String>(threadTs);
    }
    if (!nullToAbsent || messageTs != null) {
      map['message_ts'] = Variable<String>(messageTs);
    }
    return map;
  }

  ActivitySlackMessageTableCompanion toCompanion(bool nullToAbsent) {
    return ActivitySlackMessageTableCompanion(
      activityId: Value(activityId),
      workspaceId: workspaceId == null && nullToAbsent
          ? const Value.absent()
          : Value(workspaceId),
      channelId: channelId == null && nullToAbsent
          ? const Value.absent()
          : Value(channelId),
      threadTs: threadTs == null && nullToAbsent
          ? const Value.absent()
          : Value(threadTs),
      messageTs: messageTs == null && nullToAbsent
          ? const Value.absent()
          : Value(messageTs),
    );
  }

  factory ActivitySlackMessageTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivitySlackMessageTableData(
      activityId: serializer.fromJson<String>(json['activityId']),
      workspaceId: serializer.fromJson<String?>(json['workspaceId']),
      channelId: serializer.fromJson<String?>(json['channelId']),
      threadTs: serializer.fromJson<String?>(json['threadTs']),
      messageTs: serializer.fromJson<String?>(json['messageTs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'activityId': serializer.toJson<String>(activityId),
      'workspaceId': serializer.toJson<String?>(workspaceId),
      'channelId': serializer.toJson<String?>(channelId),
      'threadTs': serializer.toJson<String?>(threadTs),
      'messageTs': serializer.toJson<String?>(messageTs),
    };
  }

  ActivitySlackMessageTableData copyWith({
    String? activityId,
    Value<String?> workspaceId = const Value.absent(),
    Value<String?> channelId = const Value.absent(),
    Value<String?> threadTs = const Value.absent(),
    Value<String?> messageTs = const Value.absent(),
  }) => ActivitySlackMessageTableData(
    activityId: activityId ?? this.activityId,
    workspaceId: workspaceId.present ? workspaceId.value : this.workspaceId,
    channelId: channelId.present ? channelId.value : this.channelId,
    threadTs: threadTs.present ? threadTs.value : this.threadTs,
    messageTs: messageTs.present ? messageTs.value : this.messageTs,
  );
  ActivitySlackMessageTableData copyWithCompanion(
    ActivitySlackMessageTableCompanion data,
  ) {
    return ActivitySlackMessageTableData(
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      threadTs: data.threadTs.present ? data.threadTs.value : this.threadTs,
      messageTs: data.messageTs.present ? data.messageTs.value : this.messageTs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivitySlackMessageTableData(')
          ..write('activityId: $activityId, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('channelId: $channelId, ')
          ..write('threadTs: $threadTs, ')
          ..write('messageTs: $messageTs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(activityId, workspaceId, channelId, threadTs, messageTs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivitySlackMessageTableData &&
          other.activityId == this.activityId &&
          other.workspaceId == this.workspaceId &&
          other.channelId == this.channelId &&
          other.threadTs == this.threadTs &&
          other.messageTs == this.messageTs);
}

class ActivitySlackMessageTableCompanion
    extends UpdateCompanion<ActivitySlackMessageTableData> {
  final Value<String> activityId;
  final Value<String?> workspaceId;
  final Value<String?> channelId;
  final Value<String?> threadTs;
  final Value<String?> messageTs;
  final Value<int> rowid;
  const ActivitySlackMessageTableCompanion({
    this.activityId = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.channelId = const Value.absent(),
    this.threadTs = const Value.absent(),
    this.messageTs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivitySlackMessageTableCompanion.insert({
    required String activityId,
    this.workspaceId = const Value.absent(),
    this.channelId = const Value.absent(),
    this.threadTs = const Value.absent(),
    this.messageTs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : activityId = Value(activityId);
  static Insertable<ActivitySlackMessageTableData> custom({
    Expression<String>? activityId,
    Expression<String>? workspaceId,
    Expression<String>? channelId,
    Expression<String>? threadTs,
    Expression<String>? messageTs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (activityId != null) 'activity_id': activityId,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (channelId != null) 'channel_id': channelId,
      if (threadTs != null) 'thread_ts': threadTs,
      if (messageTs != null) 'message_ts': messageTs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivitySlackMessageTableCompanion copyWith({
    Value<String>? activityId,
    Value<String?>? workspaceId,
    Value<String?>? channelId,
    Value<String?>? threadTs,
    Value<String?>? messageTs,
    Value<int>? rowid,
  }) {
    return ActivitySlackMessageTableCompanion(
      activityId: activityId ?? this.activityId,
      workspaceId: workspaceId ?? this.workspaceId,
      channelId: channelId ?? this.channelId,
      threadTs: threadTs ?? this.threadTs,
      messageTs: messageTs ?? this.messageTs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (threadTs.present) {
      map['thread_ts'] = Variable<String>(threadTs.value);
    }
    if (messageTs.present) {
      map['message_ts'] = Variable<String>(messageTs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitySlackMessageTableCompanion(')
          ..write('activityId: $activityId, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('channelId: $channelId, ')
          ..write('threadTs: $threadTs, ')
          ..write('messageTs: $messageTs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityDiscordMessageTableTable extends ActivityDiscordMessageTable
    with
        TableInfo<
          $ActivityDiscordMessageTableTable,
          ActivityDiscordMessageTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityDiscordMessageTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _guildIdMeta = const VerificationMeta(
    'guildId',
  );
  @override
  late final GeneratedColumn<String> guildId = GeneratedColumn<String>(
    'guild_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _replyToIdMeta = const VerificationMeta(
    'replyToId',
  );
  @override
  late final GeneratedColumn<String> replyToId = GeneratedColumn<String>(
    'reply_to_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    activityId,
    guildId,
    channelId,
    messageId,
    replyToId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_discord_message';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityDiscordMessageTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('guild_id')) {
      context.handle(
        _guildIdMeta,
        guildId.isAcceptableOrUnknown(data['guild_id']!, _guildIdMeta),
      );
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    }
    if (data.containsKey('reply_to_id')) {
      context.handle(
        _replyToIdMeta,
        replyToId.isAcceptableOrUnknown(data['reply_to_id']!, _replyToIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {activityId};
  @override
  ActivityDiscordMessageTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityDiscordMessageTableData(
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      guildId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guild_id'],
      ),
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      ),
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id'],
      ),
      replyToId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reply_to_id'],
      ),
    );
  }

  @override
  $ActivityDiscordMessageTableTable createAlias(String alias) {
    return $ActivityDiscordMessageTableTable(attachedDatabase, alias);
  }
}

class ActivityDiscordMessageTableData extends DataClass
    implements Insertable<ActivityDiscordMessageTableData> {
  final String activityId;
  final String? guildId;
  final String? channelId;
  final String? messageId;
  final String? replyToId;
  const ActivityDiscordMessageTableData({
    required this.activityId,
    this.guildId,
    this.channelId,
    this.messageId,
    this.replyToId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['activity_id'] = Variable<String>(activityId);
    if (!nullToAbsent || guildId != null) {
      map['guild_id'] = Variable<String>(guildId);
    }
    if (!nullToAbsent || channelId != null) {
      map['channel_id'] = Variable<String>(channelId);
    }
    if (!nullToAbsent || messageId != null) {
      map['message_id'] = Variable<String>(messageId);
    }
    if (!nullToAbsent || replyToId != null) {
      map['reply_to_id'] = Variable<String>(replyToId);
    }
    return map;
  }

  ActivityDiscordMessageTableCompanion toCompanion(bool nullToAbsent) {
    return ActivityDiscordMessageTableCompanion(
      activityId: Value(activityId),
      guildId: guildId == null && nullToAbsent
          ? const Value.absent()
          : Value(guildId),
      channelId: channelId == null && nullToAbsent
          ? const Value.absent()
          : Value(channelId),
      messageId: messageId == null && nullToAbsent
          ? const Value.absent()
          : Value(messageId),
      replyToId: replyToId == null && nullToAbsent
          ? const Value.absent()
          : Value(replyToId),
    );
  }

  factory ActivityDiscordMessageTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityDiscordMessageTableData(
      activityId: serializer.fromJson<String>(json['activityId']),
      guildId: serializer.fromJson<String?>(json['guildId']),
      channelId: serializer.fromJson<String?>(json['channelId']),
      messageId: serializer.fromJson<String?>(json['messageId']),
      replyToId: serializer.fromJson<String?>(json['replyToId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'activityId': serializer.toJson<String>(activityId),
      'guildId': serializer.toJson<String?>(guildId),
      'channelId': serializer.toJson<String?>(channelId),
      'messageId': serializer.toJson<String?>(messageId),
      'replyToId': serializer.toJson<String?>(replyToId),
    };
  }

  ActivityDiscordMessageTableData copyWith({
    String? activityId,
    Value<String?> guildId = const Value.absent(),
    Value<String?> channelId = const Value.absent(),
    Value<String?> messageId = const Value.absent(),
    Value<String?> replyToId = const Value.absent(),
  }) => ActivityDiscordMessageTableData(
    activityId: activityId ?? this.activityId,
    guildId: guildId.present ? guildId.value : this.guildId,
    channelId: channelId.present ? channelId.value : this.channelId,
    messageId: messageId.present ? messageId.value : this.messageId,
    replyToId: replyToId.present ? replyToId.value : this.replyToId,
  );
  ActivityDiscordMessageTableData copyWithCompanion(
    ActivityDiscordMessageTableCompanion data,
  ) {
    return ActivityDiscordMessageTableData(
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      guildId: data.guildId.present ? data.guildId.value : this.guildId,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      replyToId: data.replyToId.present ? data.replyToId.value : this.replyToId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityDiscordMessageTableData(')
          ..write('activityId: $activityId, ')
          ..write('guildId: $guildId, ')
          ..write('channelId: $channelId, ')
          ..write('messageId: $messageId, ')
          ..write('replyToId: $replyToId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(activityId, guildId, channelId, messageId, replyToId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityDiscordMessageTableData &&
          other.activityId == this.activityId &&
          other.guildId == this.guildId &&
          other.channelId == this.channelId &&
          other.messageId == this.messageId &&
          other.replyToId == this.replyToId);
}

class ActivityDiscordMessageTableCompanion
    extends UpdateCompanion<ActivityDiscordMessageTableData> {
  final Value<String> activityId;
  final Value<String?> guildId;
  final Value<String?> channelId;
  final Value<String?> messageId;
  final Value<String?> replyToId;
  final Value<int> rowid;
  const ActivityDiscordMessageTableCompanion({
    this.activityId = const Value.absent(),
    this.guildId = const Value.absent(),
    this.channelId = const Value.absent(),
    this.messageId = const Value.absent(),
    this.replyToId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityDiscordMessageTableCompanion.insert({
    required String activityId,
    this.guildId = const Value.absent(),
    this.channelId = const Value.absent(),
    this.messageId = const Value.absent(),
    this.replyToId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : activityId = Value(activityId);
  static Insertable<ActivityDiscordMessageTableData> custom({
    Expression<String>? activityId,
    Expression<String>? guildId,
    Expression<String>? channelId,
    Expression<String>? messageId,
    Expression<String>? replyToId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (activityId != null) 'activity_id': activityId,
      if (guildId != null) 'guild_id': guildId,
      if (channelId != null) 'channel_id': channelId,
      if (messageId != null) 'message_id': messageId,
      if (replyToId != null) 'reply_to_id': replyToId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityDiscordMessageTableCompanion copyWith({
    Value<String>? activityId,
    Value<String?>? guildId,
    Value<String?>? channelId,
    Value<String?>? messageId,
    Value<String?>? replyToId,
    Value<int>? rowid,
  }) {
    return ActivityDiscordMessageTableCompanion(
      activityId: activityId ?? this.activityId,
      guildId: guildId ?? this.guildId,
      channelId: channelId ?? this.channelId,
      messageId: messageId ?? this.messageId,
      replyToId: replyToId ?? this.replyToId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (guildId.present) {
      map['guild_id'] = Variable<String>(guildId.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (replyToId.present) {
      map['reply_to_id'] = Variable<String>(replyToId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityDiscordMessageTableCompanion(')
          ..write('activityId: $activityId, ')
          ..write('guildId: $guildId, ')
          ..write('channelId: $channelId, ')
          ..write('messageId: $messageId, ')
          ..write('replyToId: $replyToId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTableTable extends SessionsTable
    with TableInfo<$SessionsTableTable, SessionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refreshTokenMeta = const VerificationMeta(
    'refreshToken',
  );
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
    'token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> expiresAt =
      GeneratedColumn<PgDateTime>(
        'expires_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _deviceInfoMeta = const VerificationMeta(
    'deviceInfo',
  );
  @override
  late final GeneratedColumn<String> deviceInfo = GeneratedColumn<String>(
    'device_info',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    refreshToken,
    expiresAt,
    deviceInfo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('token')) {
      context.handle(
        _refreshTokenMeta,
        refreshToken.isAcceptableOrUnknown(data['token']!, _refreshTokenMeta),
      );
    } else if (isInserting) {
      context.missing(_refreshTokenMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('device_info')) {
      context.handle(
        _deviceInfoMeta,
        deviceInfo.isAcceptableOrUnknown(data['device_info']!, _deviceInfoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      refreshToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}expires_at'],
      )!,
      deviceInfo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_info'],
      ),
    );
  }

  @override
  $SessionsTableTable createAlias(String alias) {
    return $SessionsTableTable(attachedDatabase, alias);
  }
}

class SessionsTableData extends DataClass
    implements Insertable<SessionsTableData> {
  final String id;
  final String userId;
  final String refreshToken;
  final PgDateTime expiresAt;
  final String? deviceInfo;
  const SessionsTableData({
    required this.id,
    required this.userId,
    required this.refreshToken,
    required this.expiresAt,
    this.deviceInfo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['token'] = Variable<String>(refreshToken);
    map['expires_at'] = Variable<PgDateTime>(
      expiresAt,
      PgTypes.timestampWithTimezone,
    );
    if (!nullToAbsent || deviceInfo != null) {
      map['device_info'] = Variable<String>(deviceInfo);
    }
    return map;
  }

  SessionsTableCompanion toCompanion(bool nullToAbsent) {
    return SessionsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      refreshToken: Value(refreshToken),
      expiresAt: Value(expiresAt),
      deviceInfo: deviceInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceInfo),
    );
  }

  factory SessionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      refreshToken: serializer.fromJson<String>(json['refreshToken']),
      expiresAt: serializer.fromJson<PgDateTime>(json['expiresAt']),
      deviceInfo: serializer.fromJson<String?>(json['deviceInfo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'refreshToken': serializer.toJson<String>(refreshToken),
      'expiresAt': serializer.toJson<PgDateTime>(expiresAt),
      'deviceInfo': serializer.toJson<String?>(deviceInfo),
    };
  }

  SessionsTableData copyWith({
    String? id,
    String? userId,
    String? refreshToken,
    PgDateTime? expiresAt,
    Value<String?> deviceInfo = const Value.absent(),
  }) => SessionsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    refreshToken: refreshToken ?? this.refreshToken,
    expiresAt: expiresAt ?? this.expiresAt,
    deviceInfo: deviceInfo.present ? deviceInfo.value : this.deviceInfo,
  );
  SessionsTableData copyWithCompanion(SessionsTableCompanion data) {
    return SessionsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      refreshToken: data.refreshToken.present
          ? data.refreshToken.value
          : this.refreshToken,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      deviceInfo: data.deviceInfo.present
          ? data.deviceInfo.value
          : this.deviceInfo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('deviceInfo: $deviceInfo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, refreshToken, expiresAt, deviceInfo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.refreshToken == this.refreshToken &&
          other.expiresAt == this.expiresAt &&
          other.deviceInfo == this.deviceInfo);
}

class SessionsTableCompanion extends UpdateCompanion<SessionsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> refreshToken;
  final Value<PgDateTime> expiresAt;
  final Value<String?> deviceInfo;
  final Value<int> rowid;
  const SessionsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.deviceInfo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsTableCompanion.insert({
    required String id,
    required String userId,
    required String refreshToken,
    required PgDateTime expiresAt,
    this.deviceInfo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       refreshToken = Value(refreshToken),
       expiresAt = Value(expiresAt);
  static Insertable<SessionsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? refreshToken,
    Expression<PgDateTime>? expiresAt,
    Expression<String>? deviceInfo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (refreshToken != null) 'token': refreshToken,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (deviceInfo != null) 'device_info': deviceInfo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? refreshToken,
    Value<PgDateTime>? expiresAt,
    Value<String?>? deviceInfo,
    Value<int>? rowid,
  }) {
    return SessionsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (refreshToken.present) {
      map['token'] = Variable<String>(refreshToken.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<PgDateTime>(
        expiresAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (deviceInfo.present) {
      map['device_info'] = Variable<String>(deviceInfo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('deviceInfo: $deviceInfo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupsTableTable extends GroupsTable
    with TableInfo<$GroupsTableTable, GroupsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconUrlMeta = const VerificationMeta(
    'iconUrl',
  );
  @override
  late final GeneratedColumn<String> iconUrl = GeneratedColumn<String>(
    'icon_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _providerNameMeta = const VerificationMeta(
    'providerName',
  );
  @override
  late final GeneratedColumn<String> providerName = GeneratedColumn<String>(
    'provider_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, type, iconUrl, providerName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('icon_url')) {
      context.handle(
        _iconUrlMeta,
        iconUrl.isAcceptableOrUnknown(data['icon_url']!, _iconUrlMeta),
      );
    }
    if (data.containsKey('provider_name')) {
      context.handle(
        _providerNameMeta,
        providerName.isAcceptableOrUnknown(
          data['provider_name']!,
          _providerNameMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      iconUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_url'],
      ),
      providerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_name'],
      ),
    );
  }

  @override
  $GroupsTableTable createAlias(String alias) {
    return $GroupsTableTable(attachedDatabase, alias);
  }
}

class GroupsTableData extends DataClass implements Insertable<GroupsTableData> {
  final String id;
  final String name;
  final String type;
  final String? iconUrl;
  final String? providerName;
  const GroupsTableData({
    required this.id,
    required this.name,
    required this.type,
    this.iconUrl,
    this.providerName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || iconUrl != null) {
      map['icon_url'] = Variable<String>(iconUrl);
    }
    if (!nullToAbsent || providerName != null) {
      map['provider_name'] = Variable<String>(providerName);
    }
    return map;
  }

  GroupsTableCompanion toCompanion(bool nullToAbsent) {
    return GroupsTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      iconUrl: iconUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(iconUrl),
      providerName: providerName == null && nullToAbsent
          ? const Value.absent()
          : Value(providerName),
    );
  }

  factory GroupsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      iconUrl: serializer.fromJson<String?>(json['iconUrl']),
      providerName: serializer.fromJson<String?>(json['providerName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'iconUrl': serializer.toJson<String?>(iconUrl),
      'providerName': serializer.toJson<String?>(providerName),
    };
  }

  GroupsTableData copyWith({
    String? id,
    String? name,
    String? type,
    Value<String?> iconUrl = const Value.absent(),
    Value<String?> providerName = const Value.absent(),
  }) => GroupsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    iconUrl: iconUrl.present ? iconUrl.value : this.iconUrl,
    providerName: providerName.present ? providerName.value : this.providerName,
  );
  GroupsTableData copyWithCompanion(GroupsTableCompanion data) {
    return GroupsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      iconUrl: data.iconUrl.present ? data.iconUrl.value : this.iconUrl,
      providerName: data.providerName.present
          ? data.providerName.value
          : this.providerName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('iconUrl: $iconUrl, ')
          ..write('providerName: $providerName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, iconUrl, providerName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.iconUrl == this.iconUrl &&
          other.providerName == this.providerName);
}

class GroupsTableCompanion extends UpdateCompanion<GroupsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> iconUrl;
  final Value<String?> providerName;
  final Value<int> rowid;
  const GroupsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.iconUrl = const Value.absent(),
    this.providerName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupsTableCompanion.insert({
    required String id,
    required String name,
    required String type,
    this.iconUrl = const Value.absent(),
    this.providerName = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type);
  static Insertable<GroupsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? iconUrl,
    Expression<String>? providerName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (iconUrl != null) 'icon_url': iconUrl,
      if (providerName != null) 'provider_name': providerName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String?>? iconUrl,
    Value<String?>? providerName,
    Value<int>? rowid,
  }) {
    return GroupsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      iconUrl: iconUrl ?? this.iconUrl,
      providerName: providerName ?? this.providerName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (iconUrl.present) {
      map['icon_url'] = Variable<String>(iconUrl.value);
    }
    if (providerName.present) {
      map['provider_name'] = Variable<String>(providerName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('iconUrl: $iconUrl, ')
          ..write('providerName: $providerName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupMembersTableTable extends GroupMembersTable
    with TableInfo<$GroupMembersTableTable, GroupMembersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupMembersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [groupId, userId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupMembersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {groupId, userId};
  @override
  GroupMembersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupMembersTableData(
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
    );
  }

  @override
  $GroupMembersTableTable createAlias(String alias) {
    return $GroupMembersTableTable(attachedDatabase, alias);
  }
}

class GroupMembersTableData extends DataClass
    implements Insertable<GroupMembersTableData> {
  final String groupId;
  final String userId;
  const GroupMembersTableData({required this.groupId, required this.userId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['group_id'] = Variable<String>(groupId);
    map['user_id'] = Variable<String>(userId);
    return map;
  }

  GroupMembersTableCompanion toCompanion(bool nullToAbsent) {
    return GroupMembersTableCompanion(
      groupId: Value(groupId),
      userId: Value(userId),
    );
  }

  factory GroupMembersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupMembersTableData(
      groupId: serializer.fromJson<String>(json['groupId']),
      userId: serializer.fromJson<String>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<String>(groupId),
      'userId': serializer.toJson<String>(userId),
    };
  }

  GroupMembersTableData copyWith({String? groupId, String? userId}) =>
      GroupMembersTableData(
        groupId: groupId ?? this.groupId,
        userId: userId ?? this.userId,
      );
  GroupMembersTableData copyWithCompanion(GroupMembersTableCompanion data) {
    return GroupMembersTableData(
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupMembersTableData(')
          ..write('groupId: $groupId, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(groupId, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupMembersTableData &&
          other.groupId == this.groupId &&
          other.userId == this.userId);
}

class GroupMembersTableCompanion
    extends UpdateCompanion<GroupMembersTableData> {
  final Value<String> groupId;
  final Value<String> userId;
  final Value<int> rowid;
  const GroupMembersTableCompanion({
    this.groupId = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupMembersTableCompanion.insert({
    required String groupId,
    required String userId,
    this.rowid = const Value.absent(),
  }) : groupId = Value(groupId),
       userId = Value(userId);
  static Insertable<GroupMembersTableData> custom({
    Expression<String>? groupId,
    Expression<String>? userId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupMembersTableCompanion copyWith({
    Value<String>? groupId,
    Value<String>? userId,
    Value<int>? rowid,
  }) {
    return GroupMembersTableCompanion(
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupMembersTableCompanion(')
          ..write('groupId: $groupId, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProviderConfigsTableTable extends ProviderConfigsTable
    with TableInfo<$ProviderConfigsTableTable, ProviderConfigsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProviderConfigsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseUrlMeta = const VerificationMeta(
    'baseUrl',
  );
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
    'base_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _iconUrlMeta = const VerificationMeta(
    'iconUrl',
  );
  @override
  late final GeneratedColumn<String> iconUrl = GeneratedColumn<String>(
    'icon_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _settingsMeta = const VerificationMeta(
    'settings',
  );
  @override
  late final GeneratedColumn<String> settings = GeneratedColumn<String>(
    'settings',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> updatedAt =
      GeneratedColumn<PgDateTime>(
        'updated_at',
        aliasedName,
        true,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    baseUrl,
    isActive,
    iconUrl,
    settings,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'provider_configs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProviderConfigsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('base_url')) {
      context.handle(
        _baseUrlMeta,
        baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_baseUrlMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('icon_url')) {
      context.handle(
        _iconUrlMeta,
        iconUrl.isAcceptableOrUnknown(data['icon_url']!, _iconUrlMeta),
      );
    }
    if (data.containsKey('settings')) {
      context.handle(
        _settingsMeta,
        settings.isAcceptableOrUnknown(data['settings']!, _settingsMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProviderConfigsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProviderConfigsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      baseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_url'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_active'],
      )!,
      iconUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_url'],
      ),
      settings: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}settings'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ProviderConfigsTableTable createAlias(String alias) {
    return $ProviderConfigsTableTable(attachedDatabase, alias);
  }
}

class ProviderConfigsTableData extends DataClass
    implements Insertable<ProviderConfigsTableData> {
  final String id;
  final String name;
  final String baseUrl;

  /// Stored as 0/1 in Postgres (avoids BOOL vs driver mapping issues).
  final int isActive;
  final String? iconUrl;
  final String settings;
  final PgDateTime? updatedAt;
  const ProviderConfigsTableData({
    required this.id,
    required this.name,
    required this.baseUrl,
    required this.isActive,
    this.iconUrl,
    required this.settings,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['base_url'] = Variable<String>(baseUrl);
    map['is_active'] = Variable<int>(isActive);
    if (!nullToAbsent || iconUrl != null) {
      map['icon_url'] = Variable<String>(iconUrl);
    }
    map['settings'] = Variable<String>(settings);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<PgDateTime>(
        updatedAt,
        PgTypes.timestampWithTimezone,
      );
    }
    return map;
  }

  ProviderConfigsTableCompanion toCompanion(bool nullToAbsent) {
    return ProviderConfigsTableCompanion(
      id: Value(id),
      name: Value(name),
      baseUrl: Value(baseUrl),
      isActive: Value(isActive),
      iconUrl: iconUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(iconUrl),
      settings: Value(settings),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ProviderConfigsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProviderConfigsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      baseUrl: serializer.fromJson<String>(json['baseUrl']),
      isActive: serializer.fromJson<int>(json['isActive']),
      iconUrl: serializer.fromJson<String?>(json['iconUrl']),
      settings: serializer.fromJson<String>(json['settings']),
      updatedAt: serializer.fromJson<PgDateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'baseUrl': serializer.toJson<String>(baseUrl),
      'isActive': serializer.toJson<int>(isActive),
      'iconUrl': serializer.toJson<String?>(iconUrl),
      'settings': serializer.toJson<String>(settings),
      'updatedAt': serializer.toJson<PgDateTime?>(updatedAt),
    };
  }

  ProviderConfigsTableData copyWith({
    String? id,
    String? name,
    String? baseUrl,
    int? isActive,
    Value<String?> iconUrl = const Value.absent(),
    String? settings,
    Value<PgDateTime?> updatedAt = const Value.absent(),
  }) => ProviderConfigsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    baseUrl: baseUrl ?? this.baseUrl,
    isActive: isActive ?? this.isActive,
    iconUrl: iconUrl.present ? iconUrl.value : this.iconUrl,
    settings: settings ?? this.settings,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  ProviderConfigsTableData copyWithCompanion(
    ProviderConfigsTableCompanion data,
  ) {
    return ProviderConfigsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      iconUrl: data.iconUrl.present ? data.iconUrl.value : this.iconUrl,
      settings: data.settings.present ? data.settings.value : this.settings,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProviderConfigsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('isActive: $isActive, ')
          ..write('iconUrl: $iconUrl, ')
          ..write('settings: $settings, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, baseUrl, isActive, iconUrl, settings, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProviderConfigsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.baseUrl == this.baseUrl &&
          other.isActive == this.isActive &&
          other.iconUrl == this.iconUrl &&
          other.settings == this.settings &&
          other.updatedAt == this.updatedAt);
}

class ProviderConfigsTableCompanion
    extends UpdateCompanion<ProviderConfigsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> baseUrl;
  final Value<int> isActive;
  final Value<String?> iconUrl;
  final Value<String> settings;
  final Value<PgDateTime?> updatedAt;
  final Value<int> rowid;
  const ProviderConfigsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.isActive = const Value.absent(),
    this.iconUrl = const Value.absent(),
    this.settings = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProviderConfigsTableCompanion.insert({
    required String id,
    required String name,
    required String baseUrl,
    this.isActive = const Value.absent(),
    this.iconUrl = const Value.absent(),
    this.settings = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       baseUrl = Value(baseUrl);
  static Insertable<ProviderConfigsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? baseUrl,
    Expression<int>? isActive,
    Expression<String>? iconUrl,
    Expression<String>? settings,
    Expression<PgDateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (baseUrl != null) 'base_url': baseUrl,
      if (isActive != null) 'is_active': isActive,
      if (iconUrl != null) 'icon_url': iconUrl,
      if (settings != null) 'settings': settings,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProviderConfigsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? baseUrl,
    Value<int>? isActive,
    Value<String?>? iconUrl,
    Value<String>? settings,
    Value<PgDateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProviderConfigsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      baseUrl: baseUrl ?? this.baseUrl,
      isActive: isActive ?? this.isActive,
      iconUrl: iconUrl ?? this.iconUrl,
      settings: settings ?? this.settings,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (iconUrl.present) {
      map['icon_url'] = Variable<String>(iconUrl.value);
    }
    if (settings.present) {
      map['settings'] = Variable<String>(settings.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<PgDateTime>(
        updatedAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProviderConfigsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('isActive: $isActive, ')
          ..write('iconUrl: $iconUrl, ')
          ..write('settings: $settings, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserIdentitiesTableTable extends UserIdentitiesTable
    with TableInfo<$UserIdentitiesTableTable, UserIdentitiesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserIdentitiesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _providerIdMeta = const VerificationMeta(
    'providerId',
  );
  @override
  late final GeneratedColumn<String> providerId = GeneratedColumn<String>(
    'provider_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _externalUsernameMeta = const VerificationMeta(
    'externalUsername',
  );
  @override
  late final GeneratedColumn<String> externalUsername = GeneratedColumn<String>(
    'external_username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Pending'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>(
        'created_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> updatedAt =
      GeneratedColumn<PgDateTime>(
        'updated_at',
        aliasedName,
        true,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    providerId,
    externalId,
    externalUsername,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_identities';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserIdentitiesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('provider_id')) {
      context.handle(
        _providerIdMeta,
        providerId.isAcceptableOrUnknown(data['provider_id']!, _providerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_providerIdMeta);
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_externalIdMeta);
    }
    if (data.containsKey('external_username')) {
      context.handle(
        _externalUsernameMeta,
        externalUsername.isAcceptableOrUnknown(
          data['external_username']!,
          _externalUsernameMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserIdentitiesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserIdentitiesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      providerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_id'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      )!,
      externalUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_username'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $UserIdentitiesTableTable createAlias(String alias) {
    return $UserIdentitiesTableTable(attachedDatabase, alias);
  }
}

class UserIdentitiesTableData extends DataClass
    implements Insertable<UserIdentitiesTableData> {
  final String id;
  final String userId;
  final String providerId;
  final String externalId;
  final String? externalUsername;
  final String status;
  final PgDateTime createdAt;
  final PgDateTime? updatedAt;
  const UserIdentitiesTableData({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.externalId,
    this.externalUsername,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['provider_id'] = Variable<String>(providerId);
    map['external_id'] = Variable<String>(externalId);
    if (!nullToAbsent || externalUsername != null) {
      map['external_username'] = Variable<String>(externalUsername);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<PgDateTime>(
      createdAt,
      PgTypes.timestampWithTimezone,
    );
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<PgDateTime>(
        updatedAt,
        PgTypes.timestampWithTimezone,
      );
    }
    return map;
  }

  UserIdentitiesTableCompanion toCompanion(bool nullToAbsent) {
    return UserIdentitiesTableCompanion(
      id: Value(id),
      userId: Value(userId),
      providerId: Value(providerId),
      externalId: Value(externalId),
      externalUsername: externalUsername == null && nullToAbsent
          ? const Value.absent()
          : Value(externalUsername),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory UserIdentitiesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserIdentitiesTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      providerId: serializer.fromJson<String>(json['providerId']),
      externalId: serializer.fromJson<String>(json['externalId']),
      externalUsername: serializer.fromJson<String?>(json['externalUsername']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<PgDateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'providerId': serializer.toJson<String>(providerId),
      'externalId': serializer.toJson<String>(externalId),
      'externalUsername': serializer.toJson<String?>(externalUsername),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
      'updatedAt': serializer.toJson<PgDateTime?>(updatedAt),
    };
  }

  UserIdentitiesTableData copyWith({
    String? id,
    String? userId,
    String? providerId,
    String? externalId,
    Value<String?> externalUsername = const Value.absent(),
    String? status,
    PgDateTime? createdAt,
    Value<PgDateTime?> updatedAt = const Value.absent(),
  }) => UserIdentitiesTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    providerId: providerId ?? this.providerId,
    externalId: externalId ?? this.externalId,
    externalUsername: externalUsername.present
        ? externalUsername.value
        : this.externalUsername,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  UserIdentitiesTableData copyWithCompanion(UserIdentitiesTableCompanion data) {
    return UserIdentitiesTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      providerId: data.providerId.present
          ? data.providerId.value
          : this.providerId,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      externalUsername: data.externalUsername.present
          ? data.externalUsername.value
          : this.externalUsername,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserIdentitiesTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('providerId: $providerId, ')
          ..write('externalId: $externalId, ')
          ..write('externalUsername: $externalUsername, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    providerId,
    externalId,
    externalUsername,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserIdentitiesTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.providerId == this.providerId &&
          other.externalId == this.externalId &&
          other.externalUsername == this.externalUsername &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserIdentitiesTableCompanion
    extends UpdateCompanion<UserIdentitiesTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> providerId;
  final Value<String> externalId;
  final Value<String?> externalUsername;
  final Value<String> status;
  final Value<PgDateTime> createdAt;
  final Value<PgDateTime?> updatedAt;
  final Value<int> rowid;
  const UserIdentitiesTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.providerId = const Value.absent(),
    this.externalId = const Value.absent(),
    this.externalUsername = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserIdentitiesTableCompanion.insert({
    required String id,
    required String userId,
    required String providerId,
    required String externalId,
    this.externalUsername = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       providerId = Value(providerId),
       externalId = Value(externalId);
  static Insertable<UserIdentitiesTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? providerId,
    Expression<String>? externalId,
    Expression<String>? externalUsername,
    Expression<String>? status,
    Expression<PgDateTime>? createdAt,
    Expression<PgDateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (providerId != null) 'provider_id': providerId,
      if (externalId != null) 'external_id': externalId,
      if (externalUsername != null) 'external_username': externalUsername,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserIdentitiesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? providerId,
    Value<String>? externalId,
    Value<String?>? externalUsername,
    Value<String>? status,
    Value<PgDateTime>? createdAt,
    Value<PgDateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserIdentitiesTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      providerId: providerId ?? this.providerId,
      externalId: externalId ?? this.externalId,
      externalUsername: externalUsername ?? this.externalUsername,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (providerId.present) {
      map['provider_id'] = Variable<String>(providerId.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (externalUsername.present) {
      map['external_username'] = Variable<String>(externalUsername.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<PgDateTime>(
        createdAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<PgDateTime>(
        updatedAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserIdentitiesTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('providerId: $providerId, ')
          ..write('externalId: $externalId, ')
          ..write('externalUsername: $externalUsername, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProviderCredentialsTableTable extends UserProviderCredentialsTable
    with
        TableInfo<
          $UserProviderCredentialsTableTable,
          UserProviderCredentialsTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProviderCredentialsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _providerIdMeta = const VerificationMeta(
    'providerId',
  );
  @override
  late final GeneratedColumn<String> providerId = GeneratedColumn<String>(
    'provider_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _settingsMeta = const VerificationMeta(
    'settings',
  );
  @override
  late final GeneratedColumn<String> settings = GeneratedColumn<String>(
    'settings',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('connected'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>(
        'created_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> updatedAt =
      GeneratedColumn<PgDateTime>(
        'updated_at',
        aliasedName,
        true,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    providerId,
    settings,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_provider_credentials';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProviderCredentialsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('provider_id')) {
      context.handle(
        _providerIdMeta,
        providerId.isAcceptableOrUnknown(data['provider_id']!, _providerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_providerIdMeta);
    }
    if (data.containsKey('settings')) {
      context.handle(
        _settingsMeta,
        settings.isAcceptableOrUnknown(data['settings']!, _settingsMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, providerId},
  ];
  @override
  UserProviderCredentialsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProviderCredentialsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      providerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_id'],
      )!,
      settings: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}settings'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $UserProviderCredentialsTableTable createAlias(String alias) {
    return $UserProviderCredentialsTableTable(attachedDatabase, alias);
  }
}

class UserProviderCredentialsTableData extends DataClass
    implements Insertable<UserProviderCredentialsTableData> {
  final String id;
  final String userId;
  final String providerId;
  final String settings;
  final String status;
  final PgDateTime createdAt;
  final PgDateTime? updatedAt;
  const UserProviderCredentialsTableData({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.settings,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['provider_id'] = Variable<String>(providerId);
    map['settings'] = Variable<String>(settings);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<PgDateTime>(
      createdAt,
      PgTypes.timestampWithTimezone,
    );
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<PgDateTime>(
        updatedAt,
        PgTypes.timestampWithTimezone,
      );
    }
    return map;
  }

  UserProviderCredentialsTableCompanion toCompanion(bool nullToAbsent) {
    return UserProviderCredentialsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      providerId: Value(providerId),
      settings: Value(settings),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory UserProviderCredentialsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProviderCredentialsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      providerId: serializer.fromJson<String>(json['providerId']),
      settings: serializer.fromJson<String>(json['settings']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<PgDateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'providerId': serializer.toJson<String>(providerId),
      'settings': serializer.toJson<String>(settings),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
      'updatedAt': serializer.toJson<PgDateTime?>(updatedAt),
    };
  }

  UserProviderCredentialsTableData copyWith({
    String? id,
    String? userId,
    String? providerId,
    String? settings,
    String? status,
    PgDateTime? createdAt,
    Value<PgDateTime?> updatedAt = const Value.absent(),
  }) => UserProviderCredentialsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    providerId: providerId ?? this.providerId,
    settings: settings ?? this.settings,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  UserProviderCredentialsTableData copyWithCompanion(
    UserProviderCredentialsTableCompanion data,
  ) {
    return UserProviderCredentialsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      providerId: data.providerId.present
          ? data.providerId.value
          : this.providerId,
      settings: data.settings.present ? data.settings.value : this.settings,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProviderCredentialsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('providerId: $providerId, ')
          ..write('settings: $settings, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    providerId,
    settings,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProviderCredentialsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.providerId == this.providerId &&
          other.settings == this.settings &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserProviderCredentialsTableCompanion
    extends UpdateCompanion<UserProviderCredentialsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> providerId;
  final Value<String> settings;
  final Value<String> status;
  final Value<PgDateTime> createdAt;
  final Value<PgDateTime?> updatedAt;
  final Value<int> rowid;
  const UserProviderCredentialsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.providerId = const Value.absent(),
    this.settings = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProviderCredentialsTableCompanion.insert({
    required String id,
    required String userId,
    required String providerId,
    this.settings = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       providerId = Value(providerId);
  static Insertable<UserProviderCredentialsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? providerId,
    Expression<String>? settings,
    Expression<String>? status,
    Expression<PgDateTime>? createdAt,
    Expression<PgDateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (providerId != null) 'provider_id': providerId,
      if (settings != null) 'settings': settings,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProviderCredentialsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? providerId,
    Value<String>? settings,
    Value<String>? status,
    Value<PgDateTime>? createdAt,
    Value<PgDateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserProviderCredentialsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      providerId: providerId ?? this.providerId,
      settings: settings ?? this.settings,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (providerId.present) {
      map['provider_id'] = Variable<String>(providerId.value);
    }
    if (settings.present) {
      map['settings'] = Variable<String>(settings.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<PgDateTime>(
        createdAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<PgDateTime>(
        updatedAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProviderCredentialsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('providerId: $providerId, ')
          ..write('settings: $settings, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityFollowsTableTable extends ActivityFollowsTable
    with TableInfo<$ActivityFollowsTableTable, ActivityFollowsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityFollowsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _providerIdMeta = const VerificationMeta(
    'providerId',
  );
  @override
  late final GeneratedColumn<String> providerId = GeneratedColumn<String>(
    'provider_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _objectKeyMeta = const VerificationMeta(
    'objectKey',
  );
  @override
  late final GeneratedColumn<String> objectKey = GeneratedColumn<String>(
    'object_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>(
        'created_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> updatedAt =
      GeneratedColumn<PgDateTime>(
        'updated_at',
        aliasedName,
        true,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    providerId,
    objectKey,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_follows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityFollowsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('provider_id')) {
      context.handle(
        _providerIdMeta,
        providerId.isAcceptableOrUnknown(data['provider_id']!, _providerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_providerIdMeta);
    }
    if (data.containsKey('object_key')) {
      context.handle(
        _objectKeyMeta,
        objectKey.isAcceptableOrUnknown(data['object_key']!, _objectKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_objectKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, providerId, objectKey},
  ];
  @override
  ActivityFollowsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityFollowsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      providerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_id'],
      )!,
      objectKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}object_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ActivityFollowsTableTable createAlias(String alias) {
    return $ActivityFollowsTableTable(attachedDatabase, alias);
  }
}

class ActivityFollowsTableData extends DataClass
    implements Insertable<ActivityFollowsTableData> {
  final String id;
  final String userId;
  final String providerId;
  final String objectKey;
  final PgDateTime createdAt;
  final PgDateTime? updatedAt;
  const ActivityFollowsTableData({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.objectKey,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['provider_id'] = Variable<String>(providerId);
    map['object_key'] = Variable<String>(objectKey);
    map['created_at'] = Variable<PgDateTime>(
      createdAt,
      PgTypes.timestampWithTimezone,
    );
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<PgDateTime>(
        updatedAt,
        PgTypes.timestampWithTimezone,
      );
    }
    return map;
  }

  ActivityFollowsTableCompanion toCompanion(bool nullToAbsent) {
    return ActivityFollowsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      providerId: Value(providerId),
      objectKey: Value(objectKey),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ActivityFollowsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityFollowsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      providerId: serializer.fromJson<String>(json['providerId']),
      objectKey: serializer.fromJson<String>(json['objectKey']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<PgDateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'providerId': serializer.toJson<String>(providerId),
      'objectKey': serializer.toJson<String>(objectKey),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
      'updatedAt': serializer.toJson<PgDateTime?>(updatedAt),
    };
  }

  ActivityFollowsTableData copyWith({
    String? id,
    String? userId,
    String? providerId,
    String? objectKey,
    PgDateTime? createdAt,
    Value<PgDateTime?> updatedAt = const Value.absent(),
  }) => ActivityFollowsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    providerId: providerId ?? this.providerId,
    objectKey: objectKey ?? this.objectKey,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  ActivityFollowsTableData copyWithCompanion(
    ActivityFollowsTableCompanion data,
  ) {
    return ActivityFollowsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      providerId: data.providerId.present
          ? data.providerId.value
          : this.providerId,
      objectKey: data.objectKey.present ? data.objectKey.value : this.objectKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityFollowsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('providerId: $providerId, ')
          ..write('objectKey: $objectKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, providerId, objectKey, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityFollowsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.providerId == this.providerId &&
          other.objectKey == this.objectKey &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ActivityFollowsTableCompanion
    extends UpdateCompanion<ActivityFollowsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> providerId;
  final Value<String> objectKey;
  final Value<PgDateTime> createdAt;
  final Value<PgDateTime?> updatedAt;
  final Value<int> rowid;
  const ActivityFollowsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.providerId = const Value.absent(),
    this.objectKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityFollowsTableCompanion.insert({
    required String id,
    required String userId,
    required String providerId,
    required String objectKey,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       providerId = Value(providerId),
       objectKey = Value(objectKey);
  static Insertable<ActivityFollowsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? providerId,
    Expression<String>? objectKey,
    Expression<PgDateTime>? createdAt,
    Expression<PgDateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (providerId != null) 'provider_id': providerId,
      if (objectKey != null) 'object_key': objectKey,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityFollowsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? providerId,
    Value<String>? objectKey,
    Value<PgDateTime>? createdAt,
    Value<PgDateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return ActivityFollowsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      providerId: providerId ?? this.providerId,
      objectKey: objectKey ?? this.objectKey,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (providerId.present) {
      map['provider_id'] = Variable<String>(providerId.value);
    }
    if (objectKey.present) {
      map['object_key'] = Variable<String>(objectKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<PgDateTime>(
        createdAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<PgDateTime>(
        updatedAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityFollowsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('providerId: $providerId, ')
          ..write('objectKey: $objectKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SystemSettingsTableTable extends SystemSettingsTable
    with TableInfo<$SystemSettingsTableTable, SystemSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SystemSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'system_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SystemSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SystemSettingsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SystemSettingsTableData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SystemSettingsTableTable createAlias(String alias) {
    return $SystemSettingsTableTable(attachedDatabase, alias);
  }
}

class SystemSettingsTableData extends DataClass
    implements Insertable<SystemSettingsTableData> {
  final String key;
  final String value;
  const SystemSettingsTableData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SystemSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SystemSettingsTableCompanion(key: Value(key), value: Value(value));
  }

  factory SystemSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SystemSettingsTableData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SystemSettingsTableData copyWith({String? key, String? value}) =>
      SystemSettingsTableData(key: key ?? this.key, value: value ?? this.value);
  SystemSettingsTableData copyWithCompanion(SystemSettingsTableCompanion data) {
    return SystemSettingsTableData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SystemSettingsTableData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SystemSettingsTableData &&
          other.key == this.key &&
          other.value == this.value);
}

class SystemSettingsTableCompanion
    extends UpdateCompanion<SystemSettingsTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SystemSettingsTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SystemSettingsTableCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SystemSettingsTableData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SystemSettingsTableCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SystemSettingsTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SystemSettingsTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTableTable usersTable = $UsersTableTable(this);
  late final $ActivitiesTableTable activitiesTable = $ActivitiesTableTable(
    this,
  );
  late final $ActivityPhorgeTableTable activityPhorgeTable =
      $ActivityPhorgeTableTable(this);
  late final $ActivityGithubCommitTableTable activityGithubCommitTable =
      $ActivityGithubCommitTableTable(this);
  late final $ActivityGitlabCommitTableTable activityGitlabCommitTable =
      $ActivityGitlabCommitTableTable(this);
  late final $ActivityBitbucketCommitTableTable activityBitbucketCommitTable =
      $ActivityBitbucketCommitTableTable(this);
  late final $ActivityJiraIssueTableTable activityJiraIssueTable =
      $ActivityJiraIssueTableTable(this);
  late final $ActivityLinearIssueTableTable activityLinearIssueTable =
      $ActivityLinearIssueTableTable(this);
  late final $ActivitySlackMessageTableTable activitySlackMessageTable =
      $ActivitySlackMessageTableTable(this);
  late final $ActivityDiscordMessageTableTable activityDiscordMessageTable =
      $ActivityDiscordMessageTableTable(this);
  late final $SessionsTableTable sessionsTable = $SessionsTableTable(this);
  late final $GroupsTableTable groupsTable = $GroupsTableTable(this);
  late final $GroupMembersTableTable groupMembersTable =
      $GroupMembersTableTable(this);
  late final $ProviderConfigsTableTable providerConfigsTable =
      $ProviderConfigsTableTable(this);
  late final $UserIdentitiesTableTable userIdentitiesTable =
      $UserIdentitiesTableTable(this);
  late final $UserProviderCredentialsTableTable userProviderCredentialsTable =
      $UserProviderCredentialsTableTable(this);
  late final $ActivityFollowsTableTable activityFollowsTable =
      $ActivityFollowsTableTable(this);
  late final $SystemSettingsTableTable systemSettingsTable =
      $SystemSettingsTableTable(this);
  late final Index idxActivityFollowsObject = Index(
    'idx_activity_follows_object',
    'CREATE INDEX idx_activity_follows_object ON activity_follows (provider_id, object_key)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    usersTable,
    activitiesTable,
    activityPhorgeTable,
    activityGithubCommitTable,
    activityGitlabCommitTable,
    activityBitbucketCommitTable,
    activityJiraIssueTable,
    activityLinearIssueTable,
    activitySlackMessageTable,
    activityDiscordMessageTable,
    sessionsTable,
    groupsTable,
    groupMembersTable,
    providerConfigsTable,
    userIdentitiesTable,
    userProviderCredentialsTable,
    activityFollowsTable,
    systemSettingsTable,
    idxActivityFollowsObject,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'activities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('activity_phorge', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'activities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('activity_github_commit', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'activities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('activity_gitlab_commit', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'activities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('activity_bitbucket_commit', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'activities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('activity_jira_issue', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'activities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('activity_linear_issue', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'activities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('activity_slack_message', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'activities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('activity_discord_message', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_members', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_members', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$UsersTableTableCreateCompanionBuilder =
    UsersTableCompanion Function({
      required String id,
      required String name,
      required String email,
      required String passwordHash,
      Value<String> role,
      Value<String?> phorgePhid,
      Value<String?> phorgeUsername,
      required PgDateTime createdAt,
      Value<PgDateTime?> updatedAt,
      Value<String?> avatarUrl,
      Value<int> rowid,
    });
typedef $$UsersTableTableUpdateCompanionBuilder =
    UsersTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> email,
      Value<String> passwordHash,
      Value<String> role,
      Value<String?> phorgePhid,
      Value<String?> phorgeUsername,
      Value<PgDateTime> createdAt,
      Value<PgDateTime?> updatedAt,
      Value<String?> avatarUrl,
      Value<int> rowid,
    });

final class $$UsersTableTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTableTable, UsersTableData> {
  $$UsersTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $GroupMembersTableTable,
    List<GroupMembersTableData>
  >
  _groupMembersTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.groupMembersTable,
        aliasName: $_aliasNameGenerator(
          db.usersTable.id,
          db.groupMembersTable.userId,
        ),
      );

  $$GroupMembersTableTableProcessedTableManager get groupMembersTableRefs {
    final manager = $$GroupMembersTableTableTableManager(
      $_db,
      $_db.groupMembersTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _groupMembersTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableTableFilterComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phorgePhid => $composableBuilder(
    column: $table.phorgePhid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phorgeUsername => $composableBuilder(
    column: $table.phorgeUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> groupMembersTableRefs(
    Expression<bool> Function($$GroupMembersTableTableFilterComposer f) f,
  ) {
    final $$GroupMembersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMembersTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMembersTableTableFilterComposer(
            $db: $db,
            $table: $db.groupMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phorgePhid => $composableBuilder(
    column: $table.phorgePhid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phorgeUsername => $composableBuilder(
    column: $table.phorgeUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get phorgePhid => $composableBuilder(
    column: $table.phorgePhid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phorgeUsername => $composableBuilder(
    column: $table.phorgeUsername,
    builder: (column) => column,
  );

  GeneratedColumn<PgDateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<PgDateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  Expression<T> groupMembersTableRefs<T extends Object>(
    Expression<T> Function($$GroupMembersTableTableAnnotationComposer a) f,
  ) {
    final $$GroupMembersTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.groupMembersTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GroupMembersTableTableAnnotationComposer(
                $db: $db,
                $table: $db.groupMembersTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$UsersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTableTable,
          UsersTableData,
          $$UsersTableTableFilterComposer,
          $$UsersTableTableOrderingComposer,
          $$UsersTableTableAnnotationComposer,
          $$UsersTableTableCreateCompanionBuilder,
          $$UsersTableTableUpdateCompanionBuilder,
          (UsersTableData, $$UsersTableTableReferences),
          UsersTableData,
          PrefetchHooks Function({bool groupMembersTableRefs})
        > {
  $$UsersTableTableTableManager(_$AppDatabase db, $UsersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String?> phorgePhid = const Value.absent(),
                Value<String?> phorgeUsername = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<PgDateTime?> updatedAt = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersTableCompanion(
                id: id,
                name: name,
                email: email,
                passwordHash: passwordHash,
                role: role,
                phorgePhid: phorgePhid,
                phorgeUsername: phorgeUsername,
                createdAt: createdAt,
                updatedAt: updatedAt,
                avatarUrl: avatarUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String email,
                required String passwordHash,
                Value<String> role = const Value.absent(),
                Value<String?> phorgePhid = const Value.absent(),
                Value<String?> phorgeUsername = const Value.absent(),
                required PgDateTime createdAt,
                Value<PgDateTime?> updatedAt = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersTableCompanion.insert(
                id: id,
                name: name,
                email: email,
                passwordHash: passwordHash,
                role: role,
                phorgePhid: phorgePhid,
                phorgeUsername: phorgeUsername,
                createdAt: createdAt,
                updatedAt: updatedAt,
                avatarUrl: avatarUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UsersTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupMembersTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (groupMembersTableRefs) db.groupMembersTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (groupMembersTableRefs)
                    await $_getPrefetchedData<
                      UsersTableData,
                      $UsersTableTable,
                      GroupMembersTableData
                    >(
                      currentTable: table,
                      referencedTable: $$UsersTableTableReferences
                          ._groupMembersTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$UsersTableTableReferences(
                            db,
                            table,
                            p0,
                          ).groupMembersTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UsersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTableTable,
      UsersTableData,
      $$UsersTableTableFilterComposer,
      $$UsersTableTableOrderingComposer,
      $$UsersTableTableAnnotationComposer,
      $$UsersTableTableCreateCompanionBuilder,
      $$UsersTableTableUpdateCompanionBuilder,
      (UsersTableData, $$UsersTableTableReferences),
      UsersTableData,
      PrefetchHooks Function({bool groupMembersTableRefs})
    >;
typedef $$ActivitiesTableTableCreateCompanionBuilder =
    ActivitiesTableCompanion Function({
      required String id,
      required String userId,
      Value<String?> senderUserId,
      required String providerName,
      required String title,
      required String content,
      Value<String?> url,
      required String authorName,
      Value<String?> authorAvatarUrl,
      Value<int> commentCount,
      required PgDateTime createdAt,
      Value<int> rowid,
    });
typedef $$ActivitiesTableTableUpdateCompanionBuilder =
    ActivitiesTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String?> senderUserId,
      Value<String> providerName,
      Value<String> title,
      Value<String> content,
      Value<String?> url,
      Value<String> authorName,
      Value<String?> authorAvatarUrl,
      Value<int> commentCount,
      Value<PgDateTime> createdAt,
      Value<int> rowid,
    });

final class $$ActivitiesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActivitiesTableTable,
          ActivitiesTableData
        > {
  $$ActivitiesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $ActivityPhorgeTableTable,
    List<ActivityPhorgeTableData>
  >
  _activityPhorgeTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.activityPhorgeTable,
        aliasName: $_aliasNameGenerator(
          db.activitiesTable.id,
          db.activityPhorgeTable.activityId,
        ),
      );

  $$ActivityPhorgeTableTableProcessedTableManager get activityPhorgeTableRefs {
    final manager = $$ActivityPhorgeTableTableTableManager(
      $_db,
      $_db.activityPhorgeTable,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _activityPhorgeTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ActivityGithubCommitTableTable,
    List<ActivityGithubCommitTableData>
  >
  _activityGithubCommitTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.activityGithubCommitTable,
        aliasName: $_aliasNameGenerator(
          db.activitiesTable.id,
          db.activityGithubCommitTable.activityId,
        ),
      );

  $$ActivityGithubCommitTableTableProcessedTableManager
  get activityGithubCommitTableRefs {
    final manager = $$ActivityGithubCommitTableTableTableManager(
      $_db,
      $_db.activityGithubCommitTable,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _activityGithubCommitTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ActivityGitlabCommitTableTable,
    List<ActivityGitlabCommitTableData>
  >
  _activityGitlabCommitTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.activityGitlabCommitTable,
        aliasName: $_aliasNameGenerator(
          db.activitiesTable.id,
          db.activityGitlabCommitTable.activityId,
        ),
      );

  $$ActivityGitlabCommitTableTableProcessedTableManager
  get activityGitlabCommitTableRefs {
    final manager = $$ActivityGitlabCommitTableTableTableManager(
      $_db,
      $_db.activityGitlabCommitTable,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _activityGitlabCommitTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ActivityBitbucketCommitTableTable,
    List<ActivityBitbucketCommitTableData>
  >
  _activityBitbucketCommitTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.activityBitbucketCommitTable,
        aliasName: $_aliasNameGenerator(
          db.activitiesTable.id,
          db.activityBitbucketCommitTable.activityId,
        ),
      );

  $$ActivityBitbucketCommitTableTableProcessedTableManager
  get activityBitbucketCommitTableRefs {
    final manager = $$ActivityBitbucketCommitTableTableTableManager(
      $_db,
      $_db.activityBitbucketCommitTable,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _activityBitbucketCommitTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ActivityJiraIssueTableTable,
    List<ActivityJiraIssueTableData>
  >
  _activityJiraIssueTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.activityJiraIssueTable,
        aliasName: $_aliasNameGenerator(
          db.activitiesTable.id,
          db.activityJiraIssueTable.activityId,
        ),
      );

  $$ActivityJiraIssueTableTableProcessedTableManager
  get activityJiraIssueTableRefs {
    final manager = $$ActivityJiraIssueTableTableTableManager(
      $_db,
      $_db.activityJiraIssueTable,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _activityJiraIssueTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ActivityLinearIssueTableTable,
    List<ActivityLinearIssueTableData>
  >
  _activityLinearIssueTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.activityLinearIssueTable,
        aliasName: $_aliasNameGenerator(
          db.activitiesTable.id,
          db.activityLinearIssueTable.activityId,
        ),
      );

  $$ActivityLinearIssueTableTableProcessedTableManager
  get activityLinearIssueTableRefs {
    final manager = $$ActivityLinearIssueTableTableTableManager(
      $_db,
      $_db.activityLinearIssueTable,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _activityLinearIssueTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ActivitySlackMessageTableTable,
    List<ActivitySlackMessageTableData>
  >
  _activitySlackMessageTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.activitySlackMessageTable,
        aliasName: $_aliasNameGenerator(
          db.activitiesTable.id,
          db.activitySlackMessageTable.activityId,
        ),
      );

  $$ActivitySlackMessageTableTableProcessedTableManager
  get activitySlackMessageTableRefs {
    final manager = $$ActivitySlackMessageTableTableTableManager(
      $_db,
      $_db.activitySlackMessageTable,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _activitySlackMessageTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ActivityDiscordMessageTableTable,
    List<ActivityDiscordMessageTableData>
  >
  _activityDiscordMessageTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.activityDiscordMessageTable,
        aliasName: $_aliasNameGenerator(
          db.activitiesTable.id,
          db.activityDiscordMessageTable.activityId,
        ),
      );

  $$ActivityDiscordMessageTableTableProcessedTableManager
  get activityDiscordMessageTableRefs {
    final manager = $$ActivityDiscordMessageTableTableTableManager(
      $_db,
      $_db.activityDiscordMessageTable,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _activityDiscordMessageTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ActivitiesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ActivitiesTableTable> {
  $$ActivitiesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderUserId => $composableBuilder(
    column: $table.senderUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorAvatarUrl => $composableBuilder(
    column: $table.authorAvatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get commentCount => $composableBuilder(
    column: $table.commentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> activityPhorgeTableRefs(
    Expression<bool> Function($$ActivityPhorgeTableTableFilterComposer f) f,
  ) {
    final $$ActivityPhorgeTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activityPhorgeTable,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivityPhorgeTableTableFilterComposer(
            $db: $db,
            $table: $db.activityPhorgeTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> activityGithubCommitTableRefs(
    Expression<bool> Function($$ActivityGithubCommitTableTableFilterComposer f)
    f,
  ) {
    final $$ActivityGithubCommitTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityGithubCommitTable,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityGithubCommitTableTableFilterComposer(
                $db: $db,
                $table: $db.activityGithubCommitTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> activityGitlabCommitTableRefs(
    Expression<bool> Function($$ActivityGitlabCommitTableTableFilterComposer f)
    f,
  ) {
    final $$ActivityGitlabCommitTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityGitlabCommitTable,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityGitlabCommitTableTableFilterComposer(
                $db: $db,
                $table: $db.activityGitlabCommitTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> activityBitbucketCommitTableRefs(
    Expression<bool> Function(
      $$ActivityBitbucketCommitTableTableFilterComposer f,
    )
    f,
  ) {
    final $$ActivityBitbucketCommitTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityBitbucketCommitTable,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityBitbucketCommitTableTableFilterComposer(
                $db: $db,
                $table: $db.activityBitbucketCommitTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> activityJiraIssueTableRefs(
    Expression<bool> Function($$ActivityJiraIssueTableTableFilterComposer f) f,
  ) {
    final $$ActivityJiraIssueTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityJiraIssueTable,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityJiraIssueTableTableFilterComposer(
                $db: $db,
                $table: $db.activityJiraIssueTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> activityLinearIssueTableRefs(
    Expression<bool> Function($$ActivityLinearIssueTableTableFilterComposer f)
    f,
  ) {
    final $$ActivityLinearIssueTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityLinearIssueTable,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityLinearIssueTableTableFilterComposer(
                $db: $db,
                $table: $db.activityLinearIssueTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> activitySlackMessageTableRefs(
    Expression<bool> Function($$ActivitySlackMessageTableTableFilterComposer f)
    f,
  ) {
    final $$ActivitySlackMessageTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activitySlackMessageTable,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivitySlackMessageTableTableFilterComposer(
                $db: $db,
                $table: $db.activitySlackMessageTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> activityDiscordMessageTableRefs(
    Expression<bool> Function(
      $$ActivityDiscordMessageTableTableFilterComposer f,
    )
    f,
  ) {
    final $$ActivityDiscordMessageTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityDiscordMessageTable,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityDiscordMessageTableTableFilterComposer(
                $db: $db,
                $table: $db.activityDiscordMessageTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ActivitiesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivitiesTableTable> {
  $$ActivitiesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderUserId => $composableBuilder(
    column: $table.senderUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorAvatarUrl => $composableBuilder(
    column: $table.authorAvatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get commentCount => $composableBuilder(
    column: $table.commentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivitiesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivitiesTableTable> {
  $$ActivitiesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get senderUserId => $composableBuilder(
    column: $table.senderUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorAvatarUrl => $composableBuilder(
    column: $table.authorAvatarUrl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get commentCount => $composableBuilder(
    column: $table.commentCount,
    builder: (column) => column,
  );

  GeneratedColumn<PgDateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> activityPhorgeTableRefs<T extends Object>(
    Expression<T> Function($$ActivityPhorgeTableTableAnnotationComposer a) f,
  ) {
    final $$ActivityPhorgeTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityPhorgeTable,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityPhorgeTableTableAnnotationComposer(
                $db: $db,
                $table: $db.activityPhorgeTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> activityGithubCommitTableRefs<T extends Object>(
    Expression<T> Function($$ActivityGithubCommitTableTableAnnotationComposer a)
    f,
  ) {
    final $$ActivityGithubCommitTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityGithubCommitTable,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityGithubCommitTableTableAnnotationComposer(
                $db: $db,
                $table: $db.activityGithubCommitTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> activityGitlabCommitTableRefs<T extends Object>(
    Expression<T> Function($$ActivityGitlabCommitTableTableAnnotationComposer a)
    f,
  ) {
    final $$ActivityGitlabCommitTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityGitlabCommitTable,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityGitlabCommitTableTableAnnotationComposer(
                $db: $db,
                $table: $db.activityGitlabCommitTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> activityBitbucketCommitTableRefs<T extends Object>(
    Expression<T> Function(
      $$ActivityBitbucketCommitTableTableAnnotationComposer a,
    )
    f,
  ) {
    final $$ActivityBitbucketCommitTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityBitbucketCommitTable,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityBitbucketCommitTableTableAnnotationComposer(
                $db: $db,
                $table: $db.activityBitbucketCommitTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> activityJiraIssueTableRefs<T extends Object>(
    Expression<T> Function($$ActivityJiraIssueTableTableAnnotationComposer a) f,
  ) {
    final $$ActivityJiraIssueTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityJiraIssueTable,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityJiraIssueTableTableAnnotationComposer(
                $db: $db,
                $table: $db.activityJiraIssueTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> activityLinearIssueTableRefs<T extends Object>(
    Expression<T> Function($$ActivityLinearIssueTableTableAnnotationComposer a)
    f,
  ) {
    final $$ActivityLinearIssueTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityLinearIssueTable,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityLinearIssueTableTableAnnotationComposer(
                $db: $db,
                $table: $db.activityLinearIssueTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> activitySlackMessageTableRefs<T extends Object>(
    Expression<T> Function($$ActivitySlackMessageTableTableAnnotationComposer a)
    f,
  ) {
    final $$ActivitySlackMessageTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activitySlackMessageTable,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivitySlackMessageTableTableAnnotationComposer(
                $db: $db,
                $table: $db.activitySlackMessageTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> activityDiscordMessageTableRefs<T extends Object>(
    Expression<T> Function(
      $$ActivityDiscordMessageTableTableAnnotationComposer a,
    )
    f,
  ) {
    final $$ActivityDiscordMessageTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityDiscordMessageTable,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityDiscordMessageTableTableAnnotationComposer(
                $db: $db,
                $table: $db.activityDiscordMessageTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ActivitiesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivitiesTableTable,
          ActivitiesTableData,
          $$ActivitiesTableTableFilterComposer,
          $$ActivitiesTableTableOrderingComposer,
          $$ActivitiesTableTableAnnotationComposer,
          $$ActivitiesTableTableCreateCompanionBuilder,
          $$ActivitiesTableTableUpdateCompanionBuilder,
          (ActivitiesTableData, $$ActivitiesTableTableReferences),
          ActivitiesTableData,
          PrefetchHooks Function({
            bool activityPhorgeTableRefs,
            bool activityGithubCommitTableRefs,
            bool activityGitlabCommitTableRefs,
            bool activityBitbucketCommitTableRefs,
            bool activityJiraIssueTableRefs,
            bool activityLinearIssueTableRefs,
            bool activitySlackMessageTableRefs,
            bool activityDiscordMessageTableRefs,
          })
        > {
  $$ActivitiesTableTableTableManager(
    _$AppDatabase db,
    $ActivitiesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivitiesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivitiesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivitiesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> senderUserId = const Value.absent(),
                Value<String> providerName = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String> authorName = const Value.absent(),
                Value<String?> authorAvatarUrl = const Value.absent(),
                Value<int> commentCount = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesTableCompanion(
                id: id,
                userId: userId,
                senderUserId: senderUserId,
                providerName: providerName,
                title: title,
                content: content,
                url: url,
                authorName: authorName,
                authorAvatarUrl: authorAvatarUrl,
                commentCount: commentCount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                Value<String?> senderUserId = const Value.absent(),
                required String providerName,
                required String title,
                required String content,
                Value<String?> url = const Value.absent(),
                required String authorName,
                Value<String?> authorAvatarUrl = const Value.absent(),
                Value<int> commentCount = const Value.absent(),
                required PgDateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesTableCompanion.insert(
                id: id,
                userId: userId,
                senderUserId: senderUserId,
                providerName: providerName,
                title: title,
                content: content,
                url: url,
                authorName: authorName,
                authorAvatarUrl: authorAvatarUrl,
                commentCount: commentCount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivitiesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                activityPhorgeTableRefs = false,
                activityGithubCommitTableRefs = false,
                activityGitlabCommitTableRefs = false,
                activityBitbucketCommitTableRefs = false,
                activityJiraIssueTableRefs = false,
                activityLinearIssueTableRefs = false,
                activitySlackMessageTableRefs = false,
                activityDiscordMessageTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (activityPhorgeTableRefs) db.activityPhorgeTable,
                    if (activityGithubCommitTableRefs)
                      db.activityGithubCommitTable,
                    if (activityGitlabCommitTableRefs)
                      db.activityGitlabCommitTable,
                    if (activityBitbucketCommitTableRefs)
                      db.activityBitbucketCommitTable,
                    if (activityJiraIssueTableRefs) db.activityJiraIssueTable,
                    if (activityLinearIssueTableRefs)
                      db.activityLinearIssueTable,
                    if (activitySlackMessageTableRefs)
                      db.activitySlackMessageTable,
                    if (activityDiscordMessageTableRefs)
                      db.activityDiscordMessageTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (activityPhorgeTableRefs)
                        await $_getPrefetchedData<
                          ActivitiesTableData,
                          $ActivitiesTableTable,
                          ActivityPhorgeTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableTableReferences
                              ._activityPhorgeTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).activityPhorgeTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.activityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activityGithubCommitTableRefs)
                        await $_getPrefetchedData<
                          ActivitiesTableData,
                          $ActivitiesTableTable,
                          ActivityGithubCommitTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableTableReferences
                              ._activityGithubCommitTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).activityGithubCommitTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.activityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activityGitlabCommitTableRefs)
                        await $_getPrefetchedData<
                          ActivitiesTableData,
                          $ActivitiesTableTable,
                          ActivityGitlabCommitTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableTableReferences
                              ._activityGitlabCommitTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).activityGitlabCommitTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.activityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activityBitbucketCommitTableRefs)
                        await $_getPrefetchedData<
                          ActivitiesTableData,
                          $ActivitiesTableTable,
                          ActivityBitbucketCommitTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableTableReferences
                              ._activityBitbucketCommitTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).activityBitbucketCommitTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.activityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activityJiraIssueTableRefs)
                        await $_getPrefetchedData<
                          ActivitiesTableData,
                          $ActivitiesTableTable,
                          ActivityJiraIssueTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableTableReferences
                              ._activityJiraIssueTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).activityJiraIssueTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.activityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activityLinearIssueTableRefs)
                        await $_getPrefetchedData<
                          ActivitiesTableData,
                          $ActivitiesTableTable,
                          ActivityLinearIssueTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableTableReferences
                              ._activityLinearIssueTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).activityLinearIssueTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.activityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activitySlackMessageTableRefs)
                        await $_getPrefetchedData<
                          ActivitiesTableData,
                          $ActivitiesTableTable,
                          ActivitySlackMessageTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableTableReferences
                              ._activitySlackMessageTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).activitySlackMessageTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.activityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activityDiscordMessageTableRefs)
                        await $_getPrefetchedData<
                          ActivitiesTableData,
                          $ActivitiesTableTable,
                          ActivityDiscordMessageTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableTableReferences
                              ._activityDiscordMessageTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).activityDiscordMessageTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.activityId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ActivitiesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivitiesTableTable,
      ActivitiesTableData,
      $$ActivitiesTableTableFilterComposer,
      $$ActivitiesTableTableOrderingComposer,
      $$ActivitiesTableTableAnnotationComposer,
      $$ActivitiesTableTableCreateCompanionBuilder,
      $$ActivitiesTableTableUpdateCompanionBuilder,
      (ActivitiesTableData, $$ActivitiesTableTableReferences),
      ActivitiesTableData,
      PrefetchHooks Function({
        bool activityPhorgeTableRefs,
        bool activityGithubCommitTableRefs,
        bool activityGitlabCommitTableRefs,
        bool activityBitbucketCommitTableRefs,
        bool activityJiraIssueTableRefs,
        bool activityLinearIssueTableRefs,
        bool activitySlackMessageTableRefs,
        bool activityDiscordMessageTableRefs,
      })
    >;
typedef $$ActivityPhorgeTableTableCreateCompanionBuilder =
    ActivityPhorgeTableCompanion Function({
      required String activityId,
      Value<String?> taskPhid,
      Value<String?> revisionId,
      Value<String?> tags,
      Value<int> rowid,
    });
typedef $$ActivityPhorgeTableTableUpdateCompanionBuilder =
    ActivityPhorgeTableCompanion Function({
      Value<String> activityId,
      Value<String?> taskPhid,
      Value<String?> revisionId,
      Value<String?> tags,
      Value<int> rowid,
    });

final class $$ActivityPhorgeTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActivityPhorgeTableTable,
          ActivityPhorgeTableData
        > {
  $$ActivityPhorgeTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActivitiesTableTable _activityIdTable(_$AppDatabase db) =>
      db.activitiesTable.createAlias(
        $_aliasNameGenerator(
          db.activityPhorgeTable.activityId,
          db.activitiesTable.id,
        ),
      );

  $$ActivitiesTableTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<String>('activity_id')!;

    final manager = $$ActivitiesTableTableTableManager(
      $_db,
      $_db.activitiesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActivityPhorgeTableTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityPhorgeTableTable> {
  $$ActivityPhorgeTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get taskPhid => $composableBuilder(
    column: $table.taskPhid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivitiesTableTableFilterComposer get activityId {
    final $$ActivitiesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableFilterComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityPhorgeTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityPhorgeTableTable> {
  $$ActivityPhorgeTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get taskPhid => $composableBuilder(
    column: $table.taskPhid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableTableOrderingComposer get activityId {
    final $$ActivitiesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableOrderingComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityPhorgeTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityPhorgeTableTable> {
  $$ActivityPhorgeTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get taskPhid =>
      $composableBuilder(column: $table.taskPhid, builder: (column) => column);

  GeneratedColumn<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  $$ActivitiesTableTableAnnotationComposer get activityId {
    final $$ActivitiesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityPhorgeTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityPhorgeTableTable,
          ActivityPhorgeTableData,
          $$ActivityPhorgeTableTableFilterComposer,
          $$ActivityPhorgeTableTableOrderingComposer,
          $$ActivityPhorgeTableTableAnnotationComposer,
          $$ActivityPhorgeTableTableCreateCompanionBuilder,
          $$ActivityPhorgeTableTableUpdateCompanionBuilder,
          (ActivityPhorgeTableData, $$ActivityPhorgeTableTableReferences),
          ActivityPhorgeTableData,
          PrefetchHooks Function({bool activityId})
        > {
  $$ActivityPhorgeTableTableTableManager(
    _$AppDatabase db,
    $ActivityPhorgeTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityPhorgeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityPhorgeTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActivityPhorgeTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> activityId = const Value.absent(),
                Value<String?> taskPhid = const Value.absent(),
                Value<String?> revisionId = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityPhorgeTableCompanion(
                activityId: activityId,
                taskPhid: taskPhid,
                revisionId: revisionId,
                tags: tags,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String activityId,
                Value<String?> taskPhid = const Value.absent(),
                Value<String?> revisionId = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityPhorgeTableCompanion.insert(
                activityId: activityId,
                taskPhid: taskPhid,
                revisionId: revisionId,
                tags: tags,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivityPhorgeTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({activityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (activityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.activityId,
                                referencedTable:
                                    $$ActivityPhorgeTableTableReferences
                                        ._activityIdTable(db),
                                referencedColumn:
                                    $$ActivityPhorgeTableTableReferences
                                        ._activityIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActivityPhorgeTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityPhorgeTableTable,
      ActivityPhorgeTableData,
      $$ActivityPhorgeTableTableFilterComposer,
      $$ActivityPhorgeTableTableOrderingComposer,
      $$ActivityPhorgeTableTableAnnotationComposer,
      $$ActivityPhorgeTableTableCreateCompanionBuilder,
      $$ActivityPhorgeTableTableUpdateCompanionBuilder,
      (ActivityPhorgeTableData, $$ActivityPhorgeTableTableReferences),
      ActivityPhorgeTableData,
      PrefetchHooks Function({bool activityId})
    >;
typedef $$ActivityGithubCommitTableTableCreateCompanionBuilder =
    ActivityGithubCommitTableCompanion Function({
      required String activityId,
      Value<String?> repo,
      Value<String?> branch,
      Value<int> rowid,
    });
typedef $$ActivityGithubCommitTableTableUpdateCompanionBuilder =
    ActivityGithubCommitTableCompanion Function({
      Value<String> activityId,
      Value<String?> repo,
      Value<String?> branch,
      Value<int> rowid,
    });

final class $$ActivityGithubCommitTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActivityGithubCommitTableTable,
          ActivityGithubCommitTableData
        > {
  $$ActivityGithubCommitTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActivitiesTableTable _activityIdTable(_$AppDatabase db) =>
      db.activitiesTable.createAlias(
        $_aliasNameGenerator(
          db.activityGithubCommitTable.activityId,
          db.activitiesTable.id,
        ),
      );

  $$ActivitiesTableTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<String>('activity_id')!;

    final manager = $$ActivitiesTableTableTableManager(
      $_db,
      $_db.activitiesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActivityGithubCommitTableTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityGithubCommitTableTable> {
  $$ActivityGithubCommitTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get repo => $composableBuilder(
    column: $table.repo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivitiesTableTableFilterComposer get activityId {
    final $$ActivitiesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableFilterComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityGithubCommitTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityGithubCommitTableTable> {
  $$ActivityGithubCommitTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get repo => $composableBuilder(
    column: $table.repo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableTableOrderingComposer get activityId {
    final $$ActivitiesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableOrderingComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityGithubCommitTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityGithubCommitTableTable> {
  $$ActivityGithubCommitTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get repo =>
      $composableBuilder(column: $table.repo, builder: (column) => column);

  GeneratedColumn<String> get branch =>
      $composableBuilder(column: $table.branch, builder: (column) => column);

  $$ActivitiesTableTableAnnotationComposer get activityId {
    final $$ActivitiesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityGithubCommitTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityGithubCommitTableTable,
          ActivityGithubCommitTableData,
          $$ActivityGithubCommitTableTableFilterComposer,
          $$ActivityGithubCommitTableTableOrderingComposer,
          $$ActivityGithubCommitTableTableAnnotationComposer,
          $$ActivityGithubCommitTableTableCreateCompanionBuilder,
          $$ActivityGithubCommitTableTableUpdateCompanionBuilder,
          (
            ActivityGithubCommitTableData,
            $$ActivityGithubCommitTableTableReferences,
          ),
          ActivityGithubCommitTableData,
          PrefetchHooks Function({bool activityId})
        > {
  $$ActivityGithubCommitTableTableTableManager(
    _$AppDatabase db,
    $ActivityGithubCommitTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityGithubCommitTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ActivityGithubCommitTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActivityGithubCommitTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> activityId = const Value.absent(),
                Value<String?> repo = const Value.absent(),
                Value<String?> branch = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityGithubCommitTableCompanion(
                activityId: activityId,
                repo: repo,
                branch: branch,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String activityId,
                Value<String?> repo = const Value.absent(),
                Value<String?> branch = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityGithubCommitTableCompanion.insert(
                activityId: activityId,
                repo: repo,
                branch: branch,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivityGithubCommitTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({activityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (activityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.activityId,
                                referencedTable:
                                    $$ActivityGithubCommitTableTableReferences
                                        ._activityIdTable(db),
                                referencedColumn:
                                    $$ActivityGithubCommitTableTableReferences
                                        ._activityIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActivityGithubCommitTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityGithubCommitTableTable,
      ActivityGithubCommitTableData,
      $$ActivityGithubCommitTableTableFilterComposer,
      $$ActivityGithubCommitTableTableOrderingComposer,
      $$ActivityGithubCommitTableTableAnnotationComposer,
      $$ActivityGithubCommitTableTableCreateCompanionBuilder,
      $$ActivityGithubCommitTableTableUpdateCompanionBuilder,
      (
        ActivityGithubCommitTableData,
        $$ActivityGithubCommitTableTableReferences,
      ),
      ActivityGithubCommitTableData,
      PrefetchHooks Function({bool activityId})
    >;
typedef $$ActivityGitlabCommitTableTableCreateCompanionBuilder =
    ActivityGitlabCommitTableCompanion Function({
      required String activityId,
      Value<String?> project,
      Value<String?> branch,
      Value<int> rowid,
    });
typedef $$ActivityGitlabCommitTableTableUpdateCompanionBuilder =
    ActivityGitlabCommitTableCompanion Function({
      Value<String> activityId,
      Value<String?> project,
      Value<String?> branch,
      Value<int> rowid,
    });

final class $$ActivityGitlabCommitTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActivityGitlabCommitTableTable,
          ActivityGitlabCommitTableData
        > {
  $$ActivityGitlabCommitTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActivitiesTableTable _activityIdTable(_$AppDatabase db) =>
      db.activitiesTable.createAlias(
        $_aliasNameGenerator(
          db.activityGitlabCommitTable.activityId,
          db.activitiesTable.id,
        ),
      );

  $$ActivitiesTableTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<String>('activity_id')!;

    final manager = $$ActivitiesTableTableTableManager(
      $_db,
      $_db.activitiesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActivityGitlabCommitTableTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityGitlabCommitTableTable> {
  $$ActivityGitlabCommitTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get project => $composableBuilder(
    column: $table.project,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivitiesTableTableFilterComposer get activityId {
    final $$ActivitiesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableFilterComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityGitlabCommitTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityGitlabCommitTableTable> {
  $$ActivityGitlabCommitTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get project => $composableBuilder(
    column: $table.project,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableTableOrderingComposer get activityId {
    final $$ActivitiesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableOrderingComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityGitlabCommitTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityGitlabCommitTableTable> {
  $$ActivityGitlabCommitTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get project =>
      $composableBuilder(column: $table.project, builder: (column) => column);

  GeneratedColumn<String> get branch =>
      $composableBuilder(column: $table.branch, builder: (column) => column);

  $$ActivitiesTableTableAnnotationComposer get activityId {
    final $$ActivitiesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityGitlabCommitTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityGitlabCommitTableTable,
          ActivityGitlabCommitTableData,
          $$ActivityGitlabCommitTableTableFilterComposer,
          $$ActivityGitlabCommitTableTableOrderingComposer,
          $$ActivityGitlabCommitTableTableAnnotationComposer,
          $$ActivityGitlabCommitTableTableCreateCompanionBuilder,
          $$ActivityGitlabCommitTableTableUpdateCompanionBuilder,
          (
            ActivityGitlabCommitTableData,
            $$ActivityGitlabCommitTableTableReferences,
          ),
          ActivityGitlabCommitTableData,
          PrefetchHooks Function({bool activityId})
        > {
  $$ActivityGitlabCommitTableTableTableManager(
    _$AppDatabase db,
    $ActivityGitlabCommitTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityGitlabCommitTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ActivityGitlabCommitTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActivityGitlabCommitTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> activityId = const Value.absent(),
                Value<String?> project = const Value.absent(),
                Value<String?> branch = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityGitlabCommitTableCompanion(
                activityId: activityId,
                project: project,
                branch: branch,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String activityId,
                Value<String?> project = const Value.absent(),
                Value<String?> branch = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityGitlabCommitTableCompanion.insert(
                activityId: activityId,
                project: project,
                branch: branch,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivityGitlabCommitTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({activityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (activityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.activityId,
                                referencedTable:
                                    $$ActivityGitlabCommitTableTableReferences
                                        ._activityIdTable(db),
                                referencedColumn:
                                    $$ActivityGitlabCommitTableTableReferences
                                        ._activityIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActivityGitlabCommitTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityGitlabCommitTableTable,
      ActivityGitlabCommitTableData,
      $$ActivityGitlabCommitTableTableFilterComposer,
      $$ActivityGitlabCommitTableTableOrderingComposer,
      $$ActivityGitlabCommitTableTableAnnotationComposer,
      $$ActivityGitlabCommitTableTableCreateCompanionBuilder,
      $$ActivityGitlabCommitTableTableUpdateCompanionBuilder,
      (
        ActivityGitlabCommitTableData,
        $$ActivityGitlabCommitTableTableReferences,
      ),
      ActivityGitlabCommitTableData,
      PrefetchHooks Function({bool activityId})
    >;
typedef $$ActivityBitbucketCommitTableTableCreateCompanionBuilder =
    ActivityBitbucketCommitTableCompanion Function({
      required String activityId,
      Value<String?> repo,
      Value<String?> branch,
      Value<int> rowid,
    });
typedef $$ActivityBitbucketCommitTableTableUpdateCompanionBuilder =
    ActivityBitbucketCommitTableCompanion Function({
      Value<String> activityId,
      Value<String?> repo,
      Value<String?> branch,
      Value<int> rowid,
    });

final class $$ActivityBitbucketCommitTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActivityBitbucketCommitTableTable,
          ActivityBitbucketCommitTableData
        > {
  $$ActivityBitbucketCommitTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActivitiesTableTable _activityIdTable(_$AppDatabase db) =>
      db.activitiesTable.createAlias(
        $_aliasNameGenerator(
          db.activityBitbucketCommitTable.activityId,
          db.activitiesTable.id,
        ),
      );

  $$ActivitiesTableTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<String>('activity_id')!;

    final manager = $$ActivitiesTableTableTableManager(
      $_db,
      $_db.activitiesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActivityBitbucketCommitTableTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityBitbucketCommitTableTable> {
  $$ActivityBitbucketCommitTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get repo => $composableBuilder(
    column: $table.repo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivitiesTableTableFilterComposer get activityId {
    final $$ActivitiesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableFilterComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityBitbucketCommitTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityBitbucketCommitTableTable> {
  $$ActivityBitbucketCommitTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get repo => $composableBuilder(
    column: $table.repo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableTableOrderingComposer get activityId {
    final $$ActivitiesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableOrderingComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityBitbucketCommitTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityBitbucketCommitTableTable> {
  $$ActivityBitbucketCommitTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get repo =>
      $composableBuilder(column: $table.repo, builder: (column) => column);

  GeneratedColumn<String> get branch =>
      $composableBuilder(column: $table.branch, builder: (column) => column);

  $$ActivitiesTableTableAnnotationComposer get activityId {
    final $$ActivitiesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityBitbucketCommitTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityBitbucketCommitTableTable,
          ActivityBitbucketCommitTableData,
          $$ActivityBitbucketCommitTableTableFilterComposer,
          $$ActivityBitbucketCommitTableTableOrderingComposer,
          $$ActivityBitbucketCommitTableTableAnnotationComposer,
          $$ActivityBitbucketCommitTableTableCreateCompanionBuilder,
          $$ActivityBitbucketCommitTableTableUpdateCompanionBuilder,
          (
            ActivityBitbucketCommitTableData,
            $$ActivityBitbucketCommitTableTableReferences,
          ),
          ActivityBitbucketCommitTableData,
          PrefetchHooks Function({bool activityId})
        > {
  $$ActivityBitbucketCommitTableTableTableManager(
    _$AppDatabase db,
    $ActivityBitbucketCommitTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityBitbucketCommitTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ActivityBitbucketCommitTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActivityBitbucketCommitTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> activityId = const Value.absent(),
                Value<String?> repo = const Value.absent(),
                Value<String?> branch = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityBitbucketCommitTableCompanion(
                activityId: activityId,
                repo: repo,
                branch: branch,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String activityId,
                Value<String?> repo = const Value.absent(),
                Value<String?> branch = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityBitbucketCommitTableCompanion.insert(
                activityId: activityId,
                repo: repo,
                branch: branch,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivityBitbucketCommitTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({activityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (activityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.activityId,
                                referencedTable:
                                    $$ActivityBitbucketCommitTableTableReferences
                                        ._activityIdTable(db),
                                referencedColumn:
                                    $$ActivityBitbucketCommitTableTableReferences
                                        ._activityIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActivityBitbucketCommitTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityBitbucketCommitTableTable,
      ActivityBitbucketCommitTableData,
      $$ActivityBitbucketCommitTableTableFilterComposer,
      $$ActivityBitbucketCommitTableTableOrderingComposer,
      $$ActivityBitbucketCommitTableTableAnnotationComposer,
      $$ActivityBitbucketCommitTableTableCreateCompanionBuilder,
      $$ActivityBitbucketCommitTableTableUpdateCompanionBuilder,
      (
        ActivityBitbucketCommitTableData,
        $$ActivityBitbucketCommitTableTableReferences,
      ),
      ActivityBitbucketCommitTableData,
      PrefetchHooks Function({bool activityId})
    >;
typedef $$ActivityJiraIssueTableTableCreateCompanionBuilder =
    ActivityJiraIssueTableCompanion Function({
      required String activityId,
      required String issueKey,
      required String projectKey,
      Value<String?> statusName,
      Value<int> rowid,
    });
typedef $$ActivityJiraIssueTableTableUpdateCompanionBuilder =
    ActivityJiraIssueTableCompanion Function({
      Value<String> activityId,
      Value<String> issueKey,
      Value<String> projectKey,
      Value<String?> statusName,
      Value<int> rowid,
    });

final class $$ActivityJiraIssueTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActivityJiraIssueTableTable,
          ActivityJiraIssueTableData
        > {
  $$ActivityJiraIssueTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActivitiesTableTable _activityIdTable(_$AppDatabase db) =>
      db.activitiesTable.createAlias(
        $_aliasNameGenerator(
          db.activityJiraIssueTable.activityId,
          db.activitiesTable.id,
        ),
      );

  $$ActivitiesTableTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<String>('activity_id')!;

    final manager = $$ActivitiesTableTableTableManager(
      $_db,
      $_db.activitiesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActivityJiraIssueTableTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityJiraIssueTableTable> {
  $$ActivityJiraIssueTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get issueKey => $composableBuilder(
    column: $table.issueKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectKey => $composableBuilder(
    column: $table.projectKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statusName => $composableBuilder(
    column: $table.statusName,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivitiesTableTableFilterComposer get activityId {
    final $$ActivitiesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableFilterComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityJiraIssueTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityJiraIssueTableTable> {
  $$ActivityJiraIssueTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get issueKey => $composableBuilder(
    column: $table.issueKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectKey => $composableBuilder(
    column: $table.projectKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statusName => $composableBuilder(
    column: $table.statusName,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableTableOrderingComposer get activityId {
    final $$ActivitiesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableOrderingComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityJiraIssueTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityJiraIssueTableTable> {
  $$ActivityJiraIssueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get issueKey =>
      $composableBuilder(column: $table.issueKey, builder: (column) => column);

  GeneratedColumn<String> get projectKey => $composableBuilder(
    column: $table.projectKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get statusName => $composableBuilder(
    column: $table.statusName,
    builder: (column) => column,
  );

  $$ActivitiesTableTableAnnotationComposer get activityId {
    final $$ActivitiesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityJiraIssueTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityJiraIssueTableTable,
          ActivityJiraIssueTableData,
          $$ActivityJiraIssueTableTableFilterComposer,
          $$ActivityJiraIssueTableTableOrderingComposer,
          $$ActivityJiraIssueTableTableAnnotationComposer,
          $$ActivityJiraIssueTableTableCreateCompanionBuilder,
          $$ActivityJiraIssueTableTableUpdateCompanionBuilder,
          (ActivityJiraIssueTableData, $$ActivityJiraIssueTableTableReferences),
          ActivityJiraIssueTableData,
          PrefetchHooks Function({bool activityId})
        > {
  $$ActivityJiraIssueTableTableTableManager(
    _$AppDatabase db,
    $ActivityJiraIssueTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityJiraIssueTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ActivityJiraIssueTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActivityJiraIssueTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> activityId = const Value.absent(),
                Value<String> issueKey = const Value.absent(),
                Value<String> projectKey = const Value.absent(),
                Value<String?> statusName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityJiraIssueTableCompanion(
                activityId: activityId,
                issueKey: issueKey,
                projectKey: projectKey,
                statusName: statusName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String activityId,
                required String issueKey,
                required String projectKey,
                Value<String?> statusName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityJiraIssueTableCompanion.insert(
                activityId: activityId,
                issueKey: issueKey,
                projectKey: projectKey,
                statusName: statusName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivityJiraIssueTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({activityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (activityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.activityId,
                                referencedTable:
                                    $$ActivityJiraIssueTableTableReferences
                                        ._activityIdTable(db),
                                referencedColumn:
                                    $$ActivityJiraIssueTableTableReferences
                                        ._activityIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActivityJiraIssueTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityJiraIssueTableTable,
      ActivityJiraIssueTableData,
      $$ActivityJiraIssueTableTableFilterComposer,
      $$ActivityJiraIssueTableTableOrderingComposer,
      $$ActivityJiraIssueTableTableAnnotationComposer,
      $$ActivityJiraIssueTableTableCreateCompanionBuilder,
      $$ActivityJiraIssueTableTableUpdateCompanionBuilder,
      (ActivityJiraIssueTableData, $$ActivityJiraIssueTableTableReferences),
      ActivityJiraIssueTableData,
      PrefetchHooks Function({bool activityId})
    >;
typedef $$ActivityLinearIssueTableTableCreateCompanionBuilder =
    ActivityLinearIssueTableCompanion Function({
      required String activityId,
      required String identifier,
      required String teamKey,
      Value<String?> statusName,
      Value<int> rowid,
    });
typedef $$ActivityLinearIssueTableTableUpdateCompanionBuilder =
    ActivityLinearIssueTableCompanion Function({
      Value<String> activityId,
      Value<String> identifier,
      Value<String> teamKey,
      Value<String?> statusName,
      Value<int> rowid,
    });

final class $$ActivityLinearIssueTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActivityLinearIssueTableTable,
          ActivityLinearIssueTableData
        > {
  $$ActivityLinearIssueTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActivitiesTableTable _activityIdTable(_$AppDatabase db) =>
      db.activitiesTable.createAlias(
        $_aliasNameGenerator(
          db.activityLinearIssueTable.activityId,
          db.activitiesTable.id,
        ),
      );

  $$ActivitiesTableTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<String>('activity_id')!;

    final manager = $$ActivitiesTableTableTableManager(
      $_db,
      $_db.activitiesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActivityLinearIssueTableTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityLinearIssueTableTable> {
  $$ActivityLinearIssueTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teamKey => $composableBuilder(
    column: $table.teamKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statusName => $composableBuilder(
    column: $table.statusName,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivitiesTableTableFilterComposer get activityId {
    final $$ActivitiesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableFilterComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityLinearIssueTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityLinearIssueTableTable> {
  $$ActivityLinearIssueTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teamKey => $composableBuilder(
    column: $table.teamKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statusName => $composableBuilder(
    column: $table.statusName,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableTableOrderingComposer get activityId {
    final $$ActivitiesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableOrderingComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityLinearIssueTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityLinearIssueTableTable> {
  $$ActivityLinearIssueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => column,
  );

  GeneratedColumn<String> get teamKey =>
      $composableBuilder(column: $table.teamKey, builder: (column) => column);

  GeneratedColumn<String> get statusName => $composableBuilder(
    column: $table.statusName,
    builder: (column) => column,
  );

  $$ActivitiesTableTableAnnotationComposer get activityId {
    final $$ActivitiesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityLinearIssueTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityLinearIssueTableTable,
          ActivityLinearIssueTableData,
          $$ActivityLinearIssueTableTableFilterComposer,
          $$ActivityLinearIssueTableTableOrderingComposer,
          $$ActivityLinearIssueTableTableAnnotationComposer,
          $$ActivityLinearIssueTableTableCreateCompanionBuilder,
          $$ActivityLinearIssueTableTableUpdateCompanionBuilder,
          (
            ActivityLinearIssueTableData,
            $$ActivityLinearIssueTableTableReferences,
          ),
          ActivityLinearIssueTableData,
          PrefetchHooks Function({bool activityId})
        > {
  $$ActivityLinearIssueTableTableTableManager(
    _$AppDatabase db,
    $ActivityLinearIssueTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityLinearIssueTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ActivityLinearIssueTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActivityLinearIssueTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> activityId = const Value.absent(),
                Value<String> identifier = const Value.absent(),
                Value<String> teamKey = const Value.absent(),
                Value<String?> statusName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityLinearIssueTableCompanion(
                activityId: activityId,
                identifier: identifier,
                teamKey: teamKey,
                statusName: statusName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String activityId,
                required String identifier,
                required String teamKey,
                Value<String?> statusName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityLinearIssueTableCompanion.insert(
                activityId: activityId,
                identifier: identifier,
                teamKey: teamKey,
                statusName: statusName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivityLinearIssueTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({activityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (activityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.activityId,
                                referencedTable:
                                    $$ActivityLinearIssueTableTableReferences
                                        ._activityIdTable(db),
                                referencedColumn:
                                    $$ActivityLinearIssueTableTableReferences
                                        ._activityIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActivityLinearIssueTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityLinearIssueTableTable,
      ActivityLinearIssueTableData,
      $$ActivityLinearIssueTableTableFilterComposer,
      $$ActivityLinearIssueTableTableOrderingComposer,
      $$ActivityLinearIssueTableTableAnnotationComposer,
      $$ActivityLinearIssueTableTableCreateCompanionBuilder,
      $$ActivityLinearIssueTableTableUpdateCompanionBuilder,
      (ActivityLinearIssueTableData, $$ActivityLinearIssueTableTableReferences),
      ActivityLinearIssueTableData,
      PrefetchHooks Function({bool activityId})
    >;
typedef $$ActivitySlackMessageTableTableCreateCompanionBuilder =
    ActivitySlackMessageTableCompanion Function({
      required String activityId,
      Value<String?> workspaceId,
      Value<String?> channelId,
      Value<String?> threadTs,
      Value<String?> messageTs,
      Value<int> rowid,
    });
typedef $$ActivitySlackMessageTableTableUpdateCompanionBuilder =
    ActivitySlackMessageTableCompanion Function({
      Value<String> activityId,
      Value<String?> workspaceId,
      Value<String?> channelId,
      Value<String?> threadTs,
      Value<String?> messageTs,
      Value<int> rowid,
    });

final class $$ActivitySlackMessageTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActivitySlackMessageTableTable,
          ActivitySlackMessageTableData
        > {
  $$ActivitySlackMessageTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActivitiesTableTable _activityIdTable(_$AppDatabase db) =>
      db.activitiesTable.createAlias(
        $_aliasNameGenerator(
          db.activitySlackMessageTable.activityId,
          db.activitiesTable.id,
        ),
      );

  $$ActivitiesTableTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<String>('activity_id')!;

    final manager = $$ActivitiesTableTableTableManager(
      $_db,
      $_db.activitiesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActivitySlackMessageTableTableFilterComposer
    extends Composer<_$AppDatabase, $ActivitySlackMessageTableTable> {
  $$ActivitySlackMessageTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get threadTs => $composableBuilder(
    column: $table.threadTs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageTs => $composableBuilder(
    column: $table.messageTs,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivitiesTableTableFilterComposer get activityId {
    final $$ActivitiesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableFilterComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivitySlackMessageTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivitySlackMessageTableTable> {
  $$ActivitySlackMessageTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get threadTs => $composableBuilder(
    column: $table.threadTs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageTs => $composableBuilder(
    column: $table.messageTs,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableTableOrderingComposer get activityId {
    final $$ActivitiesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableOrderingComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivitySlackMessageTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivitySlackMessageTableTable> {
  $$ActivitySlackMessageTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get threadTs =>
      $composableBuilder(column: $table.threadTs, builder: (column) => column);

  GeneratedColumn<String> get messageTs =>
      $composableBuilder(column: $table.messageTs, builder: (column) => column);

  $$ActivitiesTableTableAnnotationComposer get activityId {
    final $$ActivitiesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivitySlackMessageTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivitySlackMessageTableTable,
          ActivitySlackMessageTableData,
          $$ActivitySlackMessageTableTableFilterComposer,
          $$ActivitySlackMessageTableTableOrderingComposer,
          $$ActivitySlackMessageTableTableAnnotationComposer,
          $$ActivitySlackMessageTableTableCreateCompanionBuilder,
          $$ActivitySlackMessageTableTableUpdateCompanionBuilder,
          (
            ActivitySlackMessageTableData,
            $$ActivitySlackMessageTableTableReferences,
          ),
          ActivitySlackMessageTableData,
          PrefetchHooks Function({bool activityId})
        > {
  $$ActivitySlackMessageTableTableTableManager(
    _$AppDatabase db,
    $ActivitySlackMessageTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivitySlackMessageTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ActivitySlackMessageTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActivitySlackMessageTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> activityId = const Value.absent(),
                Value<String?> workspaceId = const Value.absent(),
                Value<String?> channelId = const Value.absent(),
                Value<String?> threadTs = const Value.absent(),
                Value<String?> messageTs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivitySlackMessageTableCompanion(
                activityId: activityId,
                workspaceId: workspaceId,
                channelId: channelId,
                threadTs: threadTs,
                messageTs: messageTs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String activityId,
                Value<String?> workspaceId = const Value.absent(),
                Value<String?> channelId = const Value.absent(),
                Value<String?> threadTs = const Value.absent(),
                Value<String?> messageTs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivitySlackMessageTableCompanion.insert(
                activityId: activityId,
                workspaceId: workspaceId,
                channelId: channelId,
                threadTs: threadTs,
                messageTs: messageTs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivitySlackMessageTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({activityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (activityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.activityId,
                                referencedTable:
                                    $$ActivitySlackMessageTableTableReferences
                                        ._activityIdTable(db),
                                referencedColumn:
                                    $$ActivitySlackMessageTableTableReferences
                                        ._activityIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActivitySlackMessageTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivitySlackMessageTableTable,
      ActivitySlackMessageTableData,
      $$ActivitySlackMessageTableTableFilterComposer,
      $$ActivitySlackMessageTableTableOrderingComposer,
      $$ActivitySlackMessageTableTableAnnotationComposer,
      $$ActivitySlackMessageTableTableCreateCompanionBuilder,
      $$ActivitySlackMessageTableTableUpdateCompanionBuilder,
      (
        ActivitySlackMessageTableData,
        $$ActivitySlackMessageTableTableReferences,
      ),
      ActivitySlackMessageTableData,
      PrefetchHooks Function({bool activityId})
    >;
typedef $$ActivityDiscordMessageTableTableCreateCompanionBuilder =
    ActivityDiscordMessageTableCompanion Function({
      required String activityId,
      Value<String?> guildId,
      Value<String?> channelId,
      Value<String?> messageId,
      Value<String?> replyToId,
      Value<int> rowid,
    });
typedef $$ActivityDiscordMessageTableTableUpdateCompanionBuilder =
    ActivityDiscordMessageTableCompanion Function({
      Value<String> activityId,
      Value<String?> guildId,
      Value<String?> channelId,
      Value<String?> messageId,
      Value<String?> replyToId,
      Value<int> rowid,
    });

final class $$ActivityDiscordMessageTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActivityDiscordMessageTableTable,
          ActivityDiscordMessageTableData
        > {
  $$ActivityDiscordMessageTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActivitiesTableTable _activityIdTable(_$AppDatabase db) =>
      db.activitiesTable.createAlias(
        $_aliasNameGenerator(
          db.activityDiscordMessageTable.activityId,
          db.activitiesTable.id,
        ),
      );

  $$ActivitiesTableTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<String>('activity_id')!;

    final manager = $$ActivitiesTableTableTableManager(
      $_db,
      $_db.activitiesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActivityDiscordMessageTableTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityDiscordMessageTableTable> {
  $$ActivityDiscordMessageTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get guildId => $composableBuilder(
    column: $table.guildId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get replyToId => $composableBuilder(
    column: $table.replyToId,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivitiesTableTableFilterComposer get activityId {
    final $$ActivitiesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableFilterComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityDiscordMessageTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityDiscordMessageTableTable> {
  $$ActivityDiscordMessageTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get guildId => $composableBuilder(
    column: $table.guildId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get replyToId => $composableBuilder(
    column: $table.replyToId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableTableOrderingComposer get activityId {
    final $$ActivitiesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableOrderingComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityDiscordMessageTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityDiscordMessageTableTable> {
  $$ActivityDiscordMessageTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get guildId =>
      $composableBuilder(column: $table.guildId, builder: (column) => column);

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get replyToId =>
      $composableBuilder(column: $table.replyToId, builder: (column) => column);

  $$ActivitiesTableTableAnnotationComposer get activityId {
    final $$ActivitiesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activitiesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.activitiesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityDiscordMessageTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityDiscordMessageTableTable,
          ActivityDiscordMessageTableData,
          $$ActivityDiscordMessageTableTableFilterComposer,
          $$ActivityDiscordMessageTableTableOrderingComposer,
          $$ActivityDiscordMessageTableTableAnnotationComposer,
          $$ActivityDiscordMessageTableTableCreateCompanionBuilder,
          $$ActivityDiscordMessageTableTableUpdateCompanionBuilder,
          (
            ActivityDiscordMessageTableData,
            $$ActivityDiscordMessageTableTableReferences,
          ),
          ActivityDiscordMessageTableData,
          PrefetchHooks Function({bool activityId})
        > {
  $$ActivityDiscordMessageTableTableTableManager(
    _$AppDatabase db,
    $ActivityDiscordMessageTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityDiscordMessageTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ActivityDiscordMessageTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActivityDiscordMessageTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> activityId = const Value.absent(),
                Value<String?> guildId = const Value.absent(),
                Value<String?> channelId = const Value.absent(),
                Value<String?> messageId = const Value.absent(),
                Value<String?> replyToId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityDiscordMessageTableCompanion(
                activityId: activityId,
                guildId: guildId,
                channelId: channelId,
                messageId: messageId,
                replyToId: replyToId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String activityId,
                Value<String?> guildId = const Value.absent(),
                Value<String?> channelId = const Value.absent(),
                Value<String?> messageId = const Value.absent(),
                Value<String?> replyToId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityDiscordMessageTableCompanion.insert(
                activityId: activityId,
                guildId: guildId,
                channelId: channelId,
                messageId: messageId,
                replyToId: replyToId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivityDiscordMessageTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({activityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (activityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.activityId,
                                referencedTable:
                                    $$ActivityDiscordMessageTableTableReferences
                                        ._activityIdTable(db),
                                referencedColumn:
                                    $$ActivityDiscordMessageTableTableReferences
                                        ._activityIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActivityDiscordMessageTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityDiscordMessageTableTable,
      ActivityDiscordMessageTableData,
      $$ActivityDiscordMessageTableTableFilterComposer,
      $$ActivityDiscordMessageTableTableOrderingComposer,
      $$ActivityDiscordMessageTableTableAnnotationComposer,
      $$ActivityDiscordMessageTableTableCreateCompanionBuilder,
      $$ActivityDiscordMessageTableTableUpdateCompanionBuilder,
      (
        ActivityDiscordMessageTableData,
        $$ActivityDiscordMessageTableTableReferences,
      ),
      ActivityDiscordMessageTableData,
      PrefetchHooks Function({bool activityId})
    >;
typedef $$SessionsTableTableCreateCompanionBuilder =
    SessionsTableCompanion Function({
      required String id,
      required String userId,
      required String refreshToken,
      required PgDateTime expiresAt,
      Value<String?> deviceInfo,
      Value<int> rowid,
    });
typedef $$SessionsTableTableUpdateCompanionBuilder =
    SessionsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> refreshToken,
      Value<PgDateTime> expiresAt,
      Value<String?> deviceInfo,
      Value<int> rowid,
    });

class $$SessionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTableTable> {
  $$SessionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTableTable> {
  $$SessionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTableTable> {
  $$SessionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => column,
  );

  GeneratedColumn<PgDateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => column,
  );
}

class $$SessionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTableTable,
          SessionsTableData,
          $$SessionsTableTableFilterComposer,
          $$SessionsTableTableOrderingComposer,
          $$SessionsTableTableAnnotationComposer,
          $$SessionsTableTableCreateCompanionBuilder,
          $$SessionsTableTableUpdateCompanionBuilder,
          (
            SessionsTableData,
            BaseReferences<
              _$AppDatabase,
              $SessionsTableTable,
              SessionsTableData
            >,
          ),
          SessionsTableData,
          PrefetchHooks Function()
        > {
  $$SessionsTableTableTableManager(_$AppDatabase db, $SessionsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> refreshToken = const Value.absent(),
                Value<PgDateTime> expiresAt = const Value.absent(),
                Value<String?> deviceInfo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsTableCompanion(
                id: id,
                userId: userId,
                refreshToken: refreshToken,
                expiresAt: expiresAt,
                deviceInfo: deviceInfo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String refreshToken,
                required PgDateTime expiresAt,
                Value<String?> deviceInfo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsTableCompanion.insert(
                id: id,
                userId: userId,
                refreshToken: refreshToken,
                expiresAt: expiresAt,
                deviceInfo: deviceInfo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTableTable,
      SessionsTableData,
      $$SessionsTableTableFilterComposer,
      $$SessionsTableTableOrderingComposer,
      $$SessionsTableTableAnnotationComposer,
      $$SessionsTableTableCreateCompanionBuilder,
      $$SessionsTableTableUpdateCompanionBuilder,
      (
        SessionsTableData,
        BaseReferences<_$AppDatabase, $SessionsTableTable, SessionsTableData>,
      ),
      SessionsTableData,
      PrefetchHooks Function()
    >;
typedef $$GroupsTableTableCreateCompanionBuilder =
    GroupsTableCompanion Function({
      required String id,
      required String name,
      required String type,
      Value<String?> iconUrl,
      Value<String?> providerName,
      Value<int> rowid,
    });
typedef $$GroupsTableTableUpdateCompanionBuilder =
    GroupsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<String?> iconUrl,
      Value<String?> providerName,
      Value<int> rowid,
    });

final class $$GroupsTableTableReferences
    extends BaseReferences<_$AppDatabase, $GroupsTableTable, GroupsTableData> {
  $$GroupsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $GroupMembersTableTable,
    List<GroupMembersTableData>
  >
  _groupMembersTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.groupMembersTable,
        aliasName: $_aliasNameGenerator(
          db.groupsTable.id,
          db.groupMembersTable.groupId,
        ),
      );

  $$GroupMembersTableTableProcessedTableManager get groupMembersTableRefs {
    final manager = $$GroupMembersTableTableTableManager(
      $_db,
      $_db.groupMembersTable,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _groupMembersTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GroupsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GroupsTableTable> {
  $$GroupsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconUrl => $composableBuilder(
    column: $table.iconUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> groupMembersTableRefs(
    Expression<bool> Function($$GroupMembersTableTableFilterComposer f) f,
  ) {
    final $$GroupMembersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMembersTable,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMembersTableTableFilterComposer(
            $db: $db,
            $table: $db.groupMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupsTableTable> {
  $$GroupsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconUrl => $composableBuilder(
    column: $table.iconUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroupsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupsTableTable> {
  $$GroupsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get iconUrl =>
      $composableBuilder(column: $table.iconUrl, builder: (column) => column);

  GeneratedColumn<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => column,
  );

  Expression<T> groupMembersTableRefs<T extends Object>(
    Expression<T> Function($$GroupMembersTableTableAnnotationComposer a) f,
  ) {
    final $$GroupMembersTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.groupMembersTable,
          getReferencedColumn: (t) => t.groupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GroupMembersTableTableAnnotationComposer(
                $db: $db,
                $table: $db.groupMembersTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$GroupsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupsTableTable,
          GroupsTableData,
          $$GroupsTableTableFilterComposer,
          $$GroupsTableTableOrderingComposer,
          $$GroupsTableTableAnnotationComposer,
          $$GroupsTableTableCreateCompanionBuilder,
          $$GroupsTableTableUpdateCompanionBuilder,
          (GroupsTableData, $$GroupsTableTableReferences),
          GroupsTableData,
          PrefetchHooks Function({bool groupMembersTableRefs})
        > {
  $$GroupsTableTableTableManager(_$AppDatabase db, $GroupsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> iconUrl = const Value.absent(),
                Value<String?> providerName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupsTableCompanion(
                id: id,
                name: name,
                type: type,
                iconUrl: iconUrl,
                providerName: providerName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                Value<String?> iconUrl = const Value.absent(),
                Value<String?> providerName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupsTableCompanion.insert(
                id: id,
                name: name,
                type: type,
                iconUrl: iconUrl,
                providerName: providerName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GroupsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupMembersTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (groupMembersTableRefs) db.groupMembersTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (groupMembersTableRefs)
                    await $_getPrefetchedData<
                      GroupsTableData,
                      $GroupsTableTable,
                      GroupMembersTableData
                    >(
                      currentTable: table,
                      referencedTable: $$GroupsTableTableReferences
                          ._groupMembersTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GroupsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).groupMembersTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.groupId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GroupsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupsTableTable,
      GroupsTableData,
      $$GroupsTableTableFilterComposer,
      $$GroupsTableTableOrderingComposer,
      $$GroupsTableTableAnnotationComposer,
      $$GroupsTableTableCreateCompanionBuilder,
      $$GroupsTableTableUpdateCompanionBuilder,
      (GroupsTableData, $$GroupsTableTableReferences),
      GroupsTableData,
      PrefetchHooks Function({bool groupMembersTableRefs})
    >;
typedef $$GroupMembersTableTableCreateCompanionBuilder =
    GroupMembersTableCompanion Function({
      required String groupId,
      required String userId,
      Value<int> rowid,
    });
typedef $$GroupMembersTableTableUpdateCompanionBuilder =
    GroupMembersTableCompanion Function({
      Value<String> groupId,
      Value<String> userId,
      Value<int> rowid,
    });

final class $$GroupMembersTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GroupMembersTableTable,
          GroupMembersTableData
        > {
  $$GroupMembersTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GroupsTableTable _groupIdTable(_$AppDatabase db) =>
      db.groupsTable.createAlias(
        $_aliasNameGenerator(db.groupMembersTable.groupId, db.groupsTable.id),
      );

  $$GroupsTableTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableTableManager(
      $_db,
      $_db.groupsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTableTable _userIdTable(_$AppDatabase db) =>
      db.usersTable.createAlias(
        $_aliasNameGenerator(db.groupMembersTable.userId, db.usersTable.id),
      );

  $$UsersTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableTableManager(
      $_db,
      $_db.usersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GroupMembersTableTableFilterComposer
    extends Composer<_$AppDatabase, $GroupMembersTableTable> {
  $$GroupMembersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GroupsTableTableFilterComposer get groupId {
    final $$GroupsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groupsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableTableFilterComposer(
            $db: $db,
            $table: $db.groupsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableFilterComposer get userId {
    final $$UsersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableFilterComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMembersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupMembersTableTable> {
  $$GroupMembersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GroupsTableTableOrderingComposer get groupId {
    final $$GroupsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groupsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableTableOrderingComposer(
            $db: $db,
            $table: $db.groupsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableOrderingComposer get userId {
    final $$UsersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableOrderingComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMembersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupMembersTableTable> {
  $$GroupMembersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GroupsTableTableAnnotationComposer get groupId {
    final $$GroupsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groupsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.groupsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableAnnotationComposer get userId {
    final $$UsersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMembersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupMembersTableTable,
          GroupMembersTableData,
          $$GroupMembersTableTableFilterComposer,
          $$GroupMembersTableTableOrderingComposer,
          $$GroupMembersTableTableAnnotationComposer,
          $$GroupMembersTableTableCreateCompanionBuilder,
          $$GroupMembersTableTableUpdateCompanionBuilder,
          (GroupMembersTableData, $$GroupMembersTableTableReferences),
          GroupMembersTableData,
          PrefetchHooks Function({bool groupId, bool userId})
        > {
  $$GroupMembersTableTableTableManager(
    _$AppDatabase db,
    $GroupMembersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupMembersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupMembersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupMembersTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> groupId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupMembersTableCompanion(
                groupId: groupId,
                userId: userId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String groupId,
                required String userId,
                Value<int> rowid = const Value.absent(),
              }) => GroupMembersTableCompanion.insert(
                groupId: groupId,
                userId: userId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GroupMembersTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable:
                                    $$GroupMembersTableTableReferences
                                        ._groupIdTable(db),
                                referencedColumn:
                                    $$GroupMembersTableTableReferences
                                        ._groupIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable:
                                    $$GroupMembersTableTableReferences
                                        ._userIdTable(db),
                                referencedColumn:
                                    $$GroupMembersTableTableReferences
                                        ._userIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GroupMembersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupMembersTableTable,
      GroupMembersTableData,
      $$GroupMembersTableTableFilterComposer,
      $$GroupMembersTableTableOrderingComposer,
      $$GroupMembersTableTableAnnotationComposer,
      $$GroupMembersTableTableCreateCompanionBuilder,
      $$GroupMembersTableTableUpdateCompanionBuilder,
      (GroupMembersTableData, $$GroupMembersTableTableReferences),
      GroupMembersTableData,
      PrefetchHooks Function({bool groupId, bool userId})
    >;
typedef $$ProviderConfigsTableTableCreateCompanionBuilder =
    ProviderConfigsTableCompanion Function({
      required String id,
      required String name,
      required String baseUrl,
      Value<int> isActive,
      Value<String?> iconUrl,
      Value<String> settings,
      Value<PgDateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$ProviderConfigsTableTableUpdateCompanionBuilder =
    ProviderConfigsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> baseUrl,
      Value<int> isActive,
      Value<String?> iconUrl,
      Value<String> settings,
      Value<PgDateTime?> updatedAt,
      Value<int> rowid,
    });

class $$ProviderConfigsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProviderConfigsTableTable> {
  $$ProviderConfigsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconUrl => $composableBuilder(
    column: $table.iconUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settings => $composableBuilder(
    column: $table.settings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProviderConfigsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProviderConfigsTableTable> {
  $$ProviderConfigsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconUrl => $composableBuilder(
    column: $table.iconUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settings => $composableBuilder(
    column: $table.settings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProviderConfigsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProviderConfigsTableTable> {
  $$ProviderConfigsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get iconUrl =>
      $composableBuilder(column: $table.iconUrl, builder: (column) => column);

  GeneratedColumn<String> get settings =>
      $composableBuilder(column: $table.settings, builder: (column) => column);

  GeneratedColumn<PgDateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProviderConfigsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProviderConfigsTableTable,
          ProviderConfigsTableData,
          $$ProviderConfigsTableTableFilterComposer,
          $$ProviderConfigsTableTableOrderingComposer,
          $$ProviderConfigsTableTableAnnotationComposer,
          $$ProviderConfigsTableTableCreateCompanionBuilder,
          $$ProviderConfigsTableTableUpdateCompanionBuilder,
          (
            ProviderConfigsTableData,
            BaseReferences<
              _$AppDatabase,
              $ProviderConfigsTableTable,
              ProviderConfigsTableData
            >,
          ),
          ProviderConfigsTableData,
          PrefetchHooks Function()
        > {
  $$ProviderConfigsTableTableTableManager(
    _$AppDatabase db,
    $ProviderConfigsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProviderConfigsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProviderConfigsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ProviderConfigsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> baseUrl = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                Value<String?> iconUrl = const Value.absent(),
                Value<String> settings = const Value.absent(),
                Value<PgDateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProviderConfigsTableCompanion(
                id: id,
                name: name,
                baseUrl: baseUrl,
                isActive: isActive,
                iconUrl: iconUrl,
                settings: settings,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String baseUrl,
                Value<int> isActive = const Value.absent(),
                Value<String?> iconUrl = const Value.absent(),
                Value<String> settings = const Value.absent(),
                Value<PgDateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProviderConfigsTableCompanion.insert(
                id: id,
                name: name,
                baseUrl: baseUrl,
                isActive: isActive,
                iconUrl: iconUrl,
                settings: settings,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProviderConfigsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProviderConfigsTableTable,
      ProviderConfigsTableData,
      $$ProviderConfigsTableTableFilterComposer,
      $$ProviderConfigsTableTableOrderingComposer,
      $$ProviderConfigsTableTableAnnotationComposer,
      $$ProviderConfigsTableTableCreateCompanionBuilder,
      $$ProviderConfigsTableTableUpdateCompanionBuilder,
      (
        ProviderConfigsTableData,
        BaseReferences<
          _$AppDatabase,
          $ProviderConfigsTableTable,
          ProviderConfigsTableData
        >,
      ),
      ProviderConfigsTableData,
      PrefetchHooks Function()
    >;
typedef $$UserIdentitiesTableTableCreateCompanionBuilder =
    UserIdentitiesTableCompanion Function({
      required String id,
      required String userId,
      required String providerId,
      required String externalId,
      Value<String?> externalUsername,
      Value<String> status,
      Value<PgDateTime> createdAt,
      Value<PgDateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$UserIdentitiesTableTableUpdateCompanionBuilder =
    UserIdentitiesTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> providerId,
      Value<String> externalId,
      Value<String?> externalUsername,
      Value<String> status,
      Value<PgDateTime> createdAt,
      Value<PgDateTime?> updatedAt,
      Value<int> rowid,
    });

class $$UserIdentitiesTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserIdentitiesTableTable> {
  $$UserIdentitiesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalUsername => $composableBuilder(
    column: $table.externalUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserIdentitiesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserIdentitiesTableTable> {
  $$UserIdentitiesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalUsername => $composableBuilder(
    column: $table.externalUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserIdentitiesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserIdentitiesTableTable> {
  $$UserIdentitiesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalUsername => $composableBuilder(
    column: $table.externalUsername,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<PgDateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<PgDateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserIdentitiesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserIdentitiesTableTable,
          UserIdentitiesTableData,
          $$UserIdentitiesTableTableFilterComposer,
          $$UserIdentitiesTableTableOrderingComposer,
          $$UserIdentitiesTableTableAnnotationComposer,
          $$UserIdentitiesTableTableCreateCompanionBuilder,
          $$UserIdentitiesTableTableUpdateCompanionBuilder,
          (
            UserIdentitiesTableData,
            BaseReferences<
              _$AppDatabase,
              $UserIdentitiesTableTable,
              UserIdentitiesTableData
            >,
          ),
          UserIdentitiesTableData,
          PrefetchHooks Function()
        > {
  $$UserIdentitiesTableTableTableManager(
    _$AppDatabase db,
    $UserIdentitiesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserIdentitiesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserIdentitiesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$UserIdentitiesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> providerId = const Value.absent(),
                Value<String> externalId = const Value.absent(),
                Value<String?> externalUsername = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<PgDateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserIdentitiesTableCompanion(
                id: id,
                userId: userId,
                providerId: providerId,
                externalId: externalId,
                externalUsername: externalUsername,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String providerId,
                required String externalId,
                Value<String?> externalUsername = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<PgDateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserIdentitiesTableCompanion.insert(
                id: id,
                userId: userId,
                providerId: providerId,
                externalId: externalId,
                externalUsername: externalUsername,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserIdentitiesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserIdentitiesTableTable,
      UserIdentitiesTableData,
      $$UserIdentitiesTableTableFilterComposer,
      $$UserIdentitiesTableTableOrderingComposer,
      $$UserIdentitiesTableTableAnnotationComposer,
      $$UserIdentitiesTableTableCreateCompanionBuilder,
      $$UserIdentitiesTableTableUpdateCompanionBuilder,
      (
        UserIdentitiesTableData,
        BaseReferences<
          _$AppDatabase,
          $UserIdentitiesTableTable,
          UserIdentitiesTableData
        >,
      ),
      UserIdentitiesTableData,
      PrefetchHooks Function()
    >;
typedef $$UserProviderCredentialsTableTableCreateCompanionBuilder =
    UserProviderCredentialsTableCompanion Function({
      required String id,
      required String userId,
      required String providerId,
      Value<String> settings,
      Value<String> status,
      Value<PgDateTime> createdAt,
      Value<PgDateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$UserProviderCredentialsTableTableUpdateCompanionBuilder =
    UserProviderCredentialsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> providerId,
      Value<String> settings,
      Value<String> status,
      Value<PgDateTime> createdAt,
      Value<PgDateTime?> updatedAt,
      Value<int> rowid,
    });

class $$UserProviderCredentialsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserProviderCredentialsTableTable> {
  $$UserProviderCredentialsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settings => $composableBuilder(
    column: $table.settings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProviderCredentialsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProviderCredentialsTableTable> {
  $$UserProviderCredentialsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settings => $composableBuilder(
    column: $table.settings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProviderCredentialsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProviderCredentialsTableTable> {
  $$UserProviderCredentialsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get settings =>
      $composableBuilder(column: $table.settings, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<PgDateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<PgDateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserProviderCredentialsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProviderCredentialsTableTable,
          UserProviderCredentialsTableData,
          $$UserProviderCredentialsTableTableFilterComposer,
          $$UserProviderCredentialsTableTableOrderingComposer,
          $$UserProviderCredentialsTableTableAnnotationComposer,
          $$UserProviderCredentialsTableTableCreateCompanionBuilder,
          $$UserProviderCredentialsTableTableUpdateCompanionBuilder,
          (
            UserProviderCredentialsTableData,
            BaseReferences<
              _$AppDatabase,
              $UserProviderCredentialsTableTable,
              UserProviderCredentialsTableData
            >,
          ),
          UserProviderCredentialsTableData,
          PrefetchHooks Function()
        > {
  $$UserProviderCredentialsTableTableTableManager(
    _$AppDatabase db,
    $UserProviderCredentialsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProviderCredentialsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$UserProviderCredentialsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$UserProviderCredentialsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> providerId = const Value.absent(),
                Value<String> settings = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<PgDateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProviderCredentialsTableCompanion(
                id: id,
                userId: userId,
                providerId: providerId,
                settings: settings,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String providerId,
                Value<String> settings = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<PgDateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProviderCredentialsTableCompanion.insert(
                id: id,
                userId: userId,
                providerId: providerId,
                settings: settings,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProviderCredentialsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProviderCredentialsTableTable,
      UserProviderCredentialsTableData,
      $$UserProviderCredentialsTableTableFilterComposer,
      $$UserProviderCredentialsTableTableOrderingComposer,
      $$UserProviderCredentialsTableTableAnnotationComposer,
      $$UserProviderCredentialsTableTableCreateCompanionBuilder,
      $$UserProviderCredentialsTableTableUpdateCompanionBuilder,
      (
        UserProviderCredentialsTableData,
        BaseReferences<
          _$AppDatabase,
          $UserProviderCredentialsTableTable,
          UserProviderCredentialsTableData
        >,
      ),
      UserProviderCredentialsTableData,
      PrefetchHooks Function()
    >;
typedef $$ActivityFollowsTableTableCreateCompanionBuilder =
    ActivityFollowsTableCompanion Function({
      required String id,
      required String userId,
      required String providerId,
      required String objectKey,
      Value<PgDateTime> createdAt,
      Value<PgDateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$ActivityFollowsTableTableUpdateCompanionBuilder =
    ActivityFollowsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> providerId,
      Value<String> objectKey,
      Value<PgDateTime> createdAt,
      Value<PgDateTime?> updatedAt,
      Value<int> rowid,
    });

class $$ActivityFollowsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityFollowsTableTable> {
  $$ActivityFollowsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get objectKey => $composableBuilder(
    column: $table.objectKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityFollowsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityFollowsTableTable> {
  $$ActivityFollowsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get objectKey => $composableBuilder(
    column: $table.objectKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityFollowsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityFollowsTableTable> {
  $$ActivityFollowsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get objectKey =>
      $composableBuilder(column: $table.objectKey, builder: (column) => column);

  GeneratedColumn<PgDateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<PgDateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ActivityFollowsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityFollowsTableTable,
          ActivityFollowsTableData,
          $$ActivityFollowsTableTableFilterComposer,
          $$ActivityFollowsTableTableOrderingComposer,
          $$ActivityFollowsTableTableAnnotationComposer,
          $$ActivityFollowsTableTableCreateCompanionBuilder,
          $$ActivityFollowsTableTableUpdateCompanionBuilder,
          (
            ActivityFollowsTableData,
            BaseReferences<
              _$AppDatabase,
              $ActivityFollowsTableTable,
              ActivityFollowsTableData
            >,
          ),
          ActivityFollowsTableData,
          PrefetchHooks Function()
        > {
  $$ActivityFollowsTableTableTableManager(
    _$AppDatabase db,
    $ActivityFollowsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityFollowsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityFollowsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActivityFollowsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> providerId = const Value.absent(),
                Value<String> objectKey = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<PgDateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityFollowsTableCompanion(
                id: id,
                userId: userId,
                providerId: providerId,
                objectKey: objectKey,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String providerId,
                required String objectKey,
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<PgDateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityFollowsTableCompanion.insert(
                id: id,
                userId: userId,
                providerId: providerId,
                objectKey: objectKey,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityFollowsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityFollowsTableTable,
      ActivityFollowsTableData,
      $$ActivityFollowsTableTableFilterComposer,
      $$ActivityFollowsTableTableOrderingComposer,
      $$ActivityFollowsTableTableAnnotationComposer,
      $$ActivityFollowsTableTableCreateCompanionBuilder,
      $$ActivityFollowsTableTableUpdateCompanionBuilder,
      (
        ActivityFollowsTableData,
        BaseReferences<
          _$AppDatabase,
          $ActivityFollowsTableTable,
          ActivityFollowsTableData
        >,
      ),
      ActivityFollowsTableData,
      PrefetchHooks Function()
    >;
typedef $$SystemSettingsTableTableCreateCompanionBuilder =
    SystemSettingsTableCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SystemSettingsTableTableUpdateCompanionBuilder =
    SystemSettingsTableCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SystemSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SystemSettingsTableTable> {
  $$SystemSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SystemSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SystemSettingsTableTable> {
  $$SystemSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SystemSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SystemSettingsTableTable> {
  $$SystemSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SystemSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SystemSettingsTableTable,
          SystemSettingsTableData,
          $$SystemSettingsTableTableFilterComposer,
          $$SystemSettingsTableTableOrderingComposer,
          $$SystemSettingsTableTableAnnotationComposer,
          $$SystemSettingsTableTableCreateCompanionBuilder,
          $$SystemSettingsTableTableUpdateCompanionBuilder,
          (
            SystemSettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $SystemSettingsTableTable,
              SystemSettingsTableData
            >,
          ),
          SystemSettingsTableData,
          PrefetchHooks Function()
        > {
  $$SystemSettingsTableTableTableManager(
    _$AppDatabase db,
    $SystemSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SystemSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SystemSettingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SystemSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SystemSettingsTableCompanion(
                key: key,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SystemSettingsTableCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SystemSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SystemSettingsTableTable,
      SystemSettingsTableData,
      $$SystemSettingsTableTableFilterComposer,
      $$SystemSettingsTableTableOrderingComposer,
      $$SystemSettingsTableTableAnnotationComposer,
      $$SystemSettingsTableTableCreateCompanionBuilder,
      $$SystemSettingsTableTableUpdateCompanionBuilder,
      (
        SystemSettingsTableData,
        BaseReferences<
          _$AppDatabase,
          $SystemSettingsTableTable,
          SystemSettingsTableData
        >,
      ),
      SystemSettingsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db, _db.usersTable);
  $$ActivitiesTableTableTableManager get activitiesTable =>
      $$ActivitiesTableTableTableManager(_db, _db.activitiesTable);
  $$ActivityPhorgeTableTableTableManager get activityPhorgeTable =>
      $$ActivityPhorgeTableTableTableManager(_db, _db.activityPhorgeTable);
  $$ActivityGithubCommitTableTableTableManager get activityGithubCommitTable =>
      $$ActivityGithubCommitTableTableTableManager(
        _db,
        _db.activityGithubCommitTable,
      );
  $$ActivityGitlabCommitTableTableTableManager get activityGitlabCommitTable =>
      $$ActivityGitlabCommitTableTableTableManager(
        _db,
        _db.activityGitlabCommitTable,
      );
  $$ActivityBitbucketCommitTableTableTableManager
  get activityBitbucketCommitTable =>
      $$ActivityBitbucketCommitTableTableTableManager(
        _db,
        _db.activityBitbucketCommitTable,
      );
  $$ActivityJiraIssueTableTableTableManager get activityJiraIssueTable =>
      $$ActivityJiraIssueTableTableTableManager(
        _db,
        _db.activityJiraIssueTable,
      );
  $$ActivityLinearIssueTableTableTableManager get activityLinearIssueTable =>
      $$ActivityLinearIssueTableTableTableManager(
        _db,
        _db.activityLinearIssueTable,
      );
  $$ActivitySlackMessageTableTableTableManager get activitySlackMessageTable =>
      $$ActivitySlackMessageTableTableTableManager(
        _db,
        _db.activitySlackMessageTable,
      );
  $$ActivityDiscordMessageTableTableTableManager
  get activityDiscordMessageTable =>
      $$ActivityDiscordMessageTableTableTableManager(
        _db,
        _db.activityDiscordMessageTable,
      );
  $$SessionsTableTableTableManager get sessionsTable =>
      $$SessionsTableTableTableManager(_db, _db.sessionsTable);
  $$GroupsTableTableTableManager get groupsTable =>
      $$GroupsTableTableTableManager(_db, _db.groupsTable);
  $$GroupMembersTableTableTableManager get groupMembersTable =>
      $$GroupMembersTableTableTableManager(_db, _db.groupMembersTable);
  $$ProviderConfigsTableTableTableManager get providerConfigsTable =>
      $$ProviderConfigsTableTableTableManager(_db, _db.providerConfigsTable);
  $$UserIdentitiesTableTableTableManager get userIdentitiesTable =>
      $$UserIdentitiesTableTableTableManager(_db, _db.userIdentitiesTable);
  $$UserProviderCredentialsTableTableTableManager
  get userProviderCredentialsTable =>
      $$UserProviderCredentialsTableTableTableManager(
        _db,
        _db.userProviderCredentialsTable,
      );
  $$ActivityFollowsTableTableTableManager get activityFollowsTable =>
      $$ActivityFollowsTableTableTableManager(_db, _db.activityFollowsTable);
  $$SystemSettingsTableTableTableManager get systemSettingsTable =>
      $$SystemSettingsTableTableTableManager(_db, _db.systemSettingsTable);
}

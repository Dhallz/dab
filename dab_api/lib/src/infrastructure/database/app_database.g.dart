// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTableTable extends UsersTable
    with TableInfo<$UsersTableTable, User> {
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
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
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
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $UsersTableTable createAlias(String alias) {
    return $UsersTableTable(attachedDatabase, alias);
  }
}

class UsersTableCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> passwordHash;
  final Value<String> role;
  final Value<String?> phorgePhid;
  final Value<String?> phorgeUsername;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
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
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       email = Value(email),
       passwordHash = Value(passwordHash),
       createdAt = Value(createdAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? passwordHash,
    Expression<String>? role,
    Expression<String>? phorgePhid,
    Expression<String>? phorgeUsername,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
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
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
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
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
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
        DriftSqlType.dateTime,
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
  final String providerName;
  final String title;
  final String content;
  final String? url;
  final String authorName;
  final String? authorAvatarUrl;
  final int commentCount;
  final DateTime createdAt;
  const ActivitiesTableData({
    required this.id,
    required this.userId,
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
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ActivitiesTableCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesTableCompanion(
      id: Value(id),
      userId: Value(userId),
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
      providerName: serializer.fromJson<String>(json['providerName']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      url: serializer.fromJson<String?>(json['url']),
      authorName: serializer.fromJson<String>(json['authorName']),
      authorAvatarUrl: serializer.fromJson<String?>(json['authorAvatarUrl']),
      commentCount: serializer.fromJson<int>(json['commentCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'providerName': serializer.toJson<String>(providerName),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'url': serializer.toJson<String?>(url),
      'authorName': serializer.toJson<String>(authorName),
      'authorAvatarUrl': serializer.toJson<String?>(authorAvatarUrl),
      'commentCount': serializer.toJson<int>(commentCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ActivitiesTableData copyWith({
    String? id,
    String? userId,
    String? providerName,
    String? title,
    String? content,
    Value<String?> url = const Value.absent(),
    String? authorName,
    Value<String?> authorAvatarUrl = const Value.absent(),
    int? commentCount,
    DateTime? createdAt,
  }) => ActivitiesTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
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
  final Value<String> providerName;
  final Value<String> title;
  final Value<String> content;
  final Value<String?> url;
  final Value<String> authorName;
  final Value<String?> authorAvatarUrl;
  final Value<int> commentCount;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ActivitiesTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
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
    required String providerName,
    required String title,
    required String content,
    this.url = const Value.absent(),
    required String authorName,
    this.authorAvatarUrl = const Value.absent(),
    this.commentCount = const Value.absent(),
    required DateTime createdAt,
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
    Expression<String>? providerName,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? url,
    Expression<String>? authorName,
    Expression<String>? authorAvatarUrl,
    Expression<int>? commentCount,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
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
    Value<String>? providerName,
    Value<String>? title,
    Value<String>? content,
    Value<String?>? url,
    Value<String>? authorName,
    Value<String?>? authorAvatarUrl,
    Value<int>? commentCount,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ActivitiesTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
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
      map['created_at'] = Variable<DateTime>(createdAt.value);
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

class $SessionsTableTable extends SessionsTable
    with TableInfo<$SessionsTableTable, Session> {
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
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
    Insertable<Session> instance, {
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
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
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
        DriftSqlType.dateTime,
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

class SessionsTableCompanion extends UpdateCompanion<Session> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> refreshToken;
  final Value<DateTime> expiresAt;
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
    required DateTime expiresAt,
    this.deviceInfo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       refreshToken = Value(refreshToken),
       expiresAt = Value(expiresAt);
  static Insertable<Session> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? refreshToken,
    Expression<DateTime>? expiresAt,
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
    Value<DateTime>? expiresAt,
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
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTableTable usersTable = $UsersTableTable(this);
  late final $ActivitiesTableTable activitiesTable = $ActivitiesTableTable(
    this,
  );
  late final $ActivityPhorgeTableTable activityPhorgeTable =
      $ActivityPhorgeTableTable(this);
  late final $SessionsTableTable sessionsTable = $SessionsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    usersTable,
    activitiesTable,
    activityPhorgeTable,
    sessionsTable,
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
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
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
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
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

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTableTable,
          User,
          $$UsersTableTableFilterComposer,
          $$UsersTableTableOrderingComposer,
          $$UsersTableTableAnnotationComposer,
          $$UsersTableTableCreateCompanionBuilder,
          $$UsersTableTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTableTable, User>),
          User,
          PrefetchHooks Function()
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
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
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
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
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
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTableTable,
      User,
      $$UsersTableTableFilterComposer,
      $$UsersTableTableOrderingComposer,
      $$UsersTableTableAnnotationComposer,
      $$UsersTableTableCreateCompanionBuilder,
      $$UsersTableTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTableTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$ActivitiesTableTableCreateCompanionBuilder =
    ActivitiesTableCompanion Function({
      required String id,
      required String userId,
      required String providerName,
      required String title,
      required String content,
      Value<String?> url,
      required String authorName,
      Value<String?> authorAvatarUrl,
      Value<int> commentCount,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ActivitiesTableTableUpdateCompanionBuilder =
    ActivitiesTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> providerName,
      Value<String> title,
      Value<String> content,
      Value<String?> url,
      Value<String> authorName,
      Value<String?> authorAvatarUrl,
      Value<int> commentCount,
      Value<DateTime> createdAt,
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
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

  GeneratedColumn<DateTime> get createdAt =>
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
          PrefetchHooks Function({bool activityPhorgeTableRefs})
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
                Value<String> providerName = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String> authorName = const Value.absent(),
                Value<String?> authorAvatarUrl = const Value.absent(),
                Value<int> commentCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesTableCompanion(
                id: id,
                userId: userId,
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
                required String providerName,
                required String title,
                required String content,
                Value<String?> url = const Value.absent(),
                required String authorName,
                Value<String?> authorAvatarUrl = const Value.absent(),
                Value<int> commentCount = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesTableCompanion.insert(
                id: id,
                userId: userId,
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
          prefetchHooksCallback: ({activityPhorgeTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (activityPhorgeTableRefs) db.activityPhorgeTable,
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
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.activityId == item.id),
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
      PrefetchHooks Function({bool activityPhorgeTableRefs})
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
typedef $$SessionsTableTableCreateCompanionBuilder =
    SessionsTableCompanion Function({
      required String id,
      required String userId,
      required String refreshToken,
      required DateTime expiresAt,
      Value<String?> deviceInfo,
      Value<int> rowid,
    });
typedef $$SessionsTableTableUpdateCompanionBuilder =
    SessionsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> refreshToken,
      Value<DateTime> expiresAt,
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

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
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

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
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

  GeneratedColumn<DateTime> get expiresAt =>
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
          Session,
          $$SessionsTableTableFilterComposer,
          $$SessionsTableTableOrderingComposer,
          $$SessionsTableTableAnnotationComposer,
          $$SessionsTableTableCreateCompanionBuilder,
          $$SessionsTableTableUpdateCompanionBuilder,
          (
            Session,
            BaseReferences<_$AppDatabase, $SessionsTableTable, Session>,
          ),
          Session,
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
                Value<DateTime> expiresAt = const Value.absent(),
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
                required DateTime expiresAt,
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
      Session,
      $$SessionsTableTableFilterComposer,
      $$SessionsTableTableOrderingComposer,
      $$SessionsTableTableAnnotationComposer,
      $$SessionsTableTableCreateCompanionBuilder,
      $$SessionsTableTableUpdateCompanionBuilder,
      (Session, BaseReferences<_$AppDatabase, $SessionsTableTable, Session>),
      Session,
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
  $$SessionsTableTableTableManager get sessionsTable =>
      $$SessionsTableTableTableManager(_db, _db.sessionsTable);
}

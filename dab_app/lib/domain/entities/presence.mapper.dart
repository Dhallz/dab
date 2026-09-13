// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'presence.dart';

class PresenceMapper extends ClassMapperBase<Presence> {
  PresenceMapper._();

  static PresenceMapper? _instance;
  static PresenceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PresenceMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Presence';

  static String _$userId(Presence v) => v.userId;
  static const Field<Presence, String> _f$userId = Field('userId', _$userId);
  static bool _$isOnline(Presence v) => v.isOnline;
  static const Field<Presence, bool> _f$isOnline = Field(
    'isOnline',
    _$isOnline,
  );
  static DateTime _$lastSeen(Presence v) => v.lastSeen;
  static const Field<Presence, DateTime> _f$lastSeen = Field(
    'lastSeen',
    _$lastSeen,
  );

  @override
  final MappableFields<Presence> fields = const {
    #userId: _f$userId,
    #isOnline: _f$isOnline,
    #lastSeen: _f$lastSeen,
  };

  static Presence _instantiate(DecodingData data) {
    return Presence(
      userId: data.dec(_f$userId),
      isOnline: data.dec(_f$isOnline),
      lastSeen: data.dec(_f$lastSeen),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Presence fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Presence>(map);
  }

  static Presence fromJson(String json) {
    return ensureInitialized().decodeJson<Presence>(json);
  }
}

mixin PresenceMappable {
  String toJson() {
    return PresenceMapper.ensureInitialized().encodeJson<Presence>(
      this as Presence,
    );
  }

  Map<String, dynamic> toMap() {
    return PresenceMapper.ensureInitialized().encodeMap<Presence>(
      this as Presence,
    );
  }

  PresenceCopyWith<Presence, Presence, Presence> get copyWith =>
      _PresenceCopyWithImpl<Presence, Presence>(
        this as Presence,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PresenceMapper.ensureInitialized().stringifyValue(this as Presence);
  }

  @override
  bool operator ==(Object other) {
    return PresenceMapper.ensureInitialized().equalsValue(
      this as Presence,
      other,
    );
  }

  @override
  int get hashCode {
    return PresenceMapper.ensureInitialized().hashValue(this as Presence);
  }
}

extension PresenceValueCopy<$R, $Out> on ObjectCopyWith<$R, Presence, $Out> {
  PresenceCopyWith<$R, Presence, $Out> get $asPresence =>
      $base.as((v, t, t2) => _PresenceCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PresenceCopyWith<$R, $In extends Presence, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? userId, bool? isOnline, DateTime? lastSeen});
  PresenceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PresenceCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Presence, $Out>
    implements PresenceCopyWith<$R, Presence, $Out> {
  _PresenceCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Presence> $mapper =
      PresenceMapper.ensureInitialized();
  @override
  $R call({String? userId, bool? isOnline, DateTime? lastSeen}) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (isOnline != null) #isOnline: isOnline,
      if (lastSeen != null) #lastSeen: lastSeen,
    }),
  );
  @override
  Presence $make(CopyWithData data) => Presence(
    userId: data.get(#userId, or: $value.userId),
    isOnline: data.get(#isOnline, or: $value.isOnline),
    lastSeen: data.get(#lastSeen, or: $value.lastSeen),
  );

  @override
  PresenceCopyWith<$R2, Presence, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PresenceCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


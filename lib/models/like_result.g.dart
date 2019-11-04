// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LikeResult> _$likeResultSerializer = new _$LikeResultSerializer();

class _$LikeResultSerializer implements StructuredSerializer<LikeResult> {
  @override
  final Iterable<Type> types = const [LikeResult, _$LikeResult];
  @override
  final String wireName = 'LikeResult';

  @override
  Iterable<Object> serialize(Serializers serializers, LikeResult object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'project',
      serializers.serialize(object.project,
          specifiedType: const FullType(Project)),
      'app_user',
      serializers.serialize(object.appUser,
          specifiedType: const FullType(User)),
      'keyValues',
      serializers.serialize(object.keyValues,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(JsonObject)])),
    ];

    return result;
  }

  @override
  LikeResult deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LikeResultBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'project':
          result.project.replace(serializers.deserialize(value,
              specifiedType: const FullType(Project)) as Project);
          break;
        case 'app_user':
          result.appUser.replace(serializers.deserialize(value,
              specifiedType: const FullType(User)) as User);
          break;
        case 'keyValues':
          result.keyValues.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(JsonObject)
              ])) as BuiltMap<dynamic, dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$LikeResult extends LikeResult {
  @override
  final int id;
  @override
  final Project project;
  @override
  final User appUser;
  @override
  final BuiltMap<String, JsonObject> keyValues;

  factory _$LikeResult([void Function(LikeResultBuilder) updates]) =>
      (new LikeResultBuilder()..update(updates)).build();

  _$LikeResult._({this.id, this.project, this.appUser, this.keyValues})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('LikeResult', 'id');
    }
    if (project == null) {
      throw new BuiltValueNullFieldError('LikeResult', 'project');
    }
    if (appUser == null) {
      throw new BuiltValueNullFieldError('LikeResult', 'appUser');
    }
    if (keyValues == null) {
      throw new BuiltValueNullFieldError('LikeResult', 'keyValues');
    }
  }

  @override
  LikeResult rebuild(void Function(LikeResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LikeResultBuilder toBuilder() => new LikeResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LikeResult &&
        id == other.id &&
        project == other.project &&
        appUser == other.appUser &&
        keyValues == other.keyValues;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, id.hashCode), project.hashCode), appUser.hashCode),
        keyValues.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LikeResult')
          ..add('id', id)
          ..add('project', project)
          ..add('appUser', appUser)
          ..add('keyValues', keyValues))
        .toString();
  }
}

class LikeResultBuilder implements Builder<LikeResult, LikeResultBuilder> {
  _$LikeResult _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  ProjectBuilder _project;
  ProjectBuilder get project => _$this._project ??= new ProjectBuilder();
  set project(ProjectBuilder project) => _$this._project = project;

  UserBuilder _appUser;
  UserBuilder get appUser => _$this._appUser ??= new UserBuilder();
  set appUser(UserBuilder appUser) => _$this._appUser = appUser;

  MapBuilder<String, JsonObject> _keyValues;
  MapBuilder<String, JsonObject> get keyValues =>
      _$this._keyValues ??= new MapBuilder<String, JsonObject>();
  set keyValues(MapBuilder<String, JsonObject> keyValues) =>
      _$this._keyValues = keyValues;

  LikeResultBuilder();

  LikeResultBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _project = _$v.project?.toBuilder();
      _appUser = _$v.appUser?.toBuilder();
      _keyValues = _$v.keyValues?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LikeResult other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$LikeResult;
  }

  @override
  void update(void Function(LikeResultBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$LikeResult build() {
    _$LikeResult _$result;
    try {
      _$result = _$v ??
          new _$LikeResult._(
              id: id,
              project: project.build(),
              appUser: appUser.build(),
              keyValues: keyValues.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'project';
        project.build();
        _$failedField = 'appUser';
        appUser.build();
        _$failedField = 'keyValues';
        keyValues.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'LikeResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

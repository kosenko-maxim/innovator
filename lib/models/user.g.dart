// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<User> _$userSerializer = new _$UserSerializer();

class _$UserSerializer implements StructuredSerializer<User> {
  @override
  final Iterable<Type> types = const [User, _$User];
  @override
  final String wireName = 'User';

  @override
  Iterable<Object> serialize(Serializers serializers, User object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'first_name',
      serializers.serialize(object.firstname,
          specifiedType: const FullType(String)),
      'last_name',
      serializers.serialize(object.lastname,
          specifiedType: const FullType(String)),
      'country',
      serializers.serialize(object.country,
          specifiedType: const FullType(String)),
      'city',
      serializers.serialize(object.city, specifiedType: const FullType(String)),
      'skills',
      serializers.serialize(object.skills,
          specifiedType: const FullType(String)),
      'likes',
      serializers.serialize(object.likes, specifiedType: const FullType(int)),
      'jobs',
      serializers.serialize(object.jobs, specifiedType: const FullType(String)),
      'education',
      serializers.serialize(object.education,
          specifiedType: const FullType(String)),
      'is_expert',
      serializers.serialize(object.isExpert,
          specifiedType: const FullType(bool)),
      'keyValues',
      serializers.serialize(object.keyValues,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(JsonObject)])),
    ];
    if (object.profilePic != null) {
      result
        ..add('profile_pic')
        ..add(serializers.serialize(object.profilePic,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  User deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserBuilder();

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
        case 'first_name':
          result.firstname = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'last_name':
          result.lastname = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'country':
          result.country = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'city':
          result.city = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'skills':
          result.skills = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'likes':
          result.likes = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'jobs':
          result.jobs = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'education':
          result.education = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'profile_pic':
          result.profilePic = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'is_expert':
          result.isExpert = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
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

class _$User extends User {
  @override
  final int id;
  @override
  final String firstname;
  @override
  final String lastname;
  @override
  final String country;
  @override
  final String city;
  @override
  final String skills;
  @override
  final int likes;
  @override
  final String jobs;
  @override
  final String education;
  @override
  final String profilePic;
  @override
  final bool isExpert;
  @override
  final BuiltMap<String, JsonObject> keyValues;

  factory _$User([void Function(UserBuilder) updates]) =>
      (new UserBuilder()..update(updates)).build();

  _$User._(
      {this.id,
      this.firstname,
      this.lastname,
      this.country,
      this.city,
      this.skills,
      this.likes,
      this.jobs,
      this.education,
      this.profilePic,
      this.isExpert,
      this.keyValues})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('User', 'id');
    }
    if (firstname == null) {
      throw new BuiltValueNullFieldError('User', 'firstname');
    }
    if (lastname == null) {
      throw new BuiltValueNullFieldError('User', 'lastname');
    }
    if (country == null) {
      throw new BuiltValueNullFieldError('User', 'country');
    }
    if (city == null) {
      throw new BuiltValueNullFieldError('User', 'city');
    }
    if (skills == null) {
      throw new BuiltValueNullFieldError('User', 'skills');
    }
    if (likes == null) {
      throw new BuiltValueNullFieldError('User', 'likes');
    }
    if (jobs == null) {
      throw new BuiltValueNullFieldError('User', 'jobs');
    }
    if (education == null) {
      throw new BuiltValueNullFieldError('User', 'education');
    }
    if (isExpert == null) {
      throw new BuiltValueNullFieldError('User', 'isExpert');
    }
    if (keyValues == null) {
      throw new BuiltValueNullFieldError('User', 'keyValues');
    }
  }

  @override
  User rebuild(void Function(UserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => new UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        id == other.id &&
        firstname == other.firstname &&
        lastname == other.lastname &&
        country == other.country &&
        city == other.city &&
        skills == other.skills &&
        likes == other.likes &&
        jobs == other.jobs &&
        education == other.education &&
        profilePic == other.profilePic &&
        isExpert == other.isExpert &&
        keyValues == other.keyValues;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc($jc(0, id.hashCode),
                                                firstname.hashCode),
                                            lastname.hashCode),
                                        country.hashCode),
                                    city.hashCode),
                                skills.hashCode),
                            likes.hashCode),
                        jobs.hashCode),
                    education.hashCode),
                profilePic.hashCode),
            isExpert.hashCode),
        keyValues.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('User')
          ..add('id', id)
          ..add('firstname', firstname)
          ..add('lastname', lastname)
          ..add('country', country)
          ..add('city', city)
          ..add('skills', skills)
          ..add('likes', likes)
          ..add('jobs', jobs)
          ..add('education', education)
          ..add('profilePic', profilePic)
          ..add('isExpert', isExpert)
          ..add('keyValues', keyValues))
        .toString();
  }
}

class UserBuilder implements Builder<User, UserBuilder> {
  _$User _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _firstname;
  String get firstname => _$this._firstname;
  set firstname(String firstname) => _$this._firstname = firstname;

  String _lastname;
  String get lastname => _$this._lastname;
  set lastname(String lastname) => _$this._lastname = lastname;

  String _country;
  String get country => _$this._country;
  set country(String country) => _$this._country = country;

  String _city;
  String get city => _$this._city;
  set city(String city) => _$this._city = city;

  String _skills;
  String get skills => _$this._skills;
  set skills(String skills) => _$this._skills = skills;

  int _likes;
  int get likes => _$this._likes;
  set likes(int likes) => _$this._likes = likes;

  String _jobs;
  String get jobs => _$this._jobs;
  set jobs(String jobs) => _$this._jobs = jobs;

  String _education;
  String get education => _$this._education;
  set education(String education) => _$this._education = education;

  String _profilePic;
  String get profilePic => _$this._profilePic;
  set profilePic(String profilePic) => _$this._profilePic = profilePic;

  bool _isExpert;
  bool get isExpert => _$this._isExpert;
  set isExpert(bool isExpert) => _$this._isExpert = isExpert;

  MapBuilder<String, JsonObject> _keyValues;
  MapBuilder<String, JsonObject> get keyValues =>
      _$this._keyValues ??= new MapBuilder<String, JsonObject>();
  set keyValues(MapBuilder<String, JsonObject> keyValues) =>
      _$this._keyValues = keyValues;

  UserBuilder();

  UserBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _firstname = _$v.firstname;
      _lastname = _$v.lastname;
      _country = _$v.country;
      _city = _$v.city;
      _skills = _$v.skills;
      _likes = _$v.likes;
      _jobs = _$v.jobs;
      _education = _$v.education;
      _profilePic = _$v.profilePic;
      _isExpert = _$v.isExpert;
      _keyValues = _$v.keyValues?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(User other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$User;
  }

  @override
  void update(void Function(UserBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$User build() {
    _$User _$result;
    try {
      _$result = _$v ??
          new _$User._(
              id: id,
              firstname: firstname,
              lastname: lastname,
              country: country,
              city: city,
              skills: skills,
              likes: likes,
              jobs: jobs,
              education: education,
              profilePic: profilePic,
              isExpert: isExpert,
              keyValues: keyValues.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'keyValues';
        keyValues.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'User', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

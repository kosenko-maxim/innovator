import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'user.g.dart';

/// модель пользователя
abstract class User implements Built<User, UserBuilder> {
  User._();

  factory User([updates(UserBuilder b)]) = _$User;

  @BuiltValueField(wireName: 'id')
  int get id;
  @BuiltValueField(wireName: 'first_name')
  String get firstname;
  @BuiltValueField(wireName: 'last_name')
  String get lastname;
  @BuiltValueField(wireName: 'country')
  String get country;
  @BuiltValueField(wireName: 'city')
  String get city;
  @BuiltValueField(wireName: 'skills')
  String get skills;
  @BuiltValueField(wireName: 'likes')
  int get likes;
  @BuiltValueField(wireName: 'jobs')
  String get jobs;
  @BuiltValueField(wireName: 'education')
  String get education;
  @nullable
  @BuiltValueField(wireName: 'profile_pic')
  String get profilePic;
  @BuiltValueField(wireName: 'is_expert')
  bool get isExpert;

  BuiltMap<String, JsonObject> get keyValues;

  String toJson() {
    return json.encode(serializers.serializeWith(User.serializer, this));
  }

  static User fromJson(String jsonString) {
    return serializers.deserializeWith(
        User.serializer, json.decode(jsonString));
  }

  static Serializer<User> get serializer => _$userSerializer;
}

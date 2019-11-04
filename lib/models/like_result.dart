import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';

import 'project.dart';
import 'serializers.dart';
import 'user.dart';

part 'like_result.g.dart';

abstract class LikeResult implements Built<LikeResult, LikeResultBuilder> {
  LikeResult._();

  factory LikeResult([updates(LikeResultBuilder b)]) = _$LikeResult;

  @BuiltValueField(wireName: 'id')
  int get id;
  @BuiltValueField(wireName: 'project')
  Project get project;
  @BuiltValueField(wireName: 'app_user')
  User get appUser;
  String toJson() {
    return json.encode(serializers.serializeWith(LikeResult.serializer, this));
  }

  BuiltMap<String, JsonObject> get keyValues;

  static LikeResult fromJson(String jsonString) {
    return serializers.deserializeWith(
        LikeResult.serializer, json.decode(jsonString));
  }

  static Serializer<LikeResult> get serializer => _$likeResultSerializer;
}

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';

import 'roadmap.dart';
import 'serializers.dart';
import 'user.dart';

part 'project.g.dart';

/// модель проекта
abstract class Project implements Built<Project, ProjectBuilder> {
  Project._();

  factory Project([updates(ProjectBuilder b)]) = _$Project;

  @BuiltValueField(wireName: 'additional_info')
  String get additionalInfo;
  @BuiltValueField(wireName: 'description')
  String get description;
  @BuiltValueField(wireName: 'id')
  @nullable
  int get id;
  @BuiltValueField(wireName: 'investors')
  @nullable
  String get investors;
  @BuiltValueField(wireName: 'is_published')
  bool get isPublished;
  @BuiltValueField(wireName: 'likes')
  @nullable
  int get likes;
  @BuiltValueField(wireName: 'roadmap')
  @nullable
  Roadmap get roadmap;
  @BuiltValueField(wireName: 'target_audience')
  String get targetAudience;
  @BuiltValueField(wireName: 'title')
  String get title;
  @nullable
  @BuiltValueField(wireName: 'creator_id')
  int get creatorId;
  @nullable
  @BuiltValueField(wireName: 'project_pic')
  String get projectPic;
  @BuiltValueField(wireName: 'tags')
  String get tags;
  @BuiltValueField(wireName: 'project_team')
  String get projectTeam;

  BuiltMap<String, JsonObject> get keyValues;

  String toJson() {
    return json.encode(serializers.serializeWith(Project.serializer, this));
  }

  static Project fromJson(String jsonString) {
    return serializers.deserializeWith(
        Project.serializer, json.decode(jsonString));
  }

  static Serializer<Project> get serializer => _$projectSerializer;
}

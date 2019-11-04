import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';

import 'roadmap.dart';
import 'serializers.dart';

part 'chapter.g.dart';

/// модель этапа дорожной карты
abstract class Chapter implements Built<Chapter, ChapterBuilder> {
  Chapter._();

  factory Chapter([updates(ChapterBuilder b)]) = _$Chapter;

  @BuiltValueField(wireName: 'date_from')
  String get dateFrom;
  @BuiltValueField(wireName: 'date_to')
  String get dateTo;
  @BuiltValueField(wireName: 'description')
  String get description;
  @BuiltValueField(wireName: 'id')
  int get id;
  @BuiltValueField(wireName: 'is_active')
  bool get isActive;
  @BuiltValueField(wireName: 'roadmap')
  Roadmap get roadmap;
  @BuiltValueField(wireName: 'title')
  String get title;

  BuiltMap<String, JsonObject> get keyValues;

  String toJson() {
    return json.encode(serializers.serializeWith(Chapter.serializer, this));
  }

  static Chapter fromJson(String jsonString) {
    return serializers.deserializeWith(
        Chapter.serializer, json.decode(jsonString));
  }

  static Serializer<Chapter> get serializer => _$chapterSerializer;
}

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'roadmap.g.dart';

/// модель дорожной карты
abstract class Roadmap implements Built<Roadmap, RoadmapBuilder> {
  Roadmap._();

  factory Roadmap([updates(RoadmapBuilder b)]) = _$Roadmap;

  @BuiltValueField(wireName: 'id')
  int get id;
  @BuiltValueField(wireName: 'title')
  String get title;

  String toJson() {
    return json.encode(serializers.serializeWith(Roadmap.serializer, this));
  }

  static Roadmap fromJson(String jsonString) {
    return serializers.deserializeWith(
        Roadmap.serializer, json.decode(jsonString));
  }

  static Serializer<Roadmap> get serializer => _$roadmapSerializer;
}

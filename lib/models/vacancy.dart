import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';

import 'project.dart';
import 'serializers.dart';

part 'vacancy.g.dart';

/// модель вакансии
abstract class Vacancy implements Built<Vacancy, VacancyBuilder> {
  Vacancy._();

  factory Vacancy([updates(VacancyBuilder b)]) = _$Vacancy;

  @BuiltValueField(wireName: 'description')
  String get description;
  @nullable
  @BuiltValueField(wireName: 'id')
  int get id;
  @nullable
  @BuiltValueField(wireName: 'project')
  Project get project;
  @BuiltValueField(wireName: 'skills')
  String get skills;
  @BuiltValueField(wireName: 'title')
  String get title;

  BuiltMap<String, JsonObject> get keyValues;

  String toJson() {
    return json.encode(serializers.serializeWith(Vacancy.serializer, this));
  }

  static Vacancy fromJson(String jsonString) {
    return serializers.deserializeWith(
        Vacancy.serializer, json.decode(jsonString));
  }

  static Serializer<Vacancy> get serializer => _$vacancySerializer;
}

import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'chapter.dart';
import 'like_result.dart';
import 'message.dart';
import 'project.dart';
import 'roadmap.dart';
import 'user.dart';
import 'vacancy.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  Chapter,
  Project,
  Roadmap,
  User,
  Vacancy,
  LikeResult,
  Message,
])
Serializers serializers = _$serializers;
Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

T deserialize<T>(dynamic value) => standardSerializers.deserializeWith<T>(
    standardSerializers.serializerForType(T), value);

BuiltList<T> deserializeListOf<T>(dynamic value) => BuiltList.from(
    value.map((value) => deserialize<T>(value)).toList(growable: false));

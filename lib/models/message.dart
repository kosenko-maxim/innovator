import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';
import 'user.dart';

part 'message.g.dart';

abstract class Message implements Built<Message, MessageBuilder> {
  Message._();

  factory Message([updates(MessageBuilder b)]) = _$Message;

  @BuiltValueField(wireName: 'sender')
  User get sender;
  @BuiltValueField(wireName: 'receiver')
  User get receiver;
  @BuiltValueField(wireName: 'timestamp')
  String get timestamp;
  @BuiltValueField(wireName: 'message')
  String get message;

  String toJson() {
    return json.encode(serializers.serializeWith(Message.serializer, this));
  }

  static Message fromJson(String jsonString) {
    return serializers.deserializeWith(
        Message.serializer, json.decode(jsonString));
  }

  static Serializer<Message> get serializer => _$messageSerializer;
}

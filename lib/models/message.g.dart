// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Message> _$messageSerializer = new _$MessageSerializer();

class _$MessageSerializer implements StructuredSerializer<Message> {
  @override
  final Iterable<Type> types = const [Message, _$Message];
  @override
  final String wireName = 'Message';

  @override
  Iterable<Object> serialize(Serializers serializers, Message object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'sender',
      serializers.serialize(object.sender, specifiedType: const FullType(User)),
      'receiver',
      serializers.serialize(object.receiver,
          specifiedType: const FullType(User)),
      'timestamp',
      serializers.serialize(object.timestamp,
          specifiedType: const FullType(String)),
      'message',
      serializers.serialize(object.message,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Message deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MessageBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'sender':
          result.sender.replace(serializers.deserialize(value,
              specifiedType: const FullType(User)) as User);
          break;
        case 'receiver':
          result.receiver.replace(serializers.deserialize(value,
              specifiedType: const FullType(User)) as User);
          break;
        case 'timestamp':
          result.timestamp = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Message extends Message {
  @override
  final User sender;
  @override
  final User receiver;
  @override
  final String timestamp;
  @override
  final String message;

  factory _$Message([void Function(MessageBuilder) updates]) =>
      (new MessageBuilder()..update(updates)).build();

  _$Message._({this.sender, this.receiver, this.timestamp, this.message})
      : super._() {
    if (sender == null) {
      throw new BuiltValueNullFieldError('Message', 'sender');
    }
    if (receiver == null) {
      throw new BuiltValueNullFieldError('Message', 'receiver');
    }
    if (timestamp == null) {
      throw new BuiltValueNullFieldError('Message', 'timestamp');
    }
    if (message == null) {
      throw new BuiltValueNullFieldError('Message', 'message');
    }
  }

  @override
  Message rebuild(void Function(MessageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MessageBuilder toBuilder() => new MessageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Message &&
        sender == other.sender &&
        receiver == other.receiver &&
        timestamp == other.timestamp &&
        message == other.message;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, sender.hashCode), receiver.hashCode),
            timestamp.hashCode),
        message.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Message')
          ..add('sender', sender)
          ..add('receiver', receiver)
          ..add('timestamp', timestamp)
          ..add('message', message))
        .toString();
  }
}

class MessageBuilder implements Builder<Message, MessageBuilder> {
  _$Message _$v;

  UserBuilder _sender;
  UserBuilder get sender => _$this._sender ??= new UserBuilder();
  set sender(UserBuilder sender) => _$this._sender = sender;

  UserBuilder _receiver;
  UserBuilder get receiver => _$this._receiver ??= new UserBuilder();
  set receiver(UserBuilder receiver) => _$this._receiver = receiver;

  String _timestamp;
  String get timestamp => _$this._timestamp;
  set timestamp(String timestamp) => _$this._timestamp = timestamp;

  String _message;
  String get message => _$this._message;
  set message(String message) => _$this._message = message;

  MessageBuilder();

  MessageBuilder get _$this {
    if (_$v != null) {
      _sender = _$v.sender?.toBuilder();
      _receiver = _$v.receiver?.toBuilder();
      _timestamp = _$v.timestamp;
      _message = _$v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Message other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Message;
  }

  @override
  void update(void Function(MessageBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Message build() {
    _$Message _$result;
    try {
      _$result = _$v ??
          new _$Message._(
              sender: sender.build(),
              receiver: receiver.build(),
              timestamp: timestamp,
              message: message);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'sender';
        sender.build();
        _$failedField = 'receiver';
        receiver.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Message', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

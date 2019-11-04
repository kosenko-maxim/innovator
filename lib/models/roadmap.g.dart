// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Roadmap> _$roadmapSerializer = new _$RoadmapSerializer();

class _$RoadmapSerializer implements StructuredSerializer<Roadmap> {
  @override
  final Iterable<Type> types = const [Roadmap, _$Roadmap];
  @override
  final String wireName = 'Roadmap';

  @override
  Iterable<Object> serialize(Serializers serializers, Roadmap object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Roadmap deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RoadmapBuilder();

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
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Roadmap extends Roadmap {
  @override
  final int id;
  @override
  final String title;

  factory _$Roadmap([void Function(RoadmapBuilder) updates]) =>
      (new RoadmapBuilder()..update(updates)).build();

  _$Roadmap._({this.id, this.title}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Roadmap', 'id');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('Roadmap', 'title');
    }
  }

  @override
  Roadmap rebuild(void Function(RoadmapBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoadmapBuilder toBuilder() => new RoadmapBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Roadmap && id == other.id && title == other.title;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, id.hashCode), title.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Roadmap')
          ..add('id', id)
          ..add('title', title))
        .toString();
  }
}

class RoadmapBuilder implements Builder<Roadmap, RoadmapBuilder> {
  _$Roadmap _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  RoadmapBuilder();

  RoadmapBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _title = _$v.title;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Roadmap other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Roadmap;
  }

  @override
  void update(void Function(RoadmapBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Roadmap build() {
    final _$result = _$v ?? new _$Roadmap._(id: id, title: title);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

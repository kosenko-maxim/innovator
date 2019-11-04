// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Chapter> _$chapterSerializer = new _$ChapterSerializer();

class _$ChapterSerializer implements StructuredSerializer<Chapter> {
  @override
  final Iterable<Type> types = const [Chapter, _$Chapter];
  @override
  final String wireName = 'Chapter';

  @override
  Iterable<Object> serialize(Serializers serializers, Chapter object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'date_from',
      serializers.serialize(object.dateFrom,
          specifiedType: const FullType(String)),
      'date_to',
      serializers.serialize(object.dateTo,
          specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'is_active',
      serializers.serialize(object.isActive,
          specifiedType: const FullType(bool)),
      'roadmap',
      serializers.serialize(object.roadmap,
          specifiedType: const FullType(Roadmap)),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'keyValues',
      serializers.serialize(object.keyValues,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(JsonObject)])),
    ];

    return result;
  }

  @override
  Chapter deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChapterBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'date_from':
          result.dateFrom = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'date_to':
          result.dateTo = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'is_active':
          result.isActive = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'roadmap':
          result.roadmap.replace(serializers.deserialize(value,
              specifiedType: const FullType(Roadmap)) as Roadmap);
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'keyValues':
          result.keyValues.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(JsonObject)
              ])) as BuiltMap<dynamic, dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$Chapter extends Chapter {
  @override
  final String dateFrom;
  @override
  final String dateTo;
  @override
  final String description;
  @override
  final int id;
  @override
  final bool isActive;
  @override
  final Roadmap roadmap;
  @override
  final String title;
  @override
  final BuiltMap<String, JsonObject> keyValues;

  factory _$Chapter([void Function(ChapterBuilder) updates]) =>
      (new ChapterBuilder()..update(updates)).build();

  _$Chapter._(
      {this.dateFrom,
      this.dateTo,
      this.description,
      this.id,
      this.isActive,
      this.roadmap,
      this.title,
      this.keyValues})
      : super._() {
    if (dateFrom == null) {
      throw new BuiltValueNullFieldError('Chapter', 'dateFrom');
    }
    if (dateTo == null) {
      throw new BuiltValueNullFieldError('Chapter', 'dateTo');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('Chapter', 'description');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('Chapter', 'id');
    }
    if (isActive == null) {
      throw new BuiltValueNullFieldError('Chapter', 'isActive');
    }
    if (roadmap == null) {
      throw new BuiltValueNullFieldError('Chapter', 'roadmap');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('Chapter', 'title');
    }
    if (keyValues == null) {
      throw new BuiltValueNullFieldError('Chapter', 'keyValues');
    }
  }

  @override
  Chapter rebuild(void Function(ChapterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChapterBuilder toBuilder() => new ChapterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Chapter &&
        dateFrom == other.dateFrom &&
        dateTo == other.dateTo &&
        description == other.description &&
        id == other.id &&
        isActive == other.isActive &&
        roadmap == other.roadmap &&
        title == other.title &&
        keyValues == other.keyValues;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, dateFrom.hashCode), dateTo.hashCode),
                            description.hashCode),
                        id.hashCode),
                    isActive.hashCode),
                roadmap.hashCode),
            title.hashCode),
        keyValues.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Chapter')
          ..add('dateFrom', dateFrom)
          ..add('dateTo', dateTo)
          ..add('description', description)
          ..add('id', id)
          ..add('isActive', isActive)
          ..add('roadmap', roadmap)
          ..add('title', title)
          ..add('keyValues', keyValues))
        .toString();
  }
}

class ChapterBuilder implements Builder<Chapter, ChapterBuilder> {
  _$Chapter _$v;

  String _dateFrom;
  String get dateFrom => _$this._dateFrom;
  set dateFrom(String dateFrom) => _$this._dateFrom = dateFrom;

  String _dateTo;
  String get dateTo => _$this._dateTo;
  set dateTo(String dateTo) => _$this._dateTo = dateTo;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  bool _isActive;
  bool get isActive => _$this._isActive;
  set isActive(bool isActive) => _$this._isActive = isActive;

  RoadmapBuilder _roadmap;
  RoadmapBuilder get roadmap => _$this._roadmap ??= new RoadmapBuilder();
  set roadmap(RoadmapBuilder roadmap) => _$this._roadmap = roadmap;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  MapBuilder<String, JsonObject> _keyValues;
  MapBuilder<String, JsonObject> get keyValues =>
      _$this._keyValues ??= new MapBuilder<String, JsonObject>();
  set keyValues(MapBuilder<String, JsonObject> keyValues) =>
      _$this._keyValues = keyValues;

  ChapterBuilder();

  ChapterBuilder get _$this {
    if (_$v != null) {
      _dateFrom = _$v.dateFrom;
      _dateTo = _$v.dateTo;
      _description = _$v.description;
      _id = _$v.id;
      _isActive = _$v.isActive;
      _roadmap = _$v.roadmap?.toBuilder();
      _title = _$v.title;
      _keyValues = _$v.keyValues?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Chapter other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Chapter;
  }

  @override
  void update(void Function(ChapterBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Chapter build() {
    _$Chapter _$result;
    try {
      _$result = _$v ??
          new _$Chapter._(
              dateFrom: dateFrom,
              dateTo: dateTo,
              description: description,
              id: id,
              isActive: isActive,
              roadmap: roadmap.build(),
              title: title,
              keyValues: keyValues.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'roadmap';
        roadmap.build();

        _$failedField = 'keyValues';
        keyValues.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Chapter', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

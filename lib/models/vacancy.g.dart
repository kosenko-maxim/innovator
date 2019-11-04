// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacancy.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Vacancy> _$vacancySerializer = new _$VacancySerializer();

class _$VacancySerializer implements StructuredSerializer<Vacancy> {
  @override
  final Iterable<Type> types = const [Vacancy, _$Vacancy];
  @override
  final String wireName = 'Vacancy';

  @override
  Iterable<Object> serialize(Serializers serializers, Vacancy object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'skills',
      serializers.serialize(object.skills,
          specifiedType: const FullType(String)),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'keyValues',
      serializers.serialize(object.keyValues,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(JsonObject)])),
    ];
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(int)));
    }
    if (object.project != null) {
      result
        ..add('project')
        ..add(serializers.serialize(object.project,
            specifiedType: const FullType(Project)));
    }
    return result;
  }

  @override
  Vacancy deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new VacancyBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'project':
          result.project.replace(serializers.deserialize(value,
              specifiedType: const FullType(Project)) as Project);
          break;
        case 'skills':
          result.skills = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
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

class _$Vacancy extends Vacancy {
  @override
  final String description;
  @override
  final int id;
  @override
  final Project project;
  @override
  final String skills;
  @override
  final String title;
  @override
  final BuiltMap<String, JsonObject> keyValues;

  factory _$Vacancy([void Function(VacancyBuilder) updates]) =>
      (new VacancyBuilder()..update(updates)).build();

  _$Vacancy._(
      {this.description,
      this.id,
      this.project,
      this.skills,
      this.title,
      this.keyValues})
      : super._() {
    if (description == null) {
      throw new BuiltValueNullFieldError('Vacancy', 'description');
    }
    if (skills == null) {
      throw new BuiltValueNullFieldError('Vacancy', 'skills');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('Vacancy', 'title');
    }
    if (keyValues == null) {
      throw new BuiltValueNullFieldError('Vacancy', 'keyValues');
    }
  }

  @override
  Vacancy rebuild(void Function(VacancyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VacancyBuilder toBuilder() => new VacancyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Vacancy &&
        description == other.description &&
        id == other.id &&
        project == other.project &&
        skills == other.skills &&
        title == other.title &&
        keyValues == other.keyValues;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, description.hashCode), id.hashCode),
                    project.hashCode),
                skills.hashCode),
            title.hashCode),
        keyValues.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Vacancy')
          ..add('description', description)
          ..add('id', id)
          ..add('project', project)
          ..add('skills', skills)
          ..add('title', title)
          ..add('keyValues', keyValues))
        .toString();
  }
}

class VacancyBuilder implements Builder<Vacancy, VacancyBuilder> {
  _$Vacancy _$v;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  ProjectBuilder _project;
  ProjectBuilder get project => _$this._project ??= new ProjectBuilder();
  set project(ProjectBuilder project) => _$this._project = project;

  String _skills;
  String get skills => _$this._skills;
  set skills(String skills) => _$this._skills = skills;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  MapBuilder<String, JsonObject> _keyValues;
  MapBuilder<String, JsonObject> get keyValues =>
      _$this._keyValues ??= new MapBuilder<String, JsonObject>();
  set keyValues(MapBuilder<String, JsonObject> keyValues) =>
      _$this._keyValues = keyValues;

  VacancyBuilder();

  VacancyBuilder get _$this {
    if (_$v != null) {
      _description = _$v.description;
      _id = _$v.id;
      _project = _$v.project?.toBuilder();
      _skills = _$v.skills;
      _title = _$v.title;
      _keyValues = _$v.keyValues?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Vacancy other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Vacancy;
  }

  @override
  void update(void Function(VacancyBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Vacancy build() {
    _$Vacancy _$result;
    try {
      _$result = _$v ??
          new _$Vacancy._(
              description: description,
              id: id,
              project: _project?.build(),
              skills: skills,
              title: title,
              keyValues: keyValues.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'project';
        _project?.build();

        _$failedField = 'keyValues';
        keyValues.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Vacancy', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

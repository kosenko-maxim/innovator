// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Project> _$projectSerializer = new _$ProjectSerializer();

class _$ProjectSerializer implements StructuredSerializer<Project> {
  @override
  final Iterable<Type> types = const [Project, _$Project];
  @override
  final String wireName = 'Project';

  @override
  Iterable<Object> serialize(Serializers serializers, Project object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'additional_info',
      serializers.serialize(object.additionalInfo,
          specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'is_published',
      serializers.serialize(object.isPublished,
          specifiedType: const FullType(bool)),
      'target_audience',
      serializers.serialize(object.targetAudience,
          specifiedType: const FullType(String)),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'tags',
      serializers.serialize(object.tags, specifiedType: const FullType(String)),
      'project_team',
      serializers.serialize(object.projectTeam,
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
    if (object.investors != null) {
      result
        ..add('investors')
        ..add(serializers.serialize(object.investors,
            specifiedType: const FullType(String)));
    }
    if (object.likes != null) {
      result
        ..add('likes')
        ..add(serializers.serialize(object.likes,
            specifiedType: const FullType(int)));
    }
    if (object.roadmap != null) {
      result
        ..add('roadmap')
        ..add(serializers.serialize(object.roadmap,
            specifiedType: const FullType(Roadmap)));
    }
    if (object.creatorId != null) {
      result
        ..add('creator_id')
        ..add(serializers.serialize(object.creatorId,
            specifiedType: const FullType(int)));
    }
    if (object.projectPic != null) {
      result
        ..add('project_pic')
        ..add(serializers.serialize(object.projectPic,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Project deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProjectBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'additional_info':
          result.additionalInfo = serializers.deserialize(value,
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
        case 'investors':
          result.investors = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'is_published':
          result.isPublished = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'likes':
          result.likes = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'roadmap':
          result.roadmap.replace(serializers.deserialize(value,
              specifiedType: const FullType(Roadmap)) as Roadmap);
          break;
        case 'target_audience':
          result.targetAudience = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'creator_id':
          result.creatorId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'project_pic':
          result.projectPic = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'tags':
          result.tags = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'project_team':
          result.projectTeam = serializers.deserialize(value,
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

class _$Project extends Project {
  @override
  final String additionalInfo;
  @override
  final String description;
  @override
  final int id;
  @override
  final String investors;
  @override
  final bool isPublished;
  @override
  final int likes;
  @override
  final Roadmap roadmap;
  @override
  final String targetAudience;
  @override
  final String title;
  @override
  final int creatorId;
  @override
  final String projectPic;
  @override
  final String tags;
  @override
  final String projectTeam;
  @override
  final BuiltMap<String, JsonObject> keyValues;

  factory _$Project([void Function(ProjectBuilder) updates]) =>
      (new ProjectBuilder()..update(updates)).build();

  _$Project._(
      {this.additionalInfo,
      this.description,
      this.id,
      this.investors,
      this.isPublished,
      this.likes,
      this.roadmap,
      this.targetAudience,
      this.title,
      this.creatorId,
      this.projectPic,
      this.tags,
      this.projectTeam,
      this.keyValues})
      : super._() {
    if (additionalInfo == null) {
      throw new BuiltValueNullFieldError('Project', 'additionalInfo');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('Project', 'description');
    }
    if (isPublished == null) {
      throw new BuiltValueNullFieldError('Project', 'isPublished');
    }
    if (targetAudience == null) {
      throw new BuiltValueNullFieldError('Project', 'targetAudience');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('Project', 'title');
    }
    if (tags == null) {
      throw new BuiltValueNullFieldError('Project', 'tags');
    }
    if (projectTeam == null) {
      throw new BuiltValueNullFieldError('Project', 'projectTeam');
    }
    if (keyValues == null) {
      throw new BuiltValueNullFieldError('Project', 'keyValues');
    }
  }

  @override
  Project rebuild(void Function(ProjectBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectBuilder toBuilder() => new ProjectBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Project &&
        additionalInfo == other.additionalInfo &&
        description == other.description &&
        id == other.id &&
        investors == other.investors &&
        isPublished == other.isPublished &&
        likes == other.likes &&
        roadmap == other.roadmap &&
        targetAudience == other.targetAudience &&
        title == other.title &&
        creatorId == other.creatorId &&
        projectPic == other.projectPic &&
        tags == other.tags &&
        projectTeam == other.projectTeam &&
        keyValues == other.keyValues;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            0,
                                                            additionalInfo
                                                                .hashCode),
                                                        description.hashCode),
                                                    id.hashCode),
                                                investors.hashCode),
                                            isPublished.hashCode),
                                        likes.hashCode),
                                    roadmap.hashCode),
                                targetAudience.hashCode),
                            title.hashCode),
                        creatorId.hashCode),
                    projectPic.hashCode),
                tags.hashCode),
            projectTeam.hashCode),
        keyValues.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Project')
          ..add('additionalInfo', additionalInfo)
          ..add('description', description)
          ..add('id', id)
          ..add('investors', investors)
          ..add('isPublished', isPublished)
          ..add('likes', likes)
          ..add('roadmap', roadmap)
          ..add('targetAudience', targetAudience)
          ..add('title', title)
          ..add('creatorId', creatorId)
          ..add('projectPic', projectPic)
          ..add('tags', tags)
          ..add('projectTeam', projectTeam)
          ..add('keyValues', keyValues))
        .toString();
  }
}

class ProjectBuilder implements Builder<Project, ProjectBuilder> {
  _$Project _$v;

  String _additionalInfo;
  String get additionalInfo => _$this._additionalInfo;
  set additionalInfo(String additionalInfo) =>
      _$this._additionalInfo = additionalInfo;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _investors;
  String get investors => _$this._investors;
  set investors(String investors) => _$this._investors = investors;

  bool _isPublished;
  bool get isPublished => _$this._isPublished;
  set isPublished(bool isPublished) => _$this._isPublished = isPublished;

  int _likes;
  int get likes => _$this._likes;
  set likes(int likes) => _$this._likes = likes;

  RoadmapBuilder _roadmap;
  RoadmapBuilder get roadmap => _$this._roadmap ??= new RoadmapBuilder();
  set roadmap(RoadmapBuilder roadmap) => _$this._roadmap = roadmap;

  String _targetAudience;
  String get targetAudience => _$this._targetAudience;
  set targetAudience(String targetAudience) =>
      _$this._targetAudience = targetAudience;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  int _creatorId;
  int get creatorId => _$this._creatorId;
  set creatorId(int creatorId) => _$this._creatorId = creatorId;

  String _projectPic;
  String get projectPic => _$this._projectPic;
  set projectPic(String projectPic) => _$this._projectPic = projectPic;

  String _tags;
  String get tags => _$this._tags;
  set tags(String tags) => _$this._tags = tags;

  String _projectTeam;
  String get projectTeam => _$this._projectTeam;
  set projectTeam(String projectTeam) => _$this._projectTeam = projectTeam;

  MapBuilder<String, JsonObject> _keyValues;
  MapBuilder<String, JsonObject> get keyValues =>
      _$this._keyValues ??= new MapBuilder<String, JsonObject>();
  set keyValues(MapBuilder<String, JsonObject> keyValues) =>
      _$this._keyValues = keyValues;

  ProjectBuilder();

  ProjectBuilder get _$this {
    if (_$v != null) {
      _additionalInfo = _$v.additionalInfo;
      _description = _$v.description;
      _id = _$v.id;
      _investors = _$v.investors;
      _isPublished = _$v.isPublished;
      _likes = _$v.likes;
      _roadmap = _$v.roadmap?.toBuilder();
      _targetAudience = _$v.targetAudience;
      _title = _$v.title;
      _creatorId = _$v.creatorId;
      _projectPic = _$v.projectPic;
      _tags = _$v.tags;
      _projectTeam = _$v.projectTeam;
      _keyValues = _$v.keyValues?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Project other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Project;
  }

  @override
  void update(void Function(ProjectBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Project build() {
    _$Project _$result;
    try {
      _$result = _$v ??
          new _$Project._(
              additionalInfo: additionalInfo,
              description: description,
              id: id,
              investors: investors,
              isPublished: isPublished,
              likes: likes,
              roadmap: _roadmap?.build(),
              targetAudience: targetAudience,
              title: title,
              creatorId: creatorId,
              projectPic: projectPic,
              tags: tags,
              projectTeam: projectTeam,
              keyValues: keyValues.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'roadmap';
        _roadmap?.build();

        _$failedField = 'keyValues';
        keyValues.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Project', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

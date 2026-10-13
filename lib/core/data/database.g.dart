// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ModulesTable extends Modules with TableInfo<$ModulesTable, StudyModule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _glyphMeta = const VerificationMeta('glyph');
  @override
  late final GeneratedColumn<String> glyph = GeneratedColumn<String>(
    'glyph',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, glyph, sortOrder, enabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'modules';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyModule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('glyph')) {
      context.handle(
        _glyphMeta,
        glyph.isAcceptableOrUnknown(data['glyph']!, _glyphMeta),
      );
    } else if (isInserting) {
      context.missing(_glyphMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyModule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyModule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      glyph: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}glyph'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $ModulesTable createAlias(String alias) {
    return $ModulesTable(attachedDatabase, alias);
  }
}

class StudyModule extends DataClass implements Insertable<StudyModule> {
  final String id;
  final String name;
  final String glyph;
  final int sortOrder;
  final bool enabled;
  const StudyModule({
    required this.id,
    required this.name,
    required this.glyph,
    required this.sortOrder,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['glyph'] = Variable<String>(glyph);
    map['sort_order'] = Variable<int>(sortOrder);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  ModulesCompanion toCompanion(bool nullToAbsent) {
    return ModulesCompanion(
      id: Value(id),
      name: Value(name),
      glyph: Value(glyph),
      sortOrder: Value(sortOrder),
      enabled: Value(enabled),
    );
  }

  factory StudyModule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyModule(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      glyph: serializer.fromJson<String>(json['glyph']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'glyph': serializer.toJson<String>(glyph),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  StudyModule copyWith({
    String? id,
    String? name,
    String? glyph,
    int? sortOrder,
    bool? enabled,
  }) => StudyModule(
    id: id ?? this.id,
    name: name ?? this.name,
    glyph: glyph ?? this.glyph,
    sortOrder: sortOrder ?? this.sortOrder,
    enabled: enabled ?? this.enabled,
  );
  StudyModule copyWithCompanion(ModulesCompanion data) {
    return StudyModule(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      glyph: data.glyph.present ? data.glyph.value : this.glyph,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyModule(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('glyph: $glyph, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, glyph, sortOrder, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyModule &&
          other.id == this.id &&
          other.name == this.name &&
          other.glyph == this.glyph &&
          other.sortOrder == this.sortOrder &&
          other.enabled == this.enabled);
}

class ModulesCompanion extends UpdateCompanion<StudyModule> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> glyph;
  final Value<int> sortOrder;
  final Value<bool> enabled;
  final Value<int> rowid;
  const ModulesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.glyph = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModulesCompanion.insert({
    required String id,
    required String name,
    required String glyph,
    required int sortOrder,
    required bool enabled,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       glyph = Value(glyph),
       sortOrder = Value(sortOrder),
       enabled = Value(enabled);
  static Insertable<StudyModule> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? glyph,
    Expression<int>? sortOrder,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (glyph != null) 'glyph': glyph,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModulesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? glyph,
    Value<int>? sortOrder,
    Value<bool>? enabled,
    Value<int>? rowid,
  }) {
    return ModulesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      glyph: glyph ?? this.glyph,
      sortOrder: sortOrder ?? this.sortOrder,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (glyph.present) {
      map['glyph'] = Variable<String>(glyph.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModulesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('glyph: $glyph, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemGroupsTable extends ItemGroups
    with TableInfo<$ItemGroupsTable, ItemGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moduleIdMeta = const VerificationMeta(
    'moduleId',
  );
  @override
  late final GeneratedColumn<String> moduleId = GeneratedColumn<String>(
    'module_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtitleMeta = const VerificationMeta(
    'subtitle',
  );
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
    'subtitle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    moduleId,
    kind,
    name,
    subtitle,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('module_id')) {
      context.handle(
        _moduleIdMeta,
        moduleId.isAcceptableOrUnknown(data['module_id']!, _moduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(
        _subtitleMeta,
        subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta),
      );
    } else if (isInserting) {
      context.missing(_subtitleMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      moduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      subtitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $ItemGroupsTable createAlias(String alias) {
    return $ItemGroupsTable(attachedDatabase, alias);
  }
}

class ItemGroup extends DataClass implements Insertable<ItemGroup> {
  final String id;
  final String moduleId;
  final String kind;
  final String name;
  final String subtitle;
  final int sortOrder;
  const ItemGroup({
    required this.id,
    required this.moduleId,
    required this.kind,
    required this.name,
    required this.subtitle,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['module_id'] = Variable<String>(moduleId);
    map['kind'] = Variable<String>(kind);
    map['name'] = Variable<String>(name);
    map['subtitle'] = Variable<String>(subtitle);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ItemGroupsCompanion toCompanion(bool nullToAbsent) {
    return ItemGroupsCompanion(
      id: Value(id),
      moduleId: Value(moduleId),
      kind: Value(kind),
      name: Value(name),
      subtitle: Value(subtitle),
      sortOrder: Value(sortOrder),
    );
  }

  factory ItemGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemGroup(
      id: serializer.fromJson<String>(json['id']),
      moduleId: serializer.fromJson<String>(json['moduleId']),
      kind: serializer.fromJson<String>(json['kind']),
      name: serializer.fromJson<String>(json['name']),
      subtitle: serializer.fromJson<String>(json['subtitle']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'moduleId': serializer.toJson<String>(moduleId),
      'kind': serializer.toJson<String>(kind),
      'name': serializer.toJson<String>(name),
      'subtitle': serializer.toJson<String>(subtitle),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  ItemGroup copyWith({
    String? id,
    String? moduleId,
    String? kind,
    String? name,
    String? subtitle,
    int? sortOrder,
  }) => ItemGroup(
    id: id ?? this.id,
    moduleId: moduleId ?? this.moduleId,
    kind: kind ?? this.kind,
    name: name ?? this.name,
    subtitle: subtitle ?? this.subtitle,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  ItemGroup copyWithCompanion(ItemGroupsCompanion data) {
    return ItemGroup(
      id: data.id.present ? data.id.value : this.id,
      moduleId: data.moduleId.present ? data.moduleId.value : this.moduleId,
      kind: data.kind.present ? data.kind.value : this.kind,
      name: data.name.present ? data.name.value : this.name,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemGroup(')
          ..write('id: $id, ')
          ..write('moduleId: $moduleId, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('subtitle: $subtitle, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, moduleId, kind, name, subtitle, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemGroup &&
          other.id == this.id &&
          other.moduleId == this.moduleId &&
          other.kind == this.kind &&
          other.name == this.name &&
          other.subtitle == this.subtitle &&
          other.sortOrder == this.sortOrder);
}

class ItemGroupsCompanion extends UpdateCompanion<ItemGroup> {
  final Value<String> id;
  final Value<String> moduleId;
  final Value<String> kind;
  final Value<String> name;
  final Value<String> subtitle;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const ItemGroupsCompanion({
    this.id = const Value.absent(),
    this.moduleId = const Value.absent(),
    this.kind = const Value.absent(),
    this.name = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemGroupsCompanion.insert({
    required String id,
    required String moduleId,
    required String kind,
    required String name,
    required String subtitle,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       moduleId = Value(moduleId),
       kind = Value(kind),
       name = Value(name),
       subtitle = Value(subtitle),
       sortOrder = Value(sortOrder);
  static Insertable<ItemGroup> custom({
    Expression<String>? id,
    Expression<String>? moduleId,
    Expression<String>? kind,
    Expression<String>? name,
    Expression<String>? subtitle,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (moduleId != null) 'module_id': moduleId,
      if (kind != null) 'kind': kind,
      if (name != null) 'name': name,
      if (subtitle != null) 'subtitle': subtitle,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? moduleId,
    Value<String>? kind,
    Value<String>? name,
    Value<String>? subtitle,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return ItemGroupsCompanion(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      kind: kind ?? this.kind,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (moduleId.present) {
      map['module_id'] = Variable<String>(moduleId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemGroupsCompanion(')
          ..write('id: $id, ')
          ..write('moduleId: $moduleId, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('subtitle: $subtitle, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _moduleIdMeta = const VerificationMeta(
    'moduleId',
  );
  @override
  late final GeneratedColumn<String> moduleId = GeneratedColumn<String>(
    'module_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _japaneseMeta = const VerificationMeta(
    'japanese',
  );
  @override
  late final GeneratedColumn<String> japanese = GeneratedColumn<String>(
    'japanese',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readingMeta = const VerificationMeta(
    'reading',
  );
  @override
  late final GeneratedColumn<String> reading = GeneratedColumn<String>(
    'reading',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meaningEsMeta = const VerificationMeta(
    'meaningEs',
  );
  @override
  late final GeneratedColumn<String> meaningEs = GeneratedColumn<String>(
    'meaning_es',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioTextMeta = const VerificationMeta(
    'audioText',
  );
  @override
  late final GeneratedColumn<String> audioText = GeneratedColumn<String>(
    'audio_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    moduleId,
    groupId,
    kind,
    japanese,
    reading,
    meaningEs,
    audioText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(
    Insertable<Item> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('module_id')) {
      context.handle(
        _moduleIdMeta,
        moduleId.isAcceptableOrUnknown(data['module_id']!, _moduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('japanese')) {
      context.handle(
        _japaneseMeta,
        japanese.isAcceptableOrUnknown(data['japanese']!, _japaneseMeta),
      );
    } else if (isInserting) {
      context.missing(_japaneseMeta);
    }
    if (data.containsKey('reading')) {
      context.handle(
        _readingMeta,
        reading.isAcceptableOrUnknown(data['reading']!, _readingMeta),
      );
    } else if (isInserting) {
      context.missing(_readingMeta);
    }
    if (data.containsKey('meaning_es')) {
      context.handle(
        _meaningEsMeta,
        meaningEs.isAcceptableOrUnknown(data['meaning_es']!, _meaningEsMeta),
      );
    }
    if (data.containsKey('audio_text')) {
      context.handle(
        _audioTextMeta,
        audioText.isAcceptableOrUnknown(data['audio_text']!, _audioTextMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Item(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      moduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module_id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      japanese: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}japanese'],
      )!,
      reading: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading'],
      )!,
      meaningEs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning_es'],
      ),
      audioText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_text'],
      ),
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }
}

class Item extends DataClass implements Insertable<Item> {
  final int id;
  final String moduleId;
  final String groupId;
  final String kind;
  final String japanese;
  final String reading;
  final String? meaningEs;
  final String? audioText;
  const Item({
    required this.id,
    required this.moduleId,
    required this.groupId,
    required this.kind,
    required this.japanese,
    required this.reading,
    this.meaningEs,
    this.audioText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['module_id'] = Variable<String>(moduleId);
    map['group_id'] = Variable<String>(groupId);
    map['kind'] = Variable<String>(kind);
    map['japanese'] = Variable<String>(japanese);
    map['reading'] = Variable<String>(reading);
    if (!nullToAbsent || meaningEs != null) {
      map['meaning_es'] = Variable<String>(meaningEs);
    }
    if (!nullToAbsent || audioText != null) {
      map['audio_text'] = Variable<String>(audioText);
    }
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      moduleId: Value(moduleId),
      groupId: Value(groupId),
      kind: Value(kind),
      japanese: Value(japanese),
      reading: Value(reading),
      meaningEs: meaningEs == null && nullToAbsent
          ? const Value.absent()
          : Value(meaningEs),
      audioText: audioText == null && nullToAbsent
          ? const Value.absent()
          : Value(audioText),
    );
  }

  factory Item.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<int>(json['id']),
      moduleId: serializer.fromJson<String>(json['moduleId']),
      groupId: serializer.fromJson<String>(json['groupId']),
      kind: serializer.fromJson<String>(json['kind']),
      japanese: serializer.fromJson<String>(json['japanese']),
      reading: serializer.fromJson<String>(json['reading']),
      meaningEs: serializer.fromJson<String?>(json['meaningEs']),
      audioText: serializer.fromJson<String?>(json['audioText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'moduleId': serializer.toJson<String>(moduleId),
      'groupId': serializer.toJson<String>(groupId),
      'kind': serializer.toJson<String>(kind),
      'japanese': serializer.toJson<String>(japanese),
      'reading': serializer.toJson<String>(reading),
      'meaningEs': serializer.toJson<String?>(meaningEs),
      'audioText': serializer.toJson<String?>(audioText),
    };
  }

  Item copyWith({
    int? id,
    String? moduleId,
    String? groupId,
    String? kind,
    String? japanese,
    String? reading,
    Value<String?> meaningEs = const Value.absent(),
    Value<String?> audioText = const Value.absent(),
  }) => Item(
    id: id ?? this.id,
    moduleId: moduleId ?? this.moduleId,
    groupId: groupId ?? this.groupId,
    kind: kind ?? this.kind,
    japanese: japanese ?? this.japanese,
    reading: reading ?? this.reading,
    meaningEs: meaningEs.present ? meaningEs.value : this.meaningEs,
    audioText: audioText.present ? audioText.value : this.audioText,
  );
  Item copyWithCompanion(ItemsCompanion data) {
    return Item(
      id: data.id.present ? data.id.value : this.id,
      moduleId: data.moduleId.present ? data.moduleId.value : this.moduleId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      kind: data.kind.present ? data.kind.value : this.kind,
      japanese: data.japanese.present ? data.japanese.value : this.japanese,
      reading: data.reading.present ? data.reading.value : this.reading,
      meaningEs: data.meaningEs.present ? data.meaningEs.value : this.meaningEs,
      audioText: data.audioText.present ? data.audioText.value : this.audioText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('moduleId: $moduleId, ')
          ..write('groupId: $groupId, ')
          ..write('kind: $kind, ')
          ..write('japanese: $japanese, ')
          ..write('reading: $reading, ')
          ..write('meaningEs: $meaningEs, ')
          ..write('audioText: $audioText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    moduleId,
    groupId,
    kind,
    japanese,
    reading,
    meaningEs,
    audioText,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.moduleId == this.moduleId &&
          other.groupId == this.groupId &&
          other.kind == this.kind &&
          other.japanese == this.japanese &&
          other.reading == this.reading &&
          other.meaningEs == this.meaningEs &&
          other.audioText == this.audioText);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<int> id;
  final Value<String> moduleId;
  final Value<String> groupId;
  final Value<String> kind;
  final Value<String> japanese;
  final Value<String> reading;
  final Value<String?> meaningEs;
  final Value<String?> audioText;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.moduleId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.kind = const Value.absent(),
    this.japanese = const Value.absent(),
    this.reading = const Value.absent(),
    this.meaningEs = const Value.absent(),
    this.audioText = const Value.absent(),
  });
  ItemsCompanion.insert({
    this.id = const Value.absent(),
    required String moduleId,
    required String groupId,
    required String kind,
    required String japanese,
    required String reading,
    this.meaningEs = const Value.absent(),
    this.audioText = const Value.absent(),
  }) : moduleId = Value(moduleId),
       groupId = Value(groupId),
       kind = Value(kind),
       japanese = Value(japanese),
       reading = Value(reading);
  static Insertable<Item> custom({
    Expression<int>? id,
    Expression<String>? moduleId,
    Expression<String>? groupId,
    Expression<String>? kind,
    Expression<String>? japanese,
    Expression<String>? reading,
    Expression<String>? meaningEs,
    Expression<String>? audioText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (moduleId != null) 'module_id': moduleId,
      if (groupId != null) 'group_id': groupId,
      if (kind != null) 'kind': kind,
      if (japanese != null) 'japanese': japanese,
      if (reading != null) 'reading': reading,
      if (meaningEs != null) 'meaning_es': meaningEs,
      if (audioText != null) 'audio_text': audioText,
    });
  }

  ItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? moduleId,
    Value<String>? groupId,
    Value<String>? kind,
    Value<String>? japanese,
    Value<String>? reading,
    Value<String?>? meaningEs,
    Value<String?>? audioText,
  }) {
    return ItemsCompanion(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      groupId: groupId ?? this.groupId,
      kind: kind ?? this.kind,
      japanese: japanese ?? this.japanese,
      reading: reading ?? this.reading,
      meaningEs: meaningEs ?? this.meaningEs,
      audioText: audioText ?? this.audioText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (moduleId.present) {
      map['module_id'] = Variable<String>(moduleId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (japanese.present) {
      map['japanese'] = Variable<String>(japanese.value);
    }
    if (reading.present) {
      map['reading'] = Variable<String>(reading.value);
    }
    if (meaningEs.present) {
      map['meaning_es'] = Variable<String>(meaningEs.value);
    }
    if (audioText.present) {
      map['audio_text'] = Variable<String>(audioText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('moduleId: $moduleId, ')
          ..write('groupId: $groupId, ')
          ..write('kind: $kind, ')
          ..write('japanese: $japanese, ')
          ..write('reading: $reading, ')
          ..write('meaningEs: $meaningEs, ')
          ..write('audioText: $audioText')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewStatsTable extends ReviewStats
    with TableInfo<$ReviewStatsTable, ReviewStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<int> correct = GeneratedColumn<int>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSeenMeta = const VerificationMeta(
    'lastSeen',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeen = GeneratedColumn<DateTime>(
    'last_seen',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [itemId, attempts, correct, lastSeen];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewStat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    }
    if (data.containsKey('last_seen')) {
      context.handle(
        _lastSeenMeta,
        lastSeen.isAcceptableOrUnknown(data['last_seen']!, _lastSeenMeta),
      );
    } else if (isInserting) {
      context.missing(_lastSeenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  ReviewStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewStat(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct'],
      )!,
      lastSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen'],
      )!,
    );
  }

  @override
  $ReviewStatsTable createAlias(String alias) {
    return $ReviewStatsTable(attachedDatabase, alias);
  }
}

class ReviewStat extends DataClass implements Insertable<ReviewStat> {
  final int itemId;
  final int attempts;
  final int correct;
  final DateTime lastSeen;
  const ReviewStat({
    required this.itemId,
    required this.attempts,
    required this.correct,
    required this.lastSeen,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<int>(itemId);
    map['attempts'] = Variable<int>(attempts);
    map['correct'] = Variable<int>(correct);
    map['last_seen'] = Variable<DateTime>(lastSeen);
    return map;
  }

  ReviewStatsCompanion toCompanion(bool nullToAbsent) {
    return ReviewStatsCompanion(
      itemId: Value(itemId),
      attempts: Value(attempts),
      correct: Value(correct),
      lastSeen: Value(lastSeen),
    );
  }

  factory ReviewStat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewStat(
      itemId: serializer.fromJson<int>(json['itemId']),
      attempts: serializer.fromJson<int>(json['attempts']),
      correct: serializer.fromJson<int>(json['correct']),
      lastSeen: serializer.fromJson<DateTime>(json['lastSeen']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<int>(itemId),
      'attempts': serializer.toJson<int>(attempts),
      'correct': serializer.toJson<int>(correct),
      'lastSeen': serializer.toJson<DateTime>(lastSeen),
    };
  }

  ReviewStat copyWith({
    int? itemId,
    int? attempts,
    int? correct,
    DateTime? lastSeen,
  }) => ReviewStat(
    itemId: itemId ?? this.itemId,
    attempts: attempts ?? this.attempts,
    correct: correct ?? this.correct,
    lastSeen: lastSeen ?? this.lastSeen,
  );
  ReviewStat copyWithCompanion(ReviewStatsCompanion data) {
    return ReviewStat(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      correct: data.correct.present ? data.correct.value : this.correct,
      lastSeen: data.lastSeen.present ? data.lastSeen.value : this.lastSeen,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewStat(')
          ..write('itemId: $itemId, ')
          ..write('attempts: $attempts, ')
          ..write('correct: $correct, ')
          ..write('lastSeen: $lastSeen')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, attempts, correct, lastSeen);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewStat &&
          other.itemId == this.itemId &&
          other.attempts == this.attempts &&
          other.correct == this.correct &&
          other.lastSeen == this.lastSeen);
}

class ReviewStatsCompanion extends UpdateCompanion<ReviewStat> {
  final Value<int> itemId;
  final Value<int> attempts;
  final Value<int> correct;
  final Value<DateTime> lastSeen;
  const ReviewStatsCompanion({
    this.itemId = const Value.absent(),
    this.attempts = const Value.absent(),
    this.correct = const Value.absent(),
    this.lastSeen = const Value.absent(),
  });
  ReviewStatsCompanion.insert({
    this.itemId = const Value.absent(),
    this.attempts = const Value.absent(),
    this.correct = const Value.absent(),
    required DateTime lastSeen,
  }) : lastSeen = Value(lastSeen);
  static Insertable<ReviewStat> custom({
    Expression<int>? itemId,
    Expression<int>? attempts,
    Expression<int>? correct,
    Expression<DateTime>? lastSeen,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (attempts != null) 'attempts': attempts,
      if (correct != null) 'correct': correct,
      if (lastSeen != null) 'last_seen': lastSeen,
    });
  }

  ReviewStatsCompanion copyWith({
    Value<int>? itemId,
    Value<int>? attempts,
    Value<int>? correct,
    Value<DateTime>? lastSeen,
  }) {
    return ReviewStatsCompanion(
      itemId: itemId ?? this.itemId,
      attempts: attempts ?? this.attempts,
      correct: correct ?? this.correct,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (correct.present) {
      map['correct'] = Variable<int>(correct.value);
    }
    if (lastSeen.present) {
      map['last_seen'] = Variable<DateTime>(lastSeen.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewStatsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('attempts: $attempts, ')
          ..write('correct: $correct, ')
          ..write('lastSeen: $lastSeen')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ModulesTable modules = $ModulesTable(this);
  late final $ItemGroupsTable itemGroups = $ItemGroupsTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $ReviewStatsTable reviewStats = $ReviewStatsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    modules,
    itemGroups,
    items,
    settings,
    reviewStats,
  ];
}

typedef $$ModulesTableCreateCompanionBuilder =
    ModulesCompanion Function({
      required String id,
      required String name,
      required String glyph,
      required int sortOrder,
      required bool enabled,
      Value<int> rowid,
    });
typedef $$ModulesTableUpdateCompanionBuilder =
    ModulesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> glyph,
      Value<int> sortOrder,
      Value<bool> enabled,
      Value<int> rowid,
    });

class $$ModulesTableFilterComposer
    extends Composer<_$AppDatabase, $ModulesTable> {
  $$ModulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get glyph => $composableBuilder(
    column: $table.glyph,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ModulesTableOrderingComposer
    extends Composer<_$AppDatabase, $ModulesTable> {
  $$ModulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get glyph => $composableBuilder(
    column: $table.glyph,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ModulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModulesTable> {
  $$ModulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get glyph =>
      $composableBuilder(column: $table.glyph, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);
}

class $$ModulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ModulesTable,
          StudyModule,
          $$ModulesTableFilterComposer,
          $$ModulesTableOrderingComposer,
          $$ModulesTableAnnotationComposer,
          $$ModulesTableCreateCompanionBuilder,
          $$ModulesTableUpdateCompanionBuilder,
          (
            StudyModule,
            BaseReferences<_$AppDatabase, $ModulesTable, StudyModule>,
          ),
          StudyModule,
          PrefetchHooks Function()
        > {
  $$ModulesTableTableManager(_$AppDatabase db, $ModulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> glyph = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModulesCompanion(
                id: id,
                name: name,
                glyph: glyph,
                sortOrder: sortOrder,
                enabled: enabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String glyph,
                required int sortOrder,
                required bool enabled,
                Value<int> rowid = const Value.absent(),
              }) => ModulesCompanion.insert(
                id: id,
                name: name,
                glyph: glyph,
                sortOrder: sortOrder,
                enabled: enabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ModulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ModulesTable,
      StudyModule,
      $$ModulesTableFilterComposer,
      $$ModulesTableOrderingComposer,
      $$ModulesTableAnnotationComposer,
      $$ModulesTableCreateCompanionBuilder,
      $$ModulesTableUpdateCompanionBuilder,
      (StudyModule, BaseReferences<_$AppDatabase, $ModulesTable, StudyModule>),
      StudyModule,
      PrefetchHooks Function()
    >;
typedef $$ItemGroupsTableCreateCompanionBuilder =
    ItemGroupsCompanion Function({
      required String id,
      required String moduleId,
      required String kind,
      required String name,
      required String subtitle,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$ItemGroupsTableUpdateCompanionBuilder =
    ItemGroupsCompanion Function({
      Value<String> id,
      Value<String> moduleId,
      Value<String> kind,
      Value<String> name,
      Value<String> subtitle,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$ItemGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $ItemGroupsTable> {
  $$ItemGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ItemGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemGroupsTable> {
  $$ItemGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ItemGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemGroupsTable> {
  $$ItemGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get moduleId =>
      $composableBuilder(column: $table.moduleId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$ItemGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemGroupsTable,
          ItemGroup,
          $$ItemGroupsTableFilterComposer,
          $$ItemGroupsTableOrderingComposer,
          $$ItemGroupsTableAnnotationComposer,
          $$ItemGroupsTableCreateCompanionBuilder,
          $$ItemGroupsTableUpdateCompanionBuilder,
          (
            ItemGroup,
            BaseReferences<_$AppDatabase, $ItemGroupsTable, ItemGroup>,
          ),
          ItemGroup,
          PrefetchHooks Function()
        > {
  $$ItemGroupsTableTableManager(_$AppDatabase db, $ItemGroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> moduleId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> subtitle = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemGroupsCompanion(
                id: id,
                moduleId: moduleId,
                kind: kind,
                name: name,
                subtitle: subtitle,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String moduleId,
                required String kind,
                required String name,
                required String subtitle,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => ItemGroupsCompanion.insert(
                id: id,
                moduleId: moduleId,
                kind: kind,
                name: name,
                subtitle: subtitle,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ItemGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemGroupsTable,
      ItemGroup,
      $$ItemGroupsTableFilterComposer,
      $$ItemGroupsTableOrderingComposer,
      $$ItemGroupsTableAnnotationComposer,
      $$ItemGroupsTableCreateCompanionBuilder,
      $$ItemGroupsTableUpdateCompanionBuilder,
      (ItemGroup, BaseReferences<_$AppDatabase, $ItemGroupsTable, ItemGroup>),
      ItemGroup,
      PrefetchHooks Function()
    >;
typedef $$ItemsTableCreateCompanionBuilder =
    ItemsCompanion Function({
      Value<int> id,
      required String moduleId,
      required String groupId,
      required String kind,
      required String japanese,
      required String reading,
      Value<String?> meaningEs,
      Value<String?> audioText,
    });
typedef $$ItemsTableUpdateCompanionBuilder =
    ItemsCompanion Function({
      Value<int> id,
      Value<String> moduleId,
      Value<String> groupId,
      Value<String> kind,
      Value<String> japanese,
      Value<String> reading,
      Value<String?> meaningEs,
      Value<String?> audioText,
    });

class $$ItemsTableFilterComposer extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get japanese => $composableBuilder(
    column: $table.japanese,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reading => $composableBuilder(
    column: $table.reading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaningEs => $composableBuilder(
    column: $table.meaningEs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioText => $composableBuilder(
    column: $table.audioText,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get japanese => $composableBuilder(
    column: $table.japanese,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reading => $composableBuilder(
    column: $table.reading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningEs => $composableBuilder(
    column: $table.meaningEs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioText => $composableBuilder(
    column: $table.audioText,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get moduleId =>
      $composableBuilder(column: $table.moduleId, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get japanese =>
      $composableBuilder(column: $table.japanese, builder: (column) => column);

  GeneratedColumn<String> get reading =>
      $composableBuilder(column: $table.reading, builder: (column) => column);

  GeneratedColumn<String> get meaningEs =>
      $composableBuilder(column: $table.meaningEs, builder: (column) => column);

  GeneratedColumn<String> get audioText =>
      $composableBuilder(column: $table.audioText, builder: (column) => column);
}

class $$ItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemsTable,
          Item,
          $$ItemsTableFilterComposer,
          $$ItemsTableOrderingComposer,
          $$ItemsTableAnnotationComposer,
          $$ItemsTableCreateCompanionBuilder,
          $$ItemsTableUpdateCompanionBuilder,
          (Item, BaseReferences<_$AppDatabase, $ItemsTable, Item>),
          Item,
          PrefetchHooks Function()
        > {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> moduleId = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> japanese = const Value.absent(),
                Value<String> reading = const Value.absent(),
                Value<String?> meaningEs = const Value.absent(),
                Value<String?> audioText = const Value.absent(),
              }) => ItemsCompanion(
                id: id,
                moduleId: moduleId,
                groupId: groupId,
                kind: kind,
                japanese: japanese,
                reading: reading,
                meaningEs: meaningEs,
                audioText: audioText,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String moduleId,
                required String groupId,
                required String kind,
                required String japanese,
                required String reading,
                Value<String?> meaningEs = const Value.absent(),
                Value<String?> audioText = const Value.absent(),
              }) => ItemsCompanion.insert(
                id: id,
                moduleId: moduleId,
                groupId: groupId,
                kind: kind,
                japanese: japanese,
                reading: reading,
                meaningEs: meaningEs,
                audioText: audioText,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemsTable,
      Item,
      $$ItemsTableFilterComposer,
      $$ItemsTableOrderingComposer,
      $$ItemsTableAnnotationComposer,
      $$ItemsTableCreateCompanionBuilder,
      $$ItemsTableUpdateCompanionBuilder,
      (Item, BaseReferences<_$AppDatabase, $ItemsTable, Item>),
      Item,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$ReviewStatsTableCreateCompanionBuilder =
    ReviewStatsCompanion Function({
      Value<int> itemId,
      Value<int> attempts,
      Value<int> correct,
      required DateTime lastSeen,
    });
typedef $$ReviewStatsTableUpdateCompanionBuilder =
    ReviewStatsCompanion Function({
      Value<int> itemId,
      Value<int> attempts,
      Value<int> correct,
      Value<DateTime> lastSeen,
    });

class $$ReviewStatsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewStatsTable> {
  $$ReviewStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReviewStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewStatsTable> {
  $$ReviewStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReviewStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewStatsTable> {
  $$ReviewStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<int> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeen =>
      $composableBuilder(column: $table.lastSeen, builder: (column) => column);
}

class $$ReviewStatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewStatsTable,
          ReviewStat,
          $$ReviewStatsTableFilterComposer,
          $$ReviewStatsTableOrderingComposer,
          $$ReviewStatsTableAnnotationComposer,
          $$ReviewStatsTableCreateCompanionBuilder,
          $$ReviewStatsTableUpdateCompanionBuilder,
          (
            ReviewStat,
            BaseReferences<_$AppDatabase, $ReviewStatsTable, ReviewStat>,
          ),
          ReviewStat,
          PrefetchHooks Function()
        > {
  $$ReviewStatsTableTableManager(_$AppDatabase db, $ReviewStatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> itemId = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<int> correct = const Value.absent(),
                Value<DateTime> lastSeen = const Value.absent(),
              }) => ReviewStatsCompanion(
                itemId: itemId,
                attempts: attempts,
                correct: correct,
                lastSeen: lastSeen,
              ),
          createCompanionCallback:
              ({
                Value<int> itemId = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<int> correct = const Value.absent(),
                required DateTime lastSeen,
              }) => ReviewStatsCompanion.insert(
                itemId: itemId,
                attempts: attempts,
                correct: correct,
                lastSeen: lastSeen,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReviewStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewStatsTable,
      ReviewStat,
      $$ReviewStatsTableFilterComposer,
      $$ReviewStatsTableOrderingComposer,
      $$ReviewStatsTableAnnotationComposer,
      $$ReviewStatsTableCreateCompanionBuilder,
      $$ReviewStatsTableUpdateCompanionBuilder,
      (
        ReviewStat,
        BaseReferences<_$AppDatabase, $ReviewStatsTable, ReviewStat>,
      ),
      ReviewStat,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ModulesTableTableManager get modules =>
      $$ModulesTableTableManager(_db, _db.modules);
  $$ItemGroupsTableTableManager get itemGroups =>
      $$ItemGroupsTableTableManager(_db, _db.itemGroups);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$ReviewStatsTableTableManager get reviewStats =>
      $$ReviewStatsTableTableManager(_db, _db.reviewStats);
}

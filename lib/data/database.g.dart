// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $QAPairsTable extends QAPairs with TableInfo<$QAPairsTable, QAPair> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QAPairsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _queryMeta = const VerificationMeta('query');
  @override
  late final GeneratedColumn<String> query = GeneratedColumn<String>(
    'query',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
    'answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isLocalModeMeta = const VerificationMeta(
    'isLocalMode',
  );
  @override
  late final GeneratedColumn<bool> isLocalMode = GeneratedColumn<bool>(
    'is_local_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_local_mode" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    query,
    answer,
    timestamp,
    isLocalMode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'q_a_pairs';
  @override
  VerificationContext validateIntegrity(
    Insertable<QAPair> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('query')) {
      context.handle(
        _queryMeta,
        query.isAcceptableOrUnknown(data['query']!, _queryMeta),
      );
    } else if (isInserting) {
      context.missing(_queryMeta);
    }
    if (data.containsKey('answer')) {
      context.handle(
        _answerMeta,
        answer.isAcceptableOrUnknown(data['answer']!, _answerMeta),
      );
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('is_local_mode')) {
      context.handle(
        _isLocalModeMeta,
        isLocalMode.isAcceptableOrUnknown(
          data['is_local_mode']!,
          _isLocalModeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QAPair map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QAPair(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      query: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}query'],
      )!,
      answer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      isLocalMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_local_mode'],
      )!,
    );
  }

  @override
  $QAPairsTable createAlias(String alias) {
    return $QAPairsTable(attachedDatabase, alias);
  }
}

class QAPair extends DataClass implements Insertable<QAPair> {
  final int id;
  final String query;
  final String answer;
  final DateTime timestamp;
  final bool isLocalMode;
  const QAPair({
    required this.id,
    required this.query,
    required this.answer,
    required this.timestamp,
    required this.isLocalMode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['query'] = Variable<String>(query);
    map['answer'] = Variable<String>(answer);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['is_local_mode'] = Variable<bool>(isLocalMode);
    return map;
  }

  QAPairsCompanion toCompanion(bool nullToAbsent) {
    return QAPairsCompanion(
      id: Value(id),
      query: Value(query),
      answer: Value(answer),
      timestamp: Value(timestamp),
      isLocalMode: Value(isLocalMode),
    );
  }

  factory QAPair.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QAPair(
      id: serializer.fromJson<int>(json['id']),
      query: serializer.fromJson<String>(json['query']),
      answer: serializer.fromJson<String>(json['answer']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      isLocalMode: serializer.fromJson<bool>(json['isLocalMode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'query': serializer.toJson<String>(query),
      'answer': serializer.toJson<String>(answer),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'isLocalMode': serializer.toJson<bool>(isLocalMode),
    };
  }

  QAPair copyWith({
    int? id,
    String? query,
    String? answer,
    DateTime? timestamp,
    bool? isLocalMode,
  }) => QAPair(
    id: id ?? this.id,
    query: query ?? this.query,
    answer: answer ?? this.answer,
    timestamp: timestamp ?? this.timestamp,
    isLocalMode: isLocalMode ?? this.isLocalMode,
  );
  QAPair copyWithCompanion(QAPairsCompanion data) {
    return QAPair(
      id: data.id.present ? data.id.value : this.id,
      query: data.query.present ? data.query.value : this.query,
      answer: data.answer.present ? data.answer.value : this.answer,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      isLocalMode: data.isLocalMode.present
          ? data.isLocalMode.value
          : this.isLocalMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QAPair(')
          ..write('id: $id, ')
          ..write('query: $query, ')
          ..write('answer: $answer, ')
          ..write('timestamp: $timestamp, ')
          ..write('isLocalMode: $isLocalMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, query, answer, timestamp, isLocalMode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QAPair &&
          other.id == this.id &&
          other.query == this.query &&
          other.answer == this.answer &&
          other.timestamp == this.timestamp &&
          other.isLocalMode == this.isLocalMode);
}

class QAPairsCompanion extends UpdateCompanion<QAPair> {
  final Value<int> id;
  final Value<String> query;
  final Value<String> answer;
  final Value<DateTime> timestamp;
  final Value<bool> isLocalMode;
  const QAPairsCompanion({
    this.id = const Value.absent(),
    this.query = const Value.absent(),
    this.answer = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.isLocalMode = const Value.absent(),
  });
  QAPairsCompanion.insert({
    this.id = const Value.absent(),
    required String query,
    required String answer,
    required DateTime timestamp,
    this.isLocalMode = const Value.absent(),
  }) : query = Value(query),
       answer = Value(answer),
       timestamp = Value(timestamp);
  static Insertable<QAPair> custom({
    Expression<int>? id,
    Expression<String>? query,
    Expression<String>? answer,
    Expression<DateTime>? timestamp,
    Expression<bool>? isLocalMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (query != null) 'query': query,
      if (answer != null) 'answer': answer,
      if (timestamp != null) 'timestamp': timestamp,
      if (isLocalMode != null) 'is_local_mode': isLocalMode,
    });
  }

  QAPairsCompanion copyWith({
    Value<int>? id,
    Value<String>? query,
    Value<String>? answer,
    Value<DateTime>? timestamp,
    Value<bool>? isLocalMode,
  }) {
    return QAPairsCompanion(
      id: id ?? this.id,
      query: query ?? this.query,
      answer: answer ?? this.answer,
      timestamp: timestamp ?? this.timestamp,
      isLocalMode: isLocalMode ?? this.isLocalMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (query.present) {
      map['query'] = Variable<String>(query.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (isLocalMode.present) {
      map['is_local_mode'] = Variable<bool>(isLocalMode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QAPairsCompanion(')
          ..write('id: $id, ')
          ..write('query: $query, ')
          ..write('answer: $answer, ')
          ..write('timestamp: $timestamp, ')
          ..write('isLocalMode: $isLocalMode')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $QAPairsTable qAPairs = $QAPairsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [qAPairs];
}

typedef $$QAPairsTableCreateCompanionBuilder =
    QAPairsCompanion Function({
      Value<int> id,
      required String query,
      required String answer,
      required DateTime timestamp,
      Value<bool> isLocalMode,
    });
typedef $$QAPairsTableUpdateCompanionBuilder =
    QAPairsCompanion Function({
      Value<int> id,
      Value<String> query,
      Value<String> answer,
      Value<DateTime> timestamp,
      Value<bool> isLocalMode,
    });

class $$QAPairsTableFilterComposer
    extends Composer<_$AppDatabase, $QAPairsTable> {
  $$QAPairsTableFilterComposer({
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

  ColumnFilters<String> get query => $composableBuilder(
    column: $table.query,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLocalMode => $composableBuilder(
    column: $table.isLocalMode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QAPairsTableOrderingComposer
    extends Composer<_$AppDatabase, $QAPairsTable> {
  $$QAPairsTableOrderingComposer({
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

  ColumnOrderings<String> get query => $composableBuilder(
    column: $table.query,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLocalMode => $composableBuilder(
    column: $table.isLocalMode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QAPairsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QAPairsTable> {
  $$QAPairsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get query =>
      $composableBuilder(column: $table.query, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<bool> get isLocalMode => $composableBuilder(
    column: $table.isLocalMode,
    builder: (column) => column,
  );
}

class $$QAPairsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QAPairsTable,
          QAPair,
          $$QAPairsTableFilterComposer,
          $$QAPairsTableOrderingComposer,
          $$QAPairsTableAnnotationComposer,
          $$QAPairsTableCreateCompanionBuilder,
          $$QAPairsTableUpdateCompanionBuilder,
          (QAPair, BaseReferences<_$AppDatabase, $QAPairsTable, QAPair>),
          QAPair,
          PrefetchHooks Function()
        > {
  $$QAPairsTableTableManager(_$AppDatabase db, $QAPairsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QAPairsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QAPairsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QAPairsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> query = const Value.absent(),
                Value<String> answer = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<bool> isLocalMode = const Value.absent(),
              }) => QAPairsCompanion(
                id: id,
                query: query,
                answer: answer,
                timestamp: timestamp,
                isLocalMode: isLocalMode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String query,
                required String answer,
                required DateTime timestamp,
                Value<bool> isLocalMode = const Value.absent(),
              }) => QAPairsCompanion.insert(
                id: id,
                query: query,
                answer: answer,
                timestamp: timestamp,
                isLocalMode: isLocalMode,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QAPairsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QAPairsTable,
      QAPair,
      $$QAPairsTableFilterComposer,
      $$QAPairsTableOrderingComposer,
      $$QAPairsTableAnnotationComposer,
      $$QAPairsTableCreateCompanionBuilder,
      $$QAPairsTableUpdateCompanionBuilder,
      (QAPair, BaseReferences<_$AppDatabase, $QAPairsTable, QAPair>),
      QAPair,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$QAPairsTableTableManager get qAPairs =>
      $$QAPairsTableTableManager(_db, _db.qAPairs);
}

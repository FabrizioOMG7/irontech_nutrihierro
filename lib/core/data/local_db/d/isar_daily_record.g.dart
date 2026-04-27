// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_daily_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarDailyRecordCollection on Isar {
  IsarCollection<IsarDailyRecord> get isarDailyRecords => this.collection();
}

const IsarDailyRecordSchema = CollectionSchema(
  name: r'IsarDailyRecord',
  id: 2965117609125765854,
  properties: {
    r'consumedIron': PropertySchema(
      id: 0,
      name: r'consumedIron',
      type: IsarType.double,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'tookSupplement': PropertySchema(
      id: 2,
      name: r'tookSupplement',
      type: IsarType.bool,
    )
  },
  estimateSize: _isarDailyRecordEstimateSize,
  serialize: _isarDailyRecordSerialize,
  deserialize: _isarDailyRecordDeserialize,
  deserializeProp: _isarDailyRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarDailyRecordGetId,
  getLinks: _isarDailyRecordGetLinks,
  attach: _isarDailyRecordAttach,
  version: '3.1.0+1',
);

int _isarDailyRecordEstimateSize(
  IsarDailyRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _isarDailyRecordSerialize(
  IsarDailyRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.consumedIron);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeBool(offsets[2], object.tookSupplement);
}

IsarDailyRecord _isarDailyRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarDailyRecord();
  object.consumedIron = reader.readDouble(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.id = id;
  object.tookSupplement = reader.readBool(offsets[2]);
  return object;
}

P _isarDailyRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarDailyRecordGetId(IsarDailyRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarDailyRecordGetLinks(IsarDailyRecord object) {
  return [];
}

void _isarDailyRecordAttach(
    IsarCollection<dynamic> col, Id id, IsarDailyRecord object) {
  object.id = id;
}

extension IsarDailyRecordByIndex on IsarCollection<IsarDailyRecord> {
  Future<IsarDailyRecord?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  IsarDailyRecord? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<IsarDailyRecord?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<IsarDailyRecord?> getAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(IsarDailyRecord object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(IsarDailyRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<IsarDailyRecord> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<IsarDailyRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension IsarDailyRecordQueryWhereSort
    on QueryBuilder<IsarDailyRecord, IsarDailyRecord, QWhere> {
  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension IsarDailyRecordQueryWhere
    on QueryBuilder<IsarDailyRecord, IsarDailyRecord, QWhereClause> {
  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterWhereClause>
      dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterWhereClause>
      dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterWhereClause>
      dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarDailyRecordQueryFilter
    on QueryBuilder<IsarDailyRecord, IsarDailyRecord, QFilterCondition> {
  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterFilterCondition>
      consumedIronEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'consumedIron',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterFilterCondition>
      consumedIronGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'consumedIron',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterFilterCondition>
      consumedIronLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'consumedIron',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterFilterCondition>
      consumedIronBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'consumedIron',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterFilterCondition>
      tookSupplementEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tookSupplement',
        value: value,
      ));
    });
  }
}

extension IsarDailyRecordQueryObject
    on QueryBuilder<IsarDailyRecord, IsarDailyRecord, QFilterCondition> {}

extension IsarDailyRecordQueryLinks
    on QueryBuilder<IsarDailyRecord, IsarDailyRecord, QFilterCondition> {}

extension IsarDailyRecordQuerySortBy
    on QueryBuilder<IsarDailyRecord, IsarDailyRecord, QSortBy> {
  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterSortBy>
      sortByConsumedIron() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consumedIron', Sort.asc);
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterSortBy>
      sortByConsumedIronDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consumedIron', Sort.desc);
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterSortBy>
      sortByTookSupplement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tookSupplement', Sort.asc);
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterSortBy>
      sortByTookSupplementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tookSupplement', Sort.desc);
    });
  }
}

extension IsarDailyRecordQuerySortThenBy
    on QueryBuilder<IsarDailyRecord, IsarDailyRecord, QSortThenBy> {
  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterSortBy>
      thenByConsumedIron() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consumedIron', Sort.asc);
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterSortBy>
      thenByConsumedIronDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consumedIron', Sort.desc);
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterSortBy>
      thenByTookSupplement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tookSupplement', Sort.asc);
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QAfterSortBy>
      thenByTookSupplementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tookSupplement', Sort.desc);
    });
  }
}

extension IsarDailyRecordQueryWhereDistinct
    on QueryBuilder<IsarDailyRecord, IsarDailyRecord, QDistinct> {
  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QDistinct>
      distinctByConsumedIron() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'consumedIron');
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<IsarDailyRecord, IsarDailyRecord, QDistinct>
      distinctByTookSupplement() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tookSupplement');
    });
  }
}

extension IsarDailyRecordQueryProperty
    on QueryBuilder<IsarDailyRecord, IsarDailyRecord, QQueryProperty> {
  QueryBuilder<IsarDailyRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarDailyRecord, double, QQueryOperations>
      consumedIronProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'consumedIron');
    });
  }

  QueryBuilder<IsarDailyRecord, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<IsarDailyRecord, bool, QQueryOperations>
      tookSupplementProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tookSupplement');
    });
  }
}

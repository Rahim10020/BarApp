// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'congelateur.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCongelateurCollection on Isar {
  IsarCollection<Congelateur> get congelateurs => this.collection();
}

const CongelateurSchema = CollectionSchema(
  name: r'Congelateur',
  id: 8245316602713214289,
  properties: {},
  estimateSize: _congelateurEstimateSize,
  serialize: _congelateurSerialize,
  deserialize: _congelateurDeserialize,
  deserializeProp: _congelateurDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'stockBoissons': LinkSchema(
      id: 1817862754193593080,
      name: r'stockBoissons',
      target: r'StockBoisson',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _congelateurGetId,
  getLinks: _congelateurGetLinks,
  attach: _congelateurAttach,
  version: '3.1.0+1',
);

int _congelateurEstimateSize(
  Congelateur object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _congelateurSerialize(
  Congelateur object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {}
Congelateur _congelateurDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Congelateur();
  object.id = id;
  return object;
}

P _congelateurDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _congelateurGetId(Congelateur object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _congelateurGetLinks(Congelateur object) {
  return [object.stockBoissons];
}

void _congelateurAttach(
    IsarCollection<dynamic> col, Id id, Congelateur object) {
  object.id = id;
  object.stockBoissons
      .attach(col, col.isar.collection<StockBoisson>(), r'stockBoissons', id);
}

extension CongelateurQueryWhereSort
    on QueryBuilder<Congelateur, Congelateur, QWhere> {
  QueryBuilder<Congelateur, Congelateur, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CongelateurQueryWhere
    on QueryBuilder<Congelateur, Congelateur, QWhereClause> {
  QueryBuilder<Congelateur, Congelateur, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Congelateur, Congelateur, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<Congelateur, Congelateur, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Congelateur, Congelateur, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Congelateur, Congelateur, QAfterWhereClause> idBetween(
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
}

extension CongelateurQueryFilter
    on QueryBuilder<Congelateur, Congelateur, QFilterCondition> {
  QueryBuilder<Congelateur, Congelateur, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Congelateur, Congelateur, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Congelateur, Congelateur, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Congelateur, Congelateur, QAfterFilterCondition> idBetween(
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
}

extension CongelateurQueryObject
    on QueryBuilder<Congelateur, Congelateur, QFilterCondition> {}

extension CongelateurQueryLinks
    on QueryBuilder<Congelateur, Congelateur, QFilterCondition> {
  QueryBuilder<Congelateur, Congelateur, QAfterFilterCondition> stockBoissons(
      FilterQuery<StockBoisson> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'stockBoissons');
    });
  }

  QueryBuilder<Congelateur, Congelateur, QAfterFilterCondition>
      stockBoissonsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'stockBoissons', length, true, length, true);
    });
  }

  QueryBuilder<Congelateur, Congelateur, QAfterFilterCondition>
      stockBoissonsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'stockBoissons', 0, true, 0, true);
    });
  }

  QueryBuilder<Congelateur, Congelateur, QAfterFilterCondition>
      stockBoissonsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'stockBoissons', 0, false, 999999, true);
    });
  }

  QueryBuilder<Congelateur, Congelateur, QAfterFilterCondition>
      stockBoissonsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'stockBoissons', 0, true, length, include);
    });
  }

  QueryBuilder<Congelateur, Congelateur, QAfterFilterCondition>
      stockBoissonsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'stockBoissons', length, include, 999999, true);
    });
  }

  QueryBuilder<Congelateur, Congelateur, QAfterFilterCondition>
      stockBoissonsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'stockBoissons', lower, includeLower, upper, includeUpper);
    });
  }
}

extension CongelateurQuerySortBy
    on QueryBuilder<Congelateur, Congelateur, QSortBy> {}

extension CongelateurQuerySortThenBy
    on QueryBuilder<Congelateur, Congelateur, QSortThenBy> {
  QueryBuilder<Congelateur, Congelateur, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Congelateur, Congelateur, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension CongelateurQueryWhereDistinct
    on QueryBuilder<Congelateur, Congelateur, QDistinct> {}

extension CongelateurQueryProperty
    on QueryBuilder<Congelateur, Congelateur, QQueryProperty> {
  QueryBuilder<Congelateur, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }
}

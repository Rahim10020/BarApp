// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'casier.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCasierCollection on Isar {
  IsarCollection<Casier> get casiers => this.collection();
}

const CasierSchema = CollectionSchema(
  name: r'Casier',
  id: -8557116961421826877,
  properties: {
    r'nbBouteillesRestantes': PropertySchema(
      id: 0,
      name: r'nbBouteillesRestantes',
      type: IsarType.long,
    )
  },
  estimateSize: _casierEstimateSize,
  serialize: _casierSerialize,
  deserialize: _casierDeserialize,
  deserializeProp: _casierDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'boisson': LinkSchema(
      id: -5445937300666190625,
      name: r'boisson',
      target: r'Boisson',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _casierGetId,
  getLinks: _casierGetLinks,
  attach: _casierAttach,
  version: '3.1.0+1',
);

int _casierEstimateSize(
  Casier object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _casierSerialize(
  Casier object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.nbBouteillesRestantes);
}

Casier _casierDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Casier();
  object.id = id;
  object.nbBouteillesRestantes = reader.readLong(offsets[0]);
  return object;
}

P _casierDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _casierGetId(Casier object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _casierGetLinks(Casier object) {
  return [object.boisson];
}

void _casierAttach(IsarCollection<dynamic> col, Id id, Casier object) {
  object.id = id;
  object.boisson.attach(col, col.isar.collection<Boisson>(), r'boisson', id);
}

extension CasierQueryWhereSort on QueryBuilder<Casier, Casier, QWhere> {
  QueryBuilder<Casier, Casier, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CasierQueryWhere on QueryBuilder<Casier, Casier, QWhereClause> {
  QueryBuilder<Casier, Casier, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Casier, Casier, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Casier, Casier, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Casier, Casier, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Casier, Casier, QAfterWhereClause> idBetween(
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

extension CasierQueryFilter on QueryBuilder<Casier, Casier, QFilterCondition> {
  QueryBuilder<Casier, Casier, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Casier, Casier, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Casier, Casier, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Casier, Casier, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Casier, Casier, QAfterFilterCondition>
      nbBouteillesRestantesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nbBouteillesRestantes',
        value: value,
      ));
    });
  }

  QueryBuilder<Casier, Casier, QAfterFilterCondition>
      nbBouteillesRestantesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nbBouteillesRestantes',
        value: value,
      ));
    });
  }

  QueryBuilder<Casier, Casier, QAfterFilterCondition>
      nbBouteillesRestantesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nbBouteillesRestantes',
        value: value,
      ));
    });
  }

  QueryBuilder<Casier, Casier, QAfterFilterCondition>
      nbBouteillesRestantesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nbBouteillesRestantes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CasierQueryObject on QueryBuilder<Casier, Casier, QFilterCondition> {}

extension CasierQueryLinks on QueryBuilder<Casier, Casier, QFilterCondition> {
  QueryBuilder<Casier, Casier, QAfterFilterCondition> boisson(
      FilterQuery<Boisson> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'boisson');
    });
  }

  QueryBuilder<Casier, Casier, QAfterFilterCondition> boissonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'boisson', 0, true, 0, true);
    });
  }
}

extension CasierQuerySortBy on QueryBuilder<Casier, Casier, QSortBy> {
  QueryBuilder<Casier, Casier, QAfterSortBy> sortByNbBouteillesRestantes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nbBouteillesRestantes', Sort.asc);
    });
  }

  QueryBuilder<Casier, Casier, QAfterSortBy> sortByNbBouteillesRestantesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nbBouteillesRestantes', Sort.desc);
    });
  }
}

extension CasierQuerySortThenBy on QueryBuilder<Casier, Casier, QSortThenBy> {
  QueryBuilder<Casier, Casier, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Casier, Casier, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Casier, Casier, QAfterSortBy> thenByNbBouteillesRestantes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nbBouteillesRestantes', Sort.asc);
    });
  }

  QueryBuilder<Casier, Casier, QAfterSortBy> thenByNbBouteillesRestantesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nbBouteillesRestantes', Sort.desc);
    });
  }
}

extension CasierQueryWhereDistinct on QueryBuilder<Casier, Casier, QDistinct> {
  QueryBuilder<Casier, Casier, QDistinct> distinctByNbBouteillesRestantes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nbBouteillesRestantes');
    });
  }
}

extension CasierQueryProperty on QueryBuilder<Casier, Casier, QQueryProperty> {
  QueryBuilder<Casier, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Casier, int, QQueryOperations> nbBouteillesRestantesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nbBouteillesRestantes');
    });
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vente.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVenteCollection on Isar {
  IsarCollection<Vente> get ventes => this.collection();
}

const VenteSchema = CollectionSchema(
  name: r'Vente',
  id: -5580220530297708731,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'montantVente': PropertySchema(
      id: 1,
      name: r'montantVente',
      type: IsarType.double,
    ),
    r'quantiteVendu': PropertySchema(
      id: 2,
      name: r'quantiteVendu',
      type: IsarType.long,
    )
  },
  estimateSize: _venteEstimateSize,
  serialize: _venteSerialize,
  deserialize: _venteDeserialize,
  deserializeProp: _venteDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'boisson': LinkSchema(
      id: -1751061237709407733,
      name: r'boisson',
      target: r'Boisson',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _venteGetId,
  getLinks: _venteGetLinks,
  attach: _venteAttach,
  version: '3.1.0+1',
);

int _venteEstimateSize(
  Vente object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _venteSerialize(
  Vente object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeDouble(offsets[1], object.montantVente);
  writer.writeLong(offsets[2], object.quantiteVendu);
}

Vente _venteDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Vente(
    date: reader.readDateTime(offsets[0]),
    quantiteVendu: reader.readLong(offsets[2]),
  );
  object.id = id;
  return object;
}

P _venteDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _venteGetId(Vente object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _venteGetLinks(Vente object) {
  return [object.boisson];
}

void _venteAttach(IsarCollection<dynamic> col, Id id, Vente object) {
  object.id = id;
  object.boisson.attach(col, col.isar.collection<Boisson>(), r'boisson', id);
}

extension VenteQueryWhereSort on QueryBuilder<Vente, Vente, QWhere> {
  QueryBuilder<Vente, Vente, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VenteQueryWhere on QueryBuilder<Vente, Vente, QWhereClause> {
  QueryBuilder<Vente, Vente, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Vente, Vente, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Vente, Vente, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Vente, Vente, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Vente, Vente, QAfterWhereClause> idBetween(
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

extension VenteQueryFilter on QueryBuilder<Vente, Vente, QFilterCondition> {
  QueryBuilder<Vente, Vente, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Vente, Vente, QAfterFilterCondition> dateGreaterThan(
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

  QueryBuilder<Vente, Vente, QAfterFilterCondition> dateLessThan(
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

  QueryBuilder<Vente, Vente, QAfterFilterCondition> dateBetween(
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

  QueryBuilder<Vente, Vente, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Vente, Vente, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Vente, Vente, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Vente, Vente, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Vente, Vente, QAfterFilterCondition> montantVenteEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'montantVente',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Vente, Vente, QAfterFilterCondition> montantVenteGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'montantVente',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Vente, Vente, QAfterFilterCondition> montantVenteLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'montantVente',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Vente, Vente, QAfterFilterCondition> montantVenteBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'montantVente',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Vente, Vente, QAfterFilterCondition> quantiteVenduEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantiteVendu',
        value: value,
      ));
    });
  }

  QueryBuilder<Vente, Vente, QAfterFilterCondition> quantiteVenduGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quantiteVendu',
        value: value,
      ));
    });
  }

  QueryBuilder<Vente, Vente, QAfterFilterCondition> quantiteVenduLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quantiteVendu',
        value: value,
      ));
    });
  }

  QueryBuilder<Vente, Vente, QAfterFilterCondition> quantiteVenduBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quantiteVendu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension VenteQueryObject on QueryBuilder<Vente, Vente, QFilterCondition> {}

extension VenteQueryLinks on QueryBuilder<Vente, Vente, QFilterCondition> {
  QueryBuilder<Vente, Vente, QAfterFilterCondition> boisson(
      FilterQuery<Boisson> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'boisson');
    });
  }

  QueryBuilder<Vente, Vente, QAfterFilterCondition> boissonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'boisson', 0, true, 0, true);
    });
  }
}

extension VenteQuerySortBy on QueryBuilder<Vente, Vente, QSortBy> {
  QueryBuilder<Vente, Vente, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Vente, Vente, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Vente, Vente, QAfterSortBy> sortByMontantVente() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'montantVente', Sort.asc);
    });
  }

  QueryBuilder<Vente, Vente, QAfterSortBy> sortByMontantVenteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'montantVente', Sort.desc);
    });
  }

  QueryBuilder<Vente, Vente, QAfterSortBy> sortByQuantiteVendu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantiteVendu', Sort.asc);
    });
  }

  QueryBuilder<Vente, Vente, QAfterSortBy> sortByQuantiteVenduDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantiteVendu', Sort.desc);
    });
  }
}

extension VenteQuerySortThenBy on QueryBuilder<Vente, Vente, QSortThenBy> {
  QueryBuilder<Vente, Vente, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Vente, Vente, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Vente, Vente, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Vente, Vente, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Vente, Vente, QAfterSortBy> thenByMontantVente() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'montantVente', Sort.asc);
    });
  }

  QueryBuilder<Vente, Vente, QAfterSortBy> thenByMontantVenteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'montantVente', Sort.desc);
    });
  }

  QueryBuilder<Vente, Vente, QAfterSortBy> thenByQuantiteVendu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantiteVendu', Sort.asc);
    });
  }

  QueryBuilder<Vente, Vente, QAfterSortBy> thenByQuantiteVenduDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantiteVendu', Sort.desc);
    });
  }
}

extension VenteQueryWhereDistinct on QueryBuilder<Vente, Vente, QDistinct> {
  QueryBuilder<Vente, Vente, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<Vente, Vente, QDistinct> distinctByMontantVente() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'montantVente');
    });
  }

  QueryBuilder<Vente, Vente, QDistinct> distinctByQuantiteVendu() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quantiteVendu');
    });
  }
}

extension VenteQueryProperty on QueryBuilder<Vente, Vente, QQueryProperty> {
  QueryBuilder<Vente, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Vente, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<Vente, double, QQueryOperations> montantVenteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'montantVente');
    });
  }

  QueryBuilder<Vente, int, QQueryOperations> quantiteVenduProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quantiteVendu');
    });
  }
}

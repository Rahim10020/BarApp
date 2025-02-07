// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commande.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCommandeCollection on Isar {
  IsarCollection<Commande> get commandes => this.collection();
}

const CommandeSchema = CollectionSchema(
  name: r'Commande',
  id: -688734561904518230,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'prixTotal': PropertySchema(
      id: 1,
      name: r'prixTotal',
      type: IsarType.double,
    )
  },
  estimateSize: _commandeEstimateSize,
  serialize: _commandeSerialize,
  deserialize: _commandeDeserialize,
  deserializeProp: _commandeDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'detailsCommandes': LinkSchema(
      id: -4958743713829729544,
      name: r'detailsCommandes',
      target: r'DetailsCommande',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _commandeGetId,
  getLinks: _commandeGetLinks,
  attach: _commandeAttach,
  version: '3.1.0+1',
);

int _commandeEstimateSize(
  Commande object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _commandeSerialize(
  Commande object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeDouble(offsets[1], object.prixTotal);
}

Commande _commandeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Commande();
  object.date = reader.readDateTime(offsets[0]);
  object.id = id;
  return object;
}

P _commandeDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _commandeGetId(Commande object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _commandeGetLinks(Commande object) {
  return [object.detailsCommandes];
}

void _commandeAttach(IsarCollection<dynamic> col, Id id, Commande object) {
  object.id = id;
  object.detailsCommandes.attach(
      col, col.isar.collection<DetailsCommande>(), r'detailsCommandes', id);
}

extension CommandeQueryWhereSort on QueryBuilder<Commande, Commande, QWhere> {
  QueryBuilder<Commande, Commande, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CommandeQueryWhere on QueryBuilder<Commande, Commande, QWhereClause> {
  QueryBuilder<Commande, Commande, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Commande, Commande, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Commande, Commande, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Commande, Commande, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Commande, Commande, QAfterWhereClause> idBetween(
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

extension CommandeQueryFilter
    on QueryBuilder<Commande, Commande, QFilterCondition> {
  QueryBuilder<Commande, Commande, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Commande, Commande, QAfterFilterCondition> dateGreaterThan(
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

  QueryBuilder<Commande, Commande, QAfterFilterCondition> dateLessThan(
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

  QueryBuilder<Commande, Commande, QAfterFilterCondition> dateBetween(
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

  QueryBuilder<Commande, Commande, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Commande, Commande, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Commande, Commande, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Commande, Commande, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Commande, Commande, QAfterFilterCondition> prixTotalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prixTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Commande, Commande, QAfterFilterCondition> prixTotalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prixTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Commande, Commande, QAfterFilterCondition> prixTotalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prixTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Commande, Commande, QAfterFilterCondition> prixTotalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prixTotal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension CommandeQueryObject
    on QueryBuilder<Commande, Commande, QFilterCondition> {}

extension CommandeQueryLinks
    on QueryBuilder<Commande, Commande, QFilterCondition> {
  QueryBuilder<Commande, Commande, QAfterFilterCondition> detailsCommandes(
      FilterQuery<DetailsCommande> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'detailsCommandes');
    });
  }

  QueryBuilder<Commande, Commande, QAfterFilterCondition>
      detailsCommandesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'detailsCommandes', length, true, length, true);
    });
  }

  QueryBuilder<Commande, Commande, QAfterFilterCondition>
      detailsCommandesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'detailsCommandes', 0, true, 0, true);
    });
  }

  QueryBuilder<Commande, Commande, QAfterFilterCondition>
      detailsCommandesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'detailsCommandes', 0, false, 999999, true);
    });
  }

  QueryBuilder<Commande, Commande, QAfterFilterCondition>
      detailsCommandesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'detailsCommandes', 0, true, length, include);
    });
  }

  QueryBuilder<Commande, Commande, QAfterFilterCondition>
      detailsCommandesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'detailsCommandes', length, include, 999999, true);
    });
  }

  QueryBuilder<Commande, Commande, QAfterFilterCondition>
      detailsCommandesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'detailsCommandes', lower, includeLower, upper, includeUpper);
    });
  }
}

extension CommandeQuerySortBy on QueryBuilder<Commande, Commande, QSortBy> {
  QueryBuilder<Commande, Commande, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Commande, Commande, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Commande, Commande, QAfterSortBy> sortByPrixTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prixTotal', Sort.asc);
    });
  }

  QueryBuilder<Commande, Commande, QAfterSortBy> sortByPrixTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prixTotal', Sort.desc);
    });
  }
}

extension CommandeQuerySortThenBy
    on QueryBuilder<Commande, Commande, QSortThenBy> {
  QueryBuilder<Commande, Commande, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Commande, Commande, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Commande, Commande, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Commande, Commande, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Commande, Commande, QAfterSortBy> thenByPrixTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prixTotal', Sort.asc);
    });
  }

  QueryBuilder<Commande, Commande, QAfterSortBy> thenByPrixTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prixTotal', Sort.desc);
    });
  }
}

extension CommandeQueryWhereDistinct
    on QueryBuilder<Commande, Commande, QDistinct> {
  QueryBuilder<Commande, Commande, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<Commande, Commande, QDistinct> distinctByPrixTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prixTotal');
    });
  }
}

extension CommandeQueryProperty
    on QueryBuilder<Commande, Commande, QQueryProperty> {
  QueryBuilder<Commande, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Commande, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<Commande, double, QQueryOperations> prixTotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prixTotal');
    });
  }
}

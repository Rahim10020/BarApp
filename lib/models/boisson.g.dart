// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boisson.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBoissonCollection on Isar {
  IsarCollection<Boisson> get boissons => this.collection();
}

const BoissonSchema = CollectionSchema(
  name: r'Boisson',
  id: 4544439462778932421,
  properties: {
    r'casiers': PropertySchema(
      id: 0,
      name: r'casiers',
      type: IsarType.long,
    ),
    r'modele': PropertySchema(
      id: 1,
      name: r'modele',
      type: IsarType.byte,
      enumMap: _BoissonmodeleEnumValueMap,
    ),
    r'nbBouteilleParCasier': PropertySchema(
      id: 2,
      name: r'nbBouteilleParCasier',
      type: IsarType.long,
    ),
    r'nom': PropertySchema(
      id: 3,
      name: r'nom',
      type: IsarType.string,
    ),
    r'prix': PropertySchema(
      id: 4,
      name: r'prix',
      type: IsarType.double,
    )
  },
  estimateSize: _boissonEstimateSize,
  serialize: _boissonSerialize,
  deserialize: _boissonDeserialize,
  deserializeProp: _boissonDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _boissonGetId,
  getLinks: _boissonGetLinks,
  attach: _boissonAttach,
  version: '3.1.0+1',
);

int _boissonEstimateSize(
  Boisson object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.nom.length * 3;
  return bytesCount;
}

void _boissonSerialize(
  Boisson object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.casiers);
  writer.writeByte(offsets[1], object.modele.index);
  writer.writeLong(offsets[2], object.nbBouteilleParCasier);
  writer.writeString(offsets[3], object.nom);
  writer.writeDouble(offsets[4], object.prix);
}

Boisson _boissonDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Boisson(
    casiers: reader.readLong(offsets[0]),
    modele: _BoissonmodeleValueEnumMap[reader.readByteOrNull(offsets[1])] ??
        Modele.petit,
    nbBouteilleParCasier: reader.readLong(offsets[2]),
    nom: reader.readString(offsets[3]),
    prix: reader.readDouble(offsets[4]),
  );
  object.id = id;
  return object;
}

P _boissonDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (_BoissonmodeleValueEnumMap[reader.readByteOrNull(offset)] ??
          Modele.petit) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _BoissonmodeleEnumValueMap = {
  'petit': 0,
  'grand': 1,
};
const _BoissonmodeleValueEnumMap = {
  0: Modele.petit,
  1: Modele.grand,
};

Id _boissonGetId(Boisson object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _boissonGetLinks(Boisson object) {
  return [];
}

void _boissonAttach(IsarCollection<dynamic> col, Id id, Boisson object) {
  object.id = id;
}

extension BoissonQueryWhereSort on QueryBuilder<Boisson, Boisson, QWhere> {
  QueryBuilder<Boisson, Boisson, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BoissonQueryWhere on QueryBuilder<Boisson, Boisson, QWhereClause> {
  QueryBuilder<Boisson, Boisson, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Boisson, Boisson, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterWhereClause> idBetween(
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

extension BoissonQueryFilter
    on QueryBuilder<Boisson, Boisson, QFilterCondition> {
  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> casiersEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'casiers',
        value: value,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> casiersGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'casiers',
        value: value,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> casiersLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'casiers',
        value: value,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> casiersBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'casiers',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> modeleEqualTo(
      Modele value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modele',
        value: value,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> modeleGreaterThan(
    Modele value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modele',
        value: value,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> modeleLessThan(
    Modele value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modele',
        value: value,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> modeleBetween(
    Modele lower,
    Modele upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modele',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition>
      nbBouteilleParCasierEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nbBouteilleParCasier',
        value: value,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition>
      nbBouteilleParCasierGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nbBouteilleParCasier',
        value: value,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition>
      nbBouteilleParCasierLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nbBouteilleParCasier',
        value: value,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition>
      nbBouteilleParCasierBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nbBouteilleParCasier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> nomEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> nomGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> nomLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> nomBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nom',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> nomStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> nomEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> nomContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> nomMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nom',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> nomIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nom',
        value: '',
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> nomIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nom',
        value: '',
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> prixEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prix',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> prixGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prix',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> prixLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prix',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterFilterCondition> prixBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prix',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension BoissonQueryObject
    on QueryBuilder<Boisson, Boisson, QFilterCondition> {}

extension BoissonQueryLinks
    on QueryBuilder<Boisson, Boisson, QFilterCondition> {}

extension BoissonQuerySortBy on QueryBuilder<Boisson, Boisson, QSortBy> {
  QueryBuilder<Boisson, Boisson, QAfterSortBy> sortByCasiers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'casiers', Sort.asc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> sortByCasiersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'casiers', Sort.desc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> sortByModele() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modele', Sort.asc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> sortByModeleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modele', Sort.desc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> sortByNbBouteilleParCasier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nbBouteilleParCasier', Sort.asc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy>
      sortByNbBouteilleParCasierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nbBouteilleParCasier', Sort.desc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> sortByNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.asc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> sortByNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.desc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> sortByPrix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prix', Sort.asc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> sortByPrixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prix', Sort.desc);
    });
  }
}

extension BoissonQuerySortThenBy
    on QueryBuilder<Boisson, Boisson, QSortThenBy> {
  QueryBuilder<Boisson, Boisson, QAfterSortBy> thenByCasiers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'casiers', Sort.asc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> thenByCasiersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'casiers', Sort.desc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> thenByModele() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modele', Sort.asc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> thenByModeleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modele', Sort.desc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> thenByNbBouteilleParCasier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nbBouteilleParCasier', Sort.asc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy>
      thenByNbBouteilleParCasierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nbBouteilleParCasier', Sort.desc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> thenByNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.asc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> thenByNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.desc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> thenByPrix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prix', Sort.asc);
    });
  }

  QueryBuilder<Boisson, Boisson, QAfterSortBy> thenByPrixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prix', Sort.desc);
    });
  }
}

extension BoissonQueryWhereDistinct
    on QueryBuilder<Boisson, Boisson, QDistinct> {
  QueryBuilder<Boisson, Boisson, QDistinct> distinctByCasiers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'casiers');
    });
  }

  QueryBuilder<Boisson, Boisson, QDistinct> distinctByModele() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modele');
    });
  }

  QueryBuilder<Boisson, Boisson, QDistinct> distinctByNbBouteilleParCasier() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nbBouteilleParCasier');
    });
  }

  QueryBuilder<Boisson, Boisson, QDistinct> distinctByNom(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nom', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Boisson, Boisson, QDistinct> distinctByPrix() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prix');
    });
  }
}

extension BoissonQueryProperty
    on QueryBuilder<Boisson, Boisson, QQueryProperty> {
  QueryBuilder<Boisson, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Boisson, int, QQueryOperations> casiersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'casiers');
    });
  }

  QueryBuilder<Boisson, Modele, QQueryOperations> modeleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modele');
    });
  }

  QueryBuilder<Boisson, int, QQueryOperations> nbBouteilleParCasierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nbBouteilleParCasier');
    });
  }

  QueryBuilder<Boisson, String, QQueryOperations> nomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nom');
    });
  }

  QueryBuilder<Boisson, double, QQueryOperations> prixProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prix');
    });
  }
}

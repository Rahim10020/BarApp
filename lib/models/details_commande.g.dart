// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'details_commande.dart';

// // **************************************************************************
// // IsarCollectionGenerator
// // **************************************************************************

// // coverage:ignore-file
// // ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

// extension GetDetailsCommandeCollection on Isar {
//   IsarCollection<DetailsCommande> get detailsCommandes => this.collection();
// }

// const DetailsCommandeSchema = CollectionSchema(
//   name: r'DetailsCommande',
//   id: 738492317490363922,
//   properties: {
//     r'nbCasiers': PropertySchema(
//       id: 0,
//       name: r'nbCasiers',
//       type: IsarType.long,
//     )
//   },
//   estimateSize: _detailsCommandeEstimateSize,
//   serialize: _detailsCommandeSerialize,
//   deserialize: _detailsCommandeDeserialize,
//   deserializeProp: _detailsCommandeDeserializeProp,
//   idName: r'id',
//   indexes: {},
//   links: {
//     r'boisson': LinkSchema(
//       id: -8009227233338799995,
//       name: r'boisson',
//       target: r'Boisson',
//       single: true,
//     )
//   },
//   embeddedSchemas: {},
//   getId: _detailsCommandeGetId,
//   getLinks: _detailsCommandeGetLinks,
//   attach: _detailsCommandeAttach,
//   version: '3.1.0+1',
// );

// int _detailsCommandeEstimateSize(
//   DetailsCommande object,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   var bytesCount = offsets.last;
//   return bytesCount;
// }

// void _detailsCommandeSerialize(
//   DetailsCommande object,
//   IsarWriter writer,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   writer.writeLong(offsets[0], object.nbCasiers);
// }

// DetailsCommande _detailsCommandeDeserialize(
//   Id id,
//   IsarReader reader,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   final object = DetailsCommande();
//   object.id = id;
//   object.nbCasiers = reader.readLong(offsets[0]);
//   return object;
// }

// P _detailsCommandeDeserializeProp<P>(
//   IsarReader reader,
//   int propertyId,
//   int offset,
//   Map<Type, List<int>> allOffsets,
// ) {
//   switch (propertyId) {
//     case 0:
//       return (reader.readLong(offset)) as P;
//     default:
//       throw IsarError('Unknown property with id $propertyId');
//   }
// }

// Id _detailsCommandeGetId(DetailsCommande object) {
//   return object.id;
// }

// List<IsarLinkBase<dynamic>> _detailsCommandeGetLinks(DetailsCommande object) {
//   return [object.boisson];
// }

// void _detailsCommandeAttach(
//     IsarCollection<dynamic> col, Id id, DetailsCommande object) {
//   object.id = id;
//   object.boisson.attach(col, col.isar.collection<Boisson>(), r'boisson', id);
// }

// extension DetailsCommandeQueryWhereSort
//     on QueryBuilder<DetailsCommande, DetailsCommande, QWhere> {
//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterWhere> anyId() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(const IdWhereClause.any());
//     });
//   }
// }

// extension DetailsCommandeQueryWhere
//     on QueryBuilder<DetailsCommande, DetailsCommande, QWhereClause> {
//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterWhereClause> idEqualTo(
//       Id id) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IdWhereClause.between(
//         lower: id,
//         upper: id,
//       ));
//     });
//   }

//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterWhereClause>
//       idNotEqualTo(Id id) {
//     return QueryBuilder.apply(this, (query) {
//       if (query.whereSort == Sort.asc) {
//         return query
//             .addWhereClause(
//               IdWhereClause.lessThan(upper: id, includeUpper: false),
//             )
//             .addWhereClause(
//               IdWhereClause.greaterThan(lower: id, includeLower: false),
//             );
//       } else {
//         return query
//             .addWhereClause(
//               IdWhereClause.greaterThan(lower: id, includeLower: false),
//             )
//             .addWhereClause(
//               IdWhereClause.lessThan(upper: id, includeUpper: false),
//             );
//       }
//     });
//   }

//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterWhereClause>
//       idGreaterThan(Id id, {bool include = false}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(
//         IdWhereClause.greaterThan(lower: id, includeLower: include),
//       );
//     });
//   }

//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterWhereClause> idLessThan(
//       Id id,
//       {bool include = false}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(
//         IdWhereClause.lessThan(upper: id, includeUpper: include),
//       );
//     });
//   }

//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterWhereClause> idBetween(
//     Id lowerId,
//     Id upperId, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IdWhereClause.between(
//         lower: lowerId,
//         includeLower: includeLower,
//         upper: upperId,
//         includeUpper: includeUpper,
//       ));
//     });
//   }
// }

// extension DetailsCommandeQueryFilter
//     on QueryBuilder<DetailsCommande, DetailsCommande, QFilterCondition> {
//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterFilterCondition>
//       idEqualTo(Id value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'id',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterFilterCondition>
//       idGreaterThan(
//     Id value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'id',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterFilterCondition>
//       idLessThan(
//     Id value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'id',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterFilterCondition>
//       idBetween(
//     Id lower,
//     Id upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'id',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//       ));
//     });
//   }

//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterFilterCondition>
//       nbCasiersEqualTo(int value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'nbCasiers',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterFilterCondition>
//       nbCasiersGreaterThan(
//     int value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'nbCasiers',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterFilterCondition>
//       nbCasiersLessThan(
//     int value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'nbCasiers',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterFilterCondition>
//       nbCasiersBetween(
//     int lower,
//     int upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'nbCasiers',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//       ));
//     });
//   }
// }

// extension DetailsCommandeQueryObject
//     on QueryBuilder<DetailsCommande, DetailsCommande, QFilterCondition> {}

// extension DetailsCommandeQueryLinks
//     on QueryBuilder<DetailsCommande, DetailsCommande, QFilterCondition> {
//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterFilterCondition> boisson(
//       FilterQuery<Boisson> q) {
//     return QueryBuilder.apply(this, (query) {
//       return query.link(q, r'boisson');
//     });
//   }

//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterFilterCondition>
//       boissonIsNull() {
//     return QueryBuilder.apply(this, (query) {
//       return query.linkLength(r'boisson', 0, true, 0, true);
//     });
//   }
// }

// extension DetailsCommandeQuerySortBy
//     on QueryBuilder<DetailsCommande, DetailsCommande, QSortBy> {
//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterSortBy>
//       sortByNbCasiers() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'nbCasiers', Sort.asc);
//     });
//   }

//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterSortBy>
//       sortByNbCasiersDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'nbCasiers', Sort.desc);
//     });
//   }
// }

// extension DetailsCommandeQuerySortThenBy
//     on QueryBuilder<DetailsCommande, DetailsCommande, QSortThenBy> {
//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterSortBy> thenById() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'id', Sort.asc);
//     });
//   }

//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterSortBy> thenByIdDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'id', Sort.desc);
//     });
//   }

//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterSortBy>
//       thenByNbCasiers() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'nbCasiers', Sort.asc);
//     });
//   }

//   QueryBuilder<DetailsCommande, DetailsCommande, QAfterSortBy>
//       thenByNbCasiersDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'nbCasiers', Sort.desc);
//     });
//   }
// }

// extension DetailsCommandeQueryWhereDistinct
//     on QueryBuilder<DetailsCommande, DetailsCommande, QDistinct> {
//   QueryBuilder<DetailsCommande, DetailsCommande, QDistinct>
//       distinctByNbCasiers() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'nbCasiers');
//     });
//   }
// }

// extension DetailsCommandeQueryProperty
//     on QueryBuilder<DetailsCommande, DetailsCommande, QQueryProperty> {
//   QueryBuilder<DetailsCommande, int, QQueryOperations> idProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'id');
//     });
//   }

//   QueryBuilder<DetailsCommande, int, QQueryOperations> nbCasiersProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'nbCasiers');
//     });
//   }
// }

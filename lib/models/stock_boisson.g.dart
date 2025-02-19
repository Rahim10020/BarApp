// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'stock_boisson.dart';

// // **************************************************************************
// // IsarCollectionGenerator
// // **************************************************************************

// // coverage:ignore-file
// // ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

// extension GetStockBoissonCollection on Isar {
//   IsarCollection<StockBoisson> get stockBoissons => this.collection();
// }

// const StockBoissonSchema = CollectionSchema(
//   name: r'StockBoisson',
//   id: 3341595352879883283,
//   properties: {
//     r'quantite': PropertySchema(
//       id: 0,
//       name: r'quantite',
//       type: IsarType.long,
//     )
//   },
//   estimateSize: _stockBoissonEstimateSize,
//   serialize: _stockBoissonSerialize,
//   deserialize: _stockBoissonDeserialize,
//   deserializeProp: _stockBoissonDeserializeProp,
//   idName: r'id',
//   indexes: {},
//   links: {
//     r'boisson': LinkSchema(
//       id: 619836013132124737,
//       name: r'boisson',
//       target: r'Boisson',
//       single: true,
//     )
//   },
//   embeddedSchemas: {},
//   getId: _stockBoissonGetId,
//   getLinks: _stockBoissonGetLinks,
//   attach: _stockBoissonAttach,
//   version: '3.1.0+1',
// );

// int _stockBoissonEstimateSize(
//   StockBoisson object,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   var bytesCount = offsets.last;
//   return bytesCount;
// }

// void _stockBoissonSerialize(
//   StockBoisson object,
//   IsarWriter writer,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   writer.writeLong(offsets[0], object.quantite);
// }

// StockBoisson _stockBoissonDeserialize(
//   Id id,
//   IsarReader reader,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   final object = StockBoisson();
//   object.id = id;
//   object.quantite = reader.readLong(offsets[0]);
//   return object;
// }

// P _stockBoissonDeserializeProp<P>(
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

// Id _stockBoissonGetId(StockBoisson object) {
//   return object.id;
// }

// List<IsarLinkBase<dynamic>> _stockBoissonGetLinks(StockBoisson object) {
//   return [object.boisson];
// }

// void _stockBoissonAttach(
//     IsarCollection<dynamic> col, Id id, StockBoisson object) {
//   object.id = id;
//   object.boisson.attach(col, col.isar.collection<Boisson>(), r'boisson', id);
// }

// extension StockBoissonQueryWhereSort
//     on QueryBuilder<StockBoisson, StockBoisson, QWhere> {
//   QueryBuilder<StockBoisson, StockBoisson, QAfterWhere> anyId() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(const IdWhereClause.any());
//     });
//   }
// }

// extension StockBoissonQueryWhere
//     on QueryBuilder<StockBoisson, StockBoisson, QWhereClause> {
//   QueryBuilder<StockBoisson, StockBoisson, QAfterWhereClause> idEqualTo(Id id) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IdWhereClause.between(
//         lower: id,
//         upper: id,
//       ));
//     });
//   }

//   QueryBuilder<StockBoisson, StockBoisson, QAfterWhereClause> idNotEqualTo(
//       Id id) {
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

//   QueryBuilder<StockBoisson, StockBoisson, QAfterWhereClause> idGreaterThan(
//       Id id,
//       {bool include = false}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(
//         IdWhereClause.greaterThan(lower: id, includeLower: include),
//       );
//     });
//   }

//   QueryBuilder<StockBoisson, StockBoisson, QAfterWhereClause> idLessThan(Id id,
//       {bool include = false}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(
//         IdWhereClause.lessThan(upper: id, includeUpper: include),
//       );
//     });
//   }

//   QueryBuilder<StockBoisson, StockBoisson, QAfterWhereClause> idBetween(
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

// extension StockBoissonQueryFilter
//     on QueryBuilder<StockBoisson, StockBoisson, QFilterCondition> {
//   QueryBuilder<StockBoisson, StockBoisson, QAfterFilterCondition> idEqualTo(
//       Id value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'id',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<StockBoisson, StockBoisson, QAfterFilterCondition> idGreaterThan(
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

//   QueryBuilder<StockBoisson, StockBoisson, QAfterFilterCondition> idLessThan(
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

//   QueryBuilder<StockBoisson, StockBoisson, QAfterFilterCondition> idBetween(
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

//   QueryBuilder<StockBoisson, StockBoisson, QAfterFilterCondition>
//       quantiteEqualTo(int value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'quantite',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<StockBoisson, StockBoisson, QAfterFilterCondition>
//       quantiteGreaterThan(
//     int value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'quantite',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<StockBoisson, StockBoisson, QAfterFilterCondition>
//       quantiteLessThan(
//     int value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'quantite',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<StockBoisson, StockBoisson, QAfterFilterCondition>
//       quantiteBetween(
//     int lower,
//     int upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'quantite',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//       ));
//     });
//   }
// }

// extension StockBoissonQueryObject
//     on QueryBuilder<StockBoisson, StockBoisson, QFilterCondition> {}

// extension StockBoissonQueryLinks
//     on QueryBuilder<StockBoisson, StockBoisson, QFilterCondition> {
//   QueryBuilder<StockBoisson, StockBoisson, QAfterFilterCondition> boisson(
//       FilterQuery<Boisson> q) {
//     return QueryBuilder.apply(this, (query) {
//       return query.link(q, r'boisson');
//     });
//   }

//   QueryBuilder<StockBoisson, StockBoisson, QAfterFilterCondition>
//       boissonIsNull() {
//     return QueryBuilder.apply(this, (query) {
//       return query.linkLength(r'boisson', 0, true, 0, true);
//     });
//   }
// }

// extension StockBoissonQuerySortBy
//     on QueryBuilder<StockBoisson, StockBoisson, QSortBy> {
//   QueryBuilder<StockBoisson, StockBoisson, QAfterSortBy> sortByQuantite() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'quantite', Sort.asc);
//     });
//   }

//   QueryBuilder<StockBoisson, StockBoisson, QAfterSortBy> sortByQuantiteDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'quantite', Sort.desc);
//     });
//   }
// }

// extension StockBoissonQuerySortThenBy
//     on QueryBuilder<StockBoisson, StockBoisson, QSortThenBy> {
//   QueryBuilder<StockBoisson, StockBoisson, QAfterSortBy> thenById() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'id', Sort.asc);
//     });
//   }

//   QueryBuilder<StockBoisson, StockBoisson, QAfterSortBy> thenByIdDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'id', Sort.desc);
//     });
//   }

//   QueryBuilder<StockBoisson, StockBoisson, QAfterSortBy> thenByQuantite() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'quantite', Sort.asc);
//     });
//   }

//   QueryBuilder<StockBoisson, StockBoisson, QAfterSortBy> thenByQuantiteDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'quantite', Sort.desc);
//     });
//   }
// }

// extension StockBoissonQueryWhereDistinct
//     on QueryBuilder<StockBoisson, StockBoisson, QDistinct> {
//   QueryBuilder<StockBoisson, StockBoisson, QDistinct> distinctByQuantite() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'quantite');
//     });
//   }
// }

// extension StockBoissonQueryProperty
//     on QueryBuilder<StockBoisson, StockBoisson, QQueryProperty> {
//   QueryBuilder<StockBoisson, int, QQueryOperations> idProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'id');
//     });
//   }

//   QueryBuilder<StockBoisson, int, QQueryOperations> quantiteProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'quantite');
//     });
//   }
// }

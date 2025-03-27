import 'package:hive/hive.dart';

part "id_counter.g.dart";

@HiveType(typeId: 10)
class IdCounter extends HiveObject {
  @HiveField(0)
  String entityType;

  @HiveField(1)
  int lastId;

  IdCounter({
    required this.entityType,
    required this.lastId,
  });
}

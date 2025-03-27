// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'id_counter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IdCounterAdapter extends TypeAdapter<IdCounter> {
  @override
  final int typeId = 10;

  @override
  IdCounter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IdCounter(
      entityType: fields[0] as String,
      lastId: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, IdCounter obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.entityType)
      ..writeByte(1)
      ..write(obj.lastId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdCounterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

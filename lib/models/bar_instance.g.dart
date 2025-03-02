// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bar_instance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BarInstanceAdapter extends TypeAdapter<BarInstance> {
  @override
  final int typeId = 6;

  @override
  BarInstance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BarInstance(
      id: fields[0] as int,
      nom: fields[1] as String,
      adresse: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BarInstance obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nom)
      ..writeByte(2)
      ..write(obj.adresse);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarInstanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

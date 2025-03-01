// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'casier.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CasierAdapter extends TypeAdapter<Casier> {
  @override
  final int typeId = 1;

  @override
  Casier read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Casier(
      id: fields[0] as int,
      boisson: fields[1] as Boisson,
      quantiteBoisson: fields[2] as int,
      dateCreation: fields[3] as DateTime,
      dateModification: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Casier obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.boisson)
      ..writeByte(2)
      ..write(obj.quantiteBoisson)
      ..writeByte(3)
      ..write(obj.dateCreation)
      ..writeByte(4)
      ..write(obj.dateModification);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CasierAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

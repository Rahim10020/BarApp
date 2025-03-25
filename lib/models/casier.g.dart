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
      boissonTotal: fields[2] as int,
      boissons: (fields[3] as List).cast<Boisson>(),
    );
  }

  @override
  void write(BinaryWriter writer, Casier obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.boissonTotal)
      ..writeByte(3)
      ..write(obj.boissons);
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refrigerateur.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RefrigerateurAdapter extends TypeAdapter<Refrigerateur> {
  @override
  final int typeId = 8;

  @override
  Refrigerateur read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Refrigerateur(
      id: fields[0] as int,
      boissonTotal: fields[1] as double,
      montantTotal: fields[2] as double,
      boissons: (fields[3] as List?)?.cast<Boisson>(),
    );
  }

  @override
  void write(BinaryWriter writer, Refrigerateur obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.boissonTotal)
      ..writeByte(2)
      ..write(obj.montantTotal)
      ..writeByte(3)
      ..write(obj.boissons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RefrigerateurAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boisson.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoissonAdapter extends TypeAdapter<Boisson> {
  @override
  final int typeId = 0;

  @override
  Boisson read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Boisson(
      id: fields[0] as int,
      nom: fields[1] as String?,
      prix: (fields[2] as List).cast<double>(),
      estFroid: fields[3] as bool,
      modele: fields[4] as Modele?,
      description: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Boisson obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nom)
      ..writeByte(2)
      ..write(obj.prix)
      ..writeByte(3)
      ..write(obj.estFroid)
      ..writeByte(4)
      ..write(obj.modele)
      ..writeByte(5)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoissonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      modele: fields[2] as Modele?,
      estFroid: fields[3] as bool,
      prix: (fields[4] as List).cast<double>(),
      stock: fields[6] as int,
      description: fields[5] as String?,
      imagePath: fields[7] as String,
      dateAjout: fields[8] as DateTime,
      dateModification: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Boisson obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nom)
      ..writeByte(2)
      ..write(obj.modele)
      ..writeByte(3)
      ..write(obj.estFroid)
      ..writeByte(4)
      ..write(obj.prix)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.stock)
      ..writeByte(7)
      ..write(obj.imagePath)
      ..writeByte(8)
      ..write(obj.dateAjout)
      ..writeByte(9)
      ..write(obj.dateModification);
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

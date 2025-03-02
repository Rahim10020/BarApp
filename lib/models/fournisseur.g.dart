// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fournisseur.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FournisseurAdapter extends TypeAdapter<Fournisseur> {
  @override
  final int typeId = 7;

  @override
  Fournisseur read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Fournisseur(
      id: fields[0] as int,
      nom: fields[1] as String,
      adresse: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Fournisseur obj) {
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
      other is FournisseurAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

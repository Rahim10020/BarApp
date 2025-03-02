// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ligne_vente.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LigneVenteAdapter extends TypeAdapter<LigneVente> {
  @override
  final int typeId = 2;

  @override
  LigneVente read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LigneVente(
      id: fields[0] as int,
      montant: fields[1] as double,
      boisson: fields[2] as Boisson,
    );
  }

  @override
  void write(BinaryWriter writer, LigneVente obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.montant)
      ..writeByte(2)
      ..write(obj.boisson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LigneVenteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

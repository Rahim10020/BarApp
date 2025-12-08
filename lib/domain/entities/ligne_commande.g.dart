// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ligne_commande.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LigneCommandeAdapter extends TypeAdapter<LigneCommande> {
  @override
  final int typeId = 3;

  @override
  LigneCommande read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LigneCommande(
      id: fields[0] as int,
      montant: fields[1] as double,
      casier: fields[2] as Casier,
    );
  }

  @override
  void write(BinaryWriter writer, LigneCommande obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.montant)
      ..writeByte(2)
      ..write(obj.casier);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LigneCommandeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

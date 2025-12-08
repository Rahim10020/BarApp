// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vente.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VenteAdapter extends TypeAdapter<Vente> {
  @override
  final int typeId = 4;

  @override
  Vente read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vente(
      id: fields[0] as int,
      montantTotal: fields[1] as double,
      dateVente: fields[2] as DateTime,
      lignesVente: (fields[3] as List).cast<LigneVente>(),
    );
  }

  @override
  void write(BinaryWriter writer, Vente obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.montantTotal)
      ..writeByte(2)
      ..write(obj.dateVente)
      ..writeByte(3)
      ..write(obj.lignesVente);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VenteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

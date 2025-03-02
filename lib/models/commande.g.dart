// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commande.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommandeAdapter extends TypeAdapter<Commande> {
  @override
  final int typeId = 5;

  @override
  Commande read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Commande(
      id: fields[0] as int,
      montantTotal: fields[1] as double,
      dateCommande: fields[2] as DateTime,
      lignesCommande: (fields[3] as List).cast<LigneCommande>(),
      barInstance: fields[4] as BarInstance,
    );
  }

  @override
  void write(BinaryWriter writer, Commande obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.montantTotal)
      ..writeByte(2)
      ..write(obj.dateCommande)
      ..writeByte(3)
      ..write(obj.lignesCommande)
      ..writeByte(4)
      ..write(obj.barInstance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommandeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

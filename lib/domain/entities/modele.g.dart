// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modele.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModeleAdapter extends TypeAdapter<Modele> {
  @override
  final int typeId = 9;

  @override
  Modele read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Modele.petit;
      case 1:
        return Modele.grand;
      default:
        return Modele.petit;
    }
  }

  @override
  void write(BinaryWriter writer, Modele obj) {
    switch (obj) {
      case Modele.petit:
        writer.writeByte(0);
        break;
      case Modele.grand:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModeleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

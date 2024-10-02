// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class notsAdapter extends TypeAdapter<nots> {
  @override
  final int typeId = 1;

  @override
  nots read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return nots(
      title: fields[0] as String,
      discription: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, nots obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.discription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is notsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

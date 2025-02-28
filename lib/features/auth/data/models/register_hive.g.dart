// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RegisterEntityAdapter extends TypeAdapter<RegisterEntity> {
  @override
  final int typeId = 0;

  @override
  RegisterEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RegisterEntity(
      name: fields[0] as String,
      phone: fields[1] as String,
      email: fields[2] as String,
      joinedOn: fields[3] as String,
      uid: fields[4] as String,
      fcmToken: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RegisterEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.joinedOn)
      ..writeByte(4)
      ..write(obj.uid)
      ..writeByte(5)
      ..write(obj.fcmToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisterEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

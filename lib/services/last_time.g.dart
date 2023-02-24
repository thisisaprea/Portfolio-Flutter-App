
part of 'last_time.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************





class LastTimeAdapter extends TypeAdapter<LastTime> {
  @override
  final int typeId = 0;

  @override
  LastTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LastTime()
      ..food = fields[0] as String
      ..category = fields[1] as String
      ..createdDate = fields[2] as DateTime
      ..timeStamp = (fields[3] as List).cast<DateTime>();
  }

  @override
  void write(BinaryWriter writer, LastTime obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.food)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.createdDate)
      ..writeByte(3)
      ..write(obj.timeStamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LastTimeAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
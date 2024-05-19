// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 1;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as int?,
      title: fields[1] as String,
      description: fields[2] as String?,
      createdAt: fields[3] as DateTime,
      lastUpdated: fields[4] as DateTime,
      isComplete: fields[5] as bool,
      priority: fields[6] as Priority,
      dueDate: fields[7] as DateTime?,
      startDate: fields[8] as DateTime?,
      reminder: fields[12] as DateTime?,
      notes: fields[10] as String?,
    )..subtasks = (fields[11] as List).cast<Subtask>();
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.lastUpdated)
      ..writeByte(5)
      ..write(obj.isComplete)
      ..writeByte(6)
      ..write(obj.priority)
      ..writeByte(7)
      ..write(obj.dueDate)
      ..writeByte(8)
      ..write(obj.startDate)
      ..writeByte(12)
      ..write(obj.reminder)
      ..writeByte(10)
      ..write(obj.notes)
      ..writeByte(11)
      ..write(obj.subtasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubtaskAdapter extends TypeAdapter<Subtask> {
  @override
  final int typeId = 2;

  @override
  Subtask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subtask(
      isComplete: fields[0] as bool,
      title: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Subtask obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.isComplete)
      ..writeByte(1)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubtaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      isComplete: json['isComplete'] as bool? ?? false,
      priority: $enumDecodeNullable(_$PriorityEnumMap, json['priority']) ??
          Priority.medium,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      reminder: json['reminder'] == null
          ? null
          : DateTime.parse(json['reminder'] as String),
      notes: json['notes'] as String?,
    )..subtasks = (json['subtasks'] as List<dynamic>)
        .map((e) => Subtask.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'isComplete': instance.isComplete,
      'priority': _$PriorityEnumMap[instance.priority]!,
      'dueDate': instance.dueDate?.toIso8601String(),
      'startDate': instance.startDate?.toIso8601String(),
      'reminder': instance.reminder?.toIso8601String(),
      'notes': instance.notes,
      'subtasks': instance.subtasks,
    };

const _$PriorityEnumMap = {
  Priority.low: 'low',
  Priority.medium: 'medium',
  Priority.high: 'high',
};

Subtask _$SubtaskFromJson(Map<String, dynamic> json) => Subtask(
      isComplete: json['isComplete'] as bool? ?? false,
      title: json['title'] as String,
    );

Map<String, dynamic> _$SubtaskToJson(Subtask instance) => <String, dynamic>{
      'isComplete': instance.isComplete,
      'title': instance.title,
    };

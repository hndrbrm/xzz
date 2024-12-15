// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../../bytes_helper/int_helper.dart';
import '../../../bytes_helper/iterator_helper.dart';
import '../../../bytes_helper/list_helper.dart';
import '../../../serializable/jsonable.dart';
import '../../../serializable/serializable.dart';
import '../../packet/string_packet.dart';

sealed class Component implements Serializable {
  const Component();

  int get type;
}

final class UnknownComponent extends Component {
  const UnknownComponent._(this.raw);

  final List<int> raw;

  static const id = 1;

  @override
  int get type => id;

  @override
  List<int> toBytes() => raw;

  @override
  JsonMap toJson() => { 'raw': raw }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is UnknownComponent &&
    listEqual(other.raw, raw);

  @override
  int get hashCode => Object.hashAll(raw);
}

final class LineComponent extends Component {
  const LineComponent._(this.raw);

  final List<int> raw;

  static const id = 5;

  @override
  int get type => id;

  @override
  List<int> toBytes() => raw;

  @override
  JsonMap toJson() => { 'raw': raw }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is LineComponent &&
    listEqual(other.raw, raw);

  @override
  int get hashCode => Object.hashAll(raw);
}

final class LabelComponent extends Component {
  const LabelComponent._(this.raw);

  final List<int> raw;

  static const id = 6;

  @override
  int get type => id;

  @override
  List<int> toBytes() => raw;

  @override
  JsonMap toJson() => { 'raw': raw }.toJsonMap();
  
  @override
  bool operator ==(Object other) =>
    other is LabelComponent &&
    listEqual(other.raw, raw);

  @override
  int get hashCode => Object.hashAll(raw);
}

final class PinComponent extends Component {
  const PinComponent._({
    required this.unknown1,
    required this.x,
    required this.y,
    required this.unknown2,
    required this.name,
    required this.unknown3,
    required this.netIndex,
    required this.unknown4,
  });

  final int unknown1;
  final int x;
  final int y;
  final List<int> unknown2;
  final String name;
  final List<int> unknown3;
  final int netIndex;
  final List<int> unknown4;

  static const id = 9;

  @override
  int get type => id;

  @override
  List<int> toBytes() => [
    ...unknown1.toUint32List(),
    ...x.toUint32List(),
    ...y.toUint32List(),
    ...unknown2,
    ...name.toStringPacket().toBytes(),
    ...unknown3,
    ...netIndex.toUint32List(),
    ...unknown4,
  ];

  @override
  JsonMap toJson() => {
    'unknown1': unknown1,
    'x': x,
    'y': y,
    'unknown2': unknown2,
    'name': name,
    'unknown3': unknown3,
    'netIndex': netIndex,
    'unknown4': unknown4,
  }.toJsonMap();
  
  @override
  bool operator ==(Object other) =>
    other is PinComponent &&
    other.unknown1 == unknown1 &&
    other.x == x &&
    other.y == y &&
    listEqual(other.unknown2, unknown2) &&
    other.name == name &&
    listEqual(other.unknown3, unknown3) &&
    other.netIndex == netIndex &&
    listEqual(other.unknown4, unknown4);

  @override
  int get hashCode => Object.hash(
    unknown1,
    x,
    y,
    Object.hashAll(unknown2),
    name,
    Object.hashAll(unknown3),
    netIndex,
    Object.hashAll(unknown4),
  );
}

extension ComponentIterator on Iterator<int> {
  PinComponent toPinComponent() => PinComponent._(
    unknown1: read(4).toUint32(),
    x: read(4).toUint32(),
    y: read(4).toUint32(),
    unknown2: read(8),
    name: toStringPacket()!.string,
    unknown3: read(32),
    netIndex: read(4).toUint32(),
    unknown4: read(8),
  );
}

extension ComponentJsonMap on JsonMap {
  UnknownComponent toUnknownComponent() => toObject().toUnknownComponent();
  LineComponent toLineComponent() => toObject().toLineComponent();
  LabelComponent toLabelComponent() => toObject().toLabelComponent();
  PinComponent toPinComponent() => toObject().toPinComponent();
}

extension ComponentList on List<int> {
  UnknownComponent toUnknownComponent() => UnknownComponent._(this);
  LineComponent toLineComponent() => LineComponent._(this);
  LabelComponent toLabelComponent() => LabelComponent._(this);
  PinComponent toPinComponent() => iterator.toPinComponent();
}

extension ComponentMap on Map<String, Object?> {
  UnknownComponent toUnknownComponent() => UnknownComponent._(
    (this['raw']! as List<Object?>).toBytes(),
  );
  LineComponent toLineComponent() => LineComponent._(
    (this['raw']! as List<Object?>).toBytes(),
  );
  LabelComponent toLabelComponent() => LabelComponent._(
    (this['raw']! as List<Object?>).toBytes(),
  );
  PinComponent toPinComponent() => PinComponent._(
    unknown1: this['unknown1']! as int,
    x: this['x']! as int,
    y: this['y']! as int,
    unknown2: (this['unknown2']! as List<Object?>).toBytes(),
    name: this['name']! as String,
    unknown3: (this['unknown3']! as List<Object?>).toBytes(),
    netIndex: this['netIndex']! as int,
    unknown4: (this['unknown4']! as List<Object?>).toBytes(),
  );
}

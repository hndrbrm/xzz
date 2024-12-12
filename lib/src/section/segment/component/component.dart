// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../../bytes_helper/int_helper.dart';
import '../../../bytes_helper/iterator_helper.dart';
import '../../../bytes_helper/list_helper.dart';
import '../../../serializable.dart';
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
  List<int> toByte() => raw;

  @override
  Map<String, dynamic> toMap() => {
    'raw': raw,
  };
}

final class LineComponent extends Component {
  const LineComponent._(this.raw);

  final List<int> raw;

  static const id = 5;

  @override
  int get type => id;

  @override
  List<int> toByte() => raw;

  @override
  Map<String, dynamic> toMap() => {
    'raw': raw,
  };
}

final class LabelComponent extends Component {
  const LabelComponent._(this.raw);

  final List<int> raw;

  static const id = 6;

  @override
  int get type => id;

  @override
  List<int> toByte() => raw;

  @override
  Map<String, dynamic> toMap() => {
    'raw': raw,
  };
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
  List<int> toByte() => [
    ...unknown1.toUint32List(),
    ...x.toUint32List(),
    ...y.toUint32List(),
    ...unknown2,
    ...name.toStringPacket().toByte(),
    ...unknown3,
    ...netIndex.toUint32List(),
    ...unknown4,
  ];

  @override
  Map<String, dynamic> toMap() => {
    'unknown1': unknown1,
    'x': x,
    'y': y,
    'unknown2': unknown2,
    'name': name,
    'unknown3': unknown3,
    'netIndex': netIndex,
    'unknown4': unknown4,
  };
}

extension ComponentIterator on Iterator<int> {
  PinComponent toPinComponent() => PinComponent._(
    unknown1: read(4).toUint32(),
    x: read(4).toUint32(),
    y: read(4).toUint32(),
    unknown2: read(8),
    name: toStringPacket().string,
    unknown3: read(32),
    netIndex: read(4).toUint32(),
    unknown4: read(8),
  );
}

extension ComponentMap on Map<String, dynamic> {
  UnknownComponent toUnknownComponent() => UnknownComponent._(this['raw']);
  LineComponent toLineComponent() => LineComponent._(this['raw']);
  LabelComponent toLabelComponent() => LabelComponent._(this['raw']);
  PinComponent toPinComponent() => PinComponent._(
    unknown1: this['unknown1'],
    x: this['x'],
    y: this['y'],
    unknown2: this['unknown2'],
    name: this['name'],
    unknown3: this['unknown3'],
    netIndex: this['netIndex'],
    unknown4: this['unknown4'],
  );
}

extension ComponentList on List<int> {
  UnknownComponent toUnknownComponent() => UnknownComponent._(this);
  LineComponent toLineComponent() => LineComponent._(this);
  LabelComponent toLabelComponent() => LabelComponent._(this);
  PinComponent toPinComponent() => iterator.toPinComponent();
}

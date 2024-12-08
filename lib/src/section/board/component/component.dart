// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import '../../../shareable/int_helper.dart';
import '../../../shareable/iterator_helper.dart';
import '../../../shareable/list_helper.dart';
import '../../../shareable/serializer.dart';
import 'component_packet.dart';

sealed class Component implements Serializer {
  const Component();

  int get _id;

  ComponentPacket get packet => ComponentPacket(
    id: _id,
    content: serialize(),
  );
}

final class UnknownComponent extends Component {
  const UnknownComponent.deserialize(this.raw);

  final List<int> raw;

  static const id = 1;

  @override
  int get _id => id;

  @override
  List<int> serialize() => raw;
}

final class LineComponent extends Component {
  const LineComponent.deserialize(this.raw);

  final List<int> raw;

  static const id = 5;

  @override
  int get _id => id;

  @override
  List<int> serialize() => raw;
}

final class LabelComponent extends Component {
  const LabelComponent.deserialize(this.raw);

  final List<int> raw;

  static const id = 6;

  @override
  int get _id => id;

  @override
  List<int> serialize() => raw;
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

  factory PinComponent.deserialize(Iterator<int> iterator) {
    final unknown1 = iterator.read(4).toUint32();
    final x = iterator.read(4).toUint32();
    final y = iterator.read(4).toUint32();
    final unknown2 = iterator.read(8);
    final nameLength = iterator.read(4).toUint32();
    final name = iterator.read(nameLength).toString8();
    final unknown3 = iterator.read(32);
    final netIndex = iterator.read(4).toUint32();
    final unknown4 = iterator.read(8);

    return PinComponent._(
      unknown1: unknown1,
      x: x,
      y: y,
      unknown2: unknown2,
      name: name,
      unknown3: unknown3,
      netIndex: netIndex,
      unknown4: unknown4,
    );
  }

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
  int get _id => id;

  @override
  List<int> serialize() => [
    ...unknown1.toUint32List(),
    ...x.toUint32List(),
    ...y.toUint32List(),
    ...unknown2,
    ...name.length.toUint32List(),
    ...utf8.encode(name),
    ...unknown3,
    ...netIndex.toUint32List(),
    ...unknown4,
  ];
}

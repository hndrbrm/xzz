// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../../bytes_helper/int_helper.dart';
import '../../../bytes_helper/iterator_helper.dart';
import '../../../bytes_helper/list_helper.dart';
import '../../../serializer.dart';
import '../../packet/string_packet.dart';
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
  PinComponent.deserialize(Iterator<int> iterator)
  : unknown1 = iterator.read(4).toUint32(),
    x = iterator.read(4).toUint32(),
    y = iterator.read(4).toUint32(),
    unknown2 = iterator.read(8),
    name = StringPacket.deserialize(iterator).string,
    unknown3 = iterator.read(32),
    netIndex = iterator.read(4).toUint32(),
    unknown4 = iterator.read(8);

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
    ...name.toPacket().serialize(),
    ...unknown3,
    ...netIndex.toUint32List(),
    ...unknown4,
  ];
}

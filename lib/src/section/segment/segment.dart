// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'package:dart_des/dart_des.dart';

import '../../bytes_helper/int_helper.dart';
import '../../bytes_helper/iterator_helper.dart';
import '../../bytes_helper/list_helper.dart';
import '../../bytes_helper/string_helper.dart';
import '../../serializer.dart';
import '../packet/length_packet.dart';
import '../packet/string_packet.dart';
import 'component/component.dart';
import 'component/component_packet.dart';
import 'segment_packet.dart';

sealed class Segment implements Serializer {
  const Segment();

  int get _id;

  SegmentPacket get packet =>
      SegmentPacket(
      id: _id,
      content: serialize(),
    );
}

/// Possible [layer] value:
/// * 1 ~ 16  (Trace Layers)
///   Used in order excluding last which always uses 16, ie 1, 2, 3, 4, 16.
/// * 17      (Silkscreen)
/// * 18 ~ 27 (Unknown)
/// * 28      (Board edges
final class ArcSegment extends Segment {
  ArcSegment.deserialize(Iterator<int> iterator)
  : layer = iterator.read(4).toUint32(),
    x = iterator.read(4).toUint32(),
    y = iterator.read(4).toUint32(),
    r = iterator.read(4).toInt32(),
    startAngle = iterator.read(4).toInt32(),
    endAngle = iterator.read(4).toInt32(),
    scale = iterator.read(4).toInt32(),
    unknown = iterator.read(4).toInt32();

  final int layer;
  final int x;
  final int y;
  final int r;
  final int startAngle;
  final int endAngle;
  final int scale;
  final int unknown;

  static const id = 1;

  @override
  int get _id => id;

  @override
  List<int> serialize() => [
    ...layer.toUint32List(),
    ...x.toUint32List(),
    ...y.toUint32List(),
    ...r.toInt32List(),
    ...startAngle.toInt32List(),
    ...endAngle.toInt32List(),
    ...scale.toInt32List(),
    ...unknown.toInt32List(),
  ];
}

final class ViaSegment extends Segment {
  ViaSegment.deserialize(Iterator<int> iterator)
  : x = iterator.read(4).toInt32(),
    y = iterator.read(4).toInt32(),
    layerARadius = iterator.read(4).toInt32(),
    layerBRadius = iterator.read(4).toInt32(),
    layerAIndex = iterator.read(4).toUint32(),
    layerBIndex = iterator.read(4).toUint32(),
    netIndex = iterator.read(4).toUint32(),
    name = StringPacket.deserialize(iterator).string;

  final int x;
  final int y;
  final int layerARadius;
  final int layerBRadius;
  final int layerAIndex;
  final int layerBIndex;
  final int netIndex;
  final String name;

  static const id = 2;

  @override
  int get _id => id;

  @override
  List<int> serialize() => [
    ...x.toInt32List(),
    ...y.toInt32List(),
    ...layerARadius.toInt32List(),
    ...layerBRadius.toInt32List(),
    ...layerAIndex.toUint32List(),
    ...layerBIndex.toUint32List(),
    ...netIndex.toUint32List(),
    ...name.toPacket().serialize(),
  ];
}

final class UnknownSegment extends Segment {
  UnknownSegment.deserialize(Iterator<int> iterator)
  : unknown1 = iterator.read(4).toUint32(),
    centerX = iterator.read(4).toUint32(),
    centerY = iterator.read(4).toUint32(),
    bottomLeftX = iterator.read(4).toUint32(),
    bottomLeftY = iterator.read(4).toUint32(),
    topRightX = iterator.read(4).toUint32(),
    topRightY = iterator.read(4).toUint32(),
    unknown2 = iterator.read(4).toUint32(),
    unknown3 = iterator.read(4).toUint32();

  final int unknown1;
  final int centerX;
  final int centerY;
  final int bottomLeftX;
  final int bottomLeftY;
  final int topRightX;
  final int topRightY;
  final int unknown2;
  final int unknown3;

  static const id = 3;

  @override
  int get _id => id;

  @override
  List<int> serialize() => [
    ...unknown1.toUint32List(),
    ...centerX.toUint32List(),
    ...centerY.toUint32List(),
    ...bottomLeftX.toUint32List(),
    ...bottomLeftY.toUint32List(),
    ...topRightX.toUint32List(),
    ...topRightY.toUint32List(),
    ...unknown2.toUint32List(),
    ...unknown3.toUint32List(),
  ];
}

final class LineSegment extends Segment {
  LineSegment.deserialize(Iterator<int> iterator)
  : layer = iterator.read(4).toUint32(),
    x1 = iterator.read(4).toInt32(),
    y1 = iterator.read(4).toInt32(),
    x2 = iterator.read(4).toInt32(),
    y2 = iterator.read(4).toInt32(),
    scale = iterator.read(4).toInt32(),
    traceNetIndex = iterator.read(4).toUint32();

  final int layer;
  final int x1;
  final int y1;
  final int x2;
  final int y2;
  final int scale;
  final int traceNetIndex;

  static const id = 5;

  @override
  int get _id => id;

  @override
  List<int> serialize() => [
    ...layer.toUint32List(),
    ...x1.toInt32List(),
    ...y1.toInt32List(),
    ...x2.toInt32List(),
    ...y2.toInt32List(),
    ...scale.toInt32List(),
    ...traceNetIndex.toUint32List(),
  ];
}

final class TextSegment extends Segment {
  TextSegment.deserialize(Iterator<int> iterator)
  : unknown1 = iterator.read(4).toUint32(),
    positionX = iterator.read(4).toUint32(),
    positionY = iterator.read(4).toUint32(),
    size = iterator.read(4).toUint32(),
    divider = iterator.read(4).toUint32(),
    empty = iterator.read(4).toUint32(),
    one = iterator.read(2).toUint16(),
    text = StringPacket.deserialize(iterator).string;

  final int unknown1;
  final int positionX;
  final int positionY;
  final int size;
  final int divider;
  final int empty;
  final int one;
  final String text;

  static const id = 6;

  @override
  int get _id => id;

  @override
  List<int> serialize() => [
    ...unknown1.toUint32List(),
    ...positionX.toUint32List(),
    ...positionY.toUint32List(),
    ...size.toUint32List(),
    ...divider.toUint32List(),
    ...empty.toUint32List(),
    ...one.toUint16List(),
    ...text.length.toUint32List(),
    ...text.toString8List(),
  ];
}

final class ComponentSegment extends Segment {
  const ComponentSegment._({
    required this.unknown1,
    required this.description,
    required this.unknown2,
    required this.name,
    required this.parts,
  });

  factory ComponentSegment.deserialize(List<int> list) {
    final plain = _des.decrypt(list);
    final iterator1 = plain.iterator;

    var offset = 0;

    final packet = LengthPacket.deserialize(iterator1);
    final iterator2 = packet.content.iterator;
    offset += 4;

    final unknown1 = iterator2.read(18);
    final description = StringPacket.deserialize(iterator2).string;
    final unknown2 = iterator2.read(31);
    final name = StringPacket.deserialize(iterator2).string;
    offset += 18 + 4 + description.length + 31 + 4 + name.length;

    final components = <Component>[];

    for (; offset < packet.content.length; ) {
      final container = ComponentPacket.deserialize(iterator2);
      components.add(container.silk);
      offset += container.serialize().length;
    }

    return ComponentSegment._(
      unknown1: unknown1,
      description: description,
      unknown2: unknown2,
      name: name,
      parts: components,
    );
  }

  final List<int> unknown1;
  final String description;
  final List<int> unknown2;
  final String name;
  final List<Component> parts;

  static const int id = 7;

  static final _des = DES(
    key: [ 0xdc, 0xfc, 0x12, 0xac, 0x00, 0x00, 0x00, 0x00 ],
    paddingType: DESPaddingType.None,
  );

  List<int> _fillWithZero(List<int> list) {
    final remainder = 8 - (list.length % 8);
    return [
      ...list,
      if (remainder < 8)
      ...List.filled(remainder, 0),
    ];
  }

  @override
  int get _id => id;

  @override
  List<int> serialize() {
    final bytes = [
      ...unknown1,
      ...description.length.toUint32List(),
      ...description.toString8List(),
      ...unknown2,
      ...name.length.toUint32List(),
      ...name.toString8List(),
      for (final part in parts)
      ...part.packet.serialize(),
    ].toLengthPacket().serialize();

    return _des.encrypt(_fillWithZero(bytes));
  }
}

final class PadSegment extends Segment {
  PadSegment.deserialize(Iterator<int> iterator)
  : number = iterator.read(4).toUint32(),
    originX = iterator.read(4).toUint32(),
    originY = iterator.read(4).toUint32(),
    innerDiameter = iterator.read(4).toUint32(),
    unknown1 = iterator.read(4).toUint32(),
    name = StringPacket.deserialize(iterator).string,
    outerWidth1 = iterator.read(4).toUint32(),
    outerHeight1 = iterator.read(4).toUint32(),
    flag1 = iterator.read(1).first,
    outerWidth2 = iterator.read(4).toUint32(),
    outerHeight2 = iterator.read(4).toUint32(),
    flag2 = iterator.read(1).first,
    outerWidth3 = iterator.read(4).toUint32(),
    outerHeight3 = iterator.read(4).toUint32(),
    flag3 = iterator.read(1).first,
    unknown2 = iterator.read(4).toUint32(),
    flag4 = iterator.read(1).first,
    netIndex = iterator.read(4).toUint32();

  final int number;
  final int originX;
  final int originY;
  final int innerDiameter;
  final int unknown1;
  final String name;
  final int outerWidth1;
  final int outerHeight1;
  final int flag1;
  final int outerWidth2;
  final int outerHeight2;
  final int flag2;
  final int outerWidth3;
  final int outerHeight3;
  final int flag3;
  final int unknown2;
  final int flag4;
  final int netIndex;

  static const id = 9;

  @override
  int get _id => number;

  @override
  List<int> serialize() => [
    ...number.toUint32List(),
    ...originX.toUint32List(),
    ...originY.toUint32List(),
    ...innerDiameter.toUint32List(),
    ...unknown1.toUint32List(),
    ...name.length.toUint32List(),
    ...name.toString8List(),
    ...outerWidth1.toUint32List(),
    ...outerHeight1.toUint32List(),
    flag1,
    ...outerWidth2.toUint32List(),
    ...outerHeight2.toUint32List(),
    flag2,
    ...outerWidth3.toUint32List(),
    ...outerHeight3.toUint32List(),
    flag3,
    ...unknown2.toUint32List(),
    flag4,
    ...netIndex.toUint32List(),
  ];
}

// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:dart_des/dart_des.dart';

import '../../../shareable/int_helper.dart';
import '../../../shareable/iterator_helper.dart';
import '../../../shareable/list_helper.dart';
import '../../../shareable/serializer.dart';
import '../component/component.dart';
import '../component/component_packet.dart';
import '../length_packet.dart';
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
  const ViaSegment._({
    required this.x,
    required this.y,
    required this.layerARadius,
    required this.layerBRadius,
    required this.layerAIndex,
    required this.layerBIndex,
    required this.netIndex,
    required this.name,
  });

  factory ViaSegment.deserialize(Iterator<int> iterator) {
    final x = iterator.read(4).toInt32();
    final y = iterator.read(4).toInt32();
    final layerARadius = iterator.read(4).toInt32();
    final layerBRadius = iterator.read(4).toInt32();
    final layerAIndex = iterator.read(4).toUint32();
    final layerBIndex = iterator.read(4).toUint32();
    final netIndex = iterator.read(4).toUint32();
    final nameLength = iterator.read(4).toUint32();
    final name = iterator.read(nameLength).toString8();

    return ViaSegment._(
      x: x,
      y: y,
      layerARadius: layerARadius,
      layerBRadius: layerBRadius,
      layerAIndex: layerAIndex,
      layerBIndex: layerBIndex,
      netIndex: netIndex,
      name: name,
    );
  }

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
    ...name.length.toUint32List(),
    ...utf8.encode(name),
  ];
}

final class UnknownSegment extends Segment {
  const UnknownSegment._({
    required this.unknown1,
    required this.centerX,
    required this.centerY,
    required this.bottomLeftX,
    required this.bottomLeftY,
    required this.topRightX,
    required this.topRightY,
    required this.unknown2,
    required this.unknown3,
  });

  factory UnknownSegment.deserialize(Iterator<int> iterator) {
    final unknown1 = iterator.read(4).toUint32();
    final centerX = iterator.read(4).toUint32();
    final centerY = iterator.read(4).toUint32();
    final bottomLeftX = iterator.read(4).toUint32();
    final bottomLeftY = iterator.read(4).toUint32();
    final topRightX = iterator.read(4).toUint32();
    final topRightY = iterator.read(4).toUint32();
    final unknown2 = iterator.read(4).toUint32();
    final unknown3 = iterator.read(4).toUint32();

    return UnknownSegment._(
      unknown1: unknown1,
      centerX: centerX,
      centerY: centerY,
      bottomLeftX: bottomLeftX,
      bottomLeftY: bottomLeftY,
      topRightX: topRightX,
      topRightY: topRightY,
      unknown2: unknown2,
      unknown3: unknown3,
    );
  }

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
  const TextSegment._({
    required this.unknown1,
    required this.positionX,
    required this.positionY,
    required this.size,
    required this.divider,
    required this.empty,
    required this.one,
    required this.text,
  });

  factory TextSegment.deserialize(Iterator<int> iterator) {
    final unknown1 = iterator.read(4).toUint32();
    final positionX = iterator.read(4).toUint32();
    final positionY = iterator.read(4).toUint32();
    final size = iterator.read(4).toUint32();
    final divider = iterator.read(4).toUint32();
    final empty = iterator.read(4).toUint32();
    final one = iterator.read(2).toUint16();
    final textLength = iterator.read(4).toUint32();
    final text = iterator.read(textLength).toString8();

    return TextSegment._(
      unknown1: unknown1,
      positionX: positionX,
      positionY: positionY,
      size: size,
      divider: divider,
      empty: empty,
      one: one,
      text: text,
    );
  }

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
    ...utf8.encode(text),
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
    final descriptionLength = iterator2.read(4).toUint32();
    final description = iterator2.read(descriptionLength).toString8();
    final unknown2 = iterator2.read(31);
    final nameLength = iterator2.read(4).toUint32();
    final name = iterator2.read(nameLength).toString8();
    offset += 18 + 4 + descriptionLength + 31 + 4 + nameLength;

    final parts = <Component>[];

    for (; offset < packet.content.length; ) {
      final container = ComponentPacket.deserialize(iterator2);
      parts.add(container.silk);
      offset += container.serialize().length;
    }

    return ComponentSegment._(
      unknown1: unknown1,
      description: description,
      unknown2: unknown2,
      name: name,
      parts: parts,
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
    final bytes = LengthPacket([
      ...unknown1,
      ...description.length.toUint32List(),
      ...utf8.encode(description),
      ...unknown2,
      ...name.length.toUint32List(),
      ...utf8.encode(name),
      for (final part in parts)
      ...part.packet.serialize(),
    ]).serialize();

    return _des.encrypt(_fillWithZero(bytes));
  }
}

final class PadSegment extends Segment {
  const PadSegment._({
    required this.number,
    required this.originX,
    required this.originY,
    required this.innerDiameter,
    required this.unknown1,
    required this.name,
    required this.outerWidth1,
    required this.outerHeight1,
    required this.flag1,
    required this.outerWidth2,
    required this.outerHeight2,
    required this.flag2,
    required this.outerWidth3,
    required this.outerHeight3,
    required this.flag3,
    required this.unknown2,
    required this.flag4,
    required this.netIndex,
  });

  factory PadSegment.deserialize(Iterator<int> iterator) {
    final number = iterator.read(4).toUint32();
    final originX = iterator.read(4).toUint32();
    final originY = iterator.read(4).toUint32();
    final innerDiameter = iterator.read(4).toUint32();
    final unknown1 = iterator.read(4).toUint32();
    final nameLength = iterator.read(4).toUint32();
    final name = iterator.read(nameLength).toString8();
    final outerWidth1 = iterator.read(4).toUint32();
    final outerHeight1 = iterator.read(4).toUint32();
    final flag1 = iterator.read(1).first;
    final outerWidth2 = iterator.read(4).toUint32();
    final outerHeight2 = iterator.read(4).toUint32();
    final flag2 = iterator.read(1).first;
    final outerWidth3 = iterator.read(4).toUint32();
    final outerHeight3 = iterator.read(4).toUint32();
    final flag3 = iterator.read(1).first;
    final unknown2 = iterator.read(4).toUint32();
    final flag4 = iterator.read(1).first;
    final netIndex = iterator.read(4).toUint32();

    return PadSegment._(
      number: number,
      originX: originX,
      originY: originY,
      innerDiameter: innerDiameter,
      unknown1: unknown1,
      name: name,
      outerWidth1: outerWidth1,
      outerHeight1: outerHeight1,
      flag1: flag1,
      outerWidth2: outerWidth2,
      outerHeight2: outerHeight2,
      flag2: flag2,
      outerWidth3: outerWidth3,
      outerHeight3: outerHeight3,
      flag3: flag3,
      unknown2: unknown2,
      flag4: flag4,
      netIndex: netIndex,
    );
  }

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
    ...utf8.encode(name),
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

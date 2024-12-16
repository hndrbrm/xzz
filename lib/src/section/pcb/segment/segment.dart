// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'package:dart_des/dart_des.dart';

import '../../../bytes_helper/int_helper.dart';
import '../../../bytes_helper/iterator_helper.dart';
import '../../../bytes_helper/list_helper.dart';
import '../../../serializable/byteable.dart';
import '../../../serializable/jsonable.dart';
import '../../../serializable/serializable.dart';
import '../../packet/length_packet.dart';
import '../../packet/string_packet.dart';
import 'component/component.dart';
import 'component/component_packet.dart';

sealed class Segment implements Serializable {
  const Segment();

  int get type;
}

/// Possible [layer] value:
/// * 1 ~ 16  (Trace Layers)
///   Used in order excluding last which always uses 16, ie 1, 2, 3, 4, 16.
/// * 17      (Silkscreen)
/// * 18 ~ 27 (Unknown)
/// * 28      (Board edges
final class ArcSegment extends Segment {
  const ArcSegment._({
    required this.layer,
    required this.x,
    required this.y,
    required this.r,
    required this.startAngle,
    required this.endAngle,
    required this.scale,
    required this.unknown,
  });

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
  int get type => id;

  @override
  List<int> toBytes() => [
    ...layer.toUint32List(),
    ...x.toUint32List(),
    ...y.toUint32List(),
    ...r.toInt32List(),
    ...startAngle.toInt32List(),
    ...endAngle.toInt32List(),
    ...scale.toInt32List(),
    ...unknown.toInt32List(),
  ];

  @override
  JsonMap toJson() => {
    'layer': layer,
    'x': x,
    'y': y,
    'r': r,
    'startAngle': startAngle,
    'endAngle': endAngle,
    'scale': scale,
    'unknown': unknown,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is ArcSegment &&
    other.layer == layer &&
    other.x == x &&
    other.y == y &&
    other.r == r &&
    other.startAngle == startAngle &&
    other.endAngle == endAngle &&
    other.scale == scale &&
    other.unknown == unknown;

  @override
  int get hashCode => Object.hash(
    layer,
    x,
    y,
    r,
    startAngle,
    endAngle,
    scale,
    unknown,
  );
}

final class ViaSegment extends Segment {
  ViaSegment._({
    required this.x,
    required this.y,
    required this.layerARadius,
    required this.layerBRadius,
    required this.layerAIndex,
    required this.layerBIndex,
    required this.netIndex,
    this.name,
  });
  
  final int x;
  final int y;
  final int layerARadius;
  final int layerBRadius;
  final int layerAIndex;
  final int layerBIndex;
  final int netIndex;
  final String? name;

  static const id = 2;

  @override
  int get type => id;

  @override
  List<int> toBytes() => [
    ...x.toInt32List(),
    ...y.toInt32List(),
    ...layerARadius.toInt32List(),
    ...layerBRadius.toInt32List(),
    ...layerAIndex.toUint32List(),
    ...layerBIndex.toUint32List(),
    ...netIndex.toUint32List(),
    if (name != null)
    ...name!.toStringPacket().toBytes(),
  ];

  @override
  JsonMap toJson() => {
    'x': x,
    'y': y,
    'layerARadius': layerARadius,
    'layerBRadius': layerBRadius,
    'layerAIndex': layerAIndex,
    'layerBIndex': layerBIndex,
    'netIndex': netIndex,
    if (name != null)
    'name': name,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is ViaSegment &&
    other.x == x &&
    other.y == y &&
    other.layerARadius == layerARadius &&
    other.layerBRadius == layerBRadius &&
    other.layerAIndex == layerAIndex &&
    other.layerBIndex == layerBIndex &&
    other.netIndex == netIndex &&
    other.name == name;

  @override
  int get hashCode => Object.hash(
    x,
    y,
    layerARadius,
    layerBRadius,
    layerAIndex,
    layerBIndex,
    netIndex,
    name,
  );
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
  int get type => id;

  @override
  List<int> toBytes() => [
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

  @override
  JsonMap toJson() => {
    'unknown1': unknown1,
    'centerX': centerX,
    'centerY': centerY,
    'bottomLeftX': bottomLeftX,
    'bottomLeftY': bottomLeftY,
    'topRightX': topRightX,
    'topRightY': topRightY,
    'unknown2': unknown2,
    'unknown3': unknown3,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is UnknownSegment &&
    other.unknown1 == unknown1 &&
    other.centerX == centerX &&
    other.centerY == centerY &&
    other.bottomLeftX == bottomLeftX &&
    other.bottomLeftY == bottomLeftY &&
    other.topRightX == topRightX &&
    other.topRightY == topRightY &&
    other.unknown2 == unknown2 &&
    other.unknown3 == unknown3;

  @override
  int get hashCode => Object.hash(
    unknown1,
    centerX,
    centerY,
    bottomLeftX,
    bottomLeftY,
    topRightX,
    topRightY,
    unknown2,
    unknown3,
  );
}

final class LineSegment extends Segment {
  const LineSegment._({
    required this.layer,
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.scale,
    required this.traceNetIndex,
  });
  
  final int layer;
  final int x1;
  final int y1;
  final int x2;
  final int y2;
  final int scale;
  final int traceNetIndex;

  static const id = 5;

  @override
  int get type => id;

  @override
  List<int> toBytes() => [
    ...layer.toUint32List(),
    ...x1.toInt32List(),
    ...y1.toInt32List(),
    ...x2.toInt32List(),
    ...y2.toInt32List(),
    ...scale.toInt32List(),
    ...traceNetIndex.toUint32List(),
  ];

  @override
  JsonMap toJson() => {
    'layer': layer,
    'x1': x1,
    'y1': y1,
    'x2': x2,
    'y2': y2,
    'scale': scale,
    'traceNetIndex': traceNetIndex,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is LineSegment &&
    other.layer == layer &&
    other.x1 == x1 &&
    other.y1 == y1 &&
    other.x2 == x2 &&
    other.y2 == y2 &&
    other.scale == scale &&
    other.traceNetIndex == traceNetIndex;

  @override
  int get hashCode => Object.hash(
    layer,
    x1,
    y1,
    x2,
    y2,
    scale,
    traceNetIndex,
  );
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
  int get type => id;

  @override
  List<int> toBytes() => [
    ...unknown1.toUint32List(),
    ...positionX.toUint32List(),
    ...positionY.toUint32List(),
    ...size.toUint32List(),
    ...divider.toUint32List(),
    ...empty.toUint32List(),
    ...one.toUint16List(),
    ...text.toStringPacket().toBytes(),
  ];

  @override
  JsonMap toJson() => {
    'unknown1': unknown1,
    'positionX': positionX,
    'positionY': positionY,
    'size': size,
    'divider': divider,
    'empty': empty,
    'one': one,
    'text': text,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is TextSegment &&
    other.unknown1 == unknown1 &&
    other.positionX == positionX &&
    other.positionY == positionY &&
    other.size == size &&
    other.divider == divider &&
    other.empty == empty &&
    other.one == one &&
    other.text == text;

  @override
  int get hashCode => Object.hash(
    unknown1,
    positionX,
    positionY,
    size,
    divider,
    empty,
    one,
    text,
  );
}

final class ComponentSegment extends Segment {
  const ComponentSegment._({
    required this.unknown1,
    required this.description,
    required this.unknown2,
    required this.name,
    required this.components,
  });

  final List<int> unknown1;
  final String description;
  final List<int> unknown2;
  final String name;
  final List<Component> components;

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
  int get type => id;

  @override
  List<int> toBytes() {
    final bytes = [
      ...unknown1,
      ...description.toStringPacket().toBytes(),
      ...unknown2,
      ...name.toStringPacket().toBytes(),
      for (final component in components)
      ...component.toComponentPacket().toBytes(),
    ].toBytesable().toLengthPacket().toBytes();

    return _des.encrypt(_fillWithZero(bytes));
  }

  @override
  JsonMap toJson() => {
    'unknown1': unknown1,
    'description': description,
    'unknown2': unknown2,
    'name': name,
    'components': components
      .map((e) => e.toComponentPacket().toJson())
      .toList(),
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is ComponentSegment &&
    listEqual(other.unknown1, unknown1) &&
    other.description == description &&
    listEqual(other.unknown2, unknown2) &&
    other.name == name &&
    listEqual(other.components, components);

  @override
  int get hashCode => Object.hash(
    Object.hashAll(unknown1),
    description,
    Object.hashAll(unknown2),
    name,
    Object.hashAll(components),
  );

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
  int get type => number;

  @override
  List<int> toBytes() => [
    ...number.toUint32List(),
    ...originX.toUint32List(),
    ...originY.toUint32List(),
    ...innerDiameter.toUint32List(),
    ...unknown1.toUint32List(),
    ...name.toStringPacket().toBytes(),
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

  @override
  JsonMap toJson() => {
    'number': number,
    'originX': originX,
    'originY': originY,
    'innerDiameter': innerDiameter,
    'unknown1': unknown1,
    'name': name,
    'outerWidth1': outerWidth1,
    'outerHeight1': outerHeight1,
    'flag1': flag1,
    'outerWidth2': outerWidth2,
    'outerHeight2': outerHeight2,
    'flag2': flag2,
    'outerWidth3': outerWidth3,
    'outerHeight3': outerHeight3,
    'flag3': flag3,
    'unknown2': unknown2,
    'flag4': flag4,
    'netIndex': netIndex,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is PadSegment &&
    other.number == number &&
    other.originX == originX &&
    other.originY == originY &&
    other.innerDiameter == innerDiameter &&
    other.unknown1 == unknown1 &&
    other.name == name &&
    other.outerWidth1 == outerWidth1 &&
    other.outerHeight1 == outerHeight1 &&
    other.flag1 == flag1 &&
    other.outerWidth2 == outerWidth2 &&
    other.outerHeight2 == outerHeight2 &&
    other.flag2 == flag2 &&
    other.outerWidth3 == outerWidth3 &&
    other.outerHeight3 == outerHeight3 &&
    other.flag3 == flag3 &&
    other.unknown2 == unknown2 &&
    other.flag4 == flag4 &&
    other.netIndex == netIndex;

  @override
  int get hashCode => Object.hash(
    number,
    originX,
    originY,
    innerDiameter,
    unknown1,
    name,
    outerWidth1,
    outerHeight1,
    flag1,
    outerWidth2,
    outerHeight2,
    flag2,
    outerWidth3,
    outerHeight3,
    flag3,
    unknown2,
    flag4,
    netIndex,
  );
}

extension SegmentIterator on Iterator<int> {
  ArcSegment toArcSegment() => ArcSegment._(
    layer: read(4).toUint32(),
    x: read(4).toUint32(),
    y: read(4).toUint32(),
    r: read(4).toInt32(),
    startAngle: read(4).toInt32(),
    endAngle: read(4).toInt32(),
    scale: read(4).toInt32(),
    unknown: read(4).toInt32(),
  );
  ViaSegment toViaSegment() => ViaSegment._(
    x: read(4).toInt32(),
    y: read(4).toInt32(),
    layerARadius: read(4).toInt32(),
    layerBRadius: read(4).toInt32(),
    layerAIndex: read(4).toUint32(),
    layerBIndex: read(4).toUint32(),
    netIndex: read(4).toUint32(),
    name: toStringPacket()?.string,
  );
  UnknownSegment toUnknownSegment() => UnknownSegment._(
    unknown1: read(4).toUint32(),
    centerX: read(4).toUint32(),
    centerY: read(4).toUint32(),
    bottomLeftX: read(4).toUint32(),
    bottomLeftY: read(4).toUint32(),
    topRightX: read(4).toUint32(),
    topRightY: read(4).toUint32(),
    unknown2: read(4).toUint32(),
    unknown3: read(4).toUint32(),
  );
  LineSegment toLineSegment() => LineSegment._(
    layer: read(4).toUint32(),
    x1: read(4).toInt32(),
    y1: read(4).toInt32(),
    x2: read(4).toInt32(),
    y2: read(4).toInt32(),
    scale: read(4).toInt32(),
    traceNetIndex: read(4).toUint32(),
  );
  TextSegment toTextSegment() => TextSegment._(
    unknown1: read(4).toUint32(),
    positionX: read(4).toUint32(),
    positionY: read(4).toUint32(),
    size: read(4).toUint32(),
    divider: read(4).toUint32(),
    empty: read(4).toUint32(),
    one: read(2).toUint16(),
    text: toStringPacket()!.string,
  );
  PadSegment toPadSegment() => PadSegment._(
    number: read(4).toUint32(),
    originX: read(4).toUint32(),
    originY: read(4).toUint32(),
    innerDiameter: read(4).toUint32(),
    unknown1: read(4).toUint32(),
    name: toStringPacket()!.string,
    outerWidth1: read(4).toUint32(),
    outerHeight1: read(4).toUint32(),
    flag1: read(1).first,
    outerWidth2: read(4).toUint32(),
    outerHeight2: read(4).toUint32(),
    flag2: read(1).first,
    outerWidth3: read(4).toUint32(),
    outerHeight3: read(4).toUint32(),
    flag3: read(1).first,
    unknown2: read(4).toUint32(),
    flag4: read(1).first,
    netIndex: read(4).toUint32(),
  );
}

extension SegmentJsonMap on JsonMap {
  ArcSegment toArcSegment() => toObject().toArcSegment();
  ViaSegment toViaSegment() => toObject().toViaSegment();
  UnknownSegment toUnknownSegment() => toObject().toUnknownSegment();
  LineSegment toLineSegment() => toObject().toLineSegment();
  TextSegment toTextSegment() => toObject().toTextSegment();
  ComponentSegment toComponentSegment() => toObject().toComponentSegment();
  PadSegment toPadSegment() => toObject().toPadSegment();
}

extension SegmentMap on Map<String, Object?> {
  ArcSegment toArcSegment() => ArcSegment._(
    layer: this['layer']! as int,
    x: this['x']! as int,
    y: this['y']! as int,
    r: this['r']! as int,
    startAngle: this['startAngle']! as int,
    endAngle: this['endAngle']! as int,
    scale: this['scale']! as int,
    unknown: this['unknown']! as int,
  );
  ViaSegment toViaSegment() => ViaSegment._(
    x: this['x']! as int,
    y: this['y']! as int,
    layerARadius: this['layerARadius']! as int,
    layerBRadius: this['layerBRadius']! as int,
    layerAIndex: this['layerAIndex']! as int,
    layerBIndex: this['layerBIndex']! as int,
    netIndex: this['netIndex']! as int,
    name: this['name'] as String?,
  );
  UnknownSegment toUnknownSegment() => UnknownSegment._(
    unknown1: this['unknown1']! as int,
    centerX: this['centerX']! as int,
    centerY: this['centerY']! as int,
    bottomLeftX: this['bottomLeftX']! as int,
    bottomLeftY: this['bottomLeftY']! as int,
    topRightX: this['topRightX']! as int,
    topRightY: this['topRightY']! as int,
    unknown2: this['unknown2']! as int,
    unknown3: this['unknown3']! as int,
  );
  LineSegment toLineSegment() => LineSegment._(
    layer: this['layer']! as int,
    x1: this['x1']! as int,
    y1: this['y1']! as int,
    x2: this['x2']! as int,
    y2: this['y2']! as int,
    scale: this['scale']! as int,
    traceNetIndex: this['traceNetIndex']! as int,
  );
  TextSegment toTextSegment() => TextSegment._(
    unknown1: this['unknown1']! as int,
    positionX: this['positionX']! as int,
    positionY: this['positionY']! as int,
    size: this['size']! as int,
    divider: this['divider']! as int,
    empty: this['empty']! as int,
    one: this['one']! as int,
    text: this['text']! as String,
  );
  ComponentSegment toComponentSegment() => ComponentSegment._(
    unknown1: (this['unknown1']! as List<Object?>).toBytes(),
    description: this['description']! as String,
    unknown2: (this['unknown2']! as List<Object?>).toBytes(),
    name: this['name']! as String,
    components: (this['components']! as List<Object?>)
      .map((e) => e! as Map<String, Object?>)
      .map((e) => e.toComponentPacket().toComponent())
      .toList()
  );
  PadSegment toPadSegment() => PadSegment._(
    number: this['number']! as int,
    originX: this['originX']! as int,
    originY: this['originY']! as int,
    innerDiameter: this['innerDiameter']! as int,
    unknown1: this['unknown1']! as int,
    name: this['name']! as String,
    outerWidth1: this['outerWidth1']! as int,
    outerHeight1: this['outerHeight1']! as int,
    flag1: this['flag1']! as int,
    outerWidth2: this['outerWidth2']! as int,
    outerHeight2: this['outerHeight2']! as int,
    flag2: this['flag2']! as int,
    outerWidth3: this['outerWidth3']! as int,
    outerHeight3: this['outerHeight3']! as int,
    flag3: this['flag3']! as int,
    unknown2: this['unknown2']! as int,
    flag4: this['flag4']! as int,
    netIndex: this['netIndex']! as int,
  );
}

extension SegmentList on List<int> {
  ComponentSegment toComponentSegment() {
    final plain = ComponentSegment._des.decrypt(this);
    final iterator1 = plain.iterator;

    var offset = 0;

    final packet = iterator1.toLengthPacket()!.content.toBytes();
    final iterator2 = packet.iterator;
    offset += 4;

    final unknown1 = iterator2.read(18);
    final description = iterator2.toStringPacket()!.string;
    final unknown2 = iterator2.read(31);
    final name = iterator2.toStringPacket()!.string;
    offset += 18 + 4 + description.length + 31 + 4 + name.length;

    final components = <Component>[];

    for (; offset < packet.length; ) {
      final packet = iterator2.toComponentPacket();
      components.add(packet.toComponent());
      offset += packet.toBytes().length;
    }

    return ComponentSegment._(
      unknown1: unknown1,
      description: description,
      unknown2: unknown2,
      name: name,
      components: components,
    );
  }
}

// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'package:dart_des/dart_des.dart';

import '../../bytes_helper/int_helper.dart';
import '../../bytes_helper/iterator_helper.dart';
import '../../bytes_helper/list_helper.dart';
import '../../serializable.dart';
import '../packet/length_packet.dart';
import '../packet/string_packet.dart';
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
  List<int> toByte() => [
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
  Map<String, dynamic> toMap() => {
    'layer': layer,
    'x': x,
    'y': y,
    'r': r,
    'startAngle': startAngle,
    'endAngle': endAngle,
    'scale': scale,
    'unknown': unknown,
  };
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
    required this.name,
  });
  
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
  int get type => id;

  @override
  List<int> toByte() => [
    ...x.toInt32List(),
    ...y.toInt32List(),
    ...layerARadius.toInt32List(),
    ...layerBRadius.toInt32List(),
    ...layerAIndex.toUint32List(),
    ...layerBIndex.toUint32List(),
    ...netIndex.toUint32List(),
    ...name.toStringPacket().toByte(),
  ];

  @override
  Map<String, dynamic> toMap() => {
    'x': x,
    'y': y,
    'layerARadius': layerARadius,
    'layerBRadius': layerBRadius,
    'layerAIndex': layerAIndex,
    'layerBIndex': layerBIndex,
    'netIndex': netIndex,
    'name': name,
  };
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
  List<int> toByte() => [
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
  Map<String, dynamic> toMap() => {
    'unknown1': unknown1,
    'centerX': centerX,
    'centerY': centerY,
    'bottomLeftX': bottomLeftX,
    'bottomLeftY': bottomLeftY,
    'topRightX': topRightX,
    'topRightY': topRightY,
    'unknown2': unknown2,
    'unknown3': unknown3,
  };
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
  List<int> toByte() => [
    ...layer.toUint32List(),
    ...x1.toInt32List(),
    ...y1.toInt32List(),
    ...x2.toInt32List(),
    ...y2.toInt32List(),
    ...scale.toInt32List(),
    ...traceNetIndex.toUint32List(),
  ];

  @override
  Map<String, dynamic> toMap() => {
    'layer': layer,
    'x1': x1,
    'y1': y1,
    'x2': x2,
    'y2': y2,
    'scale': scale,
    'traceNetIndex': traceNetIndex,
  };
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
  List<int> toByte() => [
    ...unknown1.toUint32List(),
    ...positionX.toUint32List(),
    ...positionY.toUint32List(),
    ...size.toUint32List(),
    ...divider.toUint32List(),
    ...empty.toUint32List(),
    ...one.toUint16List(),
    ...text.toStringPacket().toByte(),
  ];

  @override
  Map<String, dynamic> toMap() => {
    'unknown1': unknown1,
    'positionX': positionX,
    'positionY': positionY,
    'size': size,
    'divider': divider,
    'empty': empty,
    'one': one,
    'text': text,
  };
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
  List<int> toByte() {
    final bytes = [
      ...unknown1,
      ...description.toStringPacket().toByte(),
      ...unknown2,
      ...name.toStringPacket().toByte(),
      for (final component in components)
      ...component.toComponentPacket().toByte(),
    ].toLengthPacket().toByte();

    return _des.encrypt(_fillWithZero(bytes));
  }

  @override
  Map<String, dynamic> toMap() => {
    'unknown1': unknown1,
    'description': description,
    'unknown2': unknown2,
    'name': name,
    'components': components.map((e) => e.toMap()),
  };
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
  List<int> toByte() => [
    ...number.toUint32List(),
    ...originX.toUint32List(),
    ...originY.toUint32List(),
    ...innerDiameter.toUint32List(),
    ...unknown1.toUint32List(),
    ...name.toStringPacket().toByte(),
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
  Map<String, dynamic> toMap() => {
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
  };
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
    name: toStringPacket().string,
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
    text: toStringPacket().string,
  );
  PadSegment toPadSegment() => PadSegment._(
    number: read(4).toUint32(),
    originX: read(4).toUint32(),
    originY: read(4).toUint32(),
    innerDiameter: read(4).toUint32(),
    unknown1: read(4).toUint32(),
    name: toStringPacket().string,
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

extension SegmentMap on Map<String, dynamic> {
  ArcSegment toArcSegment() => ArcSegment._(
    layer: this['layer'],
    x: this['x'],
    y: this['y'],
    r: this['r'],
    startAngle: this['startAngle'],
    endAngle: this['endAngle'],
    scale: this['scale'],
    unknown: this['unknown'],
  );
  ViaSegment toViaSegment() => ViaSegment._(
    x: this['x'],
    y: this['y'],
    layerARadius: this['layerARadius'],
    layerBRadius: this['layerBRadius'],
    layerAIndex: this['layerAIndex'],
    layerBIndex: this['layerBIndex'],
    netIndex: this['netIndex'],
    name: this['name'],
  );
  UnknownSegment toUnknownSegment() => UnknownSegment._(
    unknown1: this['unknown1'],
    centerX: this['centerX'],
    centerY: this['centerY'],
    bottomLeftX: this['bottomLeftX'],
    bottomLeftY: this['bottomLeftY'],
    topRightX: this['topRightX'],
    topRightY: this['topRightY'],
    unknown2: this['unknown2'],
    unknown3: this['unknown3'],
  );
  LineSegment toLineSegment() => LineSegment._(
    layer: this['layer'],
    x1: this['x1'],
    y1: this['y1'],
    x2: this['x2'],
    y2: this['y2'],
    scale: this['scale'],
    traceNetIndex: this['traceNetIndex'],
  );
  TextSegment toTextSegment() => TextSegment._(
    unknown1: this['unknown1'],
    positionX: this['positionX'],
    positionY: this['positionY'],
    size: this['size'],
    divider: this['divider'],
    empty: this['empty'],
    one: this['one'],
    text: this['text'],
  );
  ComponentSegment toComponentSegment() => ComponentSegment._(
    unknown1: this['unknown1'],
    description: this['description'],
    unknown2: this['unknown2'],
    name: this['name'],
    components: (this['components'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .map((e) => e.toComponent())
      .toList()
  );
  PadSegment toPadSegment() => PadSegment._(
    number: this['number'],
    originX: this['originX'],
    originY: this['originY'],
    innerDiameter: this['innerDiameter'],
    unknown1: this['unknown1'],
    name: this['name'],
    outerWidth1: this['outerWidth1'],
    outerHeight1: this['outerHeight1'],
    flag1: this['flag1'],
    outerWidth2: this['outerWidth2'],
    outerHeight2: this['outerHeight2'],
    flag2: this['flag2'],
    outerWidth3: this['outerWidth3'],
    outerHeight3: this['outerHeight3'],
    flag3: this['flag3'],
    unknown2: this['unknown2'],
    flag4: this['flag4'],
    netIndex: this['netIndex'],
  );
}

extension SegmentList on List<int> {
  ComponentSegment toComponentSegment() {
    final plain = ComponentSegment._des.decrypt(this);
    final iterator1 = plain.iterator;

    var offset = 0;

    final packet = iterator1.toLengthPacket().content.toByte();
    final iterator2 = packet.iterator;
    offset += 4;

    final unknown1 = iterator2.read(18);
    final description = iterator2.toStringPacket().string;
    final unknown2 = iterator2.read(31);
    final name = iterator2.toStringPacket().string;
    offset += 18 + 4 + description.length + 31 + 4 + name.length;

    final components = <Component>[];

    for (; offset < packet.length; ) {
      final packet = iterator2.toComponentPacket();
      components.add(packet.toComponent());
      offset += packet.toByte().length;
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

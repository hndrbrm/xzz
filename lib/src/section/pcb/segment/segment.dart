// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'package:dart_des/dart_des.dart';

import '../../../bytes_helper/int_helper.dart';
import '../../../bytes_helper/list_helper.dart';
import '../../../serializable/bytes.dart';
import '../../../serializable/bytesable.dart';
import '../../../serializable/jsonable.dart';
import '../../packet/length_packet.dart';
import '../../packet/string_packet.dart';
import 'component/component.dart';
import 'component/component_packet.dart';

sealed class Segment implements Bytesable, Jsonable {
  const Segment();

  int get type;
}

/// Possible [_layer] value:
/// * 1 ~ 16  (Trace Layers)
///   Used in order excluding last which always uses 16, ie 1, 2, 3, 4, 16.
/// * 17      (Silkscreen)
/// * 18 ~ 27 (Unknown)
/// * 28      (Board edges
final class ArcSegment extends Segment {
  const ArcSegment._({
    required int layer,
    required int x,
    required int y,
    required int r,
    required int startAngle,
    required int endAngle,
    required int scale,
    required int unknown,
  })
  : _layer = layer,
    _x = x,
    _y = y,
    _r = r,
    _startAngle = startAngle,
    _endAngle = endAngle,
    _scale = scale,
    _unknown = unknown;

  final int _layer;
  final int _x;
  final int _y;
  final int _r;
  final int _startAngle;
  final int _endAngle;
  final int _scale;
  final int _unknown;

  static const id = 1;

  @override
  int get type => id;

  @override
  Bytes toBytes() => [
    ..._layer.toUint32List(),
    ..._x.toUint32List(),
    ..._y.toUint32List(),
    ..._r.toInt32List(),
    ..._startAngle.toInt32List(),
    ..._endAngle.toInt32List(),
    ..._scale.toInt32List(),
    ..._unknown.toInt32List(),
  ];

  @override
  JsonMap toJson() => {
    'layer': _layer,
    'x': _x,
    'y': _y,
    'r': _r,
    'startAngle': _startAngle,
    'endAngle': _endAngle,
    'scale': _scale,
    'unknown': _unknown,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is ArcSegment &&
    other._layer == _layer &&
    other._x == _x &&
    other._y == _y &&
    other._r == _r &&
    other._startAngle == _startAngle &&
    other._endAngle == _endAngle &&
    other._scale == _scale &&
    other._unknown == _unknown;

  @override
  int get hashCode => Object.hash(
    _layer,
    _x,
    _y,
    _r,
    _startAngle,
    _endAngle,
    _scale,
    _unknown,
  );
}

final class ViaSegment extends Segment {
  ViaSegment._({
    required int x,
    required int y,
    required int layerARadius,
    required int layerBRadius,
    required int layerAIndex,
    required int layerBIndex,
    required int netIndex,
    String? name,
  })
  : _x = x,
    _y = y,
    _layerARadius = layerARadius,
    _layerBRadius = layerBRadius,
    _layerAIndex = layerAIndex,
    _layerBIndex = layerBIndex,
    _netIndex = netIndex,
    _name = name;
  
  final int _x;
  final int _y;
  final int _layerARadius;
  final int _layerBRadius;
  final int _layerAIndex;
  final int _layerBIndex;
  final int _netIndex;
  final String? _name;

  static const id = 2;

  @override
  int get type => id;

  @override
  Bytes toBytes() => [
    ..._x.toInt32List(),
    ..._y.toInt32List(),
    ..._layerARadius.toInt32List(),
    ..._layerBRadius.toInt32List(),
    ..._layerAIndex.toUint32List(),
    ..._layerBIndex.toUint32List(),
    ..._netIndex.toUint32List(),
    if (_name != null)
    ..._name.toStringPacket().toBytes(),
  ];

  @override
  JsonMap toJson() => {
    'x': _x,
    'y': _y,
    'layerARadius': _layerARadius,
    'layerBRadius': _layerBRadius,
    'layerAIndex': _layerAIndex,
    'layerBIndex': _layerBIndex,
    'netIndex': _netIndex,
    if (_name != null)
    'name': _name,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is ViaSegment &&
    other._x == _x &&
    other._y == _y &&
    other._layerARadius == _layerARadius &&
    other._layerBRadius == _layerBRadius &&
    other._layerAIndex == _layerAIndex &&
    other._layerBIndex == _layerBIndex &&
    other._netIndex == _netIndex &&
    other._name == _name;

  @override
  int get hashCode => Object.hash(
    _x,
    _y,
    _layerARadius,
    _layerBRadius,
    _layerAIndex,
    _layerBIndex,
    _netIndex,
    _name,
  );
}

final class UnknownSegment extends Segment {
  const UnknownSegment._({
    required int unknown1,
    required int centerX,
    required int centerY,
    required int bottomLeftX,
    required int bottomLeftY,
    required int topRightX,
    required int topRightY,
    required int unknown2,
    required int unknown3,
  })
  : _unknown1 = unknown1,
    _centerX = centerX,
    _centerY = centerY,
    _bottomLeftX = bottomLeftX,
    _bottomLeftY = bottomLeftY,
    _topRightX = topRightX,
    _topRightY = topRightY,
    _unknown2 = unknown2,
    _unknown3 = unknown3;

  final int _unknown1;
  final int _centerX;
  final int _centerY;
  final int _bottomLeftX;
  final int _bottomLeftY;
  final int _topRightX;
  final int _topRightY;
  final int _unknown2;
  final int _unknown3;

  static const id = 3;

  @override
  int get type => id;

  @override
  Bytes toBytes() => [
    ..._unknown1.toUint32List(),
    ..._centerX.toUint32List(),
    ..._centerY.toUint32List(),
    ..._bottomLeftX.toUint32List(),
    ..._bottomLeftY.toUint32List(),
    ..._topRightX.toUint32List(),
    ..._topRightY.toUint32List(),
    ..._unknown2.toUint32List(),
    ..._unknown3.toUint32List(),
  ];

  @override
  JsonMap toJson() => {
    'unknown1': _unknown1,
    'centerX': _centerX,
    'centerY': _centerY,
    'bottomLeftX': _bottomLeftX,
    'bottomLeftY': _bottomLeftY,
    'topRightX': _topRightX,
    'topRightY': _topRightY,
    'unknown2': _unknown2,
    'unknown3': _unknown3,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is UnknownSegment &&
    other._unknown1 == _unknown1 &&
    other._centerX == _centerX &&
    other._centerY == _centerY &&
    other._bottomLeftX == _bottomLeftX &&
    other._bottomLeftY == _bottomLeftY &&
    other._topRightX == _topRightX &&
    other._topRightY == _topRightY &&
    other._unknown2 == _unknown2 &&
    other._unknown3 == _unknown3;

  @override
  int get hashCode => Object.hash(
    _unknown1,
    _centerX,
    _centerY,
    _bottomLeftX,
    _bottomLeftY,
    _topRightX,
    _topRightY,
    _unknown2,
    _unknown3,
  );
}

final class LineSegment extends Segment {
  const LineSegment._({
    required int layer,
    required int x1,
    required int y1,
    required int x2,
    required int y2,
    required int scale,
    required int traceNetIndex,
  })
  : _layer = layer,
    _x1 = x1,
    _y1 = y1,
    _x2 = x2,
    _y2 = y2,
    _scale = scale,
    _traceNetIndex = traceNetIndex;
  
  final int _layer;
  final int _x1;
  final int _y1;
  final int _x2;
  final int _y2;
  final int _scale;
  final int _traceNetIndex;

  static const id = 5;

  @override
  int get type => id;

  @override
  Bytes toBytes() => [
    ..._layer.toUint32List(),
    ..._x1.toInt32List(),
    ..._y1.toInt32List(),
    ..._x2.toInt32List(),
    ..._y2.toInt32List(),
    ..._scale.toInt32List(),
    ..._traceNetIndex.toUint32List(),
  ];

  @override
  JsonMap toJson() => {
    'layer': _layer,
    'x1': _x1,
    'y1': _y1,
    'x2': _x2,
    'y2': _y2,
    'scale': _scale,
    'traceNetIndex': _traceNetIndex,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is LineSegment &&
    other._layer == _layer &&
    other._x1 == _x1 &&
    other._y1 == _y1 &&
    other._x2 == _x2 &&
    other._y2 == _y2 &&
    other._scale == _scale &&
    other._traceNetIndex == _traceNetIndex;

  @override
  int get hashCode => Object.hash(
    _layer,
    _x1,
    _y1,
    _x2,
    _y2,
    _scale,
    _traceNetIndex,
  );
}

final class TextSegment extends Segment {
  const TextSegment._({
    required int unknown1,
    required int positionX,
    required int positionY,
    required int size,
    required int divider,
    required int empty,
    required int one,
    required String text,
  })
  : _unknown1 = unknown1,
    _positionX = positionX,
    _positionY = positionY,
    _size = size,
    _divider = divider,
    _empty = empty,
    _one = one,
    _text = text;

  final int _unknown1;
  final int _positionX;
  final int _positionY;
  final int _size;
  final int _divider;
  final int _empty;
  final int _one;
  final String _text;

  static const id = 6;

  @override
  int get type => id;

  @override
  Bytes toBytes() => [
    ..._unknown1.toUint32List(),
    ..._positionX.toUint32List(),
    ..._positionY.toUint32List(),
    ..._size.toUint32List(),
    ..._divider.toUint32List(),
    ..._empty.toUint32List(),
    ..._one.toUint16List(),
    ..._text.toStringPacket().toBytes(),
  ];

  @override
  JsonMap toJson() => {
    'unknown1': _unknown1,
    'positionX': _positionX,
    'positionY': _positionY,
    'size': _size,
    'divider': _divider,
    'empty': _empty,
    'one': _one,
    'text': _text,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is TextSegment &&
    other._unknown1 == _unknown1 &&
    other._positionX == _positionX &&
    other._positionY == _positionY &&
    other._size == _size &&
    other._divider == _divider &&
    other._empty == _empty &&
    other._one == _one &&
    other._text == _text;

  @override
  int get hashCode => Object.hash(
    _unknown1,
    _positionX,
    _positionY,
    _size,
    _divider,
    _empty,
    _one,
    _text,
  );
}

final class ComponentSegment extends Segment {
  const ComponentSegment._({
    required List<int> unknown1,
    required String description,
    required List<int> unknown2,
    required String name,
    required List<Component> components,
  })
  : _unknown1 = unknown1,
    _description = description,
    _unknown2 = unknown2,
    _name = name,
    _components = components;

  final Bytes _unknown1;
  final String _description;
  final Bytes _unknown2;
  final String _name;
  final List<Component> _components;

  static const int id = 7;

  static final _des = DES(
    key: [ 0xdc, 0xfc, 0x12, 0xac, 0x00, 0x00, 0x00, 0x00 ],
    paddingType: DESPaddingType.None,
  );

  Bytes _fillWithZero(Bytes bytes) {
    final remainder = 8 - (bytes.length % 8);
    return [
      ...bytes,
      if (remainder < 8)
      ...List.filled(remainder, 0),
    ];
  }

  @override
  int get type => id;

  @override
  Bytes toBytes() {
    final bytes = [
      ..._unknown1,
      ..._description.toStringPacket().toBytes(),
      ..._unknown2,
      ..._name.toStringPacket().toBytes(),
      for (final component in _components)
      ...component.toComponentPacket().toBytes(),
    ].toBytesable().toLengthPacket().toBytes();

    return _des.encrypt(_fillWithZero(bytes));
  }

  @override
  JsonMap toJson() => {
    'unknown1': _unknown1,
    'description': _description,
    'unknown2': _unknown2,
    'name': _name,
    'components': _components
      .map((e) => e.toComponentPacket().toJson())
      .toList(),
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is ComponentSegment &&
    listEqual(other._unknown1, _unknown1) &&
    other._description == _description &&
    listEqual(other._unknown2, _unknown2) &&
    other._name == _name &&
    listEqual(other._components, _components);

  @override
  int get hashCode => Object.hash(
    Object.hashAll(_unknown1),
    _description,
    Object.hashAll(_unknown2),
    _name,
    Object.hashAll(_components),
  );

}

final class PadSegment extends Segment {
  const PadSegment._({
    required int number,
    required int originX,
    required int originY,
    required int innerDiameter,
    required int unknown1,
    required String name,
    required int outerWidth1,
    required int outerHeight1,
    required int flag1,
    required int outerWidth2,
    required int outerHeight2,
    required int flag2,
    required int outerWidth3,
    required int outerHeight3,
    required int flag3,
    required int unknown2,
    required int flag4,
    required int netIndex,
  })
  : _number = number,
    _originX = originX,
    _originY = originY,
    _innerDiameter = innerDiameter,
    _unknown1 = unknown1,
    _name = name,
    _outerWidth1 = outerWidth1,
    _outerHeight1 = outerHeight1,
    _flag1 = flag1,
    _outerWidth2 = outerWidth2,
    _outerHeight2 = outerHeight2,
    _flag2 = flag2,
    _outerWidth3 = outerWidth3,
    _outerHeight3 = outerHeight3,
    _flag3 = flag3,
    _unknown2 = unknown2,
    _flag4 = flag4,
    _netIndex = netIndex;

  final int _number;
  final int _originX;
  final int _originY;
  final int _innerDiameter;
  final int _unknown1;
  final String _name;
  final int _outerWidth1;
  final int _outerHeight1;
  final int _flag1;
  final int _outerWidth2;
  final int _outerHeight2;
  final int _flag2;
  final int _outerWidth3;
  final int _outerHeight3;
  final int _flag3;
  final int _unknown2;
  final int _flag4;
  final int _netIndex;

  static const id = 9;

  @override
  int get type => _number;

  @override
  Bytes toBytes() => [
    ..._number.toUint32List(),
    ..._originX.toUint32List(),
    ..._originY.toUint32List(),
    ..._innerDiameter.toUint32List(),
    ..._unknown1.toUint32List(),
    ..._name.toStringPacket().toBytes(),
    ..._outerWidth1.toUint32List(),
    ..._outerHeight1.toUint32List(),
    _flag1,
    ..._outerWidth2.toUint32List(),
    ..._outerHeight2.toUint32List(),
    _flag2,
    ..._outerWidth3.toUint32List(),
    ..._outerHeight3.toUint32List(),
    _flag3,
    ..._unknown2.toUint32List(),
    _flag4,
    ..._netIndex.toUint32List(),
  ];

  @override
  JsonMap toJson() => {
    'number': _number,
    'originX': _originX,
    'originY': _originY,
    'innerDiameter': _innerDiameter,
    'unknown1': _unknown1,
    'name': _name,
    'outerWidth1': _outerWidth1,
    'outerHeight1': _outerHeight1,
    'flag1': _flag1,
    'outerWidth2': _outerWidth2,
    'outerHeight2': _outerHeight2,
    'flag2': _flag2,
    'outerWidth3': _outerWidth3,
    'outerHeight3': _outerHeight3,
    'flag3': _flag3,
    'unknown2': _unknown2,
    'flag4': _flag4,
    'netIndex': _netIndex,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is PadSegment &&
    other._number == _number &&
    other._originX == _originX &&
    other._originY == _originY &&
    other._innerDiameter == _innerDiameter &&
    other._unknown1 == _unknown1 &&
    other._name == _name &&
    other._outerWidth1 == _outerWidth1 &&
    other._outerHeight1 == _outerHeight1 &&
    other._flag1 == _flag1 &&
    other._outerWidth2 == _outerWidth2 &&
    other._outerHeight2 == _outerHeight2 &&
    other._flag2 == _flag2 &&
    other._outerWidth3 == _outerWidth3 &&
    other._outerHeight3 == _outerHeight3 &&
    other._flag3 == _flag3 &&
    other._unknown2 == _unknown2 &&
    other._flag4 == _flag4 &&
    other._netIndex == _netIndex;

  @override
  int get hashCode => Object.hash(
    _number,
    _originX,
    _originY,
    _innerDiameter,
    _unknown1,
    _name,
    _outerWidth1,
    _outerHeight1,
    _flag1,
    _outerWidth2,
    _outerHeight2,
    _flag2,
    _outerWidth3,
    _outerHeight3,
    _flag3,
    _unknown2,
    _flag4,
    _netIndex,
  );
}

extension SegmentOnBytes on Bytes {
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

extension SegmentOnIterator on Iterator<int> {
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

extension SegmentOnJsonMap on JsonMap {
  ArcSegment toArcSegment() => toObject().toArcSegment();
  ViaSegment toViaSegment() => toObject().toViaSegment();
  UnknownSegment toUnknownSegment() => toObject().toUnknownSegment();
  LineSegment toLineSegment() => toObject().toLineSegment();
  TextSegment toTextSegment() => toObject().toTextSegment();
  ComponentSegment toComponentSegment() => toObject().toComponentSegment();
  PadSegment toPadSegment() => toObject().toPadSegment();
}

extension SegmentOnMap on Map<String, Object?> {
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

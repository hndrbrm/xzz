// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../../../bytes_helper/int_helper.dart';
import '../../../../bytes_helper/list_helper.dart';
import '../../../../serializable/bytes.dart';
import '../../../../serializable/bytesable.dart';
import '../../../../serializable/jsonable.dart';
import '../../../packet/string_packet.dart';

sealed class Component implements Bytesable, Jsonable {
  const Component();

  int get type;
}

final class UnknownComponent extends Component {
  const UnknownComponent._(this._raw);

  final Bytes _raw;

  static const id = 1;

  @override
  int get type => id;

  @override
  Bytes toBytes() => _raw;

  @override
  JsonMap toJson() => { 'raw': _raw }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is UnknownComponent &&
    listEqual(other._raw, _raw);

  @override
  int get hashCode => Object.hashAll(_raw);
}

final class LineComponent extends Component {
  const LineComponent._(this._raw);

  final Bytes _raw;

  static const id = 5;

  @override
  int get type => id;

  @override
  Bytes toBytes() => _raw;

  @override
  JsonMap toJson() => { 'raw': _raw }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is LineComponent &&
    listEqual(other._raw, _raw);

  @override
  int get hashCode => Object.hashAll(_raw);
}

final class LabelComponent extends Component {
  const LabelComponent._(this._raw);

  final Bytes _raw;

  static const id = 6;

  @override
  int get type => id;

  @override
  Bytes toBytes() => _raw;

  @override
  JsonMap toJson() => { 'raw': _raw }.toJsonMap();
  
  @override
  bool operator ==(Object other) =>
    other is LabelComponent &&
    listEqual(other._raw, _raw);

  @override
  int get hashCode => Object.hashAll(_raw);
}

final class PinComponent extends Component {
  const PinComponent._({
    required int unknown1,
    required int x,
    required int y,
    required List<int> unknown2,
    required String name,
    required List<int> unknown3,
    required int netIndex,
    required List<int> unknown4,
  })
  : _unknown1 = unknown1,
    _x = x,
    _y = y,
    _unknown2 = unknown2,
    _name = name,
    _unknown3 = unknown3,
    _netIndex = netIndex,
    _unknown4 = unknown4;

  final int _unknown1;
  final int _x;
  final int _y;
  final Bytes _unknown2;
  final String _name;
  final Bytes _unknown3;
  final int _netIndex;
  final Bytes _unknown4;

  static const id = 9;

  @override
  int get type => id;

  @override
  Bytes toBytes() => [
    ..._unknown1.toUint32List(),
    ..._x.toUint32List(),
    ..._y.toUint32List(),
    ..._unknown2,
    ..._name.toStringPacket().toBytes(),
    ..._unknown3,
    ..._netIndex.toUint32List(),
    ..._unknown4,
  ];

  @override
  JsonMap toJson() => {
    'unknown1': _unknown1,
    'x': _x,
    'y': _y,
    'unknown2': _unknown2,
    'name': _name,
    'unknown3': _unknown3,
    'netIndex': _netIndex,
    'unknown4': _unknown4,
  }.toJsonMap();
  
  @override
  bool operator ==(Object other) =>
    other is PinComponent &&
    other._unknown1 == _unknown1 &&
    other._x == _x &&
    other._y == _y &&
    listEqual(other._unknown2, _unknown2) &&
    other._name == _name &&
    listEqual(other._unknown3, _unknown3) &&
    other._netIndex == _netIndex &&
    listEqual(other._unknown4, _unknown4);

  @override
  int get hashCode => Object.hash(
    _unknown1,
    _x,
    _y,
    Object.hashAll(_unknown2),
    _name,
    Object.hashAll(_unknown3),
    _netIndex,
    Object.hashAll(_unknown4),
  );
}

extension ComponentOnBytes on Bytes {
  UnknownComponent toUnknownComponent() => UnknownComponent._(this);
  LineComponent toLineComponent() => LineComponent._(this);
  LabelComponent toLabelComponent() => LabelComponent._(this);
  PinComponent toPinComponent() => iterator.toPinComponent();
}

extension ComponentOnIterator on Iterator<int> {
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

extension ComponentOnJsonMap on JsonMap {
  UnknownComponent toUnknownComponent() => toObject().toUnknownComponent();
  LineComponent toLineComponent() => toObject().toLineComponent();
  LabelComponent toLabelComponent() => toObject().toLabelComponent();
  PinComponent toPinComponent() => toObject().toPinComponent();
}

extension ComponentOnMap on Map<String, Object?> {
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

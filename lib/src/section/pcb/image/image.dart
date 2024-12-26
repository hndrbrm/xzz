// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../../bytes_helper/int_helper.dart';
import '../../../bytes_helper/list_helper.dart';
import '../../../serializable/bytes.dart';
import '../../../serializable/bytesable.dart';
import '../../../serializable/jsonable.dart';
import '../../packet/string_packet.dart';

final class Image implements Bytesable, Jsonable {
  const Image._({
    required int id,
    required int index,
    required int flag,
    required int sizeX,
    required int sizeY,
    required String name,
  })
  : _id = id,
    _index = index,
    _flag = flag,
    _sizeX = sizeX,
    _sizeY = sizeY,
    _name = name;

  final int _id;
  final int _index;
  final int _flag;
  final int _sizeX;
  final int _sizeY;
  final String _name;

  @override
  Bytes toBytes() => [
    _id,
    _index,
    _flag,
    ..._sizeX.toUint32List(),
    ..._sizeY.toUint32List(),
    ..._name.toStringPacket().toBytes(),
  ];

  @override
  JsonMap toJson() => {
    'id': _id,
    'index': _index,
    'flag': _flag,
    'sizeX': _sizeX,
    'sizeY': _sizeY,
    'name': _name,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Image &&
    other._id == _id &&
    other._index == _index &&
    other._flag == _flag &&
    other._sizeX == _sizeX &&
    other._sizeY == _sizeY &&
    other._name == _name;

  @override
  int get hashCode => Object.hash(
    _id,
    _index,
    _flag,
    _sizeX,
    _sizeY,
    _name,
  );
}

extension ImageOnIterator on Iterator<int> {
  Image toImage() => Image._(
    id: read(1).first,
    index: read(1).first,
    flag: read(1).first,
    sizeX: read(4).toUint32(),
    sizeY: read(4).toUint32(),
    name: toStringPacket()!.string,
  );
}

extension ImageOnJsonMap on JsonMap {
  Image toImage() => toObject().toImage();
}

extension ImageOnMap on Map<String, Object?> {
  Image toImage() => Image._(
    id: this['id']! as int,
    index: this['index']! as int,
    flag: this['flag']! as int,
    sizeX: this['sizeX']! as int,
    sizeY: this['sizeY']! as int,
    name: this['name']! as String,
  );
}

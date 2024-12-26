// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../../bytes_helper/int_helper.dart';
import '../../../bytes_helper/iterator_helper.dart';
import '../../../bytes_helper/list_helper.dart';
import '../../../serializable/byteable.dart';
import '../../../serializable/jsonable.dart';
import '../../packet/string_packet.dart';

final class Image implements Bytesable, Jsonable {
  const Image._({
    required this.id,
    required this.index,
    required this.flag,
    required this.sizeX,
    required this.sizeY,
    required this.name,
  });

  final int id;
  final int index;
  final int flag;
  final int sizeX;
  final int sizeY;
  final String name;

  @override
  List<int> toBytes() => [
    id,
    index,
    flag,
    ...sizeX.toUint32List(),
    ...sizeY.toUint32List(),
    ...name.toStringPacket().toBytes(),
  ];

  @override
  JsonMap toJson() => {
    'id': id,
    'index': index,
    'flag': flag,
    'sizeX': sizeX,
    'sizeY': sizeY,
    'name': name,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Image &&
    other.id == id &&
    other.index == index &&
    other.flag == flag &&
    other.sizeX == sizeX &&
    other.sizeY == sizeY &&
    other.name == name;

  @override
  int get hashCode => Object.hash(
    id,
    index,
    flag,
    sizeX,
    sizeY,
    name,
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

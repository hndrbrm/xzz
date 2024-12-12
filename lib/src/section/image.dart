// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../bytes_helper/int_helper.dart';
import '../bytes_helper/iterator_helper.dart';
import '../bytes_helper/list_helper.dart';
import '../serializable.dart';
import 'packet/byteable_packet.dart';
import 'packet/string_packet.dart';

final class Image implements Serializable {
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
  List<int> toByte() => [
    id,
    index,
    flag,
    ...sizeX.toUint32List(),
    ...sizeY.toUint32List(),
    ...name.toStringPacket().toByte(),
  ];

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'index': index,
    'flag': flag,
    'sizeX': sizeX,
    'sizeY': sizeY,
    'name': name,
  };
}

extension ImageIterator on Iterator<int> {
  Image toImage() => Image._(
    id: read(1).first,
    index: read(1).first,
    flag: read(1).first,
    sizeX: read(4).toUint32(),
    sizeY: read(4).toUint32(),
    name: toStringPacket().string,
  );
}

extension ImageMap on Map<String, dynamic> {
  Image toImage() => Image._(
    id: this['id'],
    index: this['index'],
    flag: this['flag'],
    sizeX: this['sizeX'],
    sizeY: this['sizeY'],
    name: this['name'],
  );
}

extension ImagesIterator on Iterator<int> {
  ByteablePacket<Image> toImages() => toByteablePacket((e) => e.toImage());
}

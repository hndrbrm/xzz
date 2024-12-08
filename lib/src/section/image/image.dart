// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/int_helper.dart';
import '../../bytes_helper/iterator_helper.dart';
import '../../bytes_helper/list_helper.dart';
import '../../serializer.dart';
import '../packet/string_packet.dart';

final class Image implements Serializer {
  Image.deserialize(Iterator<int> iterator)
  : id = iterator.read(1).first,
    index = iterator.read(1).first,
    flag = iterator.read(1).first,
    sizeX = iterator.read(4).toUint32(),
    sizeY = iterator.read(4).toUint32(),
    name = StringPacket.deserialize(iterator).string;

  final int id;
  final int index;
  final int flag;
  final int sizeX;
  final int sizeY;
  final String name;

  @override
  List<int> serialize() => [
    id,
    index,
    flag,
    ...sizeX.toUint32List(),
    ...sizeY.toUint32List(),
    ...name.toPacket().serialize(),
  ];
}

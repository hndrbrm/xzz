// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../shareable/iterator_helper.dart';
import '../../shareable/serializer.dart';
import 'length_packet.dart';

class IdPacket implements Serializer {
  const IdPacket({
    required this.id,
    required this.content,
  });

  IdPacket.deserialize(Iterator<int> iterator)
  : id = iterator.read(1).first,
    content = LengthPacket.deserialize(iterator).content;

  final int id;
  final List<int> content;

  @override
  List<int> serialize() => [
    id,
    ...LengthPacket(content).serialize(),
  ];
}

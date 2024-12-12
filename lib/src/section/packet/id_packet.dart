// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../byteable.dart';
import '../../bytes_helper/int_helper.dart';
import '../../bytes_helper/iterator_helper.dart';
import 'length_packet.dart';

class IdPacket implements Byteable {
  const IdPacket({
    required this.id,
    required this.content,
  });

  final int id;
  final Byteable content;

  @override
  List<int> toByte() {
    final byte = content.toByte();

    return [
      id,
      ...byte.length.toUint32List(),
      ...byte,
    ];
  }
}

extension IdPacketIterator on Iterator<int> {
  IdPacket toIdPacket() =>
    IdPacket(
      id: read(1).first,
      content: toLengthPacket().content,
    );
}

// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/int_helper.dart';
import '../../bytes_helper/iterator_helper.dart';
import '../../bytes_helper/list_helper.dart';
import '../../serializable/byteable.dart';
import 'length_packet.dart';

class IdPacket implements Bytesable {
  const IdPacket({
    required this.id,
    required this.content,
  });

  final int id;
  final Bytesable content;

  @override
  List<int> toBytes() {
    final byte = content.toBytes();

    return [
      id,
      ...byte.length.toUint32List(),
      ...byte,
    ];
  }

  @override
  bool operator ==(Object other) =>
    other is IdPacket &&
    other.id == id &&
    listEqual(other.content.toBytes(), content.toBytes());

  @override
  int get hashCode => Object.hash(
    id,
    Object.hashAll(content.toBytes()),
  );
}

extension IdPacketIterator on Iterator<int> {
  IdPacket toIdPacket() =>
    IdPacket(
      id: read(1).first,
      content: toLengthPacket().content,
    );
}

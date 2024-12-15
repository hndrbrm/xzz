// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/int_helper.dart';
import '../../bytes_helper/iterator_helper.dart';
import '../../bytes_helper/list_helper.dart';
import '../../serializable/byteable.dart';

class LengthPacket implements Bytesable {
  const LengthPacket(this.content);

  final Bytesable content;

  @override
  List<int> toBytes() {
    final byte = content.toBytes();

    return [
      ...byte.length.toUint32List(),
      ...byte,
    ];
  }
}

extension LengthPacketIterator on Iterator<int> {
  LengthPacket? toLengthPacket() {
    final probe = read(4);
    if (probe.isEmpty) {
      return null;
    }

    final length = probe.toUint32();
    final body = read(length);

    return body.toBytesable().toLengthPacket();
  }
}

extension LengthPacketByteable on Bytesable {
  LengthPacket toLengthPacket() => LengthPacket(this);
}

// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import '../../byteable.dart';
import '../../serializable.dart';
import 'length_packet.dart';

class ByteablePacket<T extends Serializable>
with IterableMixin<T>
implements Serializable
{
  const ByteablePacket._(this.whole);

  final List<T> whole;

  @override
  Iterator<T> get iterator => whole.iterator;

  @override
  List<int> toByte() => [
    for (final each in whole)
    ...each.toByte(),
  ].toByteable().toLengthPacket().toByte();

  @override
  Map<String, dynamic> toMap() => {
    'whole': whole.map((e) => e.toMap()),
  };
}

extension ByteableIterator on Iterator<int> {
  ByteablePacket<T> toByteablePacket<T extends Serializable>(T Function(Iterator<int> iterator) debyte) {
    final packet = toLengthPacket().content.toByte();
    final packetIterator = packet.iterator;

    final whole = <T>[];

    for (var offset = 0; offset < packet.length; ) {
      final each = debyte(packetIterator);
      whole.add(each);
      offset += each.toByte().length;
    }

    return ByteablePacket<T>._(whole);
  }
}

extension ByteablePacketMap on Map<String, dynamic> {
  ByteablePacket<T> toByteablePacket<T extends Serializable>() {
    final whole = this['whole'];
    return ByteablePacket<T>._(whole);
  }
}

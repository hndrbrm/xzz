// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import '../../serializable/byteable.dart';
import '../../serializable/jsonable.dart';
import '../../serializable/serializable.dart';
import 'length_packet.dart';

class BytesablePacket<T extends Serializable>
with IterableMixin<T>
implements Serializable
{
  const BytesablePacket(this.whole);

  final List<T> whole;

  @override
  Iterator<T> get iterator => whole.iterator;

  @override
  List<int> toBytes() => [
    for (final each in whole)
    ...each.toBytes(),
  ].toBytesable().toLengthPacket().toBytes();

  @override
  JsonList toJson() => whole
    .map((e) => e.toJson())
    .toJsonList();
}

extension BytesableIterator on Iterator<int> {
  BytesablePacket<T> toByteablePacket<T extends Serializable>(T Function(Iterator<int> iterator) debyte) {
    final packet = toLengthPacket().content.toBytes();
    final packetIterator = packet.iterator;

    final whole = <T>[];

    for (var offset = 0; offset < packet.length; ) {
      final each = debyte(packetIterator);
      whole.add(each);
      offset += each.toBytes().length;
    }

    return BytesablePacket<T>(whole);
  }
}

extension BytesablePacketMap on Map<String, Object?> {
  BytesablePacket<T> toByteablePacket<T extends Serializable>() {
    final whole = this['whole']! as List<T>;
    return BytesablePacket<T>(whole);
  }
}

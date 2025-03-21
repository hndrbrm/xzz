// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../../bytes_helper/list_helper.dart';
import '../../../serializable/bytes.dart';
import '../../../serializable/jsonable.dart';
import '../../packet/bytesable_packet.dart';
import 'net.dart';

class Nets extends BytesablePacket<Net> {
  const Nets(super.whole);

  @override
  bool operator ==(Object other) =>
    other is Nets &&
    listEqual(other.whole, whole);

  @override
  int get hashCode => Object.hashAll(whole);
}

extension NetsOnBytes on Bytes {
  Nets toNets() => iterator.toNets();
}

extension NetsOnIterator on Iterator<int> {
  Nets toNets() {
    final whole = toBytesablePacket((e) => e.toNet());
    return Nets(whole.whole);
  }
}

extension NetsOnJsonList on JsonList {
  Nets toNets() => toObject().toNets();
}

extension NetsOnListObject on List<Object?> {
  Nets toNets() => Nets(
    map((e) => e! as Map<String, Object?>)
      .map((e) => e.toJsonMap())
      .map((e) => e.toNet())
      .toList()
  );
}

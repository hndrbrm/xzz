// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../../bytes_helper/list_helper.dart';
import '../../../serializable/bytes.dart';
import '../../../serializable/jsonable.dart';
import '../../packet/bytesable_packet.dart';
import 'segment_packet.dart';

class Segments extends BytesablePacket<SegmentPacket> {
  const Segments(super.whole);

  @override
  JsonList toJson() => whole
    .map((e) => e.toJson())
    .toJsonList();

  @override
  bool operator ==(Object other) =>
    other is Segments &&
    listEqual(other.whole, whole);

  @override
  int get hashCode => Object.hashAll(whole);
}

extension SegmentsOnBytes on Bytes {
  Segments toSegments() => iterator.toSegments();
}

extension SegmentsOnIterator on Iterator<int> {
  Segments toSegments() {
    final whole = toBytesablePacket((e) => e.toSegmentPacket());
    return Segments(whole.whole);
  }
}

extension SegmentsOnJsonList on JsonList {
  Segments toSegments() => toObject().toSegments();
}

extension SegmentsOnListObject on List<Object?> {
  Segments toSegments() => Segments(
    map((e) => e! as Map<String, Object?>)
      .map((e) => e.toSegmentPacket())
      .toList(),
  );
}

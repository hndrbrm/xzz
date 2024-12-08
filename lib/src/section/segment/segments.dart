// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../packet/serializable_packet.dart';
import 'segment.dart';
import 'segment_packet.dart';

final class Segments extends SerializablePacket<SegmentPacket> {
  Segments.deserialize(Iterator<int> iterator)
  : super.deserialize(
    iterator,
    (iterator) => SegmentPacket.deserialize(iterator),
  );

  Iterable<Segment> get segments => map((e) => e.segment);
}
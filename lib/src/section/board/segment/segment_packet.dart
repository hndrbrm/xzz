// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../id_packet.dart';
import 'segment.dart';

final class SegmentPacket extends IdPacket {
  const SegmentPacket({
    required super.id,
    required super.content,
  });

  SegmentPacket.deserialize(super.iterator)
  : super.deserialize();

  Segment get board => switch (id) {
    ArcSegment.id => ArcSegment.deserialize(content.iterator),
    ViaSegment.id => ViaSegment.deserialize(content.iterator),
    UnknownSegment.id => UnknownSegment.deserialize(content.iterator),
    LineSegment.id => LineSegment.deserialize(content.iterator),
    TextSegment.id => TextSegment.deserialize(content.iterator),
    ComponentSegment.id => ComponentSegment.deserialize(content),
    PadSegment.id => PadSegment.deserialize(content.iterator),
    _ => throw UnknownSegmentException(id),
  };
}

final class UnknownSegmentException implements Exception {
  const UnknownSegmentException(this.id);

  final int id;

  @override
  String toString() => "Unknown Segment '$id'";
}

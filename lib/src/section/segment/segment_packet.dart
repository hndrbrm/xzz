// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../byteable.dart';
import '../../serializable.dart';
import '../packet/byteable_packet.dart';
import '../packet/id_packet.dart';
import 'segment.dart';

final class SegmentPacket extends IdPacket implements Serializable {
  const SegmentPacket._({
    required super.id,
    required super.content,
  });

  Segment toSegment() => switch (id) {
    ArcSegment.id => content.toByte().iterator.toArcSegment(),
    ViaSegment.id => content.toByte().iterator.toViaSegment(),
    UnknownSegment.id => content.toByte().iterator.toUnknownSegment(),
    LineSegment.id => content.toByte().iterator.toLineSegment(),
    TextSegment.id => content.toByte().iterator.toTextSegment(),
    ComponentSegment.id => content.toByte().toComponentSegment(),
    PadSegment.id => content.toByte().iterator.toPadSegment(),
    _ => throw UnknownSegmentException(id),
  };

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'segment': toSegment().toMap(),
  };
}

final class UnknownSegmentException implements Exception {
  const UnknownSegmentException(this.id);

  final int id;

  @override
  String toString() => "Unknown Segment '$id'";
}

extension SegmentIterator on Iterator<int> {
  SegmentPacket toSegmentPacket() {
    final packet = toIdPacket();

    return SegmentPacket._(
      id: packet.id,
      content: packet.content,
    );
  }

  ByteablePacket<SegmentPacket> toSegments() => toByteablePacket(
    (e) => e.toSegmentPacket()
  );
}

extension SegmentPacketMap on Map<String, dynamic> {
  SegmentPacket toSegmentPacket() {
    final id = this['id'];
    final segment = this['segment'] as Map<String, dynamic>;

    return SegmentPacket._(
      id: id,
      content: segment.toSegment(),
    );
  }

  Segment toSegment() {
    final id = this['id'];
    final segment = this['segment'] as Map<String, dynamic>;

    return switch (id) {
      ArcSegment.id => segment.toArcSegment(),
      ViaSegment.id => segment.toViaSegment(),
      UnknownSegment.id => segment.toUnknownSegment(),
      LineSegment.id => segment.toLineSegment(),
      TextSegment.id => segment.toTextSegment(),
      ComponentSegment.id => segment.toComponentSegment(),
      PadSegment.id => segment.toPadSegment(),
      _ => throw UnknownSegmentException(id),
    };

  }
}

extension SegmentPacketSegment on Segment {
  SegmentPacket toSegmentPacket() => SegmentPacket._(
    id: type,
    content: toByte().toByteable(),
  );
}

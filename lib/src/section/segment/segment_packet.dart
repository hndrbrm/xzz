// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/list_helper.dart';
import '../../serializable/byteable.dart';
import '../../serializable/jsonable.dart';
import '../../serializable/serializable.dart';
import '../packet/bytesable_packet.dart';
import '../packet/id_packet.dart';
import 'segment.dart';

final class SegmentPacket extends IdPacket implements Serializable {
  const SegmentPacket._({
    required super.id,
    required super.content,
  });

  Segment toSegment() => switch (id) {
    ArcSegment.id => content.toBytes().iterator.toArcSegment(),
    ViaSegment.id => content.toBytes().iterator.toViaSegment(),
    UnknownSegment.id => content.toBytes().iterator.toUnknownSegment(),
    LineSegment.id => content.toBytes().iterator.toLineSegment(),
    TextSegment.id => content.toBytes().iterator.toTextSegment(),
    ComponentSegment.id => content.toBytes().toComponentSegment(),
    PadSegment.id => content.toBytes().iterator.toPadSegment(),
    _ => throw UnknownSegmentException(id),
  };

  @override
  JsonMap toJson() => {
    'id': id,
    'segment': toSegment().toJson(),
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is SegmentPacket &&
    other.id == id &&
    listEqual(other.content.toBytes(), content.toBytes());

  @override
  int get hashCode => Object.hash(
    id,
    Object.hashAll(content.toBytes()),
  );
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

  BytesablePacket<SegmentPacket> toSegments() => toByteablePacket(
    (e) => e.toSegmentPacket()
  );
}

extension SegmentPacketJsonMap on JsonMap {
  SegmentPacket toSegmentPacket() => toObject().toSegmentPacket();
}

extension SegmentPacketMap on Map<String, Object?> {
  SegmentPacket toSegmentPacket() {
    final id = this['id']! as int;
    final segment = this['segment']! as Map<String, Object?>;
    final content = switch (id) {
      ArcSegment.id => segment.toArcSegment(),
      ViaSegment.id => segment.toViaSegment(),
      UnknownSegment.id => segment.toUnknownSegment(),
      LineSegment.id => segment.toLineSegment(),
      TextSegment.id => segment.toTextSegment(),
      ComponentSegment.id => segment.toComponentSegment(),
      PadSegment.id => segment.toPadSegment(),
      _ => throw UnknownSegmentException(id),
    };

    return SegmentPacket._(
      id: id,
      content: content,
    );
  }
}

extension SegmentPacketSegment on Segment {
  SegmentPacket toSegmentPacket() => SegmentPacket._(
    id: type,
    content: toBytes().toBytesable(),
  );
}

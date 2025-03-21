// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../../bytes_helper/list_helper.dart';
import '../../../serializable/bytesable.dart';
import '../../../serializable/jsonable.dart';
import '../../packet/bytesable_packet.dart';
import '../../packet/id_packet.dart';
import 'segment.dart';

final class SegmentPacket extends IdPacket implements Bytesable, Jsonable {
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
    _ => throw UnknownSegmentException._(id),
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
  const UnknownSegmentException._(this._id);

  final int _id;

  @override
  String toString() => "Unknown Segment '$_id'";
}

extension SegmentPacketOnIterator on Iterator<int> {
  SegmentPacket toSegmentPacket() {
    final packet = toIdPacket();

    return SegmentPacket._(
      id: packet.id,
      content: packet.content,
    );
  }

  BytesablePacket<SegmentPacket> toSegmentPacketBytesable() => toBytesablePacket(
    (e) => e.toSegmentPacket()
  );
}

extension SegmentPacketOnJsonMap on JsonMap {
  SegmentPacket toSegmentPacket() => toObject().toSegmentPacket();
}

extension SegmentPacketOnMap on Map<String, Object?> {
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
      _ => throw UnknownSegmentException._(id),
    };

    return SegmentPacket._(
      id: id,
      content: content,
    );
  }
}

extension SegmentPacketOnSegment on Segment {
  SegmentPacket toSegmentPacket() => SegmentPacket._(
    id: type,
    content: toBytes().toBytesable(),
  );
}

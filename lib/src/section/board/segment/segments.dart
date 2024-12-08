// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import '../../../shareable/serializer.dart';
import '../length_packet.dart';
import 'segment.dart';
import 'segment_packet.dart';

final class Segments with IterableMixin<Segment> implements Serializer {
  Segments._({
    required List<Segment> boards,
  }) : _segments = boards;

  factory Segments.deserialize(Iterator<int> iterator) {
    final packet = LengthPacket.deserialize(iterator);
    final packetIterator = packet.content.iterator;

    final segments = <Segment>[];

    for (var offset = 0; offset < packet.content.length; ) {
      final container = SegmentPacket.deserialize(packetIterator);
      segments.add(container.board);
      offset += container.serialize().length;
    }

    return Segments._(boards: segments);
  }

  final List<Segment> _segments;

  @override
  Iterator<Segment> get iterator => _segments.iterator;

  @override
  List<int> serialize() => LengthPacket([
    for (final segment in _segments)
    ...segment.packet.serialize(),
  ]).serialize();
}

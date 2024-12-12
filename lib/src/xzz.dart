// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'section/image.dart';
import 'section/net.dart';
import 'section/offset.dart';
import 'section/packet/byteable_packet.dart';
import 'section/segment/segment_packet.dart';
import 'section/signature.dart';
import 'serializable.dart';

final class Xzz implements Serializable {
  const Xzz._({
    required this.signature,
    required this.offset,
    required this.segments,
    required this.images,
    required this.nets,
  });

  final Signature signature;
  final Offset offset;
  final ByteablePacket<SegmentPacket> segments;
  final ByteablePacket<Image> images;
  final ByteablePacket<Net> nets;

  @override
  List<int> toByte() => [
    ...signature.toByte(),
    ...offset.toByte(),
    ...segments.toByte(),
    ...images.toByte(),
    ...nets.toByte(),
  ];

  @override
  Map<String, dynamic> toMap() => {
    'signature': signature.toMap(),
    'offset': offset.toMap(),
    'segments': segments.toMap(),
    'images': images.toMap(),
    'nets': nets.toMap(),
  };
}

extension XzzIterator on Iterator<int> {
  Xzz toXzz() => Xzz._(
    signature: toSignature(),
    offset: toOffset(),
    segments: toSegments(),
    images: toImages(),
    nets: toNets()
  );
}

extension XzzMap on Map<String, dynamic> {
  Xzz toXzz() => Xzz._(
    signature: this['signature'],
    offset: this['offset'],
    segments: this['segments'],
    images: this['images'],
    nets: this['nets'],
  );
}

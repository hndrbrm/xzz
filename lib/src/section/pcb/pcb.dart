// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../serializable/byteable.dart';
import '../../serializable/jsonable.dart';
import 'image/images.dart';
import 'net/nets.dart';
import 'offset.dart';
import 'segment/segments.dart';
import 'pcb_signature.dart';

final class Pcb implements Bytesable, Jsonable {
  const Pcb._({
    required this.signature,
    required this.offset,
    required this.segments,
    required this.images,
    required this.nets,
  });

  final PcbSignature signature;
  final Offset offset;
  final Segments segments;
  final Images images;
  final Nets nets;

  @override
  List<int> toBytes() => [
    ...signature.toBytes(),
    ...offset.toBytes(),
    ...segments.toBytes(),
    ...images.toBytes(),
    ...nets.toBytes(),
  ];

  @override
  JsonMap toJson() => {
    'signature': signature.toJson(),
    'offset': offset.toJson(),
    'segments': segments.toJson(),
    'images': images.toJson(),
    'nets': nets.toJson(),
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Pcb &&
    other.signature == signature &&
    other.offset == offset &&
    other.segments == segments &&
    other.images == images &&
    other.nets == nets;

  @override
  int get hashCode => Object.hash(
    signature,
    offset,
    segments,
    images,
    nets,
  );
}

extension PcbOnJsonMap on JsonMap {
  Pcb toPcb() => toObject().toPcb();
}

extension PcbOnIterator on Iterator<int> {
  Pcb toPcb() => Pcb._(
    signature: toPcbSignature(),
    offset: toOffset(),
    segments: toSegments(),
    images: toImages(),
    nets: toNets(),
  );
}

extension PcbOnList on List<int> {
  Pcb toPcb() => iterator.toPcb();
}

extension PcbOnMap on Map<String, Object?> {
  Pcb toPcb() => Pcb._(
    signature: (this['signature']! as Map<String, Object?>).toPcbSignature(),
    offset: (this['offset']! as Map<String, Object?>).toOffset(),
    segments: (this['segments']! as List<Object?>).toSegments(),
    images: (this['images']! as List<Object?>).toImages(),
    nets: (this['nets']! as List<Object?>).toNets(),
  );
}

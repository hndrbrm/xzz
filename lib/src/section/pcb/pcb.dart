// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';
import '../../serializable/jsonable.dart';
import 'image/images.dart';
import 'net/nets.dart';
import 'offset.dart';
import 'pcb_signature.dart';
import 'segment/segments.dart';

final class Pcb implements Bytesable, Jsonable {
  const Pcb._({
    required PcbSignature signature,
    required Offset offset,
    required Segments segments,
    required Images images,
    required Nets nets,
  })
  : _signature = signature,
    _offset = offset,
    _segments = segments,
    _images = images,
    _nets = nets;

  final PcbSignature _signature;
  final Offset _offset;
  final Segments _segments;
  final Images _images;
  final Nets _nets;

  @override
  Bytes toBytes() => [
    ..._signature.toBytes(),
    ..._offset.toBytes(),
    ..._segments.toBytes(),
    ..._images.toBytes(),
    ..._nets.toBytes(),
  ];

  @override
  JsonMap toJson() => {
    'signature': _signature.toJson(),
    'offset': _offset.toJson(),
    'segments': _segments.toJson(),
    'images': _images.toJson(),
    'nets': _nets.toJson(),
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Pcb &&
    other._signature == _signature &&
    other._offset == _offset &&
    other._segments == _segments &&
    other._images == _images &&
    other._nets == _nets;

  @override
  int get hashCode => Object.hash(
    _signature,
    _offset,
    _segments,
    _images,
    _nets,
  );
}

extension PcbOnBytes on Bytes {
  Pcb toPcb() => iterator.toPcb();
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

extension PcbOnJsonMap on JsonMap {
  Pcb toPcb() => toObject().toPcb();
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

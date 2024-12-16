// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'section/image/images.dart';
import 'section/net/nets.dart';
import 'section/offset.dart';
import 'section/segment/segments.dart';
import 'section/separator.dart';
import 'section/signature.dart';
import 'serializable/jsonable.dart';
import 'serializable/serializable.dart';

final class Xzz implements Serializable {
  const Xzz._({
    required this.signature,
    required this.offset,
    required this.segments,
    required this.images,
    required this.nets,
    this.separator,
  });

  final Signature signature;
  final Offset offset;
  final Segments segments;
  final Images images;
  final Nets nets;
  final Separator? separator;

  @override
  List<int> toBytes() => [
    ...signature.toBytes(),
    ...offset.toBytes(),
    ...segments.toBytes(),
    ...images.toBytes(),
    ...nets.toBytes(),
    if (separator != null)
    ...separator!.toBytes(),
  ];

  @override
  JsonMap toJson() => {
    'signature': signature.toJson(),
    'offset': offset.toJson(),
    'segments': segments.toJson(),
    'images': images.toJson(),
    'nets': nets.toJson(),
    if (separator != null)
    'separator': separator.toJson(),
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Xzz &&
    other.signature == signature &&
    other.offset == offset &&
    other.segments == segments &&
    other.images == images &&
    other.nets == nets &&
    other.separator == separator;

  @override
  int get hashCode => Object.hash(
    signature,
    offset,
    segments,
    images,
    nets,
    separator,
  );
}

extension XzzJsonMap on JsonMap {
  Xzz toXzz() => toObject().toXzz();
}

extension XzzList on List<int> {
  Xzz toXzz() {
    final position = findSeparator();

    final iterator = this.iterator;
    final signature = iterator.toSignature();
    final offset = iterator.toOffset();
    final segments = iterator.toSegments();
    final images = iterator.toImages();
    final nets = iterator.toNets();
    final separator = (position == -1) ? null : iterator.toSeparator();

    return Xzz._(
      signature: signature,
      offset: offset,
      segments: segments,
      images: images,
      nets: nets,
      separator: separator,
    );
  }
}

extension XzzMap on Map<String, Object?> {
  Xzz toXzz() => Xzz._(
    signature: (this['signature']! as Map<String, Object?>).toSignature(),
    offset: (this['offset']! as Map<String, Object?>).toOffset(),
    segments: (this['segments']! as List<Object?>).toSegments(),
    images: (this['images']! as List<Object?>).toImages(),
    nets: (this['nets']! as List<Object?>).toNets(),
    separator: (this['separator'] as List<Object?>?)?.toSeparator(),
  );
}

// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'section/image/images.dart';
import 'section/net/nets.dart';
import 'section/offset.dart';
import 'section/segment/segments.dart';
import 'section/signature.dart';
import 'serializer.dart';

final class Xzz implements Serializer {
  Xzz.deserialize(Iterator<int> iterator)
  : signature = Signature.deserialize(iterator),
    offset = Offset.deserialize(iterator),
    segments = Segments.deserialize(iterator),
    images = Images.deserialize(iterator),
    nets = Nets.deserialize(iterator);

  final Signature signature;
  final Offset offset;
  final Segments segments;
  final Images images;
  final Nets nets;

  @override
  List<int> serialize() => [
    ...signature.serialize(),
    ...offset.serialize(),
    ...segments.serialize(),
    ...images.serialize(),
    ...nets.serialize(),
  ];
}

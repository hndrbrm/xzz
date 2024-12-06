// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'section/image/images.dart';
import 'section/info/infos.dart';
import 'section/net/nets.dart';
import 'section/offset.dart';
import 'section/signature.dart';
import 'shareable/serializer.dart';

final class Xzz implements Serializer {
  const Xzz({
    required this.signature,
    required this.offset,
    required this.infos,
    required this.images,
    required this.nets,
  });

  factory Xzz.deserialize(Iterator<int> iterator) {
    final signature = Signature.deserialize(iterator);
    final offset = Offset.deserialize(iterator);
    final infos = Infos.deserialize(iterator);
    final images = Images.deserialize(iterator);
    final nets = Nets.deserialize(iterator);

    return Xzz(
      signature: signature,
      offset: offset,
      infos: infos,
      images: images,
      nets: nets,
    );
  }

  final Signature signature;
  final Offset offset;
  final Infos infos;
  final Images images;
  final Nets nets;

  @override
  List<int> serialize() => [
    ...signature.serialize(),
    ...offset.serialize(),
    ...infos.serialize(),
    ...images.serialize(),
    ...nets.serialize(),
  ];
}

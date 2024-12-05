// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'header.dart';
import 'signature.dart';
import 'infos.dart';
import 'layers.dart';
import 'nets.dart';
import 'shareable/serializer.dart';

final class Xzz implements Serializer {
  const Xzz({
    required this.signature,
    required this.header,
    required this.infos,
    required this.layers,
    required this.nets,
  });

  factory Xzz.deserialize(Iterator<int> iterator) {
    final signature = Signature.deserialize(iterator);
    final header = Header.deserialize(iterator);
    final infos = Infos.deserialize(iterator);
    final layers = Layers.deserialize(iterator);
    final nets = Nets.deserialize(iterator);

    return Xzz(
      signature: signature,
      header: header,
      infos: infos,
      layers: layers,
      nets: nets,
    );
  }

  final Signature signature;
  final Header header;
  final Infos infos;
  final Layers layers;
  final Nets nets;

  @override
  List<int> serialize() => [
    ...signature.serialize(),
    ...header.serialize(),
    ...infos.serialize(),
    ...layers.serialize(),
    ...nets.serialize(),
  ];
}

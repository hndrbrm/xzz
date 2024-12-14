// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/list_helper.dart';
import '../../serializable/jsonable.dart';
import '../packet/bytesable_packet.dart';
import 'image.dart';

class Images extends BytesablePacket<Image> {
  const Images(super.whole);

  @override
  bool operator ==(Object other) =>
    other is Images &&
    listEqual(other.whole, whole);

  @override
  int get hashCode => Object.hashAll(whole);
}

extension ImagesIterator on Iterator<int> {
  Images toImages() {
    final whole = toByteablePacket((e) => e.toImage());
    return Images(whole.whole);
  }
}

extension ImagesJsonList on JsonList {
  Images toImages() => toObject().toImages();
}

extension ImagesList on List<Object?> {
  Images toImages() => Images(
    map((e) => e! as Map<String, Object?>)
      .map((e) => e.toJsonMap())
      .map((e) => e.toImage())
      .toList()
  );
}

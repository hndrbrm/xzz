// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../shareable/int_helper.dart';
import '../../shareable/iterator_helper.dart';
import '../../shareable/list_helper.dart';
import '../../shareable/serializer.dart';
import 'image.dart';

final class Images implements Serializer {
  const Images._({
    required this.images,
  });

  factory Images.deserialize(Iterator<int> iterator) {
    final length = iterator.read(4).toUint32();

    final images = <Image>[];

    for (var offset = 0; offset < length; ) {
      final image = Image.deserialize(iterator);
      images.add(image);
      offset += image.serialize().length;
    }

    return Images._(images: images);
  }

  final List<Image> images;

  @override
  List<int> serialize() {
    final body = [
      for (final image in images)
      ...image.serialize(),
    ];

    return [
      ...body.length.toUint32List(),
      ...body,
    ];
  }
}

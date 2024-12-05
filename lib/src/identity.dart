// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'shareable/iterator_helper.dart';
import 'shareable/list_helper.dart';
import 'shareable/serializer.dart';

final class Identity implements Serializer {
  const Identity._();

  factory Identity.deserialize(Iterator<int> iterator) {
    final id = iterator.read(12);

    if (!listEqual(id, _id)) {
      throw InvalidIdentityException();
    }

    return const Identity._();
  }

  /// Every xzz file need to starts with 'XZZPCB V1.0' string.
  static const List<int> _id = [
    0x58, 0x5a, 0x5a, 0x50, 0x43, 0x42, 0x20, 0x56, 0x31, 0x2e, 0x30, 0x00,
  ];

  @override
  List<int> serialize() => _id;
}

final class InvalidIdentityException extends FormatException {}
